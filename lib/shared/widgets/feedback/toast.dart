import 'package:flutter/material.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/text_styles.dart';
import 'package:tkit/shared/theme/spacing.dart';

/// Toast notification helper
class Toast {
  /// Show a success toast
  static void success(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    _show(
      context,
      message: message,
      icon: Icons.check_circle,
      backgroundColor: TKitColors.success,
      duration: duration,
    );
  }

  /// Show a success toast with custom content
  static void successWithWidget(
    BuildContext context, {
    required Widget content,
    Duration? duration,
  }) {
    _showWithWidget(
      context,
      content: content,
      icon: Icons.check_circle,
      backgroundColor: TKitColors.success,
      duration: duration,
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
    Duration? duration,
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
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        duration: duration ?? const Duration(seconds: 3),
        margin: const EdgeInsets.all(TKitSpacing.md),
      ),
    );
  }

  /// Show a custom toast with widget content
  static void _showWithWidget(
    BuildContext context, {
    required Widget content,
    required IconData icon,
    required Color backgroundColor,
    Duration? duration,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, size: 20, color: TKitColors.textPrimary),
            const SizedBox(width: TKitSpacing.sm),
            Expanded(child: content),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        duration: duration ?? const Duration(seconds: 3),
        margin: const EdgeInsets.all(TKitSpacing.md),
      ),
    );
  }
}
