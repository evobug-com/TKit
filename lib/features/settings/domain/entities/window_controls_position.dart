import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/widgets.dart';
import 'package:tkit/l10n/app_localizations.dart';

/// Window controls position enum
@JsonEnum(valueField: 'value')
enum WindowControlsPosition {
  /// Window controls on the left side
  left('left'),

  /// Window controls in the center
  center('center'),

  /// Window controls on the right side (default)
  right('right');

  const WindowControlsPosition(this.value);

  final String value;

  /// Get display name for UI
  String get displayName {
    switch (this) {
      case WindowControlsPosition.left:
        return 'Left';
      case WindowControlsPosition.center:
        return 'Center';
      case WindowControlsPosition.right:
        return 'Right';
    }
  }

  /// Parse from string value
  static WindowControlsPosition fromString(String value) {
    return WindowControlsPosition.values.firstWhere(
      (position) => position.value == value,
      orElse: () => WindowControlsPosition.right,
    );
  }
}

/// Extension for localized WindowControlsPosition strings
extension WindowControlsPositionLocalization on WindowControlsPosition {
  /// Get localized display name
  String localizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case WindowControlsPosition.left:
        return l10n.windowControlsPositionLeft;
      case WindowControlsPosition.center:
        return l10n.windowControlsPositionCenter;
      case WindowControlsPosition.right:
        return l10n.windowControlsPositionRight;
    }
  }
}
