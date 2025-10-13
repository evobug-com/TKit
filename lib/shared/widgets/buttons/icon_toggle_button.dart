import 'package:flutter/material.dart';
import 'package:tkit/shared/theme/colors.dart';

/// Toggle button with icon states
/// Shows different icon/color when active
class IconToggleButton extends StatelessWidget {
  final bool isActive;
  final IconData icon;
  final IconData? activeIcon;
  final VoidCallback? onPressed;
  final double size;
  final Color? color;
  final Color? activeColor;
  final Color? backgroundColor;
  final Color? activeBackgroundColor;
  final Color? borderColor;
  final Color? activeBorderColor;
  final String? tooltip;
  final String? activeTooltip;
  final bool showBorder;

  const IconToggleButton({
    super.key,
    required this.isActive,
    required this.icon,
    this.activeIcon,
    this.onPressed,
    this.size = 32,
    this.color,
    this.activeColor,
    this.backgroundColor,
    this.activeBackgroundColor,
    this.borderColor,
    this.activeBorderColor,
    this.tooltip,
    this.activeTooltip,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIcon = isActive ? (activeIcon ?? icon) : icon;
    final effectiveColor = isActive
        ? (activeColor ?? TKitColors.accent)
        : (color ?? TKitColors.textSecondary);
    final effectiveBackgroundColor = isActive
        ? (activeBackgroundColor ?? TKitColors.surfaceVariant)
        : (backgroundColor ?? TKitColors.transparent);
    final effectiveBorderColor = isActive
        ? (activeBorderColor ?? TKitColors.accent)
        : (borderColor ?? TKitColors.border);
    final effectiveTooltip =
        isActive ? (activeTooltip ?? tooltip) : tooltip;

    Widget button = SizedBox(
      width: size,
      height: size,
      child: Material(
        color: effectiveBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: showBorder
              ? BorderSide(color: effectiveBorderColor)
              : BorderSide.none,
        ),
        child: InkWell(
          onTap: onPressed,
          hoverColor: effectiveColor.withValues(alpha: 0.1),
          child: Icon(
            effectiveIcon,
            size: size * 0.6,
            color: onPressed != null ? effectiveColor : TKitColors.textDisabled,
          ),
        ),
      ),
    );

    if (effectiveTooltip != null) {
      return Tooltip(
        message: effectiveTooltip,
        child: button,
      );
    }

    return button;
  }
}
