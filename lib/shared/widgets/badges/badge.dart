import 'package:flutter/material.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/text_styles.dart';

/// Badge variant types
enum TKitBadgeVariant {
  /// Default neutral gray badge
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

/// Small status/count indicator badge
/// Compact design following TKit principles
class TKitBadge extends StatelessWidget {
  /// Text content of the badge (optional for dot-only mode)
  final String? text;

  /// Badge variant determining color
  final TKitBadgeVariant variant;

  /// Dot-only mode - shows just a colored dot without text
  final bool dotOnly;

  /// Custom dot size when in dot-only mode
  final double dotSize;

  const TKitBadge({
    super.key,
    this.text,
    this.variant = TKitBadgeVariant.defaultVariant,
    this.dotOnly = false,
    this.dotSize = 8.0,
  }) : assert(
         dotOnly || text != null,
         'Text is required when not in dot-only mode',
       );

  /// Get color based on variant
  Color get _color {
    switch (variant) {
      case TKitBadgeVariant.defaultVariant:
        return TKitColors.textMuted;
      case TKitBadgeVariant.success:
        return TKitColors.success;
      case TKitBadgeVariant.error:
        return TKitColors.error;
      case TKitBadgeVariant.warning:
        return TKitColors.warning;
      case TKitBadgeVariant.info:
        return TKitColors.info;
    }
  }

  /// Get background color (subtle, low opacity)
  Color get _backgroundColor {
    return _color.withValues(alpha: 0.1);
  }

  @override
  Widget build(BuildContext context) {
    // Dot-only mode - just show a colored square
    if (dotOnly) {
      return Container(
        width: dotSize,
        height: dotSize,
        decoration: BoxDecoration(
          color: _color,
          borderRadius: BorderRadius.circular(0), // Sharp corners
        ),
      );
    }

    // Full badge with text
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: _backgroundColor,
        border: Border.all(color: _color, width: 1),
        borderRadius: BorderRadius.circular(0), // Sharp corners
      ),
      child: Text(
        text!,
        style: TKitTextStyles.caption.copyWith(
          color: _color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          height: 1.0,
        ),
      ),
    );
  }
}

/// Numeric count badge
/// Simplified API for displaying numbers
class TKitCountBadge extends StatelessWidget {
  /// Count to display
  final int count;

  /// Badge variant
  final TKitBadgeVariant variant;

  /// Maximum count to display before showing "99+"
  final int maxCount;

  const TKitCountBadge({
    super.key,
    required this.count,
    this.variant = TKitBadgeVariant.defaultVariant,
    this.maxCount = 99,
  });

  String get _displayText {
    if (count > maxCount) {
      return '$maxCount+';
    }
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    return TKitBadge(text: _displayText, variant: variant);
  }
}
