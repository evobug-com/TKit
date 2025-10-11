import 'package:flutter/material.dart';

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
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        if (description != null) ...[
          const SizedBox(height: 4),
          Text(
            description!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          initialValue: value,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 23),
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
