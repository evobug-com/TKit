import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/text_styles.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/widgets/layout/spacer.dart';
import 'package:tkit/shared/widgets/layout/island.dart';
import 'package:tkit/shared/widgets/buttons/primary_button.dart';
import 'package:tkit/shared/widgets/buttons/accent_button.dart';
import 'package:tkit/shared/widgets/hotkey_display.dart';
import 'package:tkit/features/auto_switcher/domain/entities/orchestration_status.dart';
import 'package:tkit/features/auto_switcher/presentation/widgets/update_status_indicator.dart';

/// Unified Auto Switcher control panel
/// Combines status display and controls in one intuitive interface
class AutoSwitcherPanel extends StatelessWidget {
  final OrchestrationStatus? status;
  final bool isMonitoring;
  final VoidCallback onStartMonitoring;
  final VoidCallback onStopMonitoring;
  final VoidCallback onManualUpdate;
  final bool isLoading;
  final String? manualUpdateHotkey;

  const AutoSwitcherPanel({
    super.key,
    required this.status,
    required this.isMonitoring,
    required this.onStartMonitoring,
    required this.onStopMonitoring,
    required this.onManualUpdate,
    this.isLoading = false,
    this.manualUpdateHotkey,
  });

  @override
  Widget build(BuildContext context) {
    return Island.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header - What is this?
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(TKitSpacing.sm),
                decoration: BoxDecoration(
                  color: TKitColors.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  size: 20,
                  color: TKitColors.accent,
                ),
              ),
              const HSpace.md(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Auto Category Switcher',
                      style: TKitTextStyles.labelLarge.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Automatically changes your category based on what app you\'re using',
                      style: TKitTextStyles.caption.copyWith(
                        color: TKitColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const VSpace.lg(),

          // Current Status Card
          _buildCurrentStatus(context),

          const VSpace.lg(),

          // Main Control with guidance
          if (isMonitoring) ...[
            // Active state
            IslandVariant.standard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: TKitColors.success,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const HSpace.sm(),
                      Text(
                        '✓ Automatic switching is ON',
                        style: TKitTextStyles.bodyMedium.copyWith(
                          color: TKitColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _getActivityText(context),
                        style: TKitTextStyles.caption.copyWith(
                          color: TKitColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const VSpace.sm(),
                  Text(
                    'Your category will automatically change when you switch apps. You can turn this off anytime.',
                    style: TKitTextStyles.caption.copyWith(
                      color: TKitColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const VSpace.md(),
            AccentButton(
              onPressed: isLoading ? null : onStopMonitoring,
              text: 'Turn Off Auto-Switching',
              icon: Icons.pause_circle_outlined,
              isLoading: isLoading,
              width: double.infinity,
            ),
          ] else ...[
            // Inactive state with clear guidance
            IslandVariant.standard(
              child: Column(
                children: [
                  const Icon(
                    Icons.touch_app_outlined,
                    size: 40,
                    color: TKitColors.accent,
                  ),
                  const VSpace.md(),
                  Text(
                    'Get Started',
                    style: TKitTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const VSpace.sm(),
                  Text(
                    'Turn on automatic switching and your category will change whenever you switch to a different app.',
                    style: TKitTextStyles.bodySmall.copyWith(
                      color: TKitColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const VSpace.md(),
                  // How it works steps
                  _buildHowItWorksStep(
                    '1',
                    'You switch to an app (e.g., VS Code)',
                  ),
                  const VSpace.sm(),
                  _buildHowItWorksStep('2', 'System finds matching category'),
                  const VSpace.sm(),
                  _buildHowItWorksStep('3', 'Category changes automatically'),
                ],
              ),
            ),
            const VSpace.md(),
            PrimaryButton(
              onPressed: isLoading ? null : onStartMonitoring,
              text: 'Turn On Auto-Switching',
              icon: Icons.play_circle_outlined,
              isLoading: isLoading,
              width: double.infinity,
            ),
          ],

          const VSpace.lg(),

          // Divider
          Container(height: 1, color: TKitColors.borderSubtle),

          const VSpace.lg(),

          // Manual trigger with clear explanation
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: TKitColors.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.bolt,
                  size: 16,
                  color: TKitColors.accent,
                ),
              ),
              const HSpace.md(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Switch',
                      style: TKitTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const VSpace.xs(),
                    Text(
                      'Instantly check your active app and switch to the matching category right now',
                      style: TKitTextStyles.caption.copyWith(
                        color: TKitColors.textMuted,
                      ),
                    ),
                    if (manualUpdateHotkey != null &&
                        manualUpdateHotkey!.isNotEmpty) ...[
                      const VSpace.sm(),
                      Row(
                        children: [
                          Text(
                            'Keyboard shortcut: ',
                            style: TKitTextStyles.caption.copyWith(
                              color: TKitColors.textMuted,
                            ),
                          ),
                          HotkeyDisplay(
                            hotkeyString: manualUpdateHotkey!,
                            keySize: 18,
                            fontSize: 9,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const VSpace.md(),
          AccentButton(
            onPressed: isLoading ? null : onManualUpdate,
            text: 'Switch Now',
            icon: Icons.refresh,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildHowItWorksStep(String number, String text) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: TKitColors.accent.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: TKitTextStyles.caption.copyWith(
                color: TKitColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
            ),
          ),
        ),
        const HSpace.md(),
        Expanded(
          child: Text(
            text,
            style: TKitTextStyles.bodySmall.copyWith(
              color: TKitColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentStatus(BuildContext context) {
    final hasProcess = status?.currentProcess != null;
    final hasCategory = status?.matchedCategory != null;

    return IslandVariant.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Right Now',
            style: TKitTextStyles.caption.copyWith(
              color: TKitColors.textMuted,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w600,
            ),
          ),
          const VSpace.md(),
          Row(
            children: [
              const Icon(Icons.apps, size: 18, color: TKitColors.textMuted),
              const HSpace.sm(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Active App',
                      style: TKitTextStyles.caption.copyWith(
                        color: TKitColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      hasProcess ? status!.currentProcess! : 'None detected',
                      style: TKitTextStyles.bodyMedium.copyWith(
                        color: hasProcess
                            ? TKitColors.textPrimary
                            : TKitColors.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const VSpace.md(),
          Row(
            children: [
              const Icon(
                Icons.label_outline,
                size: 18,
                color: TKitColors.textMuted,
              ),
              const HSpace.sm(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Category',
                      style: TKitTextStyles.caption.copyWith(
                        color: TKitColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      hasCategory ? status!.matchedCategory! : 'None set',
                      style: TKitTextStyles.bodyMedium.copyWith(
                        color: hasCategory
                            ? TKitColors.textPrimary
                            : TKitColors.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (status?.lastUpdateTime != null) ...[
            const VSpace.md(),
            Row(
              children: [
                UpdateStatusIndicator(
                  status: status?.lastUpdateSuccess == true
                      ? UpdateStatusType.success
                      : UpdateStatusType.error,
                ),
                const HSpace.xs(),
                Text(
                  'Last updated ${_formatTimestamp(status!.lastUpdateTime!)}',
                  style: TKitTextStyles.caption.copyWith(
                    color: TKitColors.textMuted,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _getActivityText(BuildContext context) {
    if (status == null) {
      return 'Ready';
    }
    switch (status!.state) {
      case OrchestrationState.idle:
        return 'Ready';
      case OrchestrationState.detectingProcess:
        return 'Checking...';
      case OrchestrationState.searchingMapping:
        return 'Finding...';
      case OrchestrationState.updatingCategory:
        return 'Updating...';
      case OrchestrationState.waitingDebounce:
        return 'Waiting...';
      case OrchestrationState.error:
        return 'Error';
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return DateFormat('MMM d, HH:mm').format(timestamp);
    }
  }
}
