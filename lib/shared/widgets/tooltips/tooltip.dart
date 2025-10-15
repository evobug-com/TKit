import 'package:flutter/material.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/theme/text_styles.dart';

/// TKit styled tooltip wrapper
/// Provides consistent tooltip styling across the app
class TKitTooltip extends StatelessWidget {
  final String message;
  final Widget child;
  final TooltipTriggerMode? triggerMode;
  final Duration? waitDuration;
  final Duration? showDuration;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? verticalOffset;
  final bool preferBelow;

  const TKitTooltip({
    super.key,
    required this.message,
    required this.child,
    this.triggerMode,
    this.waitDuration,
    this.showDuration,
    this.padding,
    this.margin,
    this.verticalOffset,
    this.preferBelow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      textStyle: TKitTextStyles.bodySmall.copyWith(
        color: TKitColors.textPrimary,
      ),
      decoration: BoxDecoration(
        color: TKitColors.surfaceVariant,
        borderRadius: BorderRadius.circular(TKitSpacing.xs),
        border: Border.all(
          color: TKitColors.border,
          width: 1,
        ),
        boxShadow: [
          const BoxShadow(
            color: TKitColors.overlay,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: padding ?? const EdgeInsets.symmetric(
        horizontal: TKitSpacing.sm,
        vertical: TKitSpacing.xs,
      ),
      margin: margin ?? const EdgeInsets.all(TKitSpacing.xs),
      verticalOffset: verticalOffset ?? 8,
      preferBelow: preferBelow,
      triggerMode: triggerMode ?? TooltipTriggerMode.longPress,
      waitDuration: waitDuration ?? const Duration(milliseconds: 500),
      showDuration: showDuration ?? const Duration(seconds: 2),
      child: child,
    );
  }
}

/// Icon button with tooltip for help text
/// Useful for providing contextual help in forms and UI elements
class InfoTooltip extends StatelessWidget {
  final String message;
  final IconData icon;
  final double? iconSize;
  final Color? iconColor;
  final VoidCallback? onTap;
  final TooltipTriggerMode? triggerMode;

  const InfoTooltip({
    super.key,
    required this.message,
    this.icon = Icons.help_outline,
    this.iconSize,
    this.iconColor,
    this.onTap,
    this.triggerMode,
  });

  @override
  Widget build(BuildContext context) {
    final iconWidget = Icon(
      icon,
      size: iconSize ?? 16,
      color: iconColor ?? TKitColors.textMuted,
    );

    final tooltipChild = onTap != null
        ? InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(TKitSpacing.xs),
            child: Padding(
              padding: const EdgeInsets.all(TKitSpacing.xs),
              child: iconWidget,
            ),
          )
        : iconWidget;

    return TKitTooltip(
      message: message,
      triggerMode: triggerMode ?? TooltipTriggerMode.tap,
      waitDuration: const Duration(milliseconds: 0),
      child: tooltipChild,
    );
  }
}
