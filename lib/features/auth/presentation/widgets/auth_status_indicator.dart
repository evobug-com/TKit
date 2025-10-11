import 'package:flutter/material.dart';
import '../../../../shared/theme/colors.dart';

/// Status indicator widget (8x8px square)
/// Shows authentication status with colors:
/// - Green: Authenticated
/// - Red: Error/Unauthenticated
/// - Gray: Idle/Loading
class AuthStatusIndicator extends StatelessWidget {
  final AuthIndicatorStatus status;
  final String? tooltip;

  const AuthStatusIndicator({super.key, required this.status, this.tooltip});

  Color get _color {
    switch (status) {
      case AuthIndicatorStatus.authenticated:
        return TKitColors.success;
      case AuthIndicatorStatus.unauthenticated:
        return TKitColors.error;
      case AuthIndicatorStatus.loading:
      case AuthIndicatorStatus.idle:
        return TKitColors.idle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final indicator = Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: _color, borderRadius: BorderRadius.zero),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: indicator);
    }

    return indicator;
  }
}

/// Status values for the authentication indicator
enum AuthIndicatorStatus { authenticated, unauthenticated, loading, idle }
