import 'package:flutter/material.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/theme/text_styles.dart';

/// Tag variant types
enum TKitTagVariant {
  /// Default neutral gray tag
  defaultVariant,

  /// Success state (green)
  success,

  /// Error state (red)
  error,

  /// Warning state (orange)
  warning,

  /// Info state (blue)
  info,
}

/// Chip/tag component for labels and selections
/// Compact design following TKit principles
class TKitTag extends StatelessWidget {
  /// Tag label text
  final String label;

  /// Tag variant determining color
  final TKitTagVariant variant;

  /// Optional leading icon
  final IconData? icon;

  /// Whether the tag can be removed
  final bool removable;

  /// Callback when tag is removed (only called if removable is true)
  final VoidCallback? onRemove;

  /// Callback when tag is tapped
  final VoidCallback? onTap;

  /// Whether the tag is selected (for selectable tags)
  final bool selected;

  const TKitTag({
    super.key,
    required this.label,
    this.variant = TKitTagVariant.defaultVariant,
    this.icon,
    this.removable = false,
    this.onRemove,
    this.onTap,
    this.selected = false,
  }) : assert(!removable || onRemove != null, 'onRemove callback is required when removable is true');

  /// Get color based on variant
  Color get _color {
    switch (variant) {
      case TKitTagVariant.defaultVariant:
        return TKitColors.textMuted;
      case TKitTagVariant.success:
        return TKitColors.success;
      case TKitTagVariant.error:
        return TKitColors.error;
      case TKitTagVariant.warning:
        return TKitColors.warning;
      case TKitTagVariant.info:
        return TKitColors.info;
    }
  }

  /// Get background color
  Color get _backgroundColor {
    if (selected) {
      return _color.withValues(alpha: 0.15);
    }
    return TKitColors.surfaceVariant;
  }

  /// Get border color
  Color get _borderColor {
    if (selected) {
      return _color;
    }
    return TKitColors.border;
  }

  /// Get text color
  Color get _textColor {
    if (selected) {
      return _color;
    }
    return TKitColors.textSecondary;
  }

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: 12,
            color: _textColor,
          ),
          const SizedBox(width: TKitSpacing.xs),
        ],
        Text(
          label,
          style: TKitTextStyles.labelSmall.copyWith(
            color: _textColor,
            fontSize: 11,
            height: 1.0,
          ),
        ),
        if (removable) ...[
          const SizedBox(width: TKitSpacing.xs),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close,
              size: 12,
              color: _textColor,
            ),
          ),
        ],
      ],
    );

    final container = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TKitSpacing.sm,
        vertical: TKitSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _backgroundColor,
        border: Border.all(color: _borderColor, width: 1),
        borderRadius: BorderRadius.circular(0), // Sharp corners
      ),
      child: content,
    );

    // If tappable, wrap in InkWell
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        hoverColor: _color.withValues(alpha: 0.05),
        child: container,
      );
    }

    return container;
  }
}

/// Tag group for displaying multiple tags
/// Automatically handles layout and spacing
class TKitTagGroup extends StatelessWidget {
  /// List of tags to display
  final List<Widget> tags;

  /// Spacing between tags
  final double spacing;

  /// Whether to wrap tags to multiple lines
  final bool wrap;

  const TKitTagGroup({
    super.key,
    required this.tags,
    this.spacing = TKitSpacing.xs,
    this.wrap = true,
  });

  @override
  Widget build(BuildContext context) {
    if (wrap) {
      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: tags,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < tags.length; i++) ...[
          tags[i],
          if (i < tags.length - 1) SizedBox(width: spacing),
        ],
      ],
    );
  }
}
