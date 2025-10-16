import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/theme/text_styles.dart';

/// TKit numeric input with +/- buttons
/// Compact, monochrome design with minimal accent
class TKitNumberStepper extends StatefulWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;
  final double step;
  final int? decimalPlaces;
  final bool enabled;
  final String? suffix;
  final double? width;

  const TKitNumberStepper({
    super.key,
    required this.value,
    this.onChanged,
    this.min = 0,
    this.max = 100,
    this.step = 1,
    this.decimalPlaces,
    this.enabled = true,
    this.suffix,
    this.width,
  });

  @override
  State<TKitNumberStepper> createState() => _TKitNumberStepperState();
}

class _TKitNumberStepperState extends State<TKitNumberStepper> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _formatValue(widget.value));
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(TKitNumberStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && !_focusNode.hasFocus) {
      _controller.text = _formatValue(widget.value);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      // Format the value when focus is lost
      _controller.text = _formatValue(widget.value);
    }
  }

  String _formatValue(double value) {
    if (widget.decimalPlaces != null) {
      return value.toStringAsFixed(widget.decimalPlaces!);
    }
    return value.toString();
  }

  void _increment() {
    if (!widget.enabled || widget.onChanged == null) {
      return;
    }
    final newValue = (widget.value + widget.step).clamp(widget.min, widget.max);
    widget.onChanged?.call(newValue);
  }

  void _decrement() {
    if (!widget.enabled || widget.onChanged == null) {
      return;
    }
    final newValue = (widget.value - widget.step).clamp(widget.min, widget.max);
    widget.onChanged?.call(newValue);
  }

  void _onTextChanged(String text) {
    if (!widget.enabled || widget.onChanged == null) {
      return;
    }
    final value = double.tryParse(text);
    if (value != null) {
      final clampedValue = value.clamp(widget.min, widget.max);
      widget.onChanged?.call(clampedValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.enabled && widget.onChanged != null;
    final canDecrement = isEnabled && widget.value > widget.min;
    final canIncrement = isEnabled && widget.value < widget.max;

    return SizedBox(
      width: widget.width ?? 140,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decrement button
          _StepperButton(
            icon: Icons.remove,
            onPressed: canDecrement ? _decrement : null,
            enabled: canDecrement,
          ),
          // Text input
          Expanded(
            child: Container(
              height: 32,
              decoration: BoxDecoration(
                color: TKitColors.background,
                border: Border.symmetric(
                  horizontal: BorderSide(
                    color: isEnabled
                        ? TKitColors.border
                        : TKitColors.borderSubtle,
                  ),
                ),
              ),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                enabled: isEnabled,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.numberWithOptions(
                  decimal:
                      widget.decimalPlaces != null && widget.decimalPlaces! > 0,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                style: TKitTextStyles.bodyMedium.copyWith(
                  color: isEnabled
                      ? TKitColors.textPrimary
                      : TKitColors.textDisabled,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: TKitSpacing.xs,
                    vertical: 8,
                  ),
                  isDense: true,
                  suffix: widget.suffix != null
                      ? Text(
                          widget.suffix!,
                          style: TKitTextStyles.bodySmall.copyWith(
                            color: TKitColors.textMuted,
                          ),
                        )
                      : null,
                ),
                onChanged: _onTextChanged,
              ),
            ),
          ),
          // Increment button
          _StepperButton(
            icon: Icons.add,
            onPressed: canIncrement ? _increment : null,
            enabled: canIncrement,
          ),
        ],
      ),
    );
  }
}

/// Internal button widget for stepper
class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final bool enabled;

  const _StepperButton({
    required this.icon,
    this.onPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: Material(
        color: enabled ? TKitColors.surface : TKitColors.surfaceVariant,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: enabled ? TKitColors.border : TKitColors.borderSubtle,
              ),
            ),
            child: Icon(
              icon,
              size: 16,
              color: enabled ? TKitColors.textPrimary : TKitColors.textDisabled,
            ),
          ),
        ),
      ),
    );
  }
}

/// FormField wrapper for TKitNumberStepper to work with forms
class TKitNumberStepperFormField extends FormField<double> {
  TKitNumberStepperFormField({
    super.key,
    required double super.initialValue,
    double min = 0,
    double max = 100,
    double step = 1,
    int? decimalPlaces,
    String? suffix,
    double? width,
    super.onSaved,
    super.validator,
    bool enabled = true,
    super.autovalidateMode,
  }) : super(
         builder: (FormFieldState<double> state) {
           return Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             mainAxisSize: MainAxisSize.min,
             children: [
               TKitNumberStepper(
                 value: state.value ?? initialValue,
                 onChanged: enabled
                     ? (value) {
                         state.didChange(value);
                       }
                     : null,
                 min: min,
                 max: max,
                 step: step,
                 decimalPlaces: decimalPlaces,
                 enabled: enabled,
                 suffix: suffix,
                 width: width,
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
