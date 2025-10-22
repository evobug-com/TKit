import 'package:flutter/material.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/theme/text_styles.dart';
import 'package:tkit/shared/widgets/layout/spacer.dart';

/// TreeView - Hierarchical data display with expansion/collapse
class TreeView<T> extends StatelessWidget {
  final List<TreeNodeData<T>> nodes;
  final void Function(T)? onNodeTap;
  final double indentSize;

  const TreeView({
    super.key,
    required this.nodes,
    this.onNodeTap,
    this.indentSize = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: nodes.map((node) {
        return TreeNode<T>(
          data: node,
          onTap: onNodeTap,
          indentSize: indentSize,
        );
      }).toList(),
    );
  }
}

/// TreeNodeData - Data model for tree node
class TreeNodeData<T> {
  final T value;
  final String label;
  final IconData? icon;
  final List<TreeNodeData<T>> children;
  final bool initiallyExpanded;

  TreeNodeData({
    required this.value,
    required this.label,
    this.icon,
    this.children = const [],
    this.initiallyExpanded = false,
  });

  bool get hasChildren => children.isNotEmpty;
}

/// TreeNode - Individual tree node with expansion/collapse
class TreeNode<T> extends StatefulWidget {
  final TreeNodeData<T> data;
  final void Function(T)? onTap;
  final int depth;
  final double indentSize;

  const TreeNode({
    super.key,
    required this.data,
    this.onTap,
    this.depth = 0,
    this.indentSize = 20.0,
  });

  @override
  State<TreeNode<T>> createState() => _TreeNodeState<T>();
}

class _TreeNodeState<T> extends State<TreeNode<T>> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.data.initiallyExpanded;
  }

  void _toggleExpansion() {
    if (widget.data.hasChildren) {
      setState(() {
        _isExpanded = !_isExpanded;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Node content
        InkWell(
          onTap: () {
            _toggleExpansion();
            widget.onTap?.call(widget.data.value);
          },
          child: Container(
            padding: EdgeInsets.only(
              left: widget.depth * widget.indentSize + TKitSpacing.sm,
              right: TKitSpacing.sm,
              top: TKitSpacing.xs,
              bottom: TKitSpacing.xs,
            ),
            child: Row(
              children: [
                // Expansion indicator
                if (widget.data.hasChildren)
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    size: 16,
                    color: TKitColors.textSecondary,
                  )
                else
                  const HSpace.md(),

                const HSpace.xs(),

                // Node icon
                if (widget.data.icon != null) ...[
                  Icon(
                    widget.data.icon,
                    size: 16,
                    color: TKitColors.textSecondary,
                  ),
                  const SizedBox(width: TKitSpacing.sm),
                ],

                // Node label
                Expanded(
                  child: Text(
                    widget.data.label,
                    style: TKitTextStyles.bodySmall.copyWith(
                      color: TKitColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Children (when expanded)
        if (_isExpanded && widget.data.hasChildren)
          ...widget.data.children.map((child) {
            return TreeNode<T>(
              data: child,
              onTap: widget.onTap,
              depth: widget.depth + 1,
              indentSize: widget.indentSize,
            );
          }),
      ],
    );
  }
}
