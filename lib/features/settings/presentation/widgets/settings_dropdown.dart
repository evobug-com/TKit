import 'package:flutter/material.dart';
import 'package:tkit/shared/theme/spacing.dart';

/// Reusable dropdown widget for settings
class SettingsDropdown<T> extends StatelessWidget {
  final String label;
  final String? description;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final double? itemHeight;
  final double? menuMaxHeight;

  const SettingsDropdown({
    super.key,
    required this.label,
    this.description,
    required this.value,
    required this.items,
    required this.onChanged,
    this.itemHeight,
    this.menuMaxHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: 14,
          ),
        ),
        if (description != null) ...[
          const SizedBox(height: TKitSpacing.headerGap),
          Text(
            description!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 11,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
        const SizedBox(height: TKitSpacing.sm),
        DropdownButtonFormField<T>(
          initialValue: value,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: TKitSpacing.md, vertical: TKitSpacing.lg),
          ),
          items: items,
          onChanged: onChanged,
          isExpanded: true,
          itemHeight: itemHeight,
          menuMaxHeight: menuMaxHeight ?? 400,
        ),
      ],
    );
  }
}
