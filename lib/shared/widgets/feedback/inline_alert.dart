import 'package:flutter/material.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/text_styles.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/widgets/feedback/alert.dart';

/// InlineAlert - Compact contextual alert for inline use
/// Smaller than Alert, designed to fit within forms or smaller containers
class InlineAlert extends StatelessWidget {
  final String message;
  final AlertVariant variant;
  final bool showIcon;

  const InlineAlert({
    super.key,
    required this.message,
    this.variant = AlertVariant.info,
    this.showIcon = true,
  });

  const InlineAlert.info({
    super.key,
    required this.message,
    this.showIcon = true,
  }) : variant = AlertVariant.info;

  const InlineAlert.success({
    super.key,
    required this.message,
    this.showIcon = true,
  }) : variant = AlertVariant.success;

  const InlineAlert.warning({
    super.key,
    required this.message,
    this.showIcon = true,
  }) : variant = AlertVariant.warning;

  const InlineAlert.error({
    super.key,
    required this.message,
    this.showIcon = true,
  }) : variant = AlertVariant.error;

  Color _getColor() {
    switch (variant) {
      case AlertVariant.info:
        return TKitColors.info;
      case AlertVariant.success:
        return TKitColors.success;
      case AlertVariant.warning:
        return TKitColors.warning;
      case AlertVariant.error:
        return TKitColors.error;
    }
  }

  IconData _getIcon() {
    switch (variant) {
      case AlertVariant.info:
        return Icons.info_outline;
      case AlertVariant.success:
        return Icons.check_circle_outline;
      case AlertVariant.warning:
        return Icons.warning_amber_outlined;
      case AlertVariant.error:
        return Icons.error_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TKitSpacing.sm,
        vertical: TKitSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _getColor().withValues(alpha: 0.1),
        border: Border.all(
          color: _getColor().withValues(alpha: 0.3),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showIcon) ...[
            Icon(_getIcon(), size: 14, color: _getColor()),
            const SizedBox(width: TKitSpacing.xs),
          ],
          Flexible(
            child: Text(
              message,
              style: TKitTextStyles.bodySmall.copyWith(
                color: TKitColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
