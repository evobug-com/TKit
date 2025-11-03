import 'package:flutter/material.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/widgets/layout/spacer.dart';

/// Custom dropdown that supports multi-line items without overflow issues
class CustomDropdown<T> extends StatelessWidget {
  final String label;
  final String? description;
  final T value;
  final List<CustomDropdownItem<T>> items;
  final ValueChanged<T?> onChanged;

  const CustomDropdown({
    super.key,
    required this.label,
    this.description,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selectedItem = items.firstWhere((item) => item.value == value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontSize: 14),
        ),
        if (description != null) ...[
          const VSpace.xs(),
          Text(
            description!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 11,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
        const VSpace.sm(),
        InkWell(
          onTap: () => _showDropdownDialog(context),
          borderRadius: BorderRadius.circular(TKitSpacing.xs),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: TKitSpacing.md,
              vertical: TKitSpacing.md,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.outline),
              borderRadius: BorderRadius.circular(TKitSpacing.xs),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedItem.title,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(fontSize: 14),
                      ),
                      if (selectedItem.subtitle != null) ...[
                        const VSpace.xs(),
                        Text(
                          selectedItem.subtitle!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontSize: 11,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                const HSpace.sm(),
                Icon(
                  Icons.arrow_drop_down,
                  size: 20,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showDropdownDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600, maxHeight: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(TKitSpacing.md),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          label,
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(fontSize: 16),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Items
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final isSelected = item.value == value;

                      return InkWell(
                        onTap: () {
                          onChanged(item.value);
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(TKitSpacing.md),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primaryContainer
                                      .withValues(alpha: 0.3)
                                : null,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            fontSize: 14,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                    ),
                                    if (item.subtitle != null) ...[
                                      const VSpace.xs(),
                                      Text(
                                        item.subtitle!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              fontSize: 11,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withValues(alpha: 0.6),
                                            ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              if (isSelected) ...[
                                const HSpace.sm(),
                                Icon(
                                  Icons.check,
                                  size: 20,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Item for CustomDropdown
class CustomDropdownItem<T> {
  final T value;
  final String title;
  final String? subtitle;

  const CustomDropdownItem({
    required this.value,
    required this.title,
    this.subtitle,
  });
}
