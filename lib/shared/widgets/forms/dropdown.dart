import 'package:flutter/material.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/theme/text_styles.dart';

/// TKit dropdown with search capability
/// Compact, monochrome design with minimal accent
class TKitDropdown<T> extends StatefulWidget {
  final T? value;
  final ValueChanged<T?>? onChanged;
  final List<TKitDropdownOption<T>> options;
  final String? placeholder;
  final bool enabled;
  final bool searchable;
  final String Function(T)? displayBuilder;

  const TKitDropdown({
    super.key,
    this.value,
    this.onChanged,
    required this.options,
    this.placeholder,
    this.enabled = true,
    this.searchable = false,
    this.displayBuilder,
  });

  @override
  State<TKitDropdown<T>> createState() => _TKitDropdownState<T>();
}

class _TKitDropdownState<T> extends State<TKitDropdown<T>> {
  final _searchController = TextEditingController();
  List<TKitDropdownOption<T>> _filteredOptions = [];

  @override
  void initState() {
    super.initState();
    _filteredOptions = widget.options;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterOptions(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredOptions = widget.options;
      } else {
        _filteredOptions = widget.options
            .where((option) =>
                option.label.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  String _getDisplayText() {
    if (widget.value == null) {
      return widget.placeholder ?? 'Select an option';
    }
    if (widget.displayBuilder != null) {
      return widget.displayBuilder!(widget.value as T);
    }
    final option = widget.options.firstWhere(
      (opt) => opt.value == widget.value,
      orElse: () => widget.options.first,
    );
    return option.label;
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.enabled && widget.onChanged != null;

    return PopupMenuButton<T>(
      enabled: isEnabled,
      offset: const Offset(0, 4),
      color: TKitColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: TKitColors.border),
      ),
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: TKitColors.background,
          border: Border.all(
            color: isEnabled ? TKitColors.border : TKitColors.borderSubtle,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                _getDisplayText(),
                style: TKitTextStyles.bodyMedium.copyWith(
                  color: widget.value == null
                      ? TKitColors.textMuted
                      : (isEnabled
                          ? TKitColors.textPrimary
                          : TKitColors.textDisabled),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              size: 18,
              color: isEnabled ? TKitColors.textMuted : TKitColors.textDisabled,
            ),
          ],
        ),
      ),
      onOpened: () {
        _searchController.clear();
        _filteredOptions = widget.options;
      },
      itemBuilder: (BuildContext context) {
        final items = <PopupMenuEntry<T>>[];

        // Add search field if searchable
        if (widget.searchable) {
          items.add(
            PopupMenuItem<T>(
              enabled: false,
              padding: const EdgeInsets.symmetric(
                horizontal: TKitSpacing.sm,
                vertical: TKitSpacing.xs,
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filterOptions,
                style: TKitTextStyles.bodyMedium.copyWith(
                  color: TKitColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TKitTextStyles.bodyMedium.copyWith(
                    color: TKitColors.textMuted,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 16,
                    color: TKitColors.textMuted,
                  ),
                  filled: true,
                  fillColor: TKitColors.surfaceVariant,
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
                    borderSide: BorderSide(color: TKitColors.accent),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  isDense: true,
                ),
              ),
            ),
          );

          items.add(
            const PopupMenuDivider(height: 1),
          );
        }

        // Add options
        if (_filteredOptions.isEmpty) {
          items.add(
            PopupMenuItem<T>(
              enabled: false,
              child: Text(
                'No results found',
                style: TKitTextStyles.bodyMedium.copyWith(
                  color: TKitColors.textMuted,
                ),
              ),
            ),
          );
        } else {
          for (final option in _filteredOptions) {
            items.add(
              PopupMenuItem<T>(
                value: option.value,
                height: 32,
                padding: const EdgeInsets.symmetric(
                  horizontal: TKitSpacing.md,
                  vertical: TKitSpacing.xs,
                ),
                child: Row(
                  children: [
                    if (option.value == widget.value)
                      const Padding(
                        padding: EdgeInsets.only(right: TKitSpacing.xs),
                        child: Icon(
                          Icons.check,
                          size: 14,
                          color: TKitColors.accent,
                        ),
                      ),
                    Expanded(
                      child: Text(
                        option.label,
                        style: TKitTextStyles.bodyMedium.copyWith(
                          color: option.value == widget.value
                              ? TKitColors.textPrimary
                              : TKitColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }

        return items;
      },
      onSelected: (T value) {
        widget.onChanged?.call(value);
      },
    );
  }
}

/// Dropdown option model
class TKitDropdownOption<T> {
  final T value;
  final String label;

  const TKitDropdownOption({
    required this.value,
    required this.label,
  });
}

/// FormField wrapper for TKitDropdown to work with forms
class TKitDropdownFormField<T> extends FormField<T> {
  TKitDropdownFormField({
    super.key,
    super.initialValue,
    required List<TKitDropdownOption<T>> options,
    String? placeholder,
    super.onSaved,
    super.validator,
    bool enabled = true,
    bool searchable = false,
    String Function(T)? displayBuilder,
    super.autovalidateMode,
  }) : super(
          builder: (FormFieldState<T> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TKitDropdown<T>(
                  value: state.value,
                  onChanged: enabled
                      ? (value) {
                          state.didChange(value);
                        }
                      : null,
                  options: options,
                  placeholder: placeholder,
                  enabled: enabled,
                  searchable: searchable,
                  displayBuilder: displayBuilder,
                ),
                if (state.hasError) ...[
                  const SizedBox(height: TKitSpacing.xs),
                  Text(
                    state.errorText!,
                    style: TKitTextStyles.caption.copyWith(
                      color: TKitColors.error,
                    ),
                  ),
                ],
              ],
            );
          },
        );
}
