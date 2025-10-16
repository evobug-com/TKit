import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'unsaved_changes_notifier.g.dart';

/// State for tracking unsaved changes in settings
class UnsavedChangesState {
  final bool hasUnsavedChanges;
  final VoidCallback? onNavigationAttempt;

  const UnsavedChangesState({
    this.hasUnsavedChanges = false,
    this.onNavigationAttempt,
  });

  UnsavedChangesState copyWith({
    bool? hasUnsavedChanges,
    VoidCallback? onNavigationAttempt,
    bool clearCallback = false,
  }) {
    return UnsavedChangesState(
      hasUnsavedChanges: hasUnsavedChanges ?? this.hasUnsavedChanges,
      onNavigationAttempt: clearCallback ? null : (onNavigationAttempt ?? this.onNavigationAttempt),
    );
  }
}

/// Riverpod notifier for tracking unsaved changes in settings
/// Used to prevent navigation away from settings when there are unsaved changes
@riverpod
class UnsavedChanges extends _$UnsavedChanges {
  @override
  UnsavedChangesState build() {
    return const UnsavedChangesState();
  }

  void setHasChanges({required bool value}) {
    state = state.copyWith(hasUnsavedChanges: value);
  }

  void setOnNavigationAttempt(VoidCallback? callback) {
    if (callback == null) {
      state = state.copyWith(clearCallback: true);
    } else {
      state = state.copyWith(onNavigationAttempt: callback);
    }
  }

  void notifyNavigationAttempt() {
    state.onNavigationAttempt?.call();
  }
}
