import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/text_styles.dart';

/// TKitDivider - Horizontal divider for separating content
class TKitDivider extends StatelessWidget {
  final String? label;
  final Color? color;
  final double thickness;
  final double? indent;
  final double? endIndent;
  final double spacing;

  const TKitDivider({
    super.key,
    this.label,
    this.color,
    this.thickness = 1.0,
    this.indent,
    this.endIndent,
    this.spacing = TKitSpacing.md,
  });

  /// Divider with label text
  const TKitDivider.labeled({
    super.key,
    required this.label,
    this.color,
    this.thickness = 1.0,
    this.spacing = TKitSpacing.md,
  })  : indent = null,
        endIndent = null;

  /// Subtle divider (lighter color)
  const TKitDivider.subtle({
    super.key,
    this.label,
    this.thickness = 1.0,
    this.indent,
    this.endIndent,
    this.spacing = TKitSpacing.md,
  }) : color = TKitColors.borderSubtle;

  /// Section divider (with more spacing)
  const TKitDivider.section({
    super.key,
    this.label,
    this.color,
    this.thickness = 1.0,
    this.indent,
    this.endIndent,
  }) : spacing = TKitSpacing.lg;

  @override
  Widget build(BuildContext context) {
    if (label != null && label!.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: spacing),
        child: Row(
          children: [
            Expanded(
              child: Divider(
                color: color ?? TKitColors.border,
                thickness: thickness,
                height: 0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: TKitSpacing.md),
              child: Text(
                label!,
                style: TKitTextStyles.labelSmall.copyWith(
                  color: TKitColors.textMuted,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: color ?? TKitColors.border,
                thickness: thickness,
                height: 0,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing),
      child: Divider(
        color: color ?? TKitColors.border,
        thickness: thickness,
        indent: indent,
        endIndent: endIndent,
        height: 0,
      ),
    );
  }
}

/// TKitVerticalDivider - Vertical divider for separating content
class TKitVerticalDivider extends StatelessWidget {
  final String? label;
  final Color? color;
  final double thickness;
  final double? indent;
  final double? endIndent;
  final double spacing;
  final double? width;

  const TKitVerticalDivider({
    super.key,
    this.label,
    this.color,
    this.thickness = 1.0,
    this.indent,
    this.endIndent,
    this.spacing = TKitSpacing.md,
    this.width,
  });

  /// Subtle vertical divider (lighter color)
  const TKitVerticalDivider.subtle({
    super.key,
    this.label,
    this.thickness = 1.0,
    this.indent,
    this.endIndent,
    this.spacing = TKitSpacing.md,
    this.width,
  }) : color = TKitColors.borderSubtle;

  @override
  Widget build(BuildContext context) {
    if (label != null && label!.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: spacing),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: VerticalDivider(
                color: color ?? TKitColors.border,
                thickness: thickness,
                width: width,
                indent: indent,
                endIndent: 0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: TKitSpacing.xs),
              child: RotatedBox(
                quarterTurns: 3,
                child: Text(
                  label!,
                  style: TKitTextStyles.labelSmall.copyWith(
                    color: TKitColors.textMuted,
                  ),
                ),
              ),
            ),
            Expanded(
              child: VerticalDivider(
                color: color ?? TKitColors.border,
                thickness: thickness,
                width: width,
                indent: 0,
                endIndent: endIndent,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing),
      child: VerticalDivider(
        color: color ?? TKitColors.border,
        thickness: thickness,
        width: width,
        indent: indent,
        endIndent: endIndent,
      ),
    );
  }
}
