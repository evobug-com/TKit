import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/text_styles.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/widgets/layout/spacer.dart';

/// Pagination component for navigating pages of data
class Pagination extends StatefulWidget {
  /// Current page number (1-indexed)
  final int currentPage;

  /// Total number of pages
  final int totalPages;

  /// Callback when page changes
  final void Function(int page) onPageChanged;

  /// Whether to show the jump to page input
  final bool showJumpToPage;

  /// Whether to show page info text (e.g., "Page 1 of 10")
  final bool showPageInfo;

  /// Compact mode with smaller sizing
  final bool compact;

  /// Maximum number of page buttons to show
  final int maxPageButtons;

  const Pagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    this.showJumpToPage = true,
    this.showPageInfo = true,
    this.compact = true,
    this.maxPageButtons = 5,
  }) : assert(currentPage >= 1, 'currentPage must be >= 1'),
       assert(totalPages >= 1, 'totalPages must be >= 1'),
       assert(currentPage <= totalPages, 'currentPage must be <= totalPages'),
       assert(maxPageButtons >= 3, 'maxPageButtons must be >= 3');

  @override
  State<Pagination> createState() => _PaginationState();
}

class _PaginationState extends State<Pagination> {
  final _jumpController = TextEditingController();
  final _jumpFocusNode = FocusNode();

  @override
  void dispose() {
    _jumpController.dispose();
    _jumpFocusNode.dispose();
    super.dispose();
  }

  void _handleJumpToPage() {
    final page = int.tryParse(_jumpController.text);
    if (page != null && page >= 1 && page <= widget.totalPages) {
      widget.onPageChanged(page);
      _jumpController.clear();
      _jumpFocusNode.unfocus();
    }
  }

  List<int?> _getPageNumbers() {
    if (widget.totalPages <= widget.maxPageButtons) {
      return List.generate(widget.totalPages, (i) => i + 1);
    }

    final pages = <int?>[];
    final half = (widget.maxPageButtons - 3) ~/ 2;

    // Always show first page
    pages.add(1);

    if (widget.currentPage <= half + 2) {
      // Near the start
      for (var i = 2; i <= widget.maxPageButtons - 1; i++) {
        pages.add(i);
      }
      pages.add(null); // Ellipsis
    } else if (widget.currentPage >= widget.totalPages - half - 1) {
      // Near the end
      pages.add(null); // Ellipsis
      for (
        int i = widget.totalPages - widget.maxPageButtons + 2;
        i < widget.totalPages;
        i++
      ) {
        pages.add(i);
      }
    } else {
      // In the middle
      pages.add(null); // Ellipsis
      for (
        int i = widget.currentPage - half;
        i <= widget.currentPage + half;
        i++
      ) {
        pages.add(i);
      }
      pages.add(null); // Ellipsis
    }

    // Always show last page
    pages.add(widget.totalPages);

    return pages;
  }

