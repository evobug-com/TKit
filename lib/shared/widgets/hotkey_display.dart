import 'package:flutter/material.dart';

/// Widget that displays a keyboard shortcut in a visually appealing way
///
/// Parses a hotkey string (e.g., "ctrl+alt+f1") and displays each key
/// in a styled container resembling a keyboard key
class HotkeyDisplay extends StatelessWidget {
  final String hotkeyString;
  final double keySize;
  final double fontSize;
  final Color? keyColor;
  final Color? textColor;

  const HotkeyDisplay({
    super.key,
    required this.hotkeyString,
    this.keySize = 32,
    this.fontSize = 12,
    this.keyColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final parts = hotkeyString.split('+');
    final keys = parts.map((part) => part.trim()).toList();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < keys.length; i++) ...[
          _KeyCap(
            label: _formatKeyLabel(keys[i]),
            size: keySize,
            fontSize: fontSize,
            keyColor: keyColor,
            textColor: textColor,
          ),
          if (i < keys.length - 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                '+',
                style: TextStyle(
                  fontSize: fontSize,
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ],
    );
  }

  String _formatKeyLabel(String key) {
    final lower = key.toLowerCase();

    // Format modifier keys
    if (lower == 'ctrl' || lower == 'control') {
      return 'Ctrl';
    }
    if (lower == 'alt') {
      return 'Alt';
    }
    if (lower == 'shift') {
      return 'Shift';
    }
    if (lower == 'meta' || lower == 'win' || lower == 'cmd') {
      return 'Win';
    }

    // Format function keys
    if (lower.startsWith('f') && lower.length > 1) {
      return lower.toUpperCase();
    }

    // Format special keys
    if (lower == 'space') {
      return 'Space';
    }
    if (lower == 'enter') {
      return 'Enter';
    }
    if (lower == 'tab') {
      return 'Tab';
    }
    if (lower == 'backspace') {
      return 'Bksp';
    }
    if (lower == 'delete') {
      return 'Del';
    }
    if (lower == 'escape') {
      return 'Esc';
    }
    if (lower == 'home') {
      return 'Home';
    }
    if (lower == 'end') {
      return 'End';
    }
    if (lower == 'pageup') {
      return 'PgUp';
    }
    if (lower == 'pagedown') {
      return 'PgDn';
    }
    if (lower == 'up') {
      return '↑';
    }
    if (lower == 'down') {
      return '↓';
    }
    if (lower == 'left') {
      return '←';
    }
    if (lower == 'right') {
      return '→';
    }

    // Capitalize single letters
    return key.toUpperCase();
  }
}

class _KeyCap extends StatelessWidget {
  final String label;
  final double size;
  final double fontSize;
  final Color? keyColor;
  final Color? textColor;

  const _KeyCap({
    required this.label,
    required this.size,
    required this.fontSize,
    this.keyColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveKeyColor =
        keyColor ?? theme.colorScheme.surfaceContainerHighest;
    final effectiveTextColor = textColor ?? theme.colorScheme.onSurface;

    return Container(
      constraints: BoxConstraints(minWidth: size, minHeight: size),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: effectiveKeyColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: effectiveTextColor,
          letterSpacing: 0.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
