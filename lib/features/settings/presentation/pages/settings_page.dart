import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/theme/colors.dart';
import '../../../../shared/theme/text_styles.dart';
import '../../../../shared/theme/spacing.dart';
import '../../../../shared/widgets/layout/page_header.dart';
import '../../../../shared/widgets/layout/spacer.dart';
import '../../../../shared/widgets/layout/island.dart';
import '../../../../shared/widgets/feedback/toast.dart';
import '../../../../shared/widgets/indicators/loading_indicator.dart';
import '../../../../shared/widgets/buttons/buttons.dart';
import '../../../../shared/widgets/forms/form_field_wrapper.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/services/language_service.dart';
import '../../../../core/services/locale_provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/entities/fallback_behavior.dart';
import '../../domain/entities/update_channel.dart';
import '../../domain/entities/window_controls_position.dart';
import '../../../../core/services/updater/github_update_service.dart';
import '../../domain/usecases/factory_reset_usecase.dart';
import '../providers/settings_provider.dart';
import '../providers/window_controls_preview_provider.dart';
import '../states/settings_state.dart';
import '../widgets/settings_checkbox.dart';
import '../widgets/settings_dropdown.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/settings_slider.dart';
import '../widgets/hotkey_input.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/states/auth_state.dart';
import '../../../auth/presentation/pages/device_code_auth_page.dart';

/// Settings page for configuring application settings
@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get SettingsProvider from parent context (should be provided at app level)
    final settingsProvider = Provider.of<SettingsProvider>(
      context,
      listen: false,
    );

    // Load settings after build completes to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      settingsProvider.loadSettings();
    });

    return const _SettingsPageContent();
  }
}

class _SettingsPageContent extends StatefulWidget {
  const _SettingsPageContent();

  @override
  State<_SettingsPageContent> createState() => _SettingsPageContentState();
}

class _SettingsPageContentState extends State<_SettingsPageContent> {
  AppSettings? _currentSettings;
  bool _hasChanges = false;
  bool _isInitialized = false;
  int _resetKey = 0;
  WindowControlsPosition? _originalWindowControlsPosition;

  void _updateSettings(AppSettings settings) {
    setState(() {
      _currentSettings = settings;
      _hasChanges = context.read<SettingsProvider>().hasUnsavedChanges(
        settings,
      );
    });
  }

  void _saveSettings() {
    if (_currentSettings != null) {
      context.read<SettingsProvider>().updateSettings(_currentSettings!);
      // Clear the window controls preview after saving
      context.read<WindowControlsPreviewProvider>().clearPreview();
      // Update the original window controls position after saving
      _originalWindowControlsPosition =
          _currentSettings!.windowControlsPosition;
    }
  }

  void _discardChanges() async {
    final provider = context.read<SettingsProvider>();
    final previewProvider = context.read<WindowControlsPreviewProvider>();

    // Clear the window controls preview to revert to saved position
    previewProvider.clearPreview();

    setState(() {
      _hasChanges = false;
      _isInitialized = false;
      _resetKey++; // Force widget recreation
      // Reset to original settings from provider immediately
      if (provider.state is SettingsLoaded) {
        _currentSettings = (provider.state as SettingsLoaded).settings;
      } else if (provider.state is SettingsSaved) {
        _currentSettings = (provider.state as SettingsSaved).settings;
      }
    });
    // Load settings after the current frame to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.loadSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SettingsProvider>(
        builder: (context, provider, child) {
          final state = provider.state;

          // Handle state changes (similar to BlocConsumer listener)
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (state is SettingsSaved) {
              final l10n = AppLocalizations.of(context)!;
              Toast.success(context, l10n.settingsSavedSuccessfully);
              setState(() {
                _hasChanges = false;
                _isInitialized = false;
              });
            } else if (state is SettingsError) {
              Toast.error(context, state.message);
            }
          });
          if (state is SettingsLoading) {
            return const Center(child: LoadingIndicator());
          }

