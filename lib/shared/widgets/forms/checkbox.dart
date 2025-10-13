import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/text_styles.dart';

/// TKit styled checkbox matching the design system
/// Compact, monochrome design with minimal accent
class TKitCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final String? label;
  final bool enabled;

  const TKitCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = enabled && onChanged != null;

    Widget checkbox = SizedBox(
      width: 18,
      height: 18,
      child: Checkbox(
        value: value,
        onChanged: isEnabled ? onChanged : null,
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return TKitColors.surfaceVariant;
          }
          if (states.contains(WidgetState.selected)) {
            return TKitColors.accent;
          }
          return TKitColors.background;
        }),
        checkColor: TKitColors.textPrimary,
        side: BorderSide(
          color: isEnabled
              ? (value ? TKitColors.accent : TKitColors.border)
              : TKitColors.borderSubtle,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );

    if (label == null) {
      return checkbox;
    }

    return InkWell(
      onTap: isEnabled ? () => onChanged?.call(!value) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TKitSpacing.xs),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            checkbox,
            const SizedBox(width: TKitSpacing.sm),
            Flexible(
              child: Text(
                label!,
                style: TKitTextStyles.bodyMedium.copyWith(
                  color: isEnabled
                      ? TKitColors.textPrimary
                      : TKitColors.textDisabled,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// FormField wrapper for TKitCheckbox to work with forms
class TKitCheckboxFormField extends FormField<bool> {
  TKitCheckboxFormField({
    super.key,
    required bool super.initialValue,
    String? label,
    super.onSaved,
    super.validator,
    bool enabled = true,
    super.autovalidateMode,
  }) : super(
          builder: (FormFieldState<bool> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TKitCheckbox(
                  value: state.value ?? false,
                  onChanged: enabled
                      ? (value) {
                          state.didChange(value);
                        }
                      : null,
                  label: label,
                  enabled: enabled,
                ),
                if (state.hasError) ...[
                  const SizedBox(height: TKitSpacing.xs),
                  Text(
                    state.errorText!,
                    style: TKitTextStyles.caption.copyWith(
                      color: TKitColors.error,
                    ),
                  ),
                ],
              ],
            );
          },
        );
}
