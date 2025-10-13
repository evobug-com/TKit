import 'package:flutter/material.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/theme/text_styles.dart';

/// Context menu item data
class TKitContextMenuItem {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool enabled;
  final bool isDivider;
  final Color? textColor;

  const TKitContextMenuItem({
    required this.label,
    this.icon,
    this.onTap,
    this.enabled = true,
    this.isDivider = false,
    this.textColor,
  });

  /// Creates a divider menu item
  const TKitContextMenuItem.divider()
      : label = '',
        icon = null,
        onTap = null,
        enabled = true,
        isDivider = true,
        textColor = null;
}

/// Right-click context menu component
/// Displays a popup menu with actions
class TKitContextMenu extends StatelessWidget {
  final Widget child;
  final List<TKitContextMenuItem> items;
  final bool enabled;

  const TKitContextMenu({
    super.key,
    required this.child,
    required this.items,
    this.enabled = true,
  });

  void _showContextMenu(BuildContext context, TapDownDetails details) {
    if (!enabled) return;

    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        details.globalPosition,
        details.globalPosition,
      ),
      Offset.zero & overlay.size,
    );

    showMenu<void>(
      context: context,
      position: position,
      color: TKitColors.surfaceVariant,
      elevation: 8,
      shadowColor: TKitColors.overlay,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TKitSpacing.xs),
        side: const BorderSide(
          color: TKitColors.border,
          width: 1,
        ),
      ),
      items: items.map<PopupMenuEntry<void>>((item) {
        if (item.isDivider) {
          return const PopupMenuDivider(height: 1);
        }

        return PopupMenuItem<void>(
          enabled: item.enabled,
          onTap: item.onTap,
          padding: const EdgeInsets.symmetric(
            horizontal: TKitSpacing.md,
            vertical: TKitSpacing.sm,
          ),
          child: Row(
            children: [
              if (item.icon != null) ...[
                Icon(
                  item.icon,
                  size: 16,
                  color: item.enabled
                      ? (item.textColor ?? TKitColors.textSecondary)
                      : TKitColors.textDisabled,
                ),
                const SizedBox(width: TKitSpacing.sm),
              ],
              Text(
                item.label,
                style: TKitTextStyles.bodySmall.copyWith(
                  color: item.enabled
                      ? (item.textColor ?? TKitColors.textPrimary)
                      : TKitColors.textDisabled,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTapDown: (details) => _showContextMenu(context, details),
      child: child,
    );
  }
}

/// Extension method to show context menu programmatically
extension ContextMenuExtension on BuildContext {
  /// Shows a context menu at the current pointer position
  Future<void> showTKitContextMenu({
    required List<TKitContextMenuItem> items,
    required Offset position,
  }) {
    final overlay = Overlay.of(this).context.findRenderObject() as RenderBox;
    final relativePosition = RelativeRect.fromRect(
      Rect.fromPoints(position, position),
      Offset.zero & overlay.size,
    );

    return showMenu<void>(
      context: this,
      position: relativePosition,
      color: TKitColors.surfaceVariant,
      elevation: 8,
      shadowColor: TKitColors.overlay,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TKitSpacing.xs),
        side: const BorderSide(
          color: TKitColors.border,
          width: 1,
        ),
      ),
      items: items.map<PopupMenuEntry<void>>((item) {
        if (item.isDivider) {
          return const PopupMenuDivider(height: 1);
        }

        return PopupMenuItem<void>(
          enabled: item.enabled,
          onTap: item.onTap,
          padding: const EdgeInsets.symmetric(
            horizontal: TKitSpacing.md,
            vertical: TKitSpacing.sm,
          ),
          child: Row(
            children: [
              if (item.icon != null) ...[
                Icon(
                  item.icon,
                  size: 16,
                  color: item.enabled
                      ? (item.textColor ?? TKitColors.textSecondary)
                      : TKitColors.textDisabled,
                ),
                const SizedBox(width: TKitSpacing.sm),
              ],
              Text(
                item.label,
                style: TKitTextStyles.bodySmall.copyWith(
                  color: item.enabled
                      ? (item.textColor ?? TKitColors.textPrimary)
                      : TKitColors.textDisabled,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
