// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unsaved_changes_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod notifier for tracking unsaved changes in settings
/// Used to prevent navigation away from settings when there are unsaved changes

@ProviderFor(UnsavedChanges)
const unsavedChangesProvider = UnsavedChangesProvider._();

/// Riverpod notifier for tracking unsaved changes in settings
/// Used to prevent navigation away from settings when there are unsaved changes
final class UnsavedChangesProvider
    extends $NotifierProvider<UnsavedChanges, UnsavedChangesState> {
  /// Riverpod notifier for tracking unsaved changes in settings
  /// Used to prevent navigation away from settings when there are unsaved changes
  const UnsavedChangesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unsavedChangesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unsavedChangesHash();

  @$internal
  @override
  UnsavedChanges create() => UnsavedChanges();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UnsavedChangesState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UnsavedChangesState>(value),
    );
  }
}

String _$unsavedChangesHash() => r'f80ff2a8a02cd60b981b2c693f0378134705f9ca';

/// Riverpod notifier for tracking unsaved changes in settings
/// Used to prevent navigation away from settings when there are unsaved changes

abstract class _$UnsavedChanges extends $Notifier<UnsavedChangesState> {
  UnsavedChangesState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<UnsavedChangesState, UnsavedChangesState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UnsavedChangesState, UnsavedChangesState>,
              UnsavedChangesState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
