import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tkit/features/settings/domain/entities/window_controls_position.dart';

part 'window_controls_preview_provider.g.dart';

/// Provider for previewing window controls position changes before saving
/// This allows the UI to update immediately while keeping the actual setting unsaved
@Riverpod(keepAlive: true)
class WindowControlsPreview extends _$WindowControlsPreview {
  @override
  WindowControlsPosition? build() {
    return null;
  }

  /// Set a preview position (not saved to database)
  void setPreviewPosition(WindowControlsPosition position) {
    state = position;
  }

  /// Clear the preview position (used after save or discard)
  void clearPreview() {
    state = null;
  }
}

