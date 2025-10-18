import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:tkit/l10n/app_localizations.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/theme/text_styles.dart';
import 'package:tkit/shared/widgets/layout/island.dart';
import 'package:tkit/shared/widgets/layout/spacer.dart';
import 'package:tkit/shared/widgets/feedback/toast.dart';
import 'package:tkit/shared/widgets/buttons/primary_button.dart';
import 'package:tkit/shared/widgets/buttons/accent_button.dart';
import 'package:tkit/shared/widgets/hotkey_display.dart';
import 'package:tkit/core/providers/providers.dart';
import 'package:tkit/features/settings/presentation/providers/settings_providers.dart';
import 'package:tkit/features/settings/presentation/states/settings_state.dart';
import 'package:tkit/features/auto_switcher/domain/entities/orchestration_status.dart';
import 'package:tkit/features/auto_switcher/presentation/providers/auto_switcher_providers.dart';
import 'package:tkit/features/auto_switcher/presentation/states/auto_switcher_state.dart';

/// Auto Switcher Page
///
/// Main page for the Auto Switcher feature displaying:
/// - Unified control panel with status and controls
/// - Current process, category, and last update
/// - Start/stop monitoring and manual update actions
@RoutePage()
class AutoSwitcherPage extends ConsumerStatefulWidget {
  const AutoSwitcherPage({super.key});

  @override
  ConsumerState<AutoSwitcherPage> createState() => _AutoSwitcherPageState();
}

class _AutoSwitcherPageState extends ConsumerState<AutoSwitcherPage> {
  TutorialCoachMark? _tutorialCoachMark;
  final GlobalKey _controlCardKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Load settings to ensure hotkey is displayed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settingsNotifier = ref.read(settingsProvider.notifier);
      if (ref.read(settingsProvider) is SettingsInitial) {
        settingsNotifier.loadSettings();
      }

