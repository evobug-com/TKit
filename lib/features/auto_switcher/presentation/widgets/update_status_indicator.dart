import 'package:flutter/material.dart';
import 'package:tkit/shared/theme/colors.dart';

/// 8x8px square status indicator
/// Shows success/error/idle status with colors
class UpdateStatusIndicator extends StatelessWidget {
  final UpdateStatusType status;

  const UpdateStatusIndicator({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: _getStatusColor(),
        // Sharp corners - no border radius
      ),
    );
  }

  Color _getStatusColor() {
    switch (status) {
      case UpdateStatusType.success:
        return AppColors.success;
      case UpdateStatusType.error:
        return AppColors.error;
      case UpdateStatusType.idle:
        return AppColors.textMuted;
      case UpdateStatusType.updating:
        return AppColors.accent;
    }
  }
}

enum UpdateStatusType { success, error, idle, updating }
