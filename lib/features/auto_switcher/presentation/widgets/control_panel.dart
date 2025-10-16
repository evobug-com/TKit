import 'package:flutter/material.dart';
import 'package:tkit/l10n/app_localizations.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/text_styles.dart';
import 'package:tkit/shared/widgets/layout/island.dart';
import 'package:tkit/shared/widgets/layout/spacer.dart';
import 'package:tkit/shared/widgets/buttons/primary_button.dart';
import 'package:tkit/shared/widgets/buttons/accent_button.dart';
import 'package:tkit/shared/widgets/hotkey_display.dart';

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
    return Island.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Primary action - prominent
          if (isMonitoring) ...[
            // When monitoring is active
            IslandVariant.standard(
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: TKitColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const HSpace.md(),
                  Expanded(
                    child: Text(
                      l10n.autoSwitcherControlsActive,
                      style: TKitTextStyles.labelLarge.copyWith(
                        color: TKitColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const VSpace.md(),
            AccentButton(
              onPressed: isLoading ? null : onStopMonitoring,
              text: l10n.autoSwitcherControlsStopMonitoring,
              icon: Icons.stop_circle_outlined,
              isLoading: isLoading,
              width: double.infinity,
            ),
          ] else ...[
            // When monitoring is NOT active - make it clear what to do
            IslandVariant.standard(
              child: Column(
                children: [
                  const Icon(
                    Icons.play_circle_outlined,
                    size: 32,
                    color: TKitColors.textMuted,
                  ),
                  const VSpace.md(),
                  Text(
                    'Start monitoring to automatically switch categories',
                    style: TKitTextStyles.bodyMedium.copyWith(
                      color: TKitColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const VSpace.md(),
            PrimaryButton(
              onPressed: isLoading ? null : onStartMonitoring,
              text: l10n.autoSwitcherControlsStartMonitoring,
              icon: Icons.play_circle_outlined,
              isLoading: isLoading,
              width: double.infinity,
            ),
          ],

          const VSpace.lg(),

          // Divider
          Container(height: 1, color: TKitColors.border),

          const VSpace.lg(),

          // Quick action with clear purpose
          Row(
            children: [
              const Icon(
                Icons.bolt_outlined,
                size: 16,
                color: TKitColors.textMuted,
              ),
              const HSpace.sm(),
              Text(
                'Quick Action',
                style: TKitTextStyles.caption.copyWith(
                  color: TKitColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const VSpace.md(),

          AccentButton(
            onPressed: isLoading ? null : onManualUpdate,
            text: 'Check & Update Now',
            icon: Icons.refresh,
            width: double.infinity,
          ),

          if (manualUpdateHotkey != null && manualUpdateHotkey!.isNotEmpty) ...[
            const VSpace.sm(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Shortcut: ',
                  style: TKitTextStyles.caption.copyWith(
                    color: TKitColors.textMuted,
                  ),
                ),
                const HSpace.xs(),
                HotkeyDisplay(
                  hotkeyString: manualUpdateHotkey!,
                  keySize: 20,
                  fontSize: 10,
                ),
              ],
            ),
          ],

          const VSpace.sm(),

          Text(
            'Checks active app and updates category immediately',
            style: TKitTextStyles.caption.copyWith(color: TKitColors.textMuted),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
