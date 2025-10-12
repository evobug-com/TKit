import 'package:flutter/material.dart';
import '../../theme/colors.dart';

/// Standardized icon-only button
/// Compact design with multiple sizes
enum TKitIconButtonSize {
  small(20, 24),
  medium(20, 32),
  large(24, 40);

  final double iconSize;
  final double buttonSize;

  const TKitIconButtonSize(this.iconSize, this.buttonSize);
}

class TKitIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final TKitIconButtonSize size;
  final Color? color;
  final Color? hoverColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final String? tooltip;
  final bool showBorder;

  const TKitIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = TKitIconButtonSize.medium,
    this.color,
    this.hoverColor,
    this.backgroundColor,
    this.borderColor,
    this.tooltip,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? TKitColors.textSecondary;
    final effectiveHoverColor = hoverColor ?? TKitColors.textPrimary;
    final effectiveBackgroundColor = backgroundColor ?? TKitColors.transparent;
    final effectiveBorderColor = borderColor ?? TKitColors.border;

    Widget button = SizedBox(
      width: size.buttonSize,
      height: size.buttonSize,
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
          hoverColor: effectiveHoverColor.withValues(alpha: 0.1),
          child: Icon(
            icon,
            size: size.iconSize,
            color: onPressed != null ? effectiveColor : TKitColors.textDisabled,
          ),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}
