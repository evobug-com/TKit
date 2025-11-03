import 'package:flutter/material.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/text_styles.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/widgets/layout/spacer.dart';

/// Minimal loading indicator (spinner)
class LoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;
  final double strokeWidth;

  const LoadingIndicator({
    super.key,
    this.size = 24,
    this.color,
    this.strokeWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(color ?? TKitColors.accent),
      ),
    );
  }
}

/// Loading indicator with text
class LoadingIndicatorWithText extends StatelessWidget {
  final String text;
  final double size;
  final Color? color;

  const LoadingIndicatorWithText({
    super.key,
    required this.text,
    this.size = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LoadingIndicator(size: size, color: color),
        const VSpace.md(),
        Text(
          text,
          style: TKitTextStyles.bodyMedium.copyWith(
            color: TKitColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// Full-screen centered loading overlay
class LoadingOverlay extends StatelessWidget {
  final String? message;

  const LoadingOverlay({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TKitColors.overlay,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(TKitSpacing.xxl),
          decoration: BoxDecoration(
            color: TKitColors.surface,
            border: Border.all(color: TKitColors.border, width: 1),
            borderRadius: BorderRadius.circular(
              TKitSpacing.xs,
            ), // Minimal rounded corners
          ),
          child: message != null
              ? LoadingIndicatorWithText(text: message!)
              : const LoadingIndicator(size: 32),
        ),
      ),
    );
  }
}
