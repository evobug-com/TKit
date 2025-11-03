import 'package:flutter/material.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/text_styles.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/widgets/layout/spacer.dart';
import 'package:tkit/shared/widgets/tooltips/tooltip.dart';

/// Reusable slider widget with label and numeric value display
class SettingsSlider extends StatefulWidget {
  final String label;
  final String? description;
  final String? example;
  final String? tooltip;
  final double? recommendedValue;
  final String? recommendedLabel;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String suffix;
  final ValueChanged<double> onChanged;
  final String Function(double)? valueFormatter;
  final String? Function(double)? validator;

  const SettingsSlider({
    super.key,
    required this.label,
    this.description,
    this.example,
    this.tooltip,
    this.recommendedValue,
    this.recommendedLabel,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    this.suffix = 's',
    required this.onChanged,
    this.valueFormatter,
    this.validator,
  });

  @override
  State<SettingsSlider> createState() => _SettingsSliderState();
}

class _SettingsSliderState extends State<SettingsSlider>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;
  var _isDragging = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _getFormattedValue() {
    return widget.valueFormatter != null
        ? widget.valueFormatter!(widget.value)
        : '${widget.value.toInt()}${widget.suffix}';
  }

  @override
  Widget build(BuildContext context) {
    final validationMessage = widget.validator?.call(widget.value);
    final isRecommended =
        widget.recommendedValue != null &&
        (widget.value - widget.recommendedValue!).abs() < 0.5;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          alignment: Alignment.centerLeft,
          child: child,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(widget.label, style: TKitTextStyles.labelMedium),
                        if (widget.tooltip != null) ...[
                          const HSpace.xs(),
                          InfoTooltip(
                            message: widget.tooltip!,
                            icon: Icons.help_outline,
                            iconSize: 14,
                          ),
                        ],
                      ],
                    ),
                    if (widget.description != null) ...[
                      const SizedBox(height: TKitSpacing.headerGap),
                      Text(
                        widget.description!,
                        style: TKitTextStyles.bodySmall.copyWith(
                          color: TKitColors.textSecondary,
                        ),
                      ),
                    ],
                    if (widget.example != null) ...[
                      const VSpace.xs(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: TKitSpacing.sm,
                          vertical: TKitSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: TKitColors.accent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(TKitSpacing.xs),
                          border: Border.all(
                            color: TKitColors.accent.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.lightbulb_outline,
                              size: 12,
                              color: TKitColors.accent,
                            ),
                            const HSpace.xs(),
                            Flexible(
                              child: Text(
                                widget.example!,
                                style: TKitTextStyles.caption.copyWith(
                                  color: TKitColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const HSpace.md(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TKitTextStyles.labelLarge.copyWith(
                      color: _isDragging
                          ? TKitColors.accent
                          : isRecommended
                          ? TKitColors.success
                          : TKitColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    child: Text(_getFormattedValue()),
                  ),
                  if (isRecommended) ...[
                    const VSpace(TKitSpacing.headerGap),
                    Container(
                      padding: const EdgeInsets.all(TKitSpacing.xs),
                      decoration: BoxDecoration(
                        color: TKitColors.success.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(TKitSpacing.xs),
                      ),
                      child: Text(
                        widget.recommendedLabel ?? 'Recommended',
                        style: TKitTextStyles.caption.copyWith(
                          color: TKitColors.success,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          const VSpace.xs(),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: TKitColors.accent,
              inactiveTrackColor: TKitColors.border,
              thumbColor: TKitColors.accentBright,
              overlayColor: TKitColors.accent.withValues(alpha: 0.2),
              valueIndicatorColor: TKitColors.surfaceVariant,
              valueIndicatorTextStyle: TKitTextStyles.bodySmall.copyWith(
                color: TKitColors.textPrimary,
              ),
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            ),
            child: Slider(
              value: widget.value,
              min: widget.min,
              max: widget.max,
              divisions: widget.divisions,
              label: _getFormattedValue(),
              onChanged: widget.onChanged,
              onChangeStart: (_) {
                setState(() => _isDragging = true);
                _animationController.forward();
              },
              onChangeEnd: (_) {
                setState(() => _isDragging = false);
                _animationController.reverse();
              },
            ),
          ),
          if (validationMessage != null) ...[
            const VSpace.xs(),
            Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  size: 12,
                  color: TKitColors.warning,
                ),
                const HSpace.xs(),
                Expanded(
                  child: Text(
                    validationMessage,
                    style: TKitTextStyles.caption.copyWith(
                      color: TKitColors.warning,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
