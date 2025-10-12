import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../theme/spacing.dart';

/// Toast notification helper
class Toast {
  /// Show a success toast
  static void success(BuildContext context, String message) {
    _show(
      context,
      message: message,
      icon: Icons.check_circle,
      backgroundColor: TKitColors.success,
    );
  }

  /// Show an error toast
  static void error(BuildContext context, String message) {
    _show(
      context,
      message: message,
      icon: Icons.error,
      backgroundColor: TKitColors.error,
    );
  }

  /// Show a warning toast
  static void warning(BuildContext context, String message) {
    _show(
      context,
      message: message,
      icon: Icons.warning,
      backgroundColor: TKitColors.warning,
    );
  }

  /// Show an info toast
  static void info(BuildContext context, String message) {
    _show(
      context,
      message: message,
      icon: Icons.info,
      backgroundColor: TKitColors.info,
    );
  }

  /// Show a custom toast
  static void _show(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color backgroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, size: 20, color: TKitColors.textPrimary),
            const SizedBox(width: TKitSpacing.sm),
            Expanded(
              child: Text(
                message,
                style: TKitTextStyles.bodyMedium.copyWith(
                  color: TKitColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        duration: duration,
        margin: const EdgeInsets.all(TKitSpacing.md),
      ),
    );
  }
}