          if (state is SettingsError && state.currentSettings == null) {
            final l10n = AppLocalizations.of(context)!;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: TKitColors.error),
                  const VSpace.lg(),
                  Text(state.message, style: TKitTextStyles.bodyMedium),
                  const VSpace.lg(),
                  PrimaryButton(
                    text: l10n.settingsRetry,
                    onPressed: () {
                      context.read<SettingsProvider>().loadSettings();
                    },
                  ),
                ],
              ),
            );
          }

          // Only update _currentSettings from bloc when not already editing
          if (!_isInitialized) {
            if (state is SettingsLoaded) {
              _currentSettings = state.settings;
              _originalWindowControlsPosition =
                  state.settings.windowControlsPosition;
              _isInitialized = true;
            } else if (state is SettingsSaving) {
              _currentSettings = state.settings;
              _originalWindowControlsPosition =
                  state.settings.windowControlsPosition;
              _isInitialized = true;
            } else if (state is SettingsSaved) {
              _currentSettings = state.settings;
              _originalWindowControlsPosition =
                  state.settings.windowControlsPosition;
              _isInitialized = true;
            } else if (state is SettingsError &&
                state.currentSettings != null) {
              _currentSettings = state.currentSettings;
              _originalWindowControlsPosition =
                  state.currentSettings!.windowControlsPosition;
              _isInitialized = true;
            } else {
              _currentSettings = AppSettings.defaults(
                appVersion: AppConfig.appVersion,
              );
              _originalWindowControlsPosition =
                  _currentSettings!.windowControlsPosition;
              _isInitialized = true;
            }
          }

          // Use _currentSettings for all UI rendering
          final settings =
              _currentSettings ??
              AppSettings.defaults(appVersion: AppConfig.appVersion);
          final l10n = AppLocalizations.of(context)!;

          return Stack(
            children: [
              // Scrollable content
              SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  TKitSpacing.pagePadding,
                  _hasChanges ? 70 : TKitSpacing.pagePadding,
                  TKitSpacing.pagePadding,
                  TKitSpacing.pagePadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Page Header
                    PageHeader(
                      title: l10n.settingsPageTitle,
                      subtitle: l10n.settingsPageDescription,
                    ),
                    const VSpace.lg(),

                    // Auto Switcher Settings
                    _buildSection(l10n.settingsAutoSwitcher, [
                      // Monitoring Settings
                      _buildSubsectionTitle(l10n.settingsMonitoring),
                      const SizedBox(height: 8),
                      SettingsSlider(
                        label: l10n.settingsScanIntervalLabel,
                        description: l10n.settingsScanIntervalDescription,
                        value: settings.scanIntervalSeconds.toDouble(),
                        min: 1,
                        max: 60,
                        divisions: 59,
                        onChanged: (value) {
                          _updateSettings(
                            settings.copyWith(
                              scanIntervalSeconds: value.toInt(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      SettingsSlider(
                        label: l10n.settingsDebounceTimeLabel,
                        description: l10n.settingsDebounceTimeDescription,
                        value: settings.debounceSeconds.toDouble(),
                        min: 0,
                        max: 60,
                        divisions: 60,
                        onChanged: (value) {
                          _updateSettings(
                            settings.copyWith(debounceSeconds: value.toInt()),
                          );
                        },
                      ),
                      const SizedBox(height: 14),

                      // Auto Start Monitoring
                      SettingsCheckbox(
                        label: l10n.settingsAutoStartMonitoringLabel,
                        subtitle: l10n.settingsAutoStartMonitoringSubtitle,
                        value: settings.autoStartMonitoring,
                        onChanged: (value) {
                          _updateSettings(
                            settings.copyWith(
                              autoStartMonitoring: value ?? false,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 14),

                      // Fallback Behavior
                      _buildSubsectionTitle(l10n.settingsFallbackBehavior),
                      const SizedBox(height: 8),
                      SettingsDropdown<FallbackBehavior>(
                        label: l10n.settingsFallbackBehaviorLabel,
                        description: l10n.settingsFallbackBehaviorDescription,
                        value: settings.fallbackBehavior,
                        items: FallbackBehavior.values
                            .map(
                              (behavior) => DropdownMenuItem(
                                value: behavior,
                                child: Text(behavior.localizedName(context)),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            _updateSettings(
                              settings.copyWith(fallbackBehavior: value),
                            );
                          }
                        },
                      ),
                      if (settings.fallbackBehavior ==
                          FallbackBehavior.custom) ...[
                        const SizedBox(height: 10),
                        FormFieldWrapper(
                          label: l10n.settingsCustomCategory,
                          child: TKitTextField(
                            hintText: l10n.settingsCustomCategoryHint,
                            controller: TextEditingController(
                              text: settings.customFallbackCategoryName ?? '',
                            ),
                            readOnly: true,
                            onTap: () {
                              // TODO: Open category search dialog
                              // This will be implemented when Module 4 (Twitch API) is available
                              Toast.info(
                                context,
                                l10n.settingsCategorySearchUnavailable,
                              );
                            },
                          ),
                        ),
                      ],
                    ]),
                    const SizedBox(height: 20),

                    // Application Settings
                    _buildSection(l10n.settingsApplication, [
                      // Language selection
                      Builder(
                        builder: (context) {
                          final l10n = AppLocalizations.of(context)!;
                          final languageService = Provider.of<LanguageService>(
                            context,
                            listen: false,
                          );
                          final localeProvider = Provider.of<LocaleProvider>(
                            context,
                            listen: false,
                          );
                          final currentLocale = languageService
                              .getCurrentLocale();

                          // Map of language codes to their localized names
                          final languageNames = <String, String>{
                            'en': l10n.languageEnglish,
                            'cs': l10n.languageCzech,
                            'pl': l10n.languagePolish,
                            'es': l10n.languageSpanish,
                            'fr': l10n.languageFrench,
                            'de': l10n.languageGerman,
                            'pt': l10n.languagePortuguese,
                            'ja': l10n.languageJapanese,
                            'ko': l10n.languageKorean,
                            'zh': l10n.languageChinese,
                          };

                          return SettingsDropdown<String>(
                            label: l10n.settingsLanguage,
                            description: l10n.settingsLanguageDescription,
                            value: currentLocale.languageCode,
                            items: AppLocalizations.supportedLocales
                                .map(
                                  (locale) => DropdownMenuItem(
                                    value: locale.languageCode,
                                    child: Text(
                                      languageNames[locale.languageCode] ??
                                          locale.languageCode.toUpperCase(),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (languageCode) async {
                              if (languageCode != null) {
                                await languageService.saveLanguage(
                                  languageCode,
                                );
                                // Update locale in the app
                                localeProvider.setLocale(Locale(languageCode));

                                // Wait for the next frame to let the app rebuild with new locale
                                if (context.mounted) {
                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) {
                                    if (context.mounted) {
                                      // Get the updated localization with the new language
                                      final newL10n = AppLocalizations.of(
                                        context,
                                      )!;
                                      Toast.success(
                                        context,
                                        newL10n.languageChangeNotice,
                                      );
                                    }
                                  });
                                }
                              }
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 4),
                      SettingsCheckbox(
                        label: l10n.settingsAutoStartWindowsLabel,
                        subtitle: l10n.settingsAutoStartWindowsSubtitle,
                        value: settings.autoStartWithWindows,
                        onChanged: (value) {
                          _updateSettings(
                            settings.copyWith(
                              autoStartWithWindows: value ?? false,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 4),
                      SettingsCheckbox(
                        label: l10n.settingsStartMinimizedLabel,
                        subtitle: l10n.settingsStartMinimizedSubtitle,
                        value: settings.startMinimized,
                        onChanged: (value) {
                          _updateSettings(
                            settings.copyWith(startMinimized: value ?? false),
                          );
                        },
                      ),
                      const SizedBox(height: 4),
                      SettingsCheckbox(
                        label: l10n.settingsMinimizeToTrayLabel,
                        subtitle: l10n.settingsMinimizeToTraySubtitle,
                        value: settings.minimizeToTray,
                        onChanged: (value) {
                          _updateSettings(
                            settings.copyWith(minimizeToTray: value ?? false),
                          );
                        },
                      ),
                      const SizedBox(height: 4),
                      SettingsCheckbox(
                        label: l10n.settingsShowNotificationsLabel,
                        subtitle: l10n.settingsShowNotificationsSubtitle,
                        value: settings.showNotifications,
                        onChanged: (value) {
                          _updateSettings(
                            settings.copyWith(
                              showNotifications: value ?? false,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 4),
                      SettingsCheckbox(
                        label: l10n.settingsNotifyMissingCategoryLabel,
                        subtitle: l10n.settingsNotifyMissingCategorySubtitle,
                        value: settings.notifyOnMissingCategory,
                        onChanged: (value) {
                          _updateSettings(
                            settings.copyWith(
                              notifyOnMissingCategory: value ?? false,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomDropdown<WindowControlsPosition>(
                        label: l10n.settingsWindowControlsPositionLabel,
                        description:
                            l10n.settingsWindowControlsPositionDescription,
                        value: settings.windowControlsPosition,
                        items: WindowControlsPosition.values
                            .map(
                              (position) => CustomDropdownItem(
                                value: position,
                                title: position.localizedName(context),
                                subtitle: null,
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            // Update local state to track changes
                            final updatedSettings = settings.copyWith(
                              windowControlsPosition: value,
                            );
                            _updateSettings(updatedSettings);

                            // Set preview position (not saved to database yet)
                            context
                                .read<WindowControlsPreviewProvider>()
                                .setPreviewPosition(value);
                          }
                        },
                      ),
                    ]),
                    const SizedBox(height: 20),

                    // Updates
                    _buildSection(l10n.settingsUpdates, [
                      CustomDropdown<UpdateChannel>(
                        label: l10n.settingsUpdateChannelLabel,
                        description: l10n.settingsUpdateChannelDescription,
                        value: settings.updateChannel,
                        items: UpdateChannel.values
                            .map(
                              (channel) => CustomDropdownItem(
                                value: channel,
                                title: channel.localizedName(context),
                                subtitle: channel.localizedDescription(context),
                              ),
                            )
                            .toList(),
                        onChanged: (value) async {
                          if (value != null) {
                            final updatedSettings = settings.copyWith(
                              updateChannel: value,
                            );
                            _updateSettings(updatedSettings);

                            // Save settings immediately
                            await context
                                .read<SettingsProvider>()
                                .updateSettings(updatedSettings);

                            // Trigger update check with new channel
                            if (context.mounted) {
                              final updateService = context
                                  .read<GitHubUpdateService>();
                              await updateService.checkForUpdates(
                                silent: false,
                                channel: value,
                              );

                              if (context.mounted) {
                                Toast.success(
                                  context,
                                  l10n.settingsUpdateChannelChanged(
                                    value.localizedName(context),
                                  ),
                                );
                              }
                            }
                          }
                        },
                      ),
                    ]),
                    const SizedBox(height: 20),

                    // Keyboard Shortcuts
                    _buildSection(l10n.settingsKeyboardShortcuts, [
                      HotkeyInput(
                        key: ValueKey(
                          'hotkey_${settings.manualUpdateHotkey}_$_resetKey',
                        ),
                        label: l10n.settingsManualUpdateHotkeyLabel,
                        description: l10n.settingsManualUpdateHotkeyDescription,
                        currentHotkey: settings.manualUpdateHotkey,
                        onChanged: (hotkey) {
                          _updateSettings(
                            settings.copyWith(manualUpdateHotkey: hotkey),
                          );
                        },
                      ),
                    ]),
                    const SizedBox(height: 20),

                    // Twitch Authentication
                    _buildTwitchAuthSection(context),
                    const SizedBox(height: 20),

                    // Factory Reset
                    _buildFactoryResetSection(context),
                  ],
                ),
              ),
              // Save/Discard buttons bar - positioned on top
              if (_hasChanges)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(TKitSpacing.lg),
                    decoration: BoxDecoration(
                      color: TKitColors.surfaceVariant,
                      border: const Border(
                        bottom: BorderSide(color: TKitColors.border, width: 1),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: TKitColors.warning,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.settingsUnsavedChanges,
                          style: const TextStyle(
                            color: TKitColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        const Spacer(),
                        AccentButton(
                          text: l10n.settingsDiscard,
                          onPressed: _discardChanges,
                        ),
                        const SizedBox(width: 8),
                        PrimaryButton(
                          text: l10n.settingsSave,
                          onPressed: _saveSettings,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: TKitTextStyles.labelSmall.copyWith(
            letterSpacing: 1.0,
            color: TKitColors.textSecondary,
          ),
        ),
        VSpace.md(),
        Island.standard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSubsectionTitle(String title) {
    return Text(
      title,
      style: TKitTextStyles.labelLarge.copyWith(color: TKitColors.accent),
    );
  }

  Widget _buildTwitchAuthSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final authState = authProvider.state;
        final isAuthenticated = authState is Authenticated;
        final isLoading = authState is AuthLoading;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.settingsTwitchConnection.toUpperCase(),
              style: TKitTextStyles.labelSmall.copyWith(
                letterSpacing: 1.0,
                color: TKitColors.textSecondary,
              ),
            ),
            VSpace.md(),
            Island.standard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isAuthenticated
                              ? TKitColors.success
                              : TKitColors.textDisabled,
                          shape: BoxShape.circle,
                        ),
                      ),
                      HSpace.md(),
                      Text(
                        isAuthenticated
                            ? l10n.settingsTwitchStatusConnected
                            : l10n.settingsTwitchStatusNotConnected,
                        style: TKitTextStyles.labelLarge,
                      ),
                    ],
                  ),
                  VSpace.md(),
                  if (isAuthenticated && authState is Authenticated) ...[
                    Text(
                      l10n.settingsTwitchLoggedInAs,
                      style: TKitTextStyles.caption,
                    ),
                    VSpace.xs(),
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          size: 16,
                          color: TKitColors.accent,
                        ),
                        HSpace.sm(),
                        Text(
                          authState.user.displayName,
                          style: TKitTextStyles.bodyMedium,
                        ),
                        HSpace.sm(),
                        Text(
                          '(@${authState.user.login})',
                          style: TKitTextStyles.caption,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    FutureBuilder<DateTime?>(
                      future: authProvider.getTokenExpiration(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          final expiresAt = snapshot.data!;
                          final now = DateTime.now();
                          final isExpired = expiresAt.isBefore(now);
                          final timeRemaining = expiresAt.difference(now);

                          String expiryText;
                          if (isExpired) {
                            expiryText = 'Expired';
                          } else if (timeRemaining.inDays > 0) {
                            expiryText =
                                'Expires in ${timeRemaining.inDays}d ${timeRemaining.inHours % 24}h';
                          } else if (timeRemaining.inHours > 0) {
                            expiryText =
                                'Expires in ${timeRemaining.inHours}h ${timeRemaining.inMinutes % 60}m';
                          } else {
                            expiryText =
                                'Expires in ${timeRemaining.inMinutes}m';
                          }

                          return Row(
                            children: [
                              Icon(
                                Icons.schedule,
                                size: 14,
                                color: isExpired
                                    ? TKitColors.error
                                    : TKitColors.textMuted,
                              ),
                              HSpace.xs(),
                              Text(
                                expiryText,
                                style: TKitTextStyles.caption.copyWith(
                                  color: isExpired
                                      ? TKitColors.error
                                      : TKitColors.textMuted,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: AccentButton(
                            text: l10n.settingsTwitchDisconnect,
                            icon: Icons.logout,
                            onPressed: isLoading
                                ? null
                                : () {
                                    context.read<AuthProvider>().logout();
                                  },
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Text(
                      l10n.settingsTwitchConnectDescription,
                      style: TKitTextStyles.caption,
                    ),
                    VSpace.md(),
                    PrimaryButton(
                      text: l10n.settingsTwitchConnect,
                      icon: Icons.link,
                      isLoading: isLoading,
                      onPressed: isLoading
                          ? null
                          : () async {
                              final authProvider = context.read<AuthProvider>();
                              final deviceCodeResponse = await authProvider
                                  .initiateDeviceCodeAuth();

                              if (deviceCodeResponse != null &&
                                  context.mounted) {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (dialogContext) =>
                                      DeviceCodeAuthPage(
                                        deviceCodeResponse: deviceCodeResponse,
                                        onSuccess: () {
                                          Navigator.of(dialogContext).pop();
                                          context
                                              .read<AuthProvider>()
                                              .checkAuthStatus();
                                        },
                                        onCancel: () {
                                          Navigator.of(dialogContext).pop();
                                          context
                                              .read<AuthProvider>()
                                              .checkAuthStatus();
                                        },
                                      ),
                                );
                              }
                            },
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFactoryResetSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.settingsFactoryReset.toUpperCase(),
          style: TKitTextStyles.labelSmall.copyWith(
            letterSpacing: 1.0,
            color: TKitColors.textSecondary,
          ),
        ),
        VSpace.md(),
        Island.standard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                size: 40,
                color: TKitColors.warning,
              ),
              VSpace.md(),
              Text(
                l10n.settingsFactoryResetDescription,
                style: TKitTextStyles.bodyMedium,
              ),
              VSpace.md(),
              AccentButton(
                text: l10n.settingsFactoryResetButton,
                icon: Icons.restore,
                onPressed: () => _showFactoryResetDialog(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showFactoryResetDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: TKitColors.warning),
            const SizedBox(width: 8),
            Text(l10n.settingsFactoryResetDialogTitle),
          ],
        ),
        content: Text(l10n.settingsFactoryResetDialogMessage),
        actions: [
          AccentButton(
            text: l10n.commonCancel,
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
          PrimaryButton(
            text: l10n.settingsFactoryResetDialogConfirm,
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await _performFactoryReset(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _performFactoryReset(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    // Show loading indicator
    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
    }

    try {
      // Get the FactoryResetUseCase from Provider
      // This will be wired up in main.dart
      final factoryResetUseCase = Provider.of<FactoryResetUseCase>(
        context,
        listen: false,
      );

      final result = await factoryResetUseCase();

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      result.fold(
        (failure) {
          // Show error message
          if (context.mounted) {
            Toast.error(context, failure.message);
          }
        },
        (_) {
          // Show success message
          if (context.mounted) {
            Toast.success(context, l10n.settingsFactoryResetSuccess);
          }
        },
      );
    } catch (e) {
      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Show error message
      if (context.mounted) {
        Toast.error(context, 'Error: ${e.toString()}');
      }
    }
  }
}
