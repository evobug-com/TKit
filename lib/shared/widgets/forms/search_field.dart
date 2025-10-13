import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/text_styles.dart';
import 'package:tkit/shared/theme/spacing.dart';

/// Text field with search icon and clear button
/// Supports debouncing for live search functionality
class SearchField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSearch;
  final VoidCallback? onClear;
  final Duration debounceDuration;
  final bool autofocus;
  final String? errorText;

  const SearchField({
    super.key,
    this.controller,
    this.hintText = 'Search...',
    this.onChanged,
    this.onSearch,
    this.onClear,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.autofocus = false,
    this.errorText,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late TextEditingController _controller;
  Timer? _debounceTimer;
  bool _isOwned = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController();
      _isOwned = true;
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    if (_isOwned) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value) {
    widget.onChanged?.call(value);

    // Cancel previous timer
    _debounceTimer?.cancel();

    // Start new timer for debounced search
    if (widget.onSearch != null) {
      _debounceTimer = Timer(widget.debounceDuration, () {
        widget.onSearch?.call(value);
      });
    }
  }

  void _onClear() {
    _controller.clear();
    widget.onClear?.call();
    widget.onChanged?.call('');
    widget.onSearch?.call('');
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      autofocus: widget.autofocus,
      onChanged: _onChanged,
      style: TKitTextStyles.bodyMedium.copyWith(
        color: TKitColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TKitTextStyles.bodyMedium.copyWith(
          color: TKitColors.textMuted,
        ),
        errorText: widget.errorText,
        filled: true,
        fillColor: TKitColors.background,
        prefixIcon: const Icon(
          Icons.search,
          size: 18,
          color: TKitColors.textMuted,
        ),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: _controller,
          builder: (context, value, child) {
            if (value.text.isEmpty) return const SizedBox.shrink();
            return IconButton(
              icon: const Icon(
                Icons.clear,
                size: 18,
                color: TKitColors.textMuted,
              ),
              onPressed: _onClear,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
            );
          },
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
          borderSide: BorderSide(color: TKitColors.accent, width: 2),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: TKitColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: TKitSpacing.sm,
          vertical: TKitSpacing.sm,
        ),
        isDense: true,
      ),
    );
  }
}
