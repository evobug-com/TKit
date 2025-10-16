import 'package:flutter/material.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/text_styles.dart';
import 'package:tkit/shared/theme/spacing.dart';

/// Breadcrumb item data
class BreadcrumbItem {
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;

  const BreadcrumbItem({required this.label, this.onTap, this.icon});
}

/// Breadcrumb - Navigation path display with clickable items
/// Shows the current location in a hierarchy
class Breadcrumb extends StatelessWidget {
  final List<BreadcrumbItem> items;
  final IconData separator;
  final bool compact;
  final int maxItems;

  const Breadcrumb({
    super.key,
    required this.items,
    this.separator = Icons.chevron_right,
    this.compact = false,
    this.maxItems = 0,
  });

  List<BreadcrumbItem> _getDisplayItems() {
    if (maxItems <= 0 || items.length <= maxItems) {
      return items;
    }

    // Show first item, ellipsis, and last (maxItems - 1) items
    final visibleCount = maxItems - 1;
    return [
      items.first,
      const BreadcrumbItem(label: '...'),
      ...items.sublist(items.length - visibleCount),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final displayItems = _getDisplayItems();
    final fontSize = compact ? 11.0 : 13.0;

    return Row(
      children: [
        for (var i = 0; i < displayItems.length; i++) ...[
          if (i > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: TKitSpacing.xs),
              child: Icon(
                separator,
                size: compact ? 12 : 14,
                color: TKitColors.textMuted,
              ),
            ),
          _BreadcrumbItemWidget(
            item: displayItems[i],
            isLast: i == displayItems.length - 1,
            fontSize: fontSize,
          ),
        ],
      ],
    );
  }
}

/// Internal breadcrumb item widget
class _BreadcrumbItemWidget extends StatelessWidget {
  final BreadcrumbItem item;
  final bool isLast;
  final double fontSize;

  const _BreadcrumbItemWidget({
    required this.item,
    required this.isLast,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = TKitTextStyles.bodyMedium.copyWith(
      fontSize: fontSize,
      color: isLast ? TKitColors.textPrimary : TKitColors.textSecondary,
    );

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (item.icon != null) ...[
          Icon(
            item.icon,
            size: fontSize + 2,
            color: isLast ? TKitColors.textPrimary : TKitColors.textSecondary,
          ),
          const SizedBox(width: TKitSpacing.xs),
        ],
        Flexible(
          child: Text(
            item.label,
            style: textStyle,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );

    if (item.onTap != null && !isLast) {
      return InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(2),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: TKitSpacing.xs,
            vertical: 2,
          ),
          child: content,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TKitSpacing.xs,
        vertical: 2,
      ),
      child: content,
    );
  }
}

/// BreadcrumbCollapsed - Compact breadcrumb with dropdown for middle items
/// Useful when there are many breadcrumb levels
class BreadcrumbCollapsed extends StatelessWidget {
  final List<BreadcrumbItem> items;
  final IconData separator;

  const BreadcrumbCollapsed({
    super.key,
    required this.items,
    this.separator = Icons.chevron_right,
  });

  @override
  Widget build(BuildContext context) {
    if (items.length <= 3) {
      return Breadcrumb(items: items, separator: separator);
    }

    final first = items.first;
    final last = items.last;
    final middle = items.sublist(1, items.length - 1);

    return Row(
      children: [
        _BreadcrumbItemWidget(item: first, isLast: false, fontSize: 13.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: TKitSpacing.xs),
          child: Icon(separator, size: 14, color: TKitColors.textMuted),
        ),
        PopupMenuButton<BreadcrumbItem>(
          tooltip: 'Show path',
          icon: const Icon(
            Icons.more_horiz,
            size: 16,
            color: TKitColors.textSecondary,
          ),
          color: TKitColors.surface,
          elevation: 4,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          itemBuilder: (context) => [
            for (final item in middle)
              PopupMenuItem<BreadcrumbItem>(
                value: item,
                onTap: item.onTap,
                child: Row(
                  children: [
                    if (item.icon != null) ...[
                      Icon(
                        item.icon,
                        size: 14,
                        color: TKitColors.textSecondary,
                      ),
                      const SizedBox(width: TKitSpacing.xs),
                    ],
                    Text(item.label, style: TKitTextStyles.bodyMedium),
                  ],
                ),
              ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: TKitSpacing.xs),
          child: Icon(separator, size: 14, color: TKitColors.textMuted),
        ),
        _BreadcrumbItemWidget(item: last, isLast: true, fontSize: 13.0),
      ],
    );
  }
}
