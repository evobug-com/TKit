import 'package:flutter/material.dart';
import 'package:tkit/shared/theme/colors.dart';

/// Panel card with 1px border, sharp corners, dark background
class PanelCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;

  const PanelCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: TKitColors.surface,
        border: Border.all(color: TKitColors.border, width: 1),
        borderRadius: BorderRadius.circular(0), // Sharp corners
      ),
      padding: padding ?? const EdgeInsets.all(16),
      child: child,
    );
  }
}
