import 'package:flutter/material.dart';
import 'package:tkit/shared/theme/spacing.dart';

/// Vertical spacing widgets
class VSpace extends StatelessWidget {
  final double height;

  const VSpace(this.height, {super.key});

  const VSpace.xs({super.key}) : height = TKitSpacing.xs;
  const VSpace.sm({super.key}) : height = TKitSpacing.sm;
  const VSpace.md({super.key}) : height = TKitSpacing.md;
  const VSpace.lg({super.key}) : height = TKitSpacing.lg;
  const VSpace.xl({super.key}) : height = TKitSpacing.xl;
  const VSpace.xxl({super.key}) : height = TKitSpacing.xxl;

  @override
  Widget build(BuildContext context) => SizedBox(height: height);
}

/// Horizontal spacing widgets
class HSpace extends StatelessWidget {
  final double width;

  const HSpace(this.width, {super.key});

  const HSpace.xs({super.key}) : width = TKitSpacing.xs;
  const HSpace.sm({super.key}) : width = TKitSpacing.sm;
  const HSpace.md({super.key}) : width = TKitSpacing.md;
  const HSpace.lg({super.key}) : width = TKitSpacing.lg;
  const HSpace.xl({super.key}) : width = TKitSpacing.xl;
  const HSpace.xxl({super.key}) : width = TKitSpacing.xxl;

  @override
  Widget build(BuildContext context) => SizedBox(width: width);
}
