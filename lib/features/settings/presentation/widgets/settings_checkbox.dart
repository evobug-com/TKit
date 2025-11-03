import 'package:flutter/material.dart';
import 'package:tkit/shared/theme/text_styles.dart';
import 'package:tkit/shared/theme/colors.dart';

/// Reusable checkbox widget for settings
class SettingsCheckbox extends StatelessWidget {
  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const SettingsCheckbox({
    super.key,
    required this.label,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(label, style: TKitTextStyles.labelMedium),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TKitTextStyles.bodySmall.copyWith(
                color: TKitColors.textSecondary,
              ),
            )
          : null,
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      dense: true,
    );
  }
}
