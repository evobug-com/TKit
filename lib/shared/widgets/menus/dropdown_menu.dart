import 'package:flutter/material.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/theme/text_styles.dart';

/// Menu item data for dropdown menus
class TKitMenuItem<T> {
  final T value;
  final String label;
  final IconData? icon;
  final bool enabled;
  final String? subtitle;

  const TKitMenuItem({
    required this.value,
    required this.label,
    this.icon,
    this.enabled = true,
    this.subtitle,
  });
}

/// Action menu that drops down
/// Generic dropdown menu component with consistent styling
class TKitDropdownMenu<T> extends StatelessWidget {
  final T? value;
  final List<TKitMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? hint;
  final bool enabled;
  final double? width;
  final double? menuMaxHeight;

  const TKitDropdownMenu({
    super.key,
    this.value,
    required this.items,
    this.onChanged,
    this.hint,
    this.enabled = true,
    this.width,
    this.menuMaxHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: TKitColors.surface,
        borderRadius: BorderRadius.circular(TKitSpacing.xs),
        border: Border.all(color: TKitColors.border, width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item.value,
              enabled: item.enabled,
              child: Row(
                children: [
                  if (item.icon != null) ...[
                    Icon(
                      item.icon,
                      size: 16,
                      color: item.enabled
                          ? TKitColors.textSecondary
                          : TKitColors.textDisabled,
                    ),
                    const SizedBox(width: TKitSpacing.sm),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.label,
                          style: TKitTextStyles.bodySmall.copyWith(
                            color: item.enabled
                                ? TKitColors.textPrimary
                                : TKitColors.textDisabled,
                          ),
                        ),
                        if (item.subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            item.subtitle!,
                            style: TKitTextStyles.caption.copyWith(
                              color: item.enabled
                                  ? TKitColors.textMuted
                                  : TKitColors.textDisabled,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: enabled ? onChanged : null,
          hint: hint != null
              ? Text(
                  hint!,
                  style: TKitTextStyles.bodySmall.copyWith(
                    color: TKitColors.textMuted,
                  ),
                )
              : null,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: TKitColors.textSecondary,
            size: 20,
          ),
          iconEnabledColor: TKitColors.textSecondary,
          iconDisabledColor: TKitColors.textDisabled,
          dropdownColor: TKitColors.surfaceVariant,
          elevation: 8,
          style: TKitTextStyles.bodySmall,
          padding: const EdgeInsets.symmetric(
            horizontal: TKitSpacing.md,
            vertical: TKitSpacing.sm,
          ),
          borderRadius: BorderRadius.circular(TKitSpacing.xs),
          menuMaxHeight: menuMaxHeight ?? 300,
        ),
      ),
    );
  }
}

/// Compact dropdown menu button
/// More button-like appearance with icon and label
class TKitDropdownMenuButton<T> extends StatelessWidget {
  final T? value;
  final List<TKitMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final IconData? icon;
  final String? label;
  final bool enabled;
  final bool compact;

  const TKitDropdownMenuButton({
    super.key,
    this.value,
    required this.items,
    this.onChanged,
    this.icon,
    this.label,
    this.enabled = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      onSelected: enabled ? onChanged : null,
      enabled: enabled,
      color: TKitColors.surfaceVariant,
      elevation: 8,
      shadowColor: TKitColors.overlay,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TKitSpacing.xs),
        side: const BorderSide(color: TKitColors.border, width: 1),
      ),
      padding: EdgeInsets.zero,
      itemBuilder: (context) {
        return items.map((item) {
          final isSelected = item.value == value;
          return PopupMenuItem<T>(
            value: item.value,
            enabled: item.enabled,
            padding: EdgeInsets.symmetric(
              horizontal: compact ? TKitSpacing.sm : TKitSpacing.md,
              vertical: compact ? TKitSpacing.xs : TKitSpacing.sm,
            ),
            child: Row(
              children: [
                if (item.icon != null) ...[
                  Icon(
                    item.icon,
                    size: 16,
                    color: isSelected
                        ? TKitColors.accent
                        : (item.enabled
                              ? TKitColors.textSecondary
                              : TKitColors.textDisabled),
                  ),
                  const SizedBox(width: TKitSpacing.sm),
                ],
                Expanded(
                  child: Text(
                    item.label,
                    style: TKitTextStyles.bodySmall.copyWith(
                      color: isSelected
                          ? TKitColors.accent
                          : (item.enabled
                                ? TKitColors.textPrimary
                                : TKitColors.textDisabled),
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check, size: 16, color: TKitColors.accent),
              ],
            ),
          );
        }).toList();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? TKitSpacing.sm : TKitSpacing.md,
          vertical: compact ? TKitSpacing.xs : TKitSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: TKitColors.surface,
          borderRadius: BorderRadius.circular(TKitSpacing.xs),
          border: Border.all(color: TKitColors.border, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: enabled
                    ? TKitColors.textSecondary
                    : TKitColors.textDisabled,
              ),
              if (label != null) const SizedBox(width: TKitSpacing.sm),
            ],
            if (label != null)
              Text(
                label!,
                style: TKitTextStyles.bodySmall.copyWith(
                  color: enabled
                      ? TKitColors.textPrimary
                      : TKitColors.textDisabled,
                ),
              ),
            const SizedBox(width: TKitSpacing.xs),
            Icon(
              Icons.arrow_drop_down,
              size: 20,
              color: enabled
                  ? TKitColors.textSecondary
                  : TKitColors.textDisabled,
            ),
          ],
        ),
      ),
    );
  }
}
