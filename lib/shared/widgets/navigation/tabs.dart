import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../theme/spacing.dart';

/// Tab item data
class TKitTab {
  final String label;
  final IconData? icon;
  final Widget? badge;

  const TKitTab({
    required this.label,
    this.icon,
    this.badge,
  });
}

/// TKitTabBar - Horizontal tab navigation bar
/// Reusable tab system separate from main app tabs
class TKitTabBar extends StatelessWidget {
  final List<TKitTab> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final bool compact;

  const TKitTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: TKitColors.border,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          for (var i = 0; i < tabs.length; i++)
            _TabItem(
              tab: tabs[i],
              isSelected: i == selectedIndex,
              onTap: () => onTabSelected(i),
              compact: compact,
            ),
        ],
      ),
    );
  }
}

/// Internal tab item widget
class _TabItem extends StatelessWidget {
  final TKitTab tab;
  final bool isSelected;
  final VoidCallback onTap;
  final bool compact;

  const _TabItem({
    required this.tab,
    required this.isSelected,
    required this.onTap,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    final verticalPadding = compact ? TKitSpacing.sm : TKitSpacing.md;
    final horizontalPadding = compact ? TKitSpacing.md : TKitSpacing.lg;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? TKitColors.accent : TKitColors.transparent,
              width: 2.0,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (tab.icon != null) ...[
              Icon(
                tab.icon,
                size: compact ? 14 : 16,
                color: isSelected
                    ? TKitColors.textPrimary
                    : TKitColors.textSecondary,
              ),
              const SizedBox(width: TKitSpacing.xs),
            ],
            Text(
              tab.label,
              style: (compact
                      ? TKitTextStyles.labelSmall
                      : TKitTextStyles.labelMedium)
                  .copyWith(
                color: isSelected
                    ? TKitColors.textPrimary
                    : TKitColors.textSecondary,
              ),
            ),
            if (tab.badge != null) ...[
              const SizedBox(width: TKitSpacing.xs),
              tab.badge!,
            ],
          ],
        ),
      ),
    );
  }
}

/// TKitTabView - Tab content container
/// Manages tab content switching with optional animations
class TKitTabView extends StatelessWidget {
  final int selectedIndex;
  final List<Widget> children;
  final bool animate;

  const TKitTabView({
    super.key,
    required this.selectedIndex,
    required this.children,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!animate) {
      return IndexedStack(
        index: selectedIndex,
        children: children,
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      child: KeyedSubtree(
        key: ValueKey<int>(selectedIndex),
        child: children[selectedIndex],
      ),
    );
  }
}

/// TKitTabController - Complete tab system with bar and view
/// Combines tab bar and content view for convenience
class TKitTabController extends StatefulWidget {
  final List<TKitTab> tabs;
  final List<Widget> children;
  final int initialIndex;
  final ValueChanged<int>? onTabChanged;
  final bool compact;
  final bool animate;

  const TKitTabController({
    super.key,
    required this.tabs,
    required this.children,
    this.initialIndex = 0,
    this.onTabChanged,
    this.compact = false,
    this.animate = true,
  }) : assert(tabs.length == children.length,
            'tabs and children must have the same length');

  @override
  State<TKitTabController> createState() => _TKitTabControllerState();
}

class _TKitTabControllerState extends State<TKitTabController> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onTabChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TKitTabBar(
          tabs: widget.tabs,
          selectedIndex: _selectedIndex,
          onTabSelected: _onTabSelected,
          compact: widget.compact,
        ),
        Expanded(
          child: TKitTabView(
            selectedIndex: _selectedIndex,
            animate: widget.animate,
            children: widget.children,
          ),
        ),
      ],
    );
  }
}
