import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../theme/spacing.dart';

/// Alert variant types
enum AlertVariant {
  info,
  success,
  warning,
  error,
}

/// Alert - Persistent notification banner with variants
/// Use this for important messages that need to stay visible
class Alert extends StatefulWidget {
  final String message;
  final AlertVariant variant;
  final bool dismissible;
  final VoidCallback? onDismiss;
  final String? actionLabel;
  final VoidCallback? onAction;
  final EdgeInsets? padding;

  const Alert({
    super.key,
    required this.message,
    this.variant = AlertVariant.info,
    this.dismissible = false,
    this.onDismiss,
    this.actionLabel,
    this.onAction,
    this.padding,
  });

  /// Info alert (blue)
  const Alert.info({
    super.key,
    required this.message,
    this.dismissible = false,
    this.onDismiss,
    this.actionLabel,
    this.onAction,
    this.padding,
  }) : variant = AlertVariant.info;

  /// Success alert (green)
  const Alert.success({
    super.key,
    required this.message,
    this.dismissible = false,
    this.onDismiss,
    this.actionLabel,
    this.onAction,
    this.padding,
  }) : variant = AlertVariant.success;

  /// Warning alert (orange)
  const Alert.warning({
    super.key,
    required this.message,
    this.dismissible = false,
    this.onDismiss,
    this.actionLabel,
    this.onAction,
    this.padding,
  }) : variant = AlertVariant.warning;

  /// Error alert (red)
  const Alert.error({
    super.key,
    required this.message,
    this.dismissible = false,
    this.onDismiss,
    this.actionLabel,
    this.onAction,
    this.padding,
  }) : variant = AlertVariant.error;

  @override
  State<Alert> createState() => _AlertState();
}

class _AlertState extends State<Alert> {
  bool _visible = true;

  void _dismiss() {
    setState(() {
      _visible = false;
    });
    widget.onDismiss?.call();
  }

  Color _getBackgroundColor() {
    switch (widget.variant) {
      case AlertVariant.info:
        return TKitColors.info.withValues(alpha: 0.1);
      case AlertVariant.success:
        return TKitColors.success.withValues(alpha: 0.1);
      case AlertVariant.warning:
        return TKitColors.warning.withValues(alpha: 0.1);
      case AlertVariant.error:
        return TKitColors.error.withValues(alpha: 0.1);
    }
  }

  Color _getBorderColor() {
    switch (widget.variant) {
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
    switch (widget.variant) {
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
    if (!_visible) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: widget.padding ?? const EdgeInsets.all(TKitSpacing.md),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        border: Border.all(
          color: _getBorderColor(),
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            _getIcon(),
            size: 18,
            color: _getBorderColor(),
          ),
          const SizedBox(width: TKitSpacing.sm),
          Expanded(
            child: Text(
              widget.message,
              style: TKitTextStyles.bodyMedium.copyWith(
                color: TKitColors.textPrimary,
              ),
            ),
          ),
          if (widget.actionLabel != null && widget.onAction != null) ...[
            const SizedBox(width: TKitSpacing.sm),
            InkWell(
              onTap: widget.onAction,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: TKitSpacing.sm,
                  vertical: TKitSpacing.xs,
                ),
                child: Text(
                  widget.actionLabel!,
                  style: TKitTextStyles.labelSmall.copyWith(
                    color: _getBorderColor(),
                  ),
                ),
              ),
            ),
          ],
          if (widget.dismissible) ...[
            const SizedBox(width: TKitSpacing.sm),
            InkWell(
              onTap: _dismiss,
              child: Icon(
                Icons.close,
                size: 16,
                color: TKitColors.textMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Banner - Full-width alert variant
/// Typically used at the top of pages or sections
class Banner extends StatelessWidget {
  final String message;
  final AlertVariant variant;
  final bool dismissible;
  final VoidCallback? onDismiss;
  final String? actionLabel;
  final VoidCallback? onAction;

  const Banner({
    super.key,
    required this.message,
    this.variant = AlertVariant.info,
    this.dismissible = false,
    this.onDismiss,
    this.actionLabel,
    this.onAction,
  });

  const Banner.info({
    super.key,
    required this.message,
    this.dismissible = false,
    this.onDismiss,
    this.actionLabel,
    this.onAction,
  }) : variant = AlertVariant.info;

  const Banner.success({
    super.key,
    required this.message,
    this.dismissible = false,
    this.onDismiss,
    this.actionLabel,
    this.onAction,
  }) : variant = AlertVariant.success;

  const Banner.warning({
    super.key,
    required this.message,
    this.dismissible = false,
    this.onDismiss,
    this.actionLabel,
    this.onAction,
  }) : variant = AlertVariant.warning;

  const Banner.error({
    super.key,
    required this.message,
    this.dismissible = false,
    this.onDismiss,
    this.actionLabel,
    this.onAction,
  }) : variant = AlertVariant.error;

  @override
  Widget build(BuildContext context) {
    return Alert(
      message: message,
      variant: variant,
      dismissible: dismissible,
      onDismiss: onDismiss,
      actionLabel: actionLabel,
      onAction: onAction,
      padding: const EdgeInsets.symmetric(
        horizontal: TKitSpacing.lg,
        vertical: TKitSpacing.md,
      ),
    );
  }
}
