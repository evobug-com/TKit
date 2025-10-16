import 'package:flutter/material.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/text_styles.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/widgets/buttons/primary_button.dart';
import 'package:tkit/shared/widgets/buttons/accent_button.dart';

/// Base dialog template with consistent styling
class BaseDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget>? actions;
  final IconData? icon;
  final Color? iconColor;
  final double? width;

  const BaseDialog({
    super.key,
    required this.title,
    required this.content,
    this.actions,
    this.icon,
    this.iconColor,
    this.width = 500,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: TKitColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          border: Border.all(color: TKitColors.border),
          color: TKitColors.surface,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(TKitSpacing.md),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: TKitColors.border)),
                color: TKitColors.surfaceVariant,
              ),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: iconColor ?? TKitColors.accent, size: 20),
                    const SizedBox(width: TKitSpacing.sm),
                  ],
                  Expanded(child: Text(title, style: TKitTextStyles.heading3)),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    color: TKitColors.textSecondary,
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(TKitSpacing.md),
                child: content,
              ),
            ),

            // Actions
            if (actions != null && actions!.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(TKitSpacing.md),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: TKitColors.border)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Quick action dialog helper
class QuickActionDialog {
  /// Show a confirmation dialog
  static Future<bool> confirm({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    IconData? icon,
    Color? iconColor,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => BaseDialog(
        title: title,
        icon: icon ?? Icons.help_outline,
        iconColor: iconColor ?? TKitColors.warning,
        content: Text(message, style: TKitTextStyles.bodyMedium),
        actions: [
          AccentButton(
            text: cancelText,
            onPressed: () => Navigator.of(context).pop(false),
          ),
          const SizedBox(width: TKitSpacing.sm),
          PrimaryButton(
            text: confirmText,
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Show an info dialog
  static Future<void> info({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
    IconData? icon,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (context) => BaseDialog(
        title: title,
        icon: icon ?? Icons.info_outline,
        iconColor: TKitColors.info,
        content: Text(message, style: TKitTextStyles.bodyMedium),
        actions: [
          PrimaryButton(
            text: buttonText,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  /// Show an error dialog
  static Future<void> error({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
  }) async {
    await showDialog<void>(
      context: context,
      builder: (context) => BaseDialog(
        title: title,
        icon: Icons.error_outline,
        iconColor: TKitColors.error,
        content: Text(message, style: TKitTextStyles.bodyMedium),
        actions: [
          PrimaryButton(
            text: buttonText,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
