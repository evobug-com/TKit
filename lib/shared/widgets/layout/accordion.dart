import 'package:flutter/material.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/theme/text_styles.dart';

/// Accordion - Multiple expandable sections
/// Use for grouping related content that can be expanded/collapsed
class Accordion extends StatelessWidget {
  final List<AccordionItem> items;
  final bool allowMultipleExpanded;

  const Accordion({
    super.key,
    required this.items,
    this.allowMultipleExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    if (allowMultipleExpanded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: items,
      );
    }

    return _SingleExpandAccordion(items: items);
  }
}

class _SingleExpandAccordion extends StatefulWidget {
  final List<AccordionItem> items;

  const _SingleExpandAccordion({required this.items});

  @override
  State<_SingleExpandAccordion> createState() => _SingleExpandAccordionState();
}

class _SingleExpandAccordionState extends State<_SingleExpandAccordion> {
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(widget.items.length, (index) {
        final item = widget.items[index];
        return AccordionItem(
          key: item.key,
          title: item.title,
          subtitle: item.subtitle,
          icon: item.icon,
          initiallyExpanded: _expandedIndex == index,
          onExpansionChanged: (isExpanded) {
            setState(() {
              _expandedIndex = isExpanded ? index : null;
            });
            item.onExpansionChanged?.call(isExpanded);
          },
          child: item.child,
        );
      }),
    );
  }
}

/// AccordionItem - Individual accordion section
class AccordionItem extends StatefulWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget child;
  final bool initiallyExpanded;
  final ValueChanged<bool>? onExpansionChanged;

  const AccordionItem({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    required this.child,
    this.initiallyExpanded = false,
    this.onExpansionChanged,
  });

  @override
  State<AccordionItem> createState() => _AccordionItemState();
}

class _AccordionItemState extends State<AccordionItem> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    widget.onExpansionChanged?.call(_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: TKitColors.surface,
        border: Border(bottom: BorderSide(color: TKitColors.border, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: _toggleExpanded,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TKitSpacing.md,
                vertical: TKitSpacing.sm,
              ),
              child: Row(
                children: [
                  // Expand icon
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    size: 16,
                    color: TKitColors.textSecondary,
                  ),
                  const SizedBox(width: TKitSpacing.sm),

                  // Optional icon
                  if (widget.icon != null) ...[
                    Icon(
                      widget.icon,
                      size: 14,
                      color: TKitColors.textSecondary,
                    ),
                    const SizedBox(width: TKitSpacing.sm),
                  ],

                  // Title and subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.title, style: TKitTextStyles.labelMedium),
                        if (widget.subtitle != null) ...[
                          const SizedBox(height: TKitSpacing.headerGap),
                          Text(
                            widget.subtitle!,
                            style: TKitTextStyles.bodySmall,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expandable content
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Container(
              padding: const EdgeInsets.only(
                left: TKitSpacing.xl,
                right: TKitSpacing.md,
                bottom: TKitSpacing.md,
              ),
              child: widget.child,
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
            sizeCurve: Curves.easeInOut,
          ),
        ],
      ),
    );
  }
}
