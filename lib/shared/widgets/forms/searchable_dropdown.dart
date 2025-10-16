import 'package:flutter/material.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/text_styles.dart';
import 'package:tkit/shared/theme/spacing.dart';

/// Dropdown with built-in search/filter functionality
class SearchableDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T? value;
  final String Function(T) itemLabel;
  final ValueChanged<T?>? onChanged;
  final String? hintText;
  final String? searchHintText;
  final String? errorText;
  final bool Function(T, String)? filterFunction;

  const SearchableDropdown({
    super.key,
    required this.items,
    required this.itemLabel,
    this.value,
    this.onChanged,
    this.hintText = 'Select...',
    this.searchHintText = 'Search...',
    this.errorText,
    this.filterFunction,
  });

  @override
  State<SearchableDropdown<T>> createState() => _SearchableDropdownState<T>();
}

class _SearchableDropdownState<T> extends State<SearchableDropdown<T>> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  List<T> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
  }

  @override
  void didUpdateWidget(SearchableDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      _filterItems(_searchController.text);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items.where((item) {
          if (widget.filterFunction != null) {
            return widget.filterFunction!(item, query);
          }
          return widget
              .itemLabel(item)
              .toLowerCase()
              .contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _showDropdown() {
    _searchController.clear();
    _filteredItems = widget.items;

    showDialog<T>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: TKitColors.surface,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
                side: BorderSide(color: TKitColors.border),
              ),
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 400,
                  maxHeight: 500,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Search field
                    Padding(
                      padding: const EdgeInsets.all(TKitSpacing.md),
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        autofocus: true,
                        onChanged: (value) {
                          setDialogState(() {
                            _filterItems(value);
                          });
                        },
                        style: TKitTextStyles.bodyMedium.copyWith(
                          color: TKitColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: widget.searchHintText,
                          hintStyle: TKitTextStyles.bodyMedium.copyWith(
                            color: TKitColors.textMuted,
                          ),
                          filled: true,
                          fillColor: TKitColors.background,
                          prefixIcon: const Icon(
                            Icons.search,
                            size: 18,
                            color: TKitColors.textMuted,
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(color: TKitColors.border),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(color: TKitColors.border),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(
                              color: TKitColors.accent,
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: TKitSpacing.sm,
                            vertical: TKitSpacing.sm,
                          ),
                          isDense: true,
                        ),
                      ),
                    ),
                    const Divider(height: 1, color: TKitColors.border),
                    // Items list
                    Flexible(
                      child: _filteredItems.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(TKitSpacing.xl),
                                child: Text(
                                  'No items found',
                                  style: TKitTextStyles.bodyMedium.copyWith(
                                    color: TKitColors.textMuted,
                                  ),
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: _filteredItems.length,
                              itemBuilder: (context, index) {
                                final item = _filteredItems[index];
                                final isSelected = item == widget.value;
                                return InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop(item);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: TKitSpacing.md,
                                      vertical: TKitSpacing.md,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? TKitColors.surfaceVariant
                                          : TKitColors.transparent,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            widget.itemLabel(item),
                                            style: TKitTextStyles.bodyMedium
                                                .copyWith(
                                                  color: isSelected
                                                      ? TKitColors.textPrimary
                                                      : TKitColors
                                                            .textSecondary,
                                                ),
                                          ),
                                        ),
                                        if (isSelected)
                                          const Icon(
                                            Icons.check,
                                            size: 18,
                                            color: TKitColors.accent,
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((selectedItem) {
      if (selectedItem != null) {
        widget.onChanged?.call(selectedItem);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onChanged != null ? _showDropdown : null,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TKitSpacing.sm,
          vertical: TKitSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: TKitColors.background,
          border: Border.all(
            color: widget.errorText != null
                ? TKitColors.error
                : TKitColors.border,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.value != null
                    ? widget.itemLabel(widget.value as T)
                    : widget.hintText ?? '',
                style: TKitTextStyles.bodyMedium.copyWith(
                  color: widget.value != null
                      ? TKitColors.textPrimary
                      : TKitColors.textMuted,
                ),
              ),
            ),
            const SizedBox(width: TKitSpacing.sm),
            Icon(
              Icons.arrow_drop_down,
              size: 20,
              color: widget.onChanged != null
                  ? TKitColors.textMuted
                  : TKitColors.textDisabled,
            ),
          ],
        ),
      ),
    );
  }
}
