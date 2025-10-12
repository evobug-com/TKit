import 'package:flutter/foundation.dart';

/// Notifier for tracking unsaved changes in settings
/// Used to prevent navigation away from settings when there are unsaved changes
class UnsavedChangesNotifier extends ChangeNotifier {
  bool _hasUnsavedChanges = false;
  VoidCallback? _onNavigationAttempt;

  bool get hasUnsavedChanges => _hasUnsavedChanges;

  void setHasChanges(bool value) {
    if (_hasUnsavedChanges != value) {
      _hasUnsavedChanges = value;
      notifyListeners();
    }
  }

  void setOnNavigationAttempt(VoidCallback? callback) {
    _onNavigationAttempt = callback;
  }

  void notifyNavigationAttempt() {
    _onNavigationAttempt?.call();
  }
}
