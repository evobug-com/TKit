import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/text_styles.dart';

/// TKit toggle switch component
/// Compact, monochrome design with minimal accent
class TKitSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final bool enabled;

  const TKitSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = enabled && onChanged != null;

    Widget switchWidget = SizedBox(
      height: 20,
      child: Switch(
        value: value,
        onChanged: isEnabled ? onChanged : null,
        activeColor: TKitColors.accent,
        activeTrackColor: TKitColors.accentDim,
        inactiveThumbColor: TKitColors.textMuted,
        inactiveTrackColor: TKitColors.surfaceVariant,
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return TKitColors.borderSubtle;
          }
          return TKitColors.border;
        }),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );

    if (label == null) {
      return switchWidget;
    }

    return InkWell(
      onTap: isEnabled ? () => onChanged?.call(!value) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TKitSpacing.xs),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
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
            const SizedBox(width: TKitSpacing.md),
            switchWidget,
          ],
        ),
      ),
    );
  }
}

/// FormField wrapper for TKitSwitch to work with forms
class TKitSwitchFormField extends FormField<bool> {
  TKitSwitchFormField({
    super.key,
    required bool initialValue,
    String? label,
    FormFieldSetter<bool>? onSaved,
    FormFieldValidator<bool>? validator,
    bool enabled = true,
    AutovalidateMode? autovalidateMode,
  }) : super(
          initialValue: initialValue,
          onSaved: onSaved,
          validator: validator,
          autovalidateMode: autovalidateMode,
          builder: (FormFieldState<bool> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TKitSwitch(
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
