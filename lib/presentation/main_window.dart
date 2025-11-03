import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/widgets/layout/spacer.dart';
import 'package:window_manager/window_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:auto_route/auto_route.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:tkit/l10n/app_localizations.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/text_styles.dart';
import 'package:tkit/core/routing/app_router.dart';
import 'package:tkit/core/config/app_config.dart';
import 'package:tkit/core/providers/providers.dart';
import 'package:tkit/features/auth/presentation/providers/auth_providers.dart';
import 'package:tkit/features/auth/presentation/states/auth_state.dart';
import 'package:tkit/features/settings/presentation/providers/settings_providers.dart';
import 'package:tkit/features/settings/presentation/providers/window_controls_preview_provider.dart';
import 'package:tkit/features/settings/presentation/providers/unsaved_changes_notifier.dart';
import 'package:tkit/features/settings/presentation/states/settings_state.dart';
import 'package:tkit/features/settings/domain/entities/window_controls_position.dart';
import 'package:tkit/features/settings/domain/entities/update_channel.dart';
import 'package:tkit/shared/widgets/badges/channel_badge.dart';
import 'package:tkit/presentation/widgets/version_status_indicator.dart';
import 'package:tkit/presentation/widgets/whats_new_dialog.dart';

/// Main application window with custom chrome
class MainWindow extends ConsumerStatefulWidget {
  final Widget child;
  final AppRouter router;

  const MainWindow({super.key, required this.child, required this.router});

