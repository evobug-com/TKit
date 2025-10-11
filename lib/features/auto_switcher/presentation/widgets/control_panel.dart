import 'package:flutter/material.dart';
import 'package:tkit/l10n/app_localizations.dart';
import '../../../../shared/theme/colors.dart';
import '../../../../shared/theme/text_styles.dart';
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
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Text(l10n.autoSwitcherControlsHeader, style: AppTextStyles.heading3),
          const SizedBox(height: 24),

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

          const SizedBox(height: 16),

          // Manual update button with hotkey display
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AccentButton(
                onPressed: isLoading ? null : onManualUpdate,
                text: l10n.autoSwitcherControlsManualUpdate,
              ),
              if (manualUpdateHotkey != null && manualUpdateHotkey!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Center(
                  child: HotkeyDisplay(
                    hotkeyString: manualUpdateHotkey!,
                    keySize: 24,
                    fontSize: 10,
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 24),

          // Status info
          _buildStatusInfo(context),
        ],
      ),
    );
  }

  Widget _buildStatusInfo(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.autoSwitcherControlsMonitoringStatus,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isMonitoring ? AppColors.success : AppColors.textMuted,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                isMonitoring ? l10n.autoSwitcherControlsActive : l10n.autoSwitcherControlsInactive,
                style: AppTextStyles.body.copyWith(
                  color: isMonitoring
                      ? AppColors.success
                      : AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            isMonitoring
                ? l10n.autoSwitcherControlsActiveDescription
                : l10n.autoSwitcherControlsInactiveDescription,
            style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
