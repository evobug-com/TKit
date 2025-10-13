import 'package:flutter/material.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/theme/text_styles.dart';

/// Menu button action item
class MenuAction {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;
  final bool enabled;
  final Color? textColor;
  final bool isDivider;

  const MenuAction({
    required this.label,
    this.icon,
    required this.onTap,
    this.enabled = true,
    this.textColor,
    this.isDivider = false,
  });

  /// Creates a divider
  const MenuAction.divider()
      : label = '',
        icon = null,
        onTap = _emptyCallback,
        enabled = true,
        textColor = null,
        isDivider = true;

  static void _emptyCallback() {}
}

/// Button that opens a menu with actions
/// Can be used for overflow menus, action buttons, etc.
class MenuButton extends StatelessWidget {
  final List<MenuAction> actions;
  final Widget? child;
  final IconData? icon;
  final String? label;
  final String? tooltip;
  final bool enabled;
  final bool compact;
  final Color? iconColor;
  final Color? backgroundColor;

  const MenuButton({
    super.key,
    required this.actions,
    this.child,
    this.icon,
    this.label,
    this.tooltip,
    this.enabled = true,
    this.compact = false,
    this.iconColor,
    this.backgroundColor,
  });

  /// Creates an overflow menu button (three dots)
  const MenuButton.overflow({
    super.key,
    required this.actions,
    this.tooltip = 'More options',
    this.enabled = true,
    this.compact = true,
    this.iconColor,
    this.backgroundColor,
  })  : child = null,
        icon = Icons.more_vert,
        label = null;

  /// Creates an icon-only menu button
  const MenuButton.icon({
    super.key,
    required this.actions,
    required IconData this.icon,
    this.tooltip,
    this.enabled = true,
    this.compact = true,
    this.iconColor,
    this.backgroundColor,
  })  : child = null,
        label = null;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<void>(
      enabled: enabled,
      tooltip: tooltip,
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
      padding: EdgeInsets.zero,
      itemBuilder: (context) {
        return actions.map<PopupMenuEntry<void>>((action) {
          if (action.isDivider) {
            return const PopupMenuDivider(height: 1);
          }

          return PopupMenuItem<void>(
            enabled: action.enabled,
            onTap: action.onTap,
            padding: EdgeInsets.symmetric(
              horizontal: compact ? TKitSpacing.sm : TKitSpacing.md,
              vertical: compact ? TKitSpacing.xs : TKitSpacing.sm,
            ),
            child: Row(
              children: [
                if (action.icon != null) ...[
                  Icon(
                    action.icon,
                    size: 16,
                    color: action.enabled
                        ? (action.textColor ?? TKitColors.textSecondary)
                        : TKitColors.textDisabled,
                  ),
                  const SizedBox(width: TKitSpacing.sm),
                ],
                Text(
                  action.label,
                  style: TKitTextStyles.bodySmall.copyWith(
                    color: action.enabled
                        ? (action.textColor ?? TKitColors.textPrimary)
                        : TKitColors.textDisabled,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
      child: child ?? _buildDefaultButton(),
    );
  }

  Widget _buildDefaultButton() {
    // Icon-only button
    if (label == null && icon != null) {
      return Container(
        padding: EdgeInsets.all(compact ? TKitSpacing.xs : TKitSpacing.sm),
        decoration: backgroundColor != null
            ? BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(TKitSpacing.xs),
              )
            : null,
        child: Icon(
          icon,
          size: compact ? 16 : 20,
          color: enabled
              ? (iconColor ?? TKitColors.textSecondary)
              : TKitColors.textDisabled,
        ),
      );
    }

    // Button with label and optional icon
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? TKitSpacing.sm : TKitSpacing.md,
        vertical: compact ? TKitSpacing.xs : TKitSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? TKitColors.surface,
        borderRadius: BorderRadius.circular(TKitSpacing.xs),
        border: Border.all(
          color: TKitColors.border,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16,
              color: enabled
                  ? (iconColor ?? TKitColors.textSecondary)
                  : TKitColors.textDisabled,
            ),
            if (label != null) const SizedBox(width: TKitSpacing.sm),
          ],
          if (label != null)
            Text(
              label!,
              style: TKitTextStyles.bodySmall.copyWith(
                color: enabled ? TKitColors.textPrimary : TKitColors.textDisabled,
              ),
            ),
          const SizedBox(width: TKitSpacing.xs),
          Icon(
            Icons.arrow_drop_down,
            size: 20,
            color: enabled ? TKitColors.textSecondary : TKitColors.textDisabled,
          ),
        ],
      ),
    );
  }
}

/// Icon menu button - simplified version for icon-only menus
class IconMenuButton extends StatelessWidget {
  final IconData icon;
  final List<MenuAction> actions;
  final String? tooltip;
  final bool enabled;
  final double? iconSize;
  final Color? iconColor;

  const IconMenuButton({
    super.key,
    required this.icon,
    required this.actions,
    this.tooltip,
    this.enabled = true,
    this.iconSize,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return MenuButton.icon(
      icon: icon,
      actions: actions,
      tooltip: tooltip,
      enabled: enabled,
      iconColor: iconColor,
      compact: true,
    );
  }
}
