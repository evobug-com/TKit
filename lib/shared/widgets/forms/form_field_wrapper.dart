import 'package:flutter/material.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/text_styles.dart';
import 'package:tkit/shared/theme/spacing.dart';

/// Form field wrapper with consistent label, help text, and error styling
class FormFieldWrapper extends StatelessWidget {
  final String label;
  final String? helpText;
  final String? errorText;
  final bool required;
  final Widget child;

  const FormFieldWrapper({
    super.key,
    required this.label,
    this.helpText,
    this.errorText,
    this.required = false,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              label.toUpperCase(),
              style: TKitTextStyles.labelSmall.copyWith(
                color: TKitColors.textSecondary,
                letterSpacing: 1.0,
              ),
            ),
            if (required) ...[
              const SizedBox(width: 4),
              Text(
                '*',
                style: TKitTextStyles.labelSmall.copyWith(
                  color: TKitColors.error,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: TKitSpacing.xs),
        child,
        if (helpText != null && errorText == null) ...[
          const SizedBox(height: TKitSpacing.xs),
          Text(
            helpText!,
            style: TKitTextStyles.caption.copyWith(
              color: TKitColors.textMuted,
            ),
          ),
        ],
        if (errorText != null) ...[
          const SizedBox(height: TKitSpacing.xs),
          Text(
            errorText!,
            style: TKitTextStyles.caption.copyWith(
              color: TKitColors.error,
            ),
          ),
        ],
      ],
    );
  }
}

/// Standard text input field with consistent styling
class TKitTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;

  const TKitTextField({
    super.key,
    this.controller,
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      onTap: onTap,
      readOnly: readOnly,
      maxLines: maxLines,
      minLines: minLines,
      style: TKitTextStyles.bodyMedium.copyWith(
        color: TKitColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TKitTextStyles.bodyMedium.copyWith(
          color: TKitColors.textMuted,
        ),
        errorText: errorText,
        filled: true,
        fillColor: TKitColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: const BorderSide(color: TKitColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: const BorderSide(color: TKitColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: const BorderSide(color: TKitColors.accent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: const BorderSide(color: TKitColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        isDense: true,
      ),
    );
  }
}
