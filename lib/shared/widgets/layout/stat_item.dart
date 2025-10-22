import 'package:flutter/material.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/text_styles.dart';
import 'package:tkit/shared/theme/spacing.dart';

/// StatItem - Display a labeled statistic value
/// Use this for showing metrics and counts
class StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final IconData? icon;

  const StatItem({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 16, color: valueColor ?? TKitColors.accent),
          const SizedBox(width: TKitSpacing.xs),
        ],
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label.toUpperCase(),
              style: TKitTextStyles.caption.copyWith(
                color: TKitColors.textMuted,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: TKitSpacing.headerGap),
            Text(
              value,
              style: TKitTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: valueColor ?? TKitColors.accent,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
