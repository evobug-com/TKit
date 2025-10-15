import 'package:flutter/material.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/theme/text_styles.dart';

/// CollapsiblePanel - Single collapsible section with animated expand/collapse
/// Use for hiding/showing content in a single panel
class CollapsiblePanel extends StatefulWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget child;
  final bool initiallyExpanded;
  final ValueChanged<bool>? onExpansionChanged;
  final EdgeInsetsGeometry? padding;
  final bool showBorder;

  const CollapsiblePanel({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    required this.child,
    this.initiallyExpanded = false,
    this.onExpansionChanged,
    this.padding,
    this.showBorder = true,
  });

  @override
  State<CollapsiblePanel> createState() => _CollapsiblePanelState();
}

class _CollapsiblePanelState extends State<CollapsiblePanel>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
    widget.onExpansionChanged?.call(_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TKitColors.surface,
        border: widget.showBorder
            ? Border.all(color: TKitColors.border, width: 1)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          InkWell(
            onTap: _toggleExpanded,
            child: Container(
              padding: widget.padding ??
                  const EdgeInsets.symmetric(
                    horizontal: TKitSpacing.md,
                    vertical: TKitSpacing.sm,
                  ),
              child: Row(
                children: [
                  // Expand icon
                  AnimatedRotation(
                    turns: _isExpanded ? 0.25 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.keyboard_arrow_right,
                      size: 16,
                      color: TKitColors.textSecondary,
                    ),
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
                        Text(
                          widget.title,
                          style: TKitTextStyles.labelMedium,
                        ),
                        if (widget.subtitle != null) ...[
                          const SizedBox(height: 2),
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

          // Expandable content with smooth animation
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Container(
              padding: widget.padding ??
                  const EdgeInsets.only(
                    left: TKitSpacing.xl,
                    right: TKitSpacing.md,
                    bottom: TKitSpacing.md,
                  ),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}
