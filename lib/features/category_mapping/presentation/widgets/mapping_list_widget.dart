import 'package:flutter/material.dart';
import 'package:tkit/l10n/app_localizations.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/text_styles.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/widgets/layout/spacer.dart';
import 'package:tkit/features/category_mapping/domain/entities/category_mapping.dart';

/// Widget to display the list of category mappings in a DataTable with bulk selection
class MappingListWidget extends StatefulWidget {
  final List<CategoryMapping> mappings;
  final Function(int id) onDelete;
  final Function(CategoryMapping mapping) onEdit;
  final Function(CategoryMapping mapping)? onToggleEnabled;
  final Function(List<int> ids)? onBulkDelete;
  final Function(List<CategoryMapping> mappings)? onBulkExport;
  final Function(List<int> ids, bool enabled)? onBulkToggleEnabled;
  final Function(List<CategoryMapping> mappings)? onBulkRestore;
  final Function(String? listId)? onSourceTap;

  const MappingListWidget({
    super.key,
    required this.mappings,
    required this.onDelete,
    required this.onEdit,
    this.onToggleEnabled,
    this.onBulkDelete,
    this.onBulkExport,
    this.onBulkToggleEnabled,
    this.onBulkRestore,
    this.onSourceTap,
  });

  @override
  State<MappingListWidget> createState() => _MappingListWidgetState();
}

class _MappingListWidgetState extends State<MappingListWidget> {
  final Set<int> _selectedIds = {};
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Undo state
  String? _lastAction;
  List<CategoryMapping>? _deletedMappings;
  Map<int, bool>? _previousEnabledStates;

  bool get _canUndo => _lastAction != null;

