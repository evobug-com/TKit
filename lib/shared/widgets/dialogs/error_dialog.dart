import 'package:flutter/material.dart';
import 'package:tkit/l10n/app_localizations.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/theme/text_styles.dart';
import 'package:tkit/shared/widgets/buttons/primary_button.dart';
import 'package:tkit/shared/widgets/indicators/status_indicator.dart';
import 'package:tkit/shared/widgets/layout/spacer.dart';

/// Error dialog for displaying error messages
class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? details;
  final String? buttonText;
  final VoidCallback? onDismiss;

  const ErrorDialog({
    super.key,
    required this.title,
    required this.message,
    this.details,
    this.buttonText,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final effectiveButtonText = buttonText ?? l10n.commonOk;

    return Dialog(
      backgroundColor: TKitColors.surface,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0), // Sharp corners
        side: const BorderSide(color: TKitColors.border, width: 1),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, minWidth: 360),
        child: Padding(
          padding: const EdgeInsets.all(TKitSpacing.xxl), // Design system: Use TKitSpacing
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title with error indicator
              Row(
                children: [
                  const StatusIndicator(status: StatusType.error, size: 12),
                  const HSpace.md(), // Design system: Use HSpace instead of hardcoded values
                  Expanded(child: Text(title, style: TKitTextStyles.heading3)),
                ],
              ),
              const VSpace.lg(), // Design system: Use VSpace instead of hardcoded values

              // Message
              Text(
                message,
                style: TKitTextStyles.bodyMedium.copyWith(
                  color: TKitColors.textSecondary,
                ),
              ),

              // Details (optional)
              if (details != null) ...[
                const VSpace.lg(), // Design system: Use VSpace instead of hardcoded values
                Container(
                  padding: const EdgeInsets.all(TKitSpacing.md), // Design system: Use TKitSpacing
                  decoration: BoxDecoration(
                    color: TKitColors.surfaceVariant,
                    border: Border.all(color: TKitColors.border, width: 1),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: SelectableText(
                    details!,
                    style: TKitTextStyles.code.copyWith(
                      fontSize: 12,
                      color: TKitColors.textMuted,
                    ),
                  ),
                ),
              ],

              const VSpace.xxl(), // Design system: Use VSpace instead of hardcoded values

              // Action
              Align(
                alignment: Alignment.centerRight,
                child: PrimaryButton(
                  text: effectiveButtonText,
                  onPressed: () {
                    Navigator.of(context).pop();
                    onDismiss?.call();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Show the error dialog
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    String? details,
    String? buttonText,
    VoidCallback? onDismiss,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (context) => ErrorDialog(
        title: title,
        message: message,
        details: details,
        buttonText: buttonText,
        onDismiss: onDismiss,
      ),
    );
  }
}