  @override
  ConsumerState<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends ConsumerState<MainWindow> {
  var _isLogScreenOpen = false;

  @override
  void initState() {
    super.initState();
    // Subscribe to router changes (StackRouter extends ChangeNotifier)
    widget.router.addListener(_onRouteChanged);

    // Check if we should show what's new dialog
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowWhatsNew();
    });
  }

  Future<void> _checkAndShowWhatsNew() async {
    try {
      final whatsNewService = ref.read(whatsNewServiceProvider);
      final shouldShow = await whatsNewService.shouldShowWhatsNew(
        AppConfig.appVersion,
      );

      if (!shouldShow || !mounted) {
        return;
      }

      // Fetch changelog for current version
      final updateInfo = await whatsNewService.getChangelogForVersion(
        AppConfig.appVersion,
      );

      if (updateInfo == null || !mounted) {
        // No changelog found, mark as seen anyway
        await whatsNewService.markVersionAsSeen(AppConfig.appVersion);
        return;
      }

      // Show what's new dialog
      // Get navigator context before async operations
      final navigatorContext = widget.router.navigatorKey.currentContext;
      if (mounted && navigatorContext != null) {
        await showDialog<void>(
          // ignore: use_build_context_synchronously
          context: navigatorContext,
          barrierDismissible: false,
          builder: (context) => WhatsNewDialog(
            updateInfo: updateInfo,
            onClose: () {
              Navigator.of(context).pop();
              // Mark this version as seen
              whatsNewService.markVersionAsSeen(AppConfig.appVersion);
            },
          ),
        );
      }
    } catch (e) {
      // Silently fail - don't block app if whats new fails
      debugPrint('Failed to show what\'s new: $e');
    }
  }

  @override
  void dispose() {
    // Unsubscribe from router changes
    widget.router.removeListener(_onRouteChanged);
    super.dispose();
  }

  void _onRouteChanged() {
    // Optimized: No logic inside setState, just trigger rebuild
    // Using postFrameCallback to avoid rebuilding during another build
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  /// Determine the update channel from the app version string
  UpdateChannel _getChannelFromVersion(String version) {
    if (version.contains('-alpha') || version.contains('-dev')) {
      return UpdateChannel.dev;
    } else if (version.contains('-beta')) {
      return UpdateChannel.beta;
    } else if (version.contains('-rc')) {
      return UpdateChannel.rc;
    }
    return UpdateChannel.stable;
  }

  /// Handle navigation with unsaved changes check
  void _handleNavigation(BuildContext context, PageRouteInfo route) {
    final unsavedChangesState = ref.read(unsavedChangesProvider);
    if (unsavedChangesState.hasUnsavedChanges) {
      // Notify settings page to show shake animation
      ref.read(unsavedChangesProvider.notifier).notifyNavigationAttempt();
    } else {
      // Navigate if no unsaved changes
      widget.router.navigate(route);
    }
  }

  /// Toggle the Talker logs screen (press F2)
  void _toggleLogsScreen(BuildContext context) {
    final navigatorContext = widget.router.navigatorKey.currentContext;
    if (navigatorContext == null) {
      return;
    }

    if (_isLogScreenOpen) {
      // Close the log screen
      Navigator.of(navigatorContext).pop();
      // Optimized: Move state change outside setState
      _isLogScreenOpen = false;
      if (mounted) {
        setState(() {});
      }
    } else {
      // Open the log screen
      final logger = ref.read(appLoggerProvider);
      // Optimized: Update state before setState
      _isLogScreenOpen = true;
      if (mounted) {
        setState(() {});
      }
      Navigator.of(navigatorContext)
          .push<void>(
            MaterialPageRoute<void>(
              builder: (context) => TalkerScreen(talker: logger.talker),
            ),
          )
          .then((_) {
            // Reset flag when screen is closed by other means (back button, etc)
            // Optimized: Move state change outside setState
            _isLogScreenOpen = false;
            if (mounted) {
              setState(() {});
            }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsState = ref.watch(settingsProvider);

    // Determine if frameless mode is enabled
    final useFrameless = settingsState is SettingsLoaded
        ? settingsState.settings.useFramelessWindow
        : settingsState is SettingsSaved
        ? settingsState.settings.useFramelessWindow
        : false; // Default to false

    // Determine if footer/header should be inverted
    final invertFooterHeader = settingsState is SettingsLoaded
        ? settingsState.settings.invertFooterHeader
        : settingsState is SettingsSaved
        ? settingsState.settings.invertFooterHeader
        : false; // Default to false

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.f2): () =>
            _toggleLogsScreen(context),
      },
      child: Focus(
        autofocus: true,
        child: Builder(
          builder: (context) {
            // Build header and footer widgets
            final header = _buildHeader(context);
            final footer = _buildFooter();

            final scaffold = Scaffold(
              backgroundColor: TKitColors.background,
              body: Column(
                children: [
                  // Custom header with tabs and window controls
                  if (invertFooterHeader) footer else header,

                  // Main content area - full width
                  Expanded(child: widget.child),

                  // Minimal footer
                  if (invertFooterHeader) header else footer,
                ],
              ),
            );

            // Apply border radius if frameless mode is enabled
            if (useFrameless) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(TKitSpacing.sm),
                child: scaffold,
              );
            }

            return scaffold;
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    // Get current route name from router (widget rebuilds via listener)
    final currentRouteName = widget.router.current.name;
    final isWelcomeScreen = currentRouteName == 'WelcomeRoute';
    final l10n = AppLocalizations.of(context)!;

    // Get settings state
    final settingsState = ref.watch(settingsProvider);

    // Get preview position from Riverpod provider
    final previewPosition = ref.watch(windowControlsPreviewProvider);

    // Get saved window controls position from settings
    final savedPosition = settingsState is SettingsLoaded
        ? settingsState.settings.windowControlsPosition
        : settingsState is SettingsSaved
        ? settingsState.settings.windowControlsPosition
        : WindowControlsPosition.right;

    // Preview position takes precedence over saved position
    final windowControlsPosition = previewPosition ?? savedPosition;

    return SizedBox(
      height: 36,
      child: Row(
        children: [
          // LEFT POSITION LAYOUT: Controls → Spacer → Tabs → Title
          if (windowControlsPosition == WindowControlsPosition.left) ...[
            // Window controls on the left (reversed order)
            _buildWindowControls(reversed: true),

            // Spacer
            Expanded(
              child: GestureDetector(
                onDoubleTap: () async {
                  if (await windowManager.isMaximized()) {
                    await windowManager.unmaximize();
                  } else {
                    await windowManager.maximize();
                  }
                },
                child: DragToMoveArea(
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),

            // Divider
            if (!isWelcomeScreen)
              Container(width: 1, height: 36, color: TKitColors.border),

            // Navigation tabs
            if (!isWelcomeScreen)
              _buildTab(
                key: const Key('nav-tab-auto-switcher'),
                context: context,
                label: l10n.mainWindowNavAutoSwitcher,
                isSelected: currentRouteName == AutoSwitcherRoute.name,
                onTap: () {
                  _handleNavigation(context, const AutoSwitcherRoute());
                },
              ),
            if (!isWelcomeScreen)
              _buildTab(
                key: const Key('nav-tab-mappings'),
                context: context,
                label: l10n.mainWindowNavMappings,
                isSelected: currentRouteName == CategoryMappingEditorRoute.name,
                onTap: () {
                  _handleNavigation(
                    context,
                    const CategoryMappingEditorRoute(),
                  );
                },
              ),
            if (!isWelcomeScreen)
              _buildTab(
                key: const Key('nav-tab-settings'),
                context: context,
                label: l10n.mainWindowNavSettings,
                isSelected: currentRouteName == SettingsRoute.name,
                onTap: () {
                  _handleNavigation(context, const SettingsRoute());
                },
              ),

            // App name on the right
            GestureDetector(
              onDoubleTap: () async {
                if (await windowManager.isMaximized()) {
                  await windowManager.unmaximize();
                } else {
                  await windowManager.maximize();
                }
              },
              child: DragToMoveArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TKitSpacing.md,
                  ),
                  child: Text(
                    AppConfig.appName.toUpperCase(),
                    style: TKitTextStyles.labelSmall.copyWith(
                      // Design system: Use labelSmall for small UI text
                      letterSpacing: 1.8,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],

          // CENTER/RIGHT POSITION LAYOUT: Title → Tabs → Spacer/Controls → Controls
          if (windowControlsPosition != WindowControlsPosition.left) ...[
            // App name - draggable area with double-click
            GestureDetector(
              onDoubleTap: () async {
                if (await windowManager.isMaximized()) {
                  await windowManager.unmaximize();
                } else {
                  await windowManager.maximize();
                }
              },
              child: DragToMoveArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TKitSpacing.md,
                  ),
                  child: Text(
                    AppConfig.appName.toUpperCase(),
                    style: TKitTextStyles.labelSmall.copyWith(
                      // Design system: Use labelSmall for small UI text
                      letterSpacing: 1.8,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),

            // Divider
            if (!isWelcomeScreen)
              Container(width: 1, height: 36, color: TKitColors.border),

            // Navigation tabs
            if (!isWelcomeScreen)
              _buildTab(
                key: const Key('nav-tab-auto-switcher'),
                context: context,
                label: l10n.mainWindowNavAutoSwitcher,
                isSelected: currentRouteName == AutoSwitcherRoute.name,
                onTap: () {
                  _handleNavigation(context, const AutoSwitcherRoute());
                },
              ),
            if (!isWelcomeScreen)
              _buildTab(
                key: const Key('nav-tab-mappings'),
                context: context,
                label: l10n.mainWindowNavMappings,
                isSelected: currentRouteName == CategoryMappingEditorRoute.name,
                onTap: () {
                  _handleNavigation(
                    context,
                    const CategoryMappingEditorRoute(),
                  );
                },
              ),
            if (!isWelcomeScreen)
              _buildTab(
                key: const Key('nav-tab-settings'),
                context: context,
                label: l10n.mainWindowNavSettings,
                isSelected: currentRouteName == SettingsRoute.name,
                onTap: () {
                  _handleNavigation(context, const SettingsRoute());
                },
              ),

            // Window controls in the center (truly centered)
            if (windowControlsPosition == WindowControlsPosition.center) ...[
              // Left spacer
              Expanded(
                child: GestureDetector(
                  onDoubleTap: () async {
                    if (await windowManager.isMaximized()) {
                      await windowManager.unmaximize();
                    } else {
                      await windowManager.maximize();
                    }
                  },
                  child: DragToMoveArea(
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ),
              _buildWindowControls(reversed: false),
              // Right spacer
              Expanded(
                child: GestureDetector(
                  onDoubleTap: () async {
                    if (await windowManager.isMaximized()) {
                      await windowManager.unmaximize();
                    } else {
                      await windowManager.maximize();
                    }
                  },
                  child: DragToMoveArea(
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ),
            ],

            // Spacer - draggable area with double-click (only for right position)
            if (windowControlsPosition == WindowControlsPosition.right)
              Expanded(
                child: GestureDetector(
                  onDoubleTap: () async {
                    if (await windowManager.isMaximized()) {
                      await windowManager.unmaximize();
                    } else {
                      await windowManager.maximize();
                    }
                  },
                  child: DragToMoveArea(
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ),

            // Window controls on the right (default)
            if (windowControlsPosition == WindowControlsPosition.right)
              _buildWindowControls(reversed: false),
          ],
        ],
      ),
    );
  }

  Widget _buildWindowControls({bool reversed = false}) {
    final l10n = AppLocalizations.of(context)!;

    final buttons = [
      // Minimize button
      _buildWindowButton(
        icon: Icons.remove,
        onTap: () async {
          await windowManager.minimize();
        },
        tooltip: l10n.mainWindowWindowControlMinimize,
      ),

      // Maximize/Restore button
      _buildWindowButton(
        icon: Icons.crop_square,
        onTap: () async {
          if (await windowManager.isMaximized()) {
            await windowManager.unmaximize();
          } else {
            await windowManager.maximize();
          }
        },
        tooltip: l10n.mainWindowWindowControlMaximize,
      ),

      // Close button
      _buildWindowButton(
        icon: Icons.close,
        onTap: () async {
          await windowManager.close();
        },
        tooltip: l10n.mainWindowWindowControlClose,
        isClose: true,
      ),
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: reversed ? buttons.reversed.toList() : buttons,
    );
  }

  Widget _buildWindowButton({
    required IconData icon,
    required VoidCallback onTap,
    required String tooltip,
    bool isClose = false,
  }) {
    return _WindowButton(icon: icon, onTap: onTap, isClose: isClose);
  }

  Widget _buildTab({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    Key? key,
  }) {
    return _TabButton(
      key: key,
      label: label,
      isSelected: isSelected,
      onTap: onTap,
    );
  }

  Widget _buildFooter() {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    final isAuthenticated = authState is Authenticated;

    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: TKitSpacing.pagePadding),
      child: Row(
        children: [
          // Twitch connection status - left side (draggable)
          Expanded(
            flex: 0,
            child: GestureDetector(
              onDoubleTap: () async {
                if (await windowManager.isMaximized()) {
                  await windowManager.unmaximize();
                } else {
                  await windowManager.maximize();
                }
              },
              child: DragToMoveArea(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Twitch icon
                    Icon(
                      Icons.videocam,
                      size: 12,
                      color: isAuthenticated
                          ? TKitColors.success
                          : TKitColors.textDisabled,
                    ),
                    const HSpace.xs(), // Design system: Use HSpace instead of hardcoded values
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: isAuthenticated
                            ? TKitColors.success
                            : TKitColors.textDisabled,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const HSpace.xs(), // Design system: Use HSpace instead of hardcoded values
                    Text(
                      isAuthenticated
                          ? l10n.mainWindowStatusConnected
                          : l10n.mainWindowStatusDisconnected,
                      style: TKitTextStyles.caption.copyWith(
                        // Design system: Use caption for small text
                        color: TKitColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Spacer - draggable area with double-click
          Expanded(
            child: GestureDetector(
              onDoubleTap: () async {
                if (await windowManager.isMaximized()) {
                  await windowManager.unmaximize();
                } else {
                  await windowManager.maximize();
                }
              },
              child: DragToMoveArea(
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          // Tutorial restart button (help icon)
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () async {
                try {
                  final logger = ref.read(appLoggerProvider);
                  final tutorialService = await ref.read(
                    tutorialServiceProvider.future,
                  );
                  await tutorialService.resetTutorial();
                  logger.info(
                    'Tutorial reset - forcing AutoSwitcher page reload',
                  );

                  // Force a fresh instance of AutoSwitcher page to trigger tutorial
                  unawaited(widget.router.replace(const AutoSwitcherRoute()));
                } catch (e) {
                  final logger = ref.read(appLoggerProvider);
                  logger.error('Failed to reset tutorial', e);
                }
              },
              child: const Icon(
                Icons.help_outline,
                size: 14,
                color: TKitColors.textMuted,
              ),
            ),
          ),
          const HSpace.md(), // Design system: Use HSpace instead of hardcoded values
          // evobug.com link (not draggable - clickable)
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () async {
                final uri = Uri.parse('https://evobug.com');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                }
              },
              child: Text(
                'evobug.com',
                style: TKitTextStyles.labelSmall.copyWith(
                  // Design system: Use labelSmall for UI labels
                  color: TKitColors.info,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          const HSpace.lg(), // Design system: Use HSpace instead of hardcoded values
          // Version info (draggable)
          GestureDetector(
            onDoubleTap: () async {
              if (await windowManager.isMaximized()) {
                await windowManager.unmaximize();
              } else {
                await windowManager.maximize();
              }
            },
            child: DragToMoveArea(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'v${AppConfig.appVersion}',
                    style: TKitTextStyles.labelSmall.copyWith(
                      // Design system: Use labelSmall for UI labels
                      color: TKitColors.textDisabled,
                    ),
                  ),
                  const HSpace.xs(), // Design system: Use HSpace instead of hardcoded values
                  ChannelBadge(
                    channel: _getChannelFromVersion(AppConfig.appVersion),
                  ),
                  const HSpace.xs(), // Design system: Use HSpace instead of hardcoded values
                  VersionStatusIndicator(
                    navigatorKey: widget.router.navigatorKey,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Stateful tab button with hover effects
class _TabButton extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_TabButton> createState() => _TabButtonState();
}

class _TabButtonState extends State<_TabButton> {
  var _isHovered = false;

  // Optimized: Move logic outside setState for hover state changes
  void _setHovered(bool value) {
    _isHovered = value;
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: TKitSpacing.lg),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? TKitColors
                      .background // Darker to create contrast with surface
                : (_isHovered ? TKitColors.borderLight : Colors.transparent),
            border: Border(
              bottom: BorderSide(
                color: widget.isSelected
                    ? TKitColors.accentBright
                    : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Center(
            child: Text(
              widget.label.toUpperCase(),
              style: TKitTextStyles.labelSmall.copyWith(
                // Design system: Use labelSmall for small UI text
                color: widget.isSelected
                    ? TKitColors.textPrimary
                    : (_isHovered
                          ? TKitColors.textSecondary
                          : TKitColors.textMuted),
                fontWeight: widget.isSelected
                    ? FontWeight.w600
                    : FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Stateful window button with hover effects
class _WindowButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isClose;

  const _WindowButton({
    required this.icon,
    required this.onTap,
    this.isClose = false,
  });

  @override
  State<_WindowButton> createState() => _WindowButtonState();
}

class _WindowButtonState extends State<_WindowButton> {
  var _isHovered = false;

  // Optimized: Move logic outside setState for hover state changes
  void _setHovered(bool value) {
    _isHovered = value;
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: 46,
          height: 36,
          color: _isHovered
              ? (widget.isClose ? TKitColors.error : TKitColors.surfaceVariant)
              : Colors.transparent,
          child: Icon(
            widget.icon,
            size: 14,
            color: _isHovered && widget.isClose
                ? TKitColors.textPrimary
                : TKitColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
