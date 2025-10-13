import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:tkit/l10n/app_localizations.dart';
import '../../../../shared/widgets/hotkey_display.dart';
import '../../../../shared/widgets/buttons/accent_button.dart';

/// Widget for recording and displaying keyboard shortcuts
class HotkeyInput extends StatefulWidget {
  final String label;
  final String? description;
  final String? currentHotkey;
  final ValueChanged<String?> onChanged;

  const HotkeyInput({
    super.key,
    required this.label,
    this.description,
    this.currentHotkey,
    required this.onChanged,
  });

  @override
  State<HotkeyInput> createState() => _HotkeyInputState();
}

class _HotkeyInputState extends State<HotkeyInput> {
  bool _isRecording = false;

  void _startRecording() {
    setState(() {
      _isRecording = true;
    });
  }

  void _stopRecording() {
    setState(() {
      _isRecording = false;
    });
  }

  void _handleHotKeyRecorded(HotKey hotKey) {
    // Ignore if it's only a modifier key without an actual key
    if (_isModifierKey(hotKey.key)) {
      return;
    }

    // Convert HotKey to string format
    final hotkeyString = _hotKeyToString(hotKey);
    widget.onChanged(hotkeyString);

    // Stop recording after capturing the hotkey
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _stopRecording();
      }
    });
  }

  bool _isModifierKey(KeyboardKey key) {
    if (key is! PhysicalKeyboardKey) return false;

    // Check if the key is a modifier key
    return key == PhysicalKeyboardKey.controlLeft ||
        key == PhysicalKeyboardKey.controlRight ||
        key == PhysicalKeyboardKey.altLeft ||
        key == PhysicalKeyboardKey.altRight ||
        key == PhysicalKeyboardKey.shiftLeft ||
        key == PhysicalKeyboardKey.shiftRight ||
        key == PhysicalKeyboardKey.metaLeft ||
        key == PhysicalKeyboardKey.metaRight;
  }

  String _hotKeyToString(HotKey hotKey) {
    final parts = <String>[];

    // Add modifiers in order
    if (hotKey.modifiers?.contains(HotKeyModifier.control) == true) {
      parts.add('ctrl');
    }
    if (hotKey.modifiers?.contains(HotKeyModifier.alt) == true) {
      parts.add('alt');
    }
    if (hotKey.modifiers?.contains(HotKeyModifier.shift) == true) {
      parts.add('shift');
    }
    if (hotKey.modifiers?.contains(HotKeyModifier.meta) == true) {
      parts.add('win');
    }

    // Add the main key
    parts.add(_physicalKeyToString(hotKey.key));

    return parts.join('+');
  }

  String _physicalKeyToString(KeyboardKey key) {
    // Try to get PhysicalKeyboardKey
    if (key is PhysicalKeyboardKey) {
      // Function keys
      if (key == PhysicalKeyboardKey.f1) return 'f1';
      if (key == PhysicalKeyboardKey.f2) return 'f2';
      if (key == PhysicalKeyboardKey.f3) return 'f3';
      if (key == PhysicalKeyboardKey.f4) return 'f4';
      if (key == PhysicalKeyboardKey.f5) return 'f5';
      if (key == PhysicalKeyboardKey.f6) return 'f6';
      if (key == PhysicalKeyboardKey.f7) return 'f7';
      if (key == PhysicalKeyboardKey.f8) return 'f8';
      if (key == PhysicalKeyboardKey.f9) return 'f9';
      if (key == PhysicalKeyboardKey.f10) return 'f10';
      if (key == PhysicalKeyboardKey.f11) return 'f11';
      if (key == PhysicalKeyboardKey.f12) return 'f12';

      // Letter keys
      if (key == PhysicalKeyboardKey.keyA) return 'a';
      if (key == PhysicalKeyboardKey.keyB) return 'b';
      if (key == PhysicalKeyboardKey.keyC) return 'c';
      if (key == PhysicalKeyboardKey.keyD) return 'd';
      if (key == PhysicalKeyboardKey.keyE) return 'e';
      if (key == PhysicalKeyboardKey.keyF) return 'f';
      if (key == PhysicalKeyboardKey.keyG) return 'g';
      if (key == PhysicalKeyboardKey.keyH) return 'h';
      if (key == PhysicalKeyboardKey.keyI) return 'i';
      if (key == PhysicalKeyboardKey.keyJ) return 'j';
      if (key == PhysicalKeyboardKey.keyK) return 'k';
      if (key == PhysicalKeyboardKey.keyL) return 'l';
      if (key == PhysicalKeyboardKey.keyM) return 'm';
      if (key == PhysicalKeyboardKey.keyN) return 'n';
      if (key == PhysicalKeyboardKey.keyO) return 'o';
      if (key == PhysicalKeyboardKey.keyP) return 'p';
      if (key == PhysicalKeyboardKey.keyQ) return 'q';
      if (key == PhysicalKeyboardKey.keyR) return 'r';
      if (key == PhysicalKeyboardKey.keyS) return 's';
      if (key == PhysicalKeyboardKey.keyT) return 't';
      if (key == PhysicalKeyboardKey.keyU) return 'u';
      if (key == PhysicalKeyboardKey.keyV) return 'v';
      if (key == PhysicalKeyboardKey.keyW) return 'w';
      if (key == PhysicalKeyboardKey.keyX) return 'x';
      if (key == PhysicalKeyboardKey.keyY) return 'y';
      if (key == PhysicalKeyboardKey.keyZ) return 'z';

      // Special keys
      if (key == PhysicalKeyboardKey.space) return 'space';
      if (key == PhysicalKeyboardKey.enter) return 'enter';
      if (key == PhysicalKeyboardKey.tab) return 'tab';
      if (key == PhysicalKeyboardKey.backspace) return 'backspace';
      if (key == PhysicalKeyboardKey.delete) return 'delete';
      if (key == PhysicalKeyboardKey.escape) return 'escape';
      if (key == PhysicalKeyboardKey.home) return 'home';
      if (key == PhysicalKeyboardKey.end) return 'end';
      if (key == PhysicalKeyboardKey.pageUp) return 'pageup';
      if (key == PhysicalKeyboardKey.pageDown) return 'pagedown';
      if (key == PhysicalKeyboardKey.arrowUp) return 'up';
      if (key == PhysicalKeyboardKey.arrowDown) return 'down';
      if (key == PhysicalKeyboardKey.arrowLeft) return 'left';
      if (key == PhysicalKeyboardKey.arrowRight) return 'right';

      // Default: return the debug label
      return key.debugName?.toLowerCase() ?? 'unknown';
    }

    // Try to get string representation
    return 'unknown';
  }

  void _clearHotkey() {
    widget.onChanged(null);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (widget.description != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      widget.description!,
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Display current or recording state
            if (_isRecording) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: theme.colorScheme.primary,
                    width: 2,
                  ),
                ),
                child: SizedBox(
                  width: 180,
                  child: HotKeyRecorder(
                    onHotKeyRecorded: _handleHotKeyRecorded,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                tooltip: AppLocalizations.of(context)!.hotkeyInputCancel,
                onPressed: _stopRecording,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
              ),
            ] else if (widget.currentHotkey != null && widget.currentHotkey!.isNotEmpty) ...[
              HotkeyDisplay(hotkeyString: widget.currentHotkey!),
              const SizedBox(width: 6),
              AccentButton(
                text: AppLocalizations.of(context)!.hotkeyInputChange,
                onPressed: _startRecording,
                width: 80,
              ),
              const SizedBox(width: 4),
              IconButton(
                icon: const Icon(Icons.clear, size: 18),
                tooltip: AppLocalizations.of(context)!.hotkeyInputClearHotkey,
                onPressed: _clearHotkey,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 28,
                  minHeight: 28,
                ),
              ),
            ] else ...[
              AccentButton(
                text: AppLocalizations.of(context)!.hotkeyInputSetHotkey,
                icon: Icons.keyboard,
                onPressed: _startRecording,
                width: 120,
              ),
            ],
          ],
        ),
      ],
    );
  }
}
