import 'package:flutter/material.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/text_styles.dart';
import 'package:tkit/shared/theme/spacing.dart';

/// Linear progress bar with percentage
class ProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final String? label;
  final bool showPercentage;
  final double height;
  final Color? color;

  const ProgressBar({
    super.key,
    required this.progress,
    this.label,
    this.showPercentage = true,
    this.height = 6,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).clamp(0, 100).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null || showPercentage)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (label != null)
                Text(
                  label!,
                  style: TKitTextStyles.bodySmall.copyWith(
                    color: TKitColors.textSecondary,
                  ),
                ),
              if (showPercentage)
                Text(
                  '$percentage%',
                  style: TKitTextStyles.bodySmall.copyWith(
                    color: TKitColors.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        if (label != null || showPercentage)
          const SizedBox(height: TKitSpacing.xs),
        Container(
          height: height,
          decoration: BoxDecoration(
            color: TKitColors.surfaceVariant,
            border: Border.all(color: TKitColors.border),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(color: color ?? TKitColors.accent),
          ),
        ),
      ],
    );
  }
}

/// Circular progress indicator with percentage
class CircularProgress extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final double size;
  final double strokeWidth;
  final bool showPercentage;
  final Color? color;

  const CircularProgress({
    super.key,
    required this.progress,
    this.size = 48,
    this.strokeWidth = 4,
    this.showPercentage = true,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).clamp(0, 100).toInt();

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              strokeWidth: strokeWidth,
              backgroundColor: TKitColors.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? TKitColors.accent,
              ),
            ),
          ),
          if (showPercentage)
            Text(
              '$percentage%',
              style: TKitTextStyles.bodySmall.copyWith(
                color: TKitColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}

/// Step progress indicator
class StepProgress extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String>? labels;

  const StepProgress({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps * 2 - 1, (index) {
        if (index.isEven) {
          final stepIndex = index ~/ 2;
          final isCompleted = stepIndex < currentStep;
          final isCurrent = stepIndex == currentStep;

          return Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isCompleted || isCurrent
                        ? TKitColors.accent
                        : TKitColors.surfaceVariant,
                    border: Border.all(
                      color: isCurrent ? TKitColors.accent : TKitColors.border,
                      width: isCurrent ? 2 : 1,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${stepIndex + 1}',
                      style: TKitTextStyles.bodySmall.copyWith(
                        color: isCompleted || isCurrent
                            ? TKitColors.textPrimary
                            : TKitColors.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                if (labels != null && stepIndex < labels!.length) ...[
                  const SizedBox(height: TKitSpacing.xs),
                  Text(
                    labels![stepIndex],
                    style: TKitTextStyles.caption.copyWith(
                      color: isCurrent
                          ? TKitColors.textPrimary
                          : TKitColors.textMuted,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          );
        } else {
          final stepIndex = index ~/ 2;
          final isCompleted = stepIndex < currentStep;

          return Expanded(
            child: Container(
              height: 2,
              color: isCompleted ? TKitColors.accent : TKitColors.border,
              margin: const EdgeInsets.only(bottom: 40),
            ),
          );
        }
      }),
    );
  }
}
