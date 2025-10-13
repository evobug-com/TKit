import 'package:flutter/material.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/text_styles.dart';
import 'package:tkit/shared/theme/spacing.dart';

/// EmptyState - Display when there's no content to show
/// Use this for empty lists, searches with no results, etc.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? subtitle;
  final Widget? action;

  const EmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 48,
            color: TKitColors.textMuted,
          ),
          const SizedBox(height: TKitSpacing.md),
          Text(
            message,
            style: TKitTextStyles.bodyMedium.copyWith(
              color: TKitColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: TKitSpacing.xs),
            Text(
              subtitle!,
              style: TKitTextStyles.bodySmall.copyWith(
                color: TKitColors.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (action != null) ...[
            const SizedBox(height: TKitSpacing.lg),
            action!,
          ],
        ],
      ),
    );
  }
}