  @override
  Widget build(BuildContext context) {
    final buttonSize = widget.compact ? 28.0 : 32.0;
    final iconSize = widget.compact ? 16.0 : 18.0;

    return Container(
      padding: EdgeInsets.all(widget.compact ? TKitSpacing.sm : TKitSpacing.md),
      decoration: BoxDecoration(
        border: Border.all(color: TKitColors.border),
        color: TKitColors.surface,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Page info
          if (widget.showPageInfo)
            Text(
              'Page ${widget.currentPage} of ${widget.totalPages}',
              style: TKitTextStyles.bodySmall.copyWith(
                color: TKitColors.textSecondary,
              ),
            )
          else
            const SizedBox.shrink(),

          // Page navigation
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // First page button
              _PaginationButton(
                onPressed: widget.currentPage > 1
                    ? () => widget.onPageChanged(1)
                    : null,
                size: buttonSize,
                child: Icon(
                  Icons.first_page,
                  size: iconSize,
                  color: widget.currentPage > 1
                      ? TKitColors.textPrimary
                      : TKitColors.textDisabled,
                ),
              ),

              const HSpace.xs(),

              // Previous page button
              _PaginationButton(
                onPressed: widget.currentPage > 1
                    ? () => widget.onPageChanged(widget.currentPage - 1)
                    : null,
                size: buttonSize,
                child: Icon(
                  Icons.chevron_left,
                  size: iconSize,
                  color: widget.currentPage > 1
                      ? TKitColors.textPrimary
                      : TKitColors.textDisabled,
                ),
              ),

              const HSpace.xs(),

              // Page number buttons
              ..._getPageNumbers().map((page) {
                if (page == null) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TKitSpacing.xs,
                    ),
                    child: Text(
                      '...',
                      style: TKitTextStyles.bodySmall.copyWith(
                        color: TKitColors.textMuted,
                      ),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: TKitSpacing.xs / 2),
                  child: _PaginationButton(
                    onPressed: page != widget.currentPage
                        ? () => widget.onPageChanged(page)
                        : null,
                    size: buttonSize,
                    isActive: page == widget.currentPage,
                    child: Text(
                      '$page',
                      style: TKitTextStyles.bodySmall.copyWith(
                        color: page == widget.currentPage
                            ? TKitColors.textPrimary
                            : TKitColors.textSecondary,
                        fontWeight: page == widget.currentPage
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }),

              const HSpace.xs(),

              // Next page button
              _PaginationButton(
                onPressed: widget.currentPage < widget.totalPages
                    ? () => widget.onPageChanged(widget.currentPage + 1)
                    : null,
                size: buttonSize,
                child: Icon(
                  Icons.chevron_right,
                  size: iconSize,
                  color: widget.currentPage < widget.totalPages
                      ? TKitColors.textPrimary
                      : TKitColors.textDisabled,
                ),
              ),

              const HSpace.xs(),

              // Last page button
              _PaginationButton(
                onPressed: widget.currentPage < widget.totalPages
                    ? () => widget.onPageChanged(widget.totalPages)
                    : null,
                size: buttonSize,
                child: Icon(
                  Icons.last_page,
                  size: iconSize,
                  color: widget.currentPage < widget.totalPages
                      ? TKitColors.textPrimary
                      : TKitColors.textDisabled,
                ),
              ),
            ],
          ),

          // Jump to page
          if (widget.showJumpToPage)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Go to:',
                  style: TKitTextStyles.bodySmall.copyWith(
                    color: TKitColors.textSecondary,
                  ),
                ),
                const HSpace.sm(),
                SizedBox(
                  width: 60,
                  height: buttonSize,
                  child: TextField(
                    controller: _jumpController,
                    focusNode: _jumpFocusNode,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: TKitTextStyles.bodySmall,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: '${widget.currentPage}',
                      hintStyle: TKitTextStyles.bodySmall.copyWith(
                        color: TKitColors.textMuted,
                      ),
                      contentPadding: const EdgeInsets.all(TKitSpacing.xs),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: TKitColors.border),
                        borderRadius: BorderRadius.zero,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: TKitColors.border),
                        borderRadius: BorderRadius.zero,
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: TKitColors.accent),
                        borderRadius: BorderRadius.zero,
                      ),
                      isDense: true,
                    ),
                    onSubmitted: (_) => _handleJumpToPage(),
                  ),
                ),
                const HSpace.xs(),
                _PaginationButton(
                  onPressed: _handleJumpToPage,
                  size: buttonSize,
                  child: Icon(
                    Icons.arrow_forward,
                    size: iconSize,
                    color: TKitColors.textPrimary,
                  ),
                ),
              ],
            )
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}

/// Internal pagination button component
class _PaginationButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final double size;
  final bool isActive;

  const _PaginationButton({
    required this.onPressed,
    required this.child,
    required this.size,
    this.isActive = false,
  });

  @override
  State<_PaginationButton> createState() => _PaginationButtonState();
}

class _PaginationButtonState extends State<_PaginationButton> {
  var _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null && !widget.isActive;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Material(
        color: widget.isActive
            ? TKitColors.accent
            : (_isHovered && !isDisabled
                  ? TKitColors.surfaceVariant
                  : TKitColors.surface),
        child: InkWell(
          onTap: widget.onPressed,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.isActive ? TKitColors.accent : TKitColors.border,
              ),
            ),
            child: Center(child: widget.child),
          ),
        ),
      ),
    );
  }
}
