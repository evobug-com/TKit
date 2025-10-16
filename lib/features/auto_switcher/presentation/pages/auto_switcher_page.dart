import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
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
  @override
  void initState() {
    super.initState();
    // Load settings to ensure hotkey is displayed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settingsNotifier = ref.read(settingsProvider.notifier);
      if (ref.read(settingsProvider) is SettingsInitial) {
        settingsNotifier.loadSettings();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const _AutoSwitcherPageContent();
  }
}

class _AutoSwitcherPageContent extends ConsumerWidget {
  const _AutoSwitcherPageContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settingsState = ref.watch(settingsProvider);
    final autoSwitcherAsync = ref.watch(autoSwitcherProvider);

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
                  // Show toast for errors
                  if (state is UpdateError) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Toast.error(context, state.errorMessage);
                    });
                  }

                  // Show success message
                  if (state is UpdateSuccess && state.message != null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Toast.success(context, state.message!);
                    });
                  }

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
                            _buildStatusCard(context, l10n, status, isMonitoring),
                            const VSpace.sm(),

                            // Main control card
                            _buildControlCard(
                              context,
                              l10n,
                              isMonitoring: isMonitoring,
                              isLoading: isLoading,
                              hotkey: manualUpdateHotkey,
                              onStart: () => ref.read(autoSwitcherProvider.notifier).startMonitoring(),
                              onStop: () => ref.read(autoSwitcherProvider.notifier).stopMonitoring(),
                              onUpdate: () => ref.read(autoSwitcherProvider.notifier).manualUpdate(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Text('Error: $error'),
                ),
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
                  color: isMonitoring ? TKitColors.success : TKitColors.textMuted,
                  shape: BoxShape.circle,
                ),
              ),
              const HSpace.sm(),
              Text(
                isMonitoring ? l10n.autoSwitcherStatusActive : l10n.autoSwitcherStatusInactive,
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

  String _formatTimestamp(BuildContext context, AppLocalizations l10n, DateTime timestamp) {
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
