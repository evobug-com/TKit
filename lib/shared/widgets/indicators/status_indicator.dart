import 'package:flutter/material.dart';
import 'package:tkit/shared/theme/colors.dart';

/// Status indicator types
enum StatusType { success, error, warning, idle, info }

/// 8x8px square status indicator with color-coded states
class StatusIndicator extends StatelessWidget {
  final StatusType status;
  final double size;

  const StatusIndicator({super.key, required this.status, this.size = 8});

  Color get _color {
    switch (status) {
      case StatusType.success:
        return TKitColors.success;
      case StatusType.error:
        return TKitColors.error;
      case StatusType.warning:
        return TKitColors.warning;
      case StatusType.idle:
        return TKitColors.idle;
      case StatusType.info:
        return TKitColors.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _color,
        borderRadius: BorderRadius.circular(0), // Sharp corners (square)
      ),
    );
  }
}

/// Animated pulsing status indicator
class PulsingStatusIndicator extends StatefulWidget {
  final StatusType status;
  final double size;

  const PulsingStatusIndicator({
    super.key,
    required this.status,
    this.size = 8,
  });

  @override
  State<PulsingStatusIndicator> createState() => _PulsingStatusIndicatorState();
}

class _PulsingStatusIndicatorState extends State<PulsingStatusIndicator>
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

  Color get _color {
    switch (widget.status) {
      case StatusType.success:
        return TKitColors.success;
      case StatusType.error:
        return TKitColors.error;
      case StatusType.warning:
        return TKitColors.warning;
      case StatusType.idle:
        return TKitColors.idle;
      case StatusType.info:
        return TKitColors.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: _color,
              borderRadius: BorderRadius.circular(0), // Sharp corners
            ),
          ),
        );
      },
    );
  }
}
