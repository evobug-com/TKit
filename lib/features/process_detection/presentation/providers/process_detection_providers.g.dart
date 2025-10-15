// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'process_detection_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(processDetectionRepository)
const processDetectionRepositoryProvider =
    ProcessDetectionRepositoryProvider._();

final class ProcessDetectionRepositoryProvider
    extends
        $FunctionalProvider<
          IProcessDetectionRepository,
          IProcessDetectionRepository,
          IProcessDetectionRepository
        >
    with $Provider<IProcessDetectionRepository> {
  const ProcessDetectionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'processDetectionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$processDetectionRepositoryHash();

  @$internal
  @override
  $ProviderElement<IProcessDetectionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IProcessDetectionRepository create(Ref ref) {
    return processDetectionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IProcessDetectionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IProcessDetectionRepository>(value),
    );
  }
}

String _$processDetectionRepositoryHash() =>
    r'db6dfcfa6f50743dfd63364dfd0a42ae90196221';

@ProviderFor(getFocusedProcessUseCase)
const getFocusedProcessUseCaseProvider = GetFocusedProcessUseCaseProvider._();

final class GetFocusedProcessUseCaseProvider
    extends
        $FunctionalProvider<
          GetFocusedProcessUseCase,
          GetFocusedProcessUseCase,
          GetFocusedProcessUseCase
        >
    with $Provider<GetFocusedProcessUseCase> {
  const GetFocusedProcessUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getFocusedProcessUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getFocusedProcessUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetFocusedProcessUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetFocusedProcessUseCase create(Ref ref) {
    return getFocusedProcessUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetFocusedProcessUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetFocusedProcessUseCase>(value),
    );
  }
}

String _$getFocusedProcessUseCaseHash() =>
    r'ffe29ef832be4936be383f83e0009fc4dea1ba5c';

@ProviderFor(watchProcessChangesUseCase)
const watchProcessChangesUseCaseProvider =
    WatchProcessChangesUseCaseProvider._();

final class WatchProcessChangesUseCaseProvider
    extends
        $FunctionalProvider<
          WatchProcessChangesUseCase,
          WatchProcessChangesUseCase,
          WatchProcessChangesUseCase
        >
    with $Provider<WatchProcessChangesUseCase> {
  const WatchProcessChangesUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchProcessChangesUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchProcessChangesUseCaseHash();

  @$internal
  @override
  $ProviderElement<WatchProcessChangesUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WatchProcessChangesUseCase create(Ref ref) {
    return watchProcessChangesUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WatchProcessChangesUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WatchProcessChangesUseCase>(value),
    );
  }
}

String _$watchProcessChangesUseCaseHash() =>
    r'0da26b1f2c8eb3e358455c1eb83f78d32a74a436';