      // Check and show tutorial
      _checkAndShowTutorial();
    });
  }

  Future<void> _checkAndShowTutorial() async {
    try {
      final tutorialService = await ref.read(tutorialServiceProvider.future);
      final isCompleted = await tutorialService.isTutorialCompleted();

      if (!isCompleted && mounted) {
        // Wait a bit for widgets to render
        await Future<void>.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          _showTutorial();
        }
      }
    } catch (e) {
      final logger = ref.read(appLoggerProvider);
      logger.warning('Failed to check tutorial status: $e');
    }
  }

  void _showTutorial() {
    final l10n = AppLocalizations.of(context)!;
    final logger = ref.read(appLoggerProvider);

    final targets = <TargetFocus>[
      TargetFocus(
        identify: "autoSwitcherControl",
        keyTarget: _controlCardKey,
        alignSkip: Alignment.topRight,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: TKitColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: TKitColors.accentBright,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: TKitColors.accentBright.withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.lightbulb_outline,
                          color: TKitColors.accentBright,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n.tutorialAutoSwitcherControlTitle,
                            style: TKitTextStyles.heading3.copyWith(
                              color: TKitColors.accentBright,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.tutorialAutoSwitcherControlDescription,
                      style: TKitTextStyles.bodyMedium.copyWith(
                        color: TKitColors.textPrimary,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    ];

    _tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      opacityShadow: 0.8,
      paddingFocus: 10,
      onFinish: () async {
        logger.info('Auto switcher tutorial completed');
        try {
          final tutorialService = await ref.read(tutorialServiceProvider.future);
          await tutorialService.completeTutorial();
        } catch (e) {
          logger.warning('Failed to mark tutorial as completed: $e');
        }
      },
      onSkip: () {
        logger.info('Auto switcher tutorial skipped');
        // Mark tutorial as completed asynchronously (fire and forget)
        ref.read(tutorialServiceProvider.future).then((tutorialService) {
          tutorialService.completeTutorial();
        }).catchError((e) {
          logger.warning('Failed to mark tutorial as completed: $e');
        });
        return true;
      },
    );

    // Wait for next frame to ensure context is valid
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _tutorialCoachMark?.show(context: context);
        logger.info('Auto switcher tutorial shown');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _AutoSwitcherPageContent(controlCardKey: _controlCardKey);
  }
}

class _AutoSwitcherPageContent extends ConsumerWidget {
  final GlobalKey? controlCardKey;

  const _AutoSwitcherPageContent({this.controlCardKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settingsState = ref.watch(settingsProvider);
    final autoSwitcherAsync = ref.watch(autoSwitcherProvider);

    // Listen for state changes to show toasts (only fires when state changes, not on rebuilds)
    ref.listen<AsyncValue<AutoSwitcherState>>(
      autoSwitcherProvider,
      (previous, next) {
        next.whenData((state) {
          // Show toast for errors
          if (state is UpdateError) {
            Toast.error(context, state.errorMessage);
          }

          // Show success message
          if (state is UpdateSuccess && state.message != null) {
            Toast.success(context, state.message!);
          }
        });
      },
    );

    // Extract hotkey from settings
    String? manualUpdateHotkey;
    if (settingsState is SettingsLoaded) {
      manualUpdateHotkey = settingsState.settings.manualUpdateHotkey;
    } else if (settingsState is SettingsSaved) {
      manualUpdateHotkey = settingsState.settings.manualUpdateHotkey;
    }

    return Scaffold(
      backgroundColor: TKitColors.background,
      body: Padding(
        padding: const EdgeInsets.all(TKitSpacing.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Main content
            Expanded(
              child: autoSwitcherAsync.when(
                data: (state) {

                  final status = _getStatusFromState(state);
                  final isMonitoring = _isMonitoringActive(state);
                  final isLoading = state is AutoSwitcherLoading;

                  return SingleChildScrollView(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 640),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Status card - what's happening right now
                            _buildStatusCard(
                              context,
                              l10n,
                              status,
                              isMonitoring,
                            ),
                            const VSpace.sm(),

                            // Main control card with tutorial key
                            Container(
                              key: controlCardKey,
                              child: _buildControlCard(
                                context,
                                l10n,
                                isMonitoring: isMonitoring,
                                isLoading: isLoading,
                                hotkey: manualUpdateHotkey,
                                onStart: () => ref
                                    .read(autoSwitcherProvider.notifier)
                                    .startMonitoring(),
                                onStop: () => ref
                                    .read(autoSwitcherProvider.notifier)
                                    .stopMonitoring(),
                                onUpdate: () => ref
                                    .read(autoSwitcherProvider.notifier)
                                    .manualUpdate(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  OrchestrationStatus? _getStatusFromState(AutoSwitcherState state) {
    return switch (state) {
      MonitoringActive(:final status) => status,
      MonitoringInactive(:final status) => status,
      Updating(:final status) => status,
      UpdateSuccess(:final status) => status,
      UpdateError(:final status) => status,
      HistoryLoaded(:final status) => status,
      AutoSwitcherLoading(:final status) => status,
      AutoSwitcherInitial() => null,
    };
  }

  bool _isMonitoringActive(AutoSwitcherState state) {
    return state is MonitoringActive ||
        (state is Updating && _getStatusFromState(state)?.isMonitoring == true);
  }

  /// Status card - shows current state in ChatGPT inline card style
  Widget _buildStatusCard(
    BuildContext context,
    AppLocalizations l10n,
    OrchestrationStatus? status,
    bool isMonitoring,
  ) {
    final hasProcess = status?.currentProcess != null;
    final hasCategory = status?.matchedCategory != null;

    return Island.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status indicator - subtle, system-like
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isMonitoring
                      ? TKitColors.success
                      : TKitColors.textMuted,
                  shape: BoxShape.circle,
                ),
              ),
              const HSpace.sm(),
              Text(
                isMonitoring
                    ? l10n.autoSwitcherStatusActive
                    : l10n.autoSwitcherStatusInactive,
                style: TKitTextStyles.bodySmall.copyWith(
                  color: TKitColors.textSecondary,
                ),
              ),
              const Spacer(),
              if (status?.lastUpdateTime != null)
                Text(
                  _formatTimestamp(context, l10n, status!.lastUpdateTime!),
                  style: TKitTextStyles.caption.copyWith(
                    color: TKitColors.textMuted,
                  ),
                ),
            ],
          ),
          const VSpace.md(),

          // Current app and category - clean, scannable
          _buildInfoRow(
            l10n.autoSwitcherLabelActiveApp,
            hasProcess ? status!.currentProcess! : l10n.autoSwitcherValueNone,
            hasProcess,
          ),
          const VSpace.sm(),
          _buildInfoRow(
            l10n.autoSwitcherLabelCategory,
            hasCategory ? status!.matchedCategory! : l10n.autoSwitcherValueNone,
            hasCategory,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isActive) {
    // Determine key based on label
    final Key? valueKey = label.contains('App') || label.contains('app')
        ? const Key('active-app-value')
        : label.contains('Category') || label.contains('category')
            ? const Key('category-value')
            : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TKitTextStyles.bodySmall.copyWith(
              color: TKitColors.textMuted,
            ),
          ),
        ),
        const HSpace.md(),
        Expanded(
          child: Text(
            value,
            key: valueKey,
            style: TKitTextStyles.bodyMedium.copyWith(
              color: isActive ? TKitColors.textPrimary : TKitColors.textMuted,
              fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// Main control card - follows ChatGPT's "max 2 actions" rule
  Widget _buildControlCard(
    BuildContext context,
    AppLocalizations l10n, {
    required bool isMonitoring,
    required bool isLoading,
    required String? hotkey,
    required VoidCallback onStart,
    required VoidCallback onStop,
    required VoidCallback onUpdate,
  }) {
    return Island.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isMonitoring) ...[
            // When active - simple description
            Text(
              l10n.autoSwitcherDescriptionActive,
              style: TKitTextStyles.bodyMedium.copyWith(
                color: TKitColors.textSecondary,
              ),
            ),
            const VSpace.xxl(),

            // Single action: Turn off
            AccentButton(
              key: const Key('auto-switcher-turn-off-button'),
              onPressed: isLoading ? null : onStop,
              text: l10n.autoSwitcherButtonTurnOff,
              icon: Icons.pause,
              isLoading: isLoading,
              width: double.infinity,
            ),
            if (hotkey != null && hotkey.isNotEmpty) ...[
              const VSpace.lg(),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${l10n.autoSwitcherInstructionPress} ',
                      style: TKitTextStyles.caption.copyWith(
                        color: TKitColors.textMuted,
                      ),
                    ),
                    HotkeyDisplay(
                      hotkeyString: hotkey,
                      keySize: 18,
                      fontSize: 9,
                    ),
                    Text(
                      ' ${l10n.autoSwitcherInstructionManual}',
                      style: TKitTextStyles.caption.copyWith(
                        color: TKitColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ] else ...[
            // When inactive - clear value prop
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.autoSwitcherHeadingEnable,
                  style: TKitTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const VSpace.sm(),
                Text(
                  l10n.autoSwitcherDescriptionInactive,
                  style: TKitTextStyles.bodyMedium.copyWith(
                    color: TKitColors.textSecondary,
                  ),
                ),
              ],
            ),
            const VSpace.xxl(),

            // Single primary action when inactive
            PrimaryButton(
              key: const Key('auto-switcher-turn-on-button'),
              onPressed: isLoading ? null : onStart,
              text: l10n.autoSwitcherButtonTurnOn,
              icon: Icons.play_arrow,
              isLoading: isLoading,
              width: double.infinity,
            ),

            // Show shortcut hint when available
            if (hotkey != null && hotkey.isNotEmpty) ...[
              const VSpace.lg(),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${l10n.autoSwitcherInstructionOr} ',
                      style: TKitTextStyles.caption.copyWith(
                        color: TKitColors.textMuted,
                      ),
                    ),
                    HotkeyDisplay(
                      hotkeyString: hotkey,
                      keySize: 18,
                      fontSize: 9,
                    ),
                    Text(
                      ' ${l10n.autoSwitcherInstructionManual}',
                      style: TKitTextStyles.caption.copyWith(
                        color: TKitColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  String _formatTimestamp(
    BuildContext context,
    AppLocalizations l10n,
    DateTime timestamp,
  ) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return l10n.autoSwitcherTimeSecondsAgo(difference.inSeconds);
    } else if (difference.inMinutes < 60) {
      return l10n.autoSwitcherTimeMinutesAgo(difference.inMinutes);
    } else if (difference.inHours < 24) {
      return l10n.autoSwitcherTimeHoursAgo(difference.inHours);
    } else {
      final format = DateFormat('MMM d, HH:mm');
      return format.format(timestamp);
    }
  }
}
