import 'package:flutter/material.dart';
import 'package:tkit/l10n/app_localizations.dart';
import '../../../../shared/theme/colors.dart';
import '../../../../shared/theme/text_styles.dart';
import '../../../../shared/theme/spacing.dart';
import '../../../../shared/widgets/layout/island.dart';
import '../../../../shared/widgets/layout/spacer.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/buttons/accent_button.dart';
import '../../../../shared/widgets/hotkey_display.dart';

/// Control panel widget for Auto Switcher
/// Contains Start/Stop monitoring and Manual update buttons
class ControlPanel extends StatelessWidget {
  final bool isMonitoring;
  final VoidCallback onStartMonitoring;
  final VoidCallback onStopMonitoring;
  final VoidCallback onManualUpdate;
  final bool isLoading;
  final String? manualUpdateHotkey;

  const ControlPanel({
    super.key,
    required this.isMonitoring,
    required this.onStartMonitoring,
    required this.onStopMonitoring,
    required this.onManualUpdate,
    this.isLoading = false,
    this.manualUpdateHotkey,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Island.comfortable(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Text(l10n.autoSwitcherControlsHeader, style: TKitTextStyles.heading3),
          const VSpace.xxl(),

          // Monitoring control
          if (isMonitoring)
            PrimaryButton(
              onPressed: isLoading ? null : onStopMonitoring,
              text: l10n.autoSwitcherControlsStopMonitoring,
              isLoading: isLoading,
            )
          else
            PrimaryButton(
              onPressed: isLoading ? null : onStartMonitoring,
              text: l10n.autoSwitcherControlsStartMonitoring,
              isLoading: isLoading,
            ),

          const VSpace.lg(),

          // Manual update button with hotkey display
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AccentButton(
                onPressed: isLoading ? null : onManualUpdate,
                text: l10n.autoSwitcherControlsManualUpdate,
              ),
              if (manualUpdateHotkey != null && manualUpdateHotkey!.isNotEmpty) ...[
                const VSpace.sm(),
                Center(
                  child: HotkeyDisplay(
                    hotkeyString: manualUpdateHotkey!,
                    keySize: 24,
                    fontSize: 11,
                  ),
                ),
              ],
            ],
          ),

          const VSpace.xxl(),

          // Status info
          _buildStatusInfo(context),
        ],
      ),
    );
  }

  Widget _buildStatusInfo(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Island(
      padding: const EdgeInsets.all(TKitSpacing.lg),
      backgroundColor: TKitColors.background,
      borderColor: TKitColors.border,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.autoSwitcherControlsMonitoringStatus,
            style: TKitTextStyles.caption.copyWith(
              color: TKitColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const VSpace.sm(),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isMonitoring ? TKitColors.success : TKitColors.textMuted,
                ),
              ),
              const HSpace.sm(),
              Text(
                isMonitoring ? l10n.autoSwitcherControlsActive : l10n.autoSwitcherControlsInactive,
                style: TKitTextStyles.bodyMedium.copyWith(
                  color: isMonitoring
                      ? TKitColors.success
                      : TKitColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const VSpace.md(),
          Text(
            isMonitoring
                ? l10n.autoSwitcherControlsActiveDescription
                : l10n.autoSwitcherControlsInactiveDescription,
            style: TKitTextStyles.caption.copyWith(color: TKitColors.textMuted),
          ),
        ],
      ),
    );
  }
}
