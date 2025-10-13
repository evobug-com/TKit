import 'package:flutter/material.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/spacing.dart';

/// Island - A container with border and background for grouping content
/// Use this for cards, panels, and content sections
class Island extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;

  const Island({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
  });

  /// Compact island with less padding
  const Island.compact({
    super.key,
    required this.child,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
  }) : padding = const EdgeInsets.all(TKitSpacing.sm);

  /// Standard island with default padding
  const Island.standard({
    super.key,
    required this.child,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
  }) : padding = const EdgeInsets.all(TKitSpacing.md);

  /// Comfortable island with generous padding
  const Island.comfortable({
    super.key,
    required this.child,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
  }) : padding = const EdgeInsets.all(TKitSpacing.lg);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(TKitSpacing.cardPadding),
      decoration: BoxDecoration(
        color: backgroundColor ?? TKitColors.surface,
        border: Border.all(
          color: borderColor ?? TKitColors.border,
          width: borderWidth ?? 1.0,
        ),
      ),
      child: child,
    );
  }
}

/// Surface variant island (lighter background)
class IslandVariant extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const IslandVariant({
    super.key,
    required this.child,
    this.padding,
  });

  const IslandVariant.compact({
    super.key,
    required this.child,
  }) : padding = const EdgeInsets.all(TKitSpacing.sm);

  const IslandVariant.standard({
    super.key,
    required this.child,
  }) : padding = const EdgeInsets.all(TKitSpacing.md);

  @override
  Widget build(BuildContext context) {
    return Island(
      backgroundColor: TKitColors.surfaceVariant,
      padding: padding,
      child: child,
    );
  }
}
