// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'window_controls_preview_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for previewing window controls position changes before saving
/// This allows the UI to update immediately while keeping the actual setting unsaved

@ProviderFor(WindowControlsPreview)
const windowControlsPreviewProvider = WindowControlsPreviewProvider._();

/// Provider for previewing window controls position changes before saving
/// This allows the UI to update immediately while keeping the actual setting unsaved
final class WindowControlsPreviewProvider
    extends $NotifierProvider<WindowControlsPreview, WindowControlsPosition?> {
  /// Provider for previewing window controls position changes before saving
  /// This allows the UI to update immediately while keeping the actual setting unsaved
  const WindowControlsPreviewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'windowControlsPreviewProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$windowControlsPreviewHash();

  @$internal
  @override
  WindowControlsPreview create() => WindowControlsPreview();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WindowControlsPosition? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WindowControlsPosition?>(value),
    );
  }
}

String _$windowControlsPreviewHash() =>
    r'107020dbdf78c9c33c618c2251aa8dec9753a8a7';

/// Provider for previewing window controls position changes before saving
/// This allows the UI to update immediately while keeping the actual setting unsaved

abstract class _$WindowControlsPreview
    extends $Notifier<WindowControlsPosition?> {
  WindowControlsPosition? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<WindowControlsPosition?, WindowControlsPosition?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<WindowControlsPosition?, WindowControlsPosition?>,
              WindowControlsPosition?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
