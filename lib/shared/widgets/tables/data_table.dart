import 'package:flutter/material.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/text_styles.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/widgets/layout/spacer.dart';

/// Column definition for TKitDataTable
class TKitTableColumn<T> {
  /// Column label displayed in header
  final String label;

  /// Unique identifier for sorting
  final String id;

  /// Width of the column (null for flexible width)
  final double? width;

  /// Cell builder function
  final Widget Function(T item) cellBuilder;

  /// Whether this column can be sorted
  final bool sortable;

  /// Text alignment
  final TextAlign textAlign;

  /// Comparison function for sorting (required if sortable is true)
  final int Function(T a, T b)? comparator;

  const TKitTableColumn({
    required this.label,
    required this.id,
    required this.cellBuilder,
    this.width,
    this.sortable = false,
    this.textAlign = TextAlign.left,
    this.comparator,
  }) : assert(
         !sortable || comparator != null,
         'comparator is required when sortable is true',
       );
}

/// Sort direction for table columns
enum TKitSortDirection { ascending, descending }

/// Compact, sortable data table component
class TKitDataTable<T> extends StatefulWidget {
  /// List of items to display
  final List<T> items;

  /// Column definitions
  final List<TKitTableColumn<T>> columns;

  /// Callback when a row is tapped
  final void Function(T item)? onRowTap;

  /// Currently selected items
  final Set<T>? selectedItems;

  /// Whether to enable row selection
  final bool selectable;

  /// Callback when selection changes
  final void Function(Set<T> selected)? onSelectionChanged;

  /// Whether to use compact styling (smaller padding)
  final bool compact;

  /// Empty state widget shown when items list is empty
  final Widget? emptyState;

  /// Header background color
  final Color? headerColor;

  /// Initial sort column ID
  final String? initialSortColumn;

  /// Initial sort direction
  final TKitSortDirection initialSortDirection;

  const TKitDataTable({
    super.key,
    required this.items,
    required this.columns,
    this.onRowTap,
    this.selectedItems,
    this.selectable = false,
    this.onSelectionChanged,
    this.compact = true,
    this.emptyState,
    this.headerColor,
    this.initialSortColumn,
    this.initialSortDirection = TKitSortDirection.ascending,
  });

  @override
  State<TKitDataTable<T>> createState() => _TKitDataTableState<T>();
}

class _TKitDataTableState<T> extends State<TKitDataTable<T>> {
  String? _sortColumnId;
  TKitSortDirection _sortDirection = TKitSortDirection.ascending;
  late List<T> _sortedItems;

  @override
  void initState() {
    super.initState();
    _sortColumnId = widget.initialSortColumn;
    _sortDirection = widget.initialSortDirection;
    _sortedItems = List.from(widget.items);
    _sortItems();
  }

  @override
  void didUpdateWidget(TKitDataTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      _sortedItems = List.from(widget.items);
      _sortItems();
    }
  }

  void _sortItems() {
    if (_sortColumnId == null) {
      return;
    }

    final column = widget.columns.firstWhere(
      (col) => col.id == _sortColumnId,
      orElse: () => widget.columns.first,
    );

    if (!column.sortable || column.comparator == null) {
      return;
    }

    _sortedItems.sort((a, b) {
      final result = column.comparator!(a, b);
      return _sortDirection == TKitSortDirection.ascending ? result : -result;
    });
  }

  void _handleSort(String columnId) {
    setState(() {
      if (_sortColumnId == columnId) {
        _sortDirection = _sortDirection == TKitSortDirection.ascending
            ? TKitSortDirection.descending
            : TKitSortDirection.ascending;
      } else {
        _sortColumnId = columnId;
        _sortDirection = TKitSortDirection.ascending;
      }
      _sortItems();
    });
  }

  void _handleRowSelection(T item, bool? selected) {
    if (!widget.selectable || widget.onSelectionChanged == null) {
      return;
    }

    final newSelection = Set<T>.from(widget.selectedItems ?? {});
    if (selected == true) {
      newSelection.add(item);
    } else {
      newSelection.remove(item);
    }
    widget.onSelectionChanged!(newSelection);
  }

  void _handleSelectAll(bool? selected) {
    if (!widget.selectable || widget.onSelectionChanged == null) {
      return;
    }

    final newSelection = selected == true ? Set<T>.from(_sortedItems) : <T>{};
    widget.onSelectionChanged!(newSelection);
  }

  @override
  Widget build(BuildContext context) {
    if (_sortedItems.isEmpty && widget.emptyState != null) {
      return widget.emptyState!;
    }

    final verticalPadding = widget.compact ? TKitSpacing.xs : TKitSpacing.sm;
    final horizontalPadding = widget.compact ? TKitSpacing.sm : TKitSpacing.md;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: TKitColors.border),
        color: TKitColors.surface,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          TKitTableHeader(
            columns: widget.columns,
            sortColumnId: _sortColumnId,
            sortDirection: _sortDirection,
            onSort: _handleSort,
            selectable: widget.selectable,
            allSelected:
                widget.selectedItems?.length == _sortedItems.length &&
                _sortedItems.isNotEmpty,
            onSelectAll: ({bool? selected}) => _handleSelectAll(selected),
            verticalPadding: verticalPadding,
            horizontalPadding: horizontalPadding,
            backgroundColor: widget.headerColor,
          ),
          // Rows
          ..._sortedItems.map((item) {
            final isSelected = widget.selectedItems?.contains(item) ?? false;
            return TKitTableRow<T>(
              item: item,
              columns: widget.columns,
              onTap: widget.onRowTap != null
                  ? () => widget.onRowTap!(item)
                  : null,
              selected: isSelected,
              selectable: widget.selectable,
              onSelectionChanged: ({bool? selected}) =>
                  _handleRowSelection(item, selected),
              verticalPadding: verticalPadding,
              horizontalPadding: horizontalPadding,
            );
          }),
        ],
      ),
    );
  }
}

