import 'package:flutter/material.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/theme/text_styles.dart';

/// SplitButtonAction - Action item for the dropdown menu
class SplitButtonAction {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final bool isDanger;

  const SplitButtonAction({
    required this.label,
    this.icon,
    required this.onPressed,
    this.isDanger = false,
  });
}

/// SplitButton - Button with dropdown for additional options
/// Primary action + dropdown menu with additional actions
class SplitButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final List<SplitButtonAction> actions;
  final IconData? icon;
  final bool isLoading;
  final double? height;

  const SplitButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.actions,
    this.icon,
    this.isLoading = false,
    this.height,
  });

  @override
  State<SplitButton> createState() => _SplitButtonState();
}

class _SplitButtonState extends State<SplitButton> {
  final GlobalKey _buttonKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  void _showDropdown() {
    final renderBox =
        _buttonKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => _DropdownOverlay(
        offset: offset,
        buttonWidth: size.width,
        buttonHeight: size.height,
        actions: widget.actions,
        onClose: _hideDropdown,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _hideDropdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      key: _buttonKey,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Primary button
        SizedBox(
          height: widget.height ?? 32,
          child: ElevatedButton(
            onPressed: widget.isLoading ? null : widget.onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: TKitColors.accent,
              foregroundColor: TKitColors.textPrimary,
              disabledBackgroundColor: TKitColors.surfaceVariant,
              disabledForegroundColor: TKitColors.textDisabled,
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 0,
              ),
              minimumSize: const Size(0, 32),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: widget.isLoading
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        TKitColors.textPrimary,
                      ),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(widget.icon, size: 14),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        widget.text,
                        style: TKitTextStyles.buttonSmall,
                      ),
                    ],
                  ),
          ),
        ),

        // Divider
        Container(
          width: 1,
          height: widget.height ?? 32,
          color: TKitColors.border,
        ),

        // Dropdown button
        SizedBox(
          height: widget.height ?? 32,
          width: 32,
          child: ElevatedButton(
            onPressed: widget.isLoading ? null : _showDropdown,
            style: ElevatedButton.styleFrom(
              backgroundColor: TKitColors.accent,
              foregroundColor: TKitColors.textPrimary,
              disabledBackgroundColor: TKitColors.surfaceVariant,
              disabledForegroundColor: TKitColors.textDisabled,
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              padding: EdgeInsets.zero,
              minimumSize: const Size(32, 32),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Icon(
              Icons.keyboard_arrow_down,
              size: 16,
            ),
          ),
        ),
      ],
    );
  }
}

/// Dropdown overlay for split button actions
class _DropdownOverlay extends StatelessWidget {
  final Offset offset;
  final double buttonWidth;
  final double buttonHeight;
  final List<SplitButtonAction> actions;
  final VoidCallback onClose;

  const _DropdownOverlay({
    required this.offset,
    required this.buttonWidth,
    required this.buttonHeight,
    required this.actions,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onClose,
      child: Stack(
        children: [
          Positioned(
            left: offset.dx,
            top: offset.dy + buttonHeight + 4,
            child: Material(
              color: TKitColors.surface,
              elevation: 8,
              child: Container(
                width: buttonWidth,
                decoration: BoxDecoration(
                  color: TKitColors.surface,
                  border: Border.all(
                    color: TKitColors.border,
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: actions.map((action) {
                    return InkWell(
                      onTap: () {
                        onClose();
                        action.onPressed();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: TKitSpacing.md,
                          vertical: TKitSpacing.sm,
                        ),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: TKitColors.borderSubtle,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            if (action.icon != null) ...[
                              Icon(
                                action.icon,
                                size: 14,
                                color: action.isDanger
                                    ? TKitColors.error
                                    : TKitColors.textSecondary,
                              ),
                              const SizedBox(width: TKitSpacing.sm),
                            ],
                            Expanded(
                              child: Text(
                                action.label,
                                style: TKitTextStyles.bodySmall.copyWith(
                                  color: action.isDanger
                                      ? TKitColors.error
                                      : TKitColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
