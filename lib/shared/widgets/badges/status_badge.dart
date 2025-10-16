import 'package:flutter/material.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/theme/text_styles.dart';

/// Status badge types
enum StatusBadgeType {
  /// Success/online/active state
  success,

  /// Error/offline/failed state
  error,

  /// Warning/pending state
  warning,

  /// Info/processing state
  info,

  /// Idle/inactive/unknown state
  idle,
}

/// Color-coded status indicator badge
/// Combines status indicator with optional text label
class StatusBadge extends StatelessWidget {
  /// Status type
  final StatusBadgeType status;

  /// Optional status text label
  final String? label;

  /// Whether to show the status dot
  final bool showDot;

  /// Size of the status dot
  final double dotSize;

  /// Whether to show the badge in compact mode (dot only, no border)
  final bool compact;

  const StatusBadge({
    super.key,
    required this.status,
    this.label,
    this.showDot = true,
    this.dotSize = 8.0,
    this.compact = false,
  });

  /// Get color based on status
  Color get _color {
    switch (status) {
      case StatusBadgeType.success:
        return TKitColors.success;
      case StatusBadgeType.error:
        return TKitColors.error;
      case StatusBadgeType.warning:
        return TKitColors.warning;
      case StatusBadgeType.info:
        return TKitColors.info;
      case StatusBadgeType.idle:
        return TKitColors.idle;
    }
  }

  /// Get background color
  Color get _backgroundColor {
    return _color.withValues(alpha: 0.1);
  }

  @override
  Widget build(BuildContext context) {
    // Compact mode - just show dot
    if (compact && label == null) {
      return Container(
        width: dotSize,
        height: dotSize,
        decoration: BoxDecoration(
          color: _color,
          borderRadius: BorderRadius.circular(0), // Sharp corners
        ),
      );
    }

    // Build content
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showDot) ...[
          Container(
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: _color,
              borderRadius: BorderRadius.circular(0), // Sharp corners
            ),
          ),
          if (label != null) const SizedBox(width: TKitSpacing.xs),
        ],
        if (label != null)
          Text(
            label!,
            style: TKitTextStyles.labelSmall.copyWith(
              color: _color,
              fontSize: 11,
              height: 1.0,
            ),
          ),
      ],
    );

    // Compact mode with label - no border/background
    if (compact) {
      return content;
    }

    // Full badge with border and background
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: _backgroundColor,
        border: Border.all(color: _color, width: 1),
        borderRadius: BorderRadius.circular(0), // Sharp corners
      ),
      child: content,
    );
  }
}

/// Pulsing status badge for active/live states
/// Useful for showing real-time activity
class PulsingStatusBadge extends StatefulWidget {
  /// Status type
  final StatusBadgeType status;

  /// Optional status text label
  final String? label;

  /// Size of the status dot
  final double dotSize;

  /// Whether to show the badge in compact mode
  final bool compact;

  const PulsingStatusBadge({
    super.key,
    required this.status,
    this.label,
    this.dotSize = 8.0,
    this.compact = false,
  });

  @override
  State<PulsingStatusBadge> createState() => _PulsingStatusBadgeState();
}

class _PulsingStatusBadgeState extends State<PulsingStatusBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Get color based on status
  Color get _color {
    switch (widget.status) {
      case StatusBadgeType.success:
        return TKitColors.success;
      case StatusBadgeType.error:
        return TKitColors.error;
      case StatusBadgeType.warning:
        return TKitColors.warning;
      case StatusBadgeType.info:
        return TKitColors.info;
      case StatusBadgeType.idle:
        return TKitColors.idle;
    }
  }

  /// Get background color
  Color get _backgroundColor {
    return _color.withValues(alpha: 0.1);
  }

  @override
  Widget build(BuildContext context) {
    // Build pulsing dot
    final dot = AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Container(
            width: widget.dotSize,
            height: widget.dotSize,
            decoration: BoxDecoration(
              color: _color,
              borderRadius: BorderRadius.circular(0), // Sharp corners
            ),
          ),
        );
      },
    );

    // Compact mode - just pulsing dot
    if (widget.compact && widget.label == null) {
      return dot;
    }

    // Build content with pulsing dot
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        dot,
        if (widget.label != null) ...[
          const SizedBox(width: TKitSpacing.xs),
          Text(
            widget.label!,
            style: TKitTextStyles.labelSmall.copyWith(
              color: _color,
              fontSize: 11,
              height: 1.0,
            ),
          ),
        ],
      ],
    );

    // Compact mode with label - no border/background
    if (widget.compact) {
      return content;
    }

    // Full badge with border and background
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: _backgroundColor,
        border: Border.all(color: _color, width: 1),
        borderRadius: BorderRadius.circular(0), // Sharp corners
      ),
      child: content,
    );
  }
}