  /// Get filtered mappings based on search query
  List<CategoryMapping> get _filteredMappings {
    if (_searchQuery.isEmpty) {
      return widget.mappings;
    }

    final query = _searchQuery.toLowerCase();
    return widget.mappings.where((mapping) {
      return mapping.processName.toLowerCase().contains(query) ||
          mapping.twitchCategoryName.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _invertSelection() {
    setState(() {
      // Invert only the visible (filtered) mappings
      final visibleIds = _filteredMappings.map((m) => m.id!).toSet();
      final currentSelection = Set<int>.from(_selectedIds);

      // Remove visible selected items
      _selectedIds.removeWhere((id) => visibleIds.contains(id));

      // Add visible unselected items
      _selectedIds.addAll(visibleIds.difference(currentSelection));
    });
  }

  void _toggleSelection(int id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedIds.clear();
    });
  }

  void _clearUndo() {
    setState(() {
      _lastAction = null;
      _deletedMappings = null;
      _previousEnabledStates = null;
    });
  }

  List<CategoryMapping> get _selectedMappings {
    return widget.mappings.where((m) => _selectedIds.contains(m.id)).toList();
  }

  void _handleUndo() {
    if (_lastAction == null) return;

    if (_lastAction == 'Delete' && _deletedMappings != null && widget.onBulkRestore != null) {
      // Restore deleted mappings
      widget.onBulkRestore!(_deletedMappings!);
    } else if ((_lastAction == 'Enable' || _lastAction == 'Disable') &&
        _previousEnabledStates != null &&
        widget.onBulkToggleEnabled != null) {
      // Restore previous enabled states
      for (final entry in _previousEnabledStates!.entries) {
        widget.onBulkToggleEnabled!([entry.key], entry.value);
      }
    }

    _clearUndo();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (widget.mappings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category_outlined,
              size: 48,
              color: TKitColors.textMuted,
            ),
            const VSpace.md(),
            Text(
              l10n.categoryMappingListEmpty,
              style: TKitTextStyles.bodyMedium.copyWith(
                color: TKitColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const VSpace.sm(),
            Text(
              l10n.categoryMappingListEmptySubtitle,
              style: TKitTextStyles.bodySmall.copyWith(
                color: TKitColors.textMuted,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Search field
        _buildSearchField(context),
        const VSpace.sm(),

        // Bulk operations toolbar
        if (_selectedIds.isNotEmpty) _buildBulkOperationsBar(context),
        if (_selectedIds.isNotEmpty) const VSpace.sm(),

        // Data table
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: TKitColors.border),
              color: TKitColors.surface,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SizedBox(
                width: double.infinity,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(TKitColors.surfaceVariant),
                  dataRowColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return TKitColors.accent.withValues(alpha: 0.1);
                    }
                    if (states.contains(WidgetState.hovered)) {
                      return TKitColors.surfaceVariant;
                    }
                    return TKitColors.surface;
                  }),
                  border: TableBorder.symmetric(
                    inside: const BorderSide(color: TKitColors.border),
                  ),
                  headingTextStyle: TKitTextStyles.labelLarge.copyWith(
                    color: TKitColors.textPrimary,
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                  dataTextStyle: TKitTextStyles.bodyMedium.copyWith(
                    color: TKitColors.textSecondary,
                    fontSize: 13,
                  ),
                  headingRowHeight: 48,
                  dataRowMinHeight: 52,
                  dataRowMaxHeight: 64,
                  columnSpacing: 16,
                  horizontalMargin: TKitSpacing.md,
                  checkboxHorizontalMargin: 8,
                  showCheckboxColumn: true,
                  columns: [
                    DataColumn(label: Text(l10n.categoryMappingListColumnProcessName)),
                    DataColumn(label: Text(l10n.categoryMappingListColumnCategory)),
                    const DataColumn(label: Text('Source')),
                    const DataColumn(label: Text('Enabled')),
                    DataColumn(label: Text(l10n.categoryMappingListColumnActions)),
                  ],
                  rows: _filteredMappings.map((mapping) {
                    final isSelected = _selectedIds.contains(mapping.id);
                    return DataRow(
                      selected: isSelected,
                      onSelectChanged: (_) => _toggleSelection(mapping.id!),
                      cells: [
                        DataCell(
                          Text(
                            mapping.processName,
                            style: TKitTextStyles.code.copyWith(
                              color: TKitColors.textPrimary,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        DataCell(
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mapping.twitchCategoryName,
                                style: TKitTextStyles.bodyMedium.copyWith(
                                  color: TKitColors.textPrimary,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                l10n.categoryMappingListCategoryId(mapping.twitchCategoryId),
                                style: TKitTextStyles.bodySmall.copyWith(
                                  color: TKitColors.textMuted,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataCell(
                          InkWell(
                            onTap: widget.onSourceTap != null
                                ? () => widget.onSourceTap!(mapping.listId)
                                : null,
                            borderRadius: BorderRadius.circular(2),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: TKitSpacing.sm,
                                vertical: TKitSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: TKitColors.info.withValues(alpha: 0.1),
                                border: Border.all(
                                  color: TKitColors.info.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    mapping.sourceListName ?? 'Unknown',
                                    style: TKitTextStyles.caption.copyWith(
                                      color: TKitColors.info,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  if (widget.onSourceTap != null) ...[
                                    const HSpace.xs(),
                                    Icon(
                                      Icons.open_in_new,
                                      size: 10,
                                      color: TKitColors.info,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: 40,
                            child: Checkbox(
                              value: mapping.isEnabled,
                              onChanged: widget.onToggleEnabled != null
                                  ? (_) => widget.onToggleEnabled!(mapping)
                                  : null,
                              activeColor: TKitColors.accent,
                              side: const BorderSide(color: TKitColors.border),
                            ),
                          ),
                        ),
                        DataCell(
                          mapping.sourceListIsReadOnly
                              ? const SizedBox.shrink()
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, size: 16),
                                      color: TKitColors.textSecondary,
                                      hoverColor: TKitColors.accent.withValues(alpha: 0.2),
                                      onPressed: () => widget.onEdit(mapping),
                                      tooltip: l10n.categoryMappingListEditTooltip,
                                      padding: const EdgeInsets.all(TKitSpacing.sm),
                                      constraints: const BoxConstraints(
                                        minWidth: 32,
                                        minHeight: 32,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, size: 16),
                                      color: TKitColors.textSecondary,
                                      hoverColor: TKitColors.error.withValues(alpha: 0.2),
                                      onPressed: () => widget.onDelete(mapping.id!),
                                      tooltip: l10n.categoryMappingListDeleteTooltip,
                                      padding: const EdgeInsets.all(TKitSpacing.sm),
                                      constraints: const BoxConstraints(
                                        minWidth: 32,
                                        minHeight: 32,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBulkOperationsBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TKitSpacing.md,
        vertical: TKitSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: TKitColors.accent.withValues(alpha: 0.1),
        border: Border.all(color: TKitColors.accent.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 18,
            color: TKitColors.accent,
          ),
          const HSpace.sm(),
          Text(
            _searchQuery.isEmpty
                ? '${_selectedIds.length} selected'
                : '${_selectedIds.length} selected (${_filteredMappings.where((m) => _selectedIds.contains(m.id)).length} visible)',
            style: TKitTextStyles.bodyMedium.copyWith(
              color: TKitColors.accent,
              fontWeight: FontWeight.w600,
            ),
          ),
          const HSpace.md(),
          TextButton.icon(
            onPressed: _invertSelection,
            icon: const Icon(Icons.swap_vert, size: 16),
            label: const Text('Invert'),
            style: TextButton.styleFrom(
              foregroundColor: TKitColors.textPrimary,
              padding: const EdgeInsets.symmetric(
                horizontal: TKitSpacing.sm,
                vertical: TKitSpacing.xs,
              ),
            ),
          ),
          const HSpace.xs(),
          TextButton.icon(
            onPressed: _clearSelection,
            icon: const Icon(Icons.clear, size: 16),
            label: const Text('Clear'),
            style: TextButton.styleFrom(
              foregroundColor: TKitColors.textPrimary,
              padding: const EdgeInsets.symmetric(
                horizontal: TKitSpacing.sm,
                vertical: TKitSpacing.xs,
              ),
            ),
          ),
          if (_canUndo) ...[
            const HSpace.xs(),
            Container(
              height: 20,
              width: 1,
              color: TKitColors.border,
              margin: const EdgeInsets.symmetric(horizontal: TKitSpacing.xs),
            ),
            const HSpace.xs(),
            TextButton.icon(
              onPressed: _handleUndo,
              icon: const Icon(Icons.undo, size: 16),
              label: Text('Undo $_lastAction'),
              style: TextButton.styleFrom(
                foregroundColor: TKitColors.accent,
                padding: const EdgeInsets.symmetric(
                  horizontal: TKitSpacing.sm,
                  vertical: TKitSpacing.xs,
                ),
              ),
            ),
          ],
          const Spacer(),
          if (widget.onBulkExport != null)
            ElevatedButton.icon(
              onPressed: () => widget.onBulkExport!(_selectedMappings),
              icon: const Icon(Icons.download, size: 14),
              label: Text(
                'Export',
                style: TKitTextStyles.buttonSmall,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: TKitColors.textPrimary,
                side: const BorderSide(color: TKitColors.border),
                elevation: 0,
                shape: const RoundedRectangleBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                minimumSize: const Size(0, 32),
              ),
            ),
          const HSpace.sm(),
          if (widget.onBulkToggleEnabled != null)
            ElevatedButton.icon(
              onPressed: () {
                // Save current state for undo
                setState(() {
                  _previousEnabledStates = {
                    for (var mapping in _selectedMappings)
                      mapping.id!: mapping.isEnabled
                  };
                  _lastAction = 'Enable';
                  _deletedMappings = null;
                });
                widget.onBulkToggleEnabled!(_selectedIds.toList(), true);
              },
              icon: const Icon(Icons.check_circle, size: 14),
              label: Text(
                'Enable',
                style: TKitTextStyles.buttonSmall,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: TKitColors.textPrimary,
                side: const BorderSide(color: TKitColors.border),
                elevation: 0,
                shape: const RoundedRectangleBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                minimumSize: const Size(0, 32),
              ),
            ),
          const HSpace.sm(),
          if (widget.onBulkToggleEnabled != null)
            ElevatedButton.icon(
              onPressed: () {
                // Save current state for undo
                setState(() {
                  _previousEnabledStates = {
                    for (var mapping in _selectedMappings)
                      mapping.id!: mapping.isEnabled
                  };
                  _lastAction = 'Disable';
                  _deletedMappings = null;
                });
                widget.onBulkToggleEnabled!(_selectedIds.toList(), false);
              },
              icon: const Icon(Icons.cancel, size: 14),
              label: Text(
                'Disable',
                style: TKitTextStyles.buttonSmall,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: TKitColors.textPrimary,
                side: const BorderSide(color: TKitColors.border),
                elevation: 0,
                shape: const RoundedRectangleBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                minimumSize: const Size(0, 32),
              ),
            ),
          const HSpace.sm(),
          if (widget.onBulkDelete != null)
            ElevatedButton.icon(
              onPressed: () {
                // Save deleted mappings for undo
                setState(() {
                  _deletedMappings = List.from(_selectedMappings);
                  _lastAction = 'Delete';
                  _previousEnabledStates = null;
                });
                widget.onBulkDelete!(_selectedIds.toList());
                _clearSelection();
              },
              icon: const Icon(Icons.delete, size: 14),
              label: Text(
                'Delete',
                style: TKitTextStyles.buttonSmall,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: TKitColors.error,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: const RoundedRectangleBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                minimumSize: const Size(0, 32),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TKitSpacing.md,
        vertical: TKitSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: TKitColors.surface,
        border: Border.all(color: TKitColors.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            size: 20,
            color: TKitColors.textMuted,
          ),
          const HSpace.sm(),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search by process name or category...',
                hintStyle: TKitTextStyles.bodyMedium.copyWith(
                  color: TKitColors.textMuted,
                  fontSize: 14,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: TKitTextStyles.bodyMedium.copyWith(
                color: TKitColors.textPrimary,
                fontSize: 14,
              ),
            ),
          ),
          if (_searchQuery.isNotEmpty) ...[
            const HSpace.sm(),
            Text(
              '${_filteredMappings.length} of ${widget.mappings.length}',
              style: TKitTextStyles.bodySmall.copyWith(
                color: TKitColors.textMuted,
                fontSize: 12,
              ),
            ),
            const HSpace.sm(),
            IconButton(
              icon: const Icon(Icons.clear, size: 18),
              color: TKitColors.textMuted,
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _searchQuery = '';
                });
              },
              tooltip: 'Clear search',
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(
                minWidth: 24,
                minHeight: 24,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
