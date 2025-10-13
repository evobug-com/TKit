import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/text_styles.dart';

/// TKit styled radio button
/// Compact, monochrome design with minimal accent
class TKitRadio<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final bool enabled;

  const TKitRadio({
    super.key,
    required this.value,
    required this.groupValue,
    this.onChanged,
    this.label,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = enabled && onChanged != null;

    Widget radio = SizedBox(
      width: 18,
      height: 18,
      child: Radio<T>(
        value: value,
        groupValue: groupValue,
        onChanged: isEnabled ? onChanged : null,
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return TKitColors.textDisabled;
          }
          if (states.contains(WidgetState.selected)) {
            return TKitColors.accent;
          }
          return TKitColors.textMuted;
        }),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );

    if (label == null) {
      return radio;
    }

    return InkWell(
      onTap: isEnabled ? () => onChanged?.call(value) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TKitSpacing.xs),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            radio,
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

/// TKit radio button group for multiple options
class TKitRadioGroup<T> extends StatelessWidget {
  final T? value;
  final ValueChanged<T?>? onChanged;
  final List<TKitRadioOption<T>> options;
  final bool enabled;
  final Axis direction;

  const TKitRadioGroup({
    super.key,
    required this.value,
    this.onChanged,
    required this.options,
    this.enabled = true,
    this.direction = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    final children = options.map((option) {
      return TKitRadio<T>(
        value: option.value,
        groupValue: value,
        onChanged: onChanged,
        label: option.label,
        enabled: enabled,
      );
    }).toList();

    if (direction == Axis.horizontal) {
      return Wrap(
        spacing: TKitSpacing.lg,
        runSpacing: TKitSpacing.xs,
        children: children,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}

/// Radio option model
class TKitRadioOption<T> {
  final T value;
  final String label;

  const TKitRadioOption({
    required this.value,
    required this.label,
  });
}

/// FormField wrapper for TKitRadioGroup to work with forms
class TKitRadioGroupFormField<T> extends FormField<T> {
  TKitRadioGroupFormField({
    super.key,
    T? initialValue,
    required List<TKitRadioOption<T>> options,
    FormFieldSetter<T>? onSaved,
    FormFieldValidator<T>? validator,
    bool enabled = true,
    Axis direction = Axis.vertical,
    AutovalidateMode? autovalidateMode,
  }) : super(
          initialValue: initialValue,
          onSaved: onSaved,
          validator: validator,
          autovalidateMode: autovalidateMode,
          builder: (FormFieldState<T> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TKitRadioGroup<T>(
                  value: state.value,
                  onChanged: enabled
                      ? (value) {
                          state.didChange(value);
                        }
                      : null,
                  options: options,
                  enabled: enabled,
                  direction: direction,
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