/// Table header with sort indicators
class TKitTableHeader<T> extends StatelessWidget {
  final List<TKitTableColumn<T>> columns;
  final String? sortColumnId;
  final TKitSortDirection sortDirection;
  final void Function(String columnId) onSort;
  final bool selectable;
  final bool allSelected;
  final void Function({bool? selected})? onSelectAll;
  final double verticalPadding;
  final double horizontalPadding;
  final Color? backgroundColor;

  const TKitTableHeader({
    super.key,
    required this.columns,
    required this.sortColumnId,
    required this.sortDirection,
    required this.onSort,
    required this.selectable,
    required this.allSelected,
    required this.onSelectAll,
    required this.verticalPadding,
    required this.horizontalPadding,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? TKitColors.surfaceVariant,
        border: const Border(bottom: BorderSide(color: TKitColors.border)),
      ),
      child: Row(
        children: [
          // Selection checkbox
          if (selectable) ...[
            SizedBox(
              width: TKitSpacing.xl * 2,
              child: Checkbox(
                value: allSelected,
                onChanged: onSelectAll != null
                    ? (value) => onSelectAll!(selected: value)
                    : null,
                fillColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return TKitColors.accent;
                  }
                  return TKitColors.border;
                }),
                side: const BorderSide(color: TKitColors.border),
              ),
            ),
          ],
          // Column headers
          ...columns.map((column) {
            final isSorted = sortColumnId == column.id;

            Widget headerContent = Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      column.label,
                      style: TKitTextStyles.labelSmall.copyWith(
                        color: TKitColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: column.textAlign,
                    ),
                  ),
                  if (column.sortable) ...[
                    const HSpace.xs(),
                    Icon(
                      isSorted
                          ? (sortDirection == TKitSortDirection.ascending
                                ? Icons.arrow_upward
                                : Icons.arrow_downward)
                          : Icons.unfold_more,
                      size: TKitSpacing.md,
                      color: isSorted
                          ? TKitColors.textPrimary
                          : TKitColors.textMuted,
                    ),
                  ],
                ],
              ),
            );

            if (column.sortable) {
              headerContent = InkWell(
                onTap: () => onSort(column.id),
                child: headerContent,
              );
            }

            return column.width != null
                ? SizedBox(width: column.width, child: headerContent)
                : Expanded(child: headerContent);
          }),
        ],
      ),
    );
  }
}

/// Table row with hover states
class TKitTableRow<T> extends StatefulWidget {
  final T item;
  final List<TKitTableColumn<T>> columns;
  final VoidCallback? onTap;
  final bool selected;
  final bool selectable;
  final void Function({bool? selected})? onSelectionChanged;
  final double verticalPadding;
  final double horizontalPadding;

  const TKitTableRow({
    super.key,
    required this.item,
    required this.columns,
    this.onTap,
    this.selected = false,
    this.selectable = false,
    this.onSelectionChanged,
    required this.verticalPadding,
    required this.horizontalPadding,
  });

  @override
  State<TKitTableRow<T>> createState() => _TKitTableRowState<T>();
}

class _TKitTableRowState<T> extends State<TKitTableRow<T>> {
  var _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Material(
        color: widget.selected
            ? TKitColors.surfaceVariant
            : (_isHovered ? TKitColors.borderSubtle : TKitColors.surface),
        child: InkWell(
          onTap: widget.onTap,
          child: Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: TKitColors.border)),
            ),
            child: Row(
              children: [
                // Selection checkbox
                if (widget.selectable) ...[
                  SizedBox(
                    width: TKitSpacing.xl * 2,
                    child: Checkbox(
                      value: widget.selected,
                      onChanged: widget.onSelectionChanged != null
                          ? (value) =>
                                widget.onSelectionChanged!(selected: value)
                          : null,
                      fillColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return TKitColors.accent;
                        }
                        return TKitColors.border;
                      }),
                      side: const BorderSide(color: TKitColors.border),
                    ),
                  ),
                ],
                // Cells
                ...widget.columns.map((column) {
                  final cell = TKitTableCell(
                    textAlign: column.textAlign,
                    verticalPadding: widget.verticalPadding,
                    horizontalPadding: widget.horizontalPadding,
                    child: column.cellBuilder(widget.item),
                  );

                  return column.width != null
                      ? SizedBox(width: column.width, child: cell)
                      : Expanded(child: cell);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Individual table cell component
class TKitTableCell extends StatelessWidget {
  final Widget child;
  final TextAlign textAlign;
  final double verticalPadding;
  final double horizontalPadding;

  const TKitTableCell({
    super.key,
    required this.child,
    this.textAlign = TextAlign.left,
    required this.verticalPadding,
    required this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: DefaultTextStyle(
        style: TKitTextStyles.bodySmall.copyWith(color: TKitColors.textPrimary),
        textAlign: textAlign,
        child: child,
      ),
    );
  }
}
