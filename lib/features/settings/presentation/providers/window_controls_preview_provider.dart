import 'package:flutter/foundation.dart';
import 'package:tkit/features/settings/domain/entities/window_controls_position.dart';

/// Provider for previewing window controls position changes before saving
/// This allows the UI to update immediately while keeping the actual setting unsaved
class WindowControlsPreviewProvider extends ChangeNotifier {
  WindowControlsPosition? _previewPosition;

  WindowControlsPosition? get previewPosition => _previewPosition;

  /// Set a preview position (not saved to database)
  void setPreviewPosition(WindowControlsPosition position) {
    _previewPosition = position;
    notifyListeners();
  }

  /// Clear the preview position (used after save or discard)
  void clearPreview() {
    _previewPosition = null;
    notifyListeners();
  }
}
