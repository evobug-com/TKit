// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_switcher_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(autoSwitcherRepository)
const autoSwitcherRepositoryProvider = AutoSwitcherRepositoryProvider._();

final class AutoSwitcherRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<IAutoSwitcherRepository>,
          IAutoSwitcherRepository,
          FutureOr<IAutoSwitcherRepository>
        >
    with
        $FutureModifier<IAutoSwitcherRepository>,
        $FutureProvider<IAutoSwitcherRepository> {
  const AutoSwitcherRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'autoSwitcherRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$autoSwitcherRepositoryHash();

  @$internal
  @override
  $FutureProviderElement<IAutoSwitcherRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<IAutoSwitcherRepository> create(Ref ref) {
    return autoSwitcherRepository(ref);
  }
}

String _$autoSwitcherRepositoryHash() =>
    r'315e26b1452af2010f133d1f01541f112c257286';

@ProviderFor(getOrchestrationStatusUseCase)
const getOrchestrationStatusUseCaseProvider =
    GetOrchestrationStatusUseCaseProvider._();

final class GetOrchestrationStatusUseCaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<GetOrchestrationStatusUseCase>,
          GetOrchestrationStatusUseCase,
          FutureOr<GetOrchestrationStatusUseCase>
        >
    with
        $FutureModifier<GetOrchestrationStatusUseCase>,
        $FutureProvider<GetOrchestrationStatusUseCase> {
  const GetOrchestrationStatusUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getOrchestrationStatusUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getOrchestrationStatusUseCaseHash();

  @$internal
  @override
  $FutureProviderElement<GetOrchestrationStatusUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GetOrchestrationStatusUseCase> create(Ref ref) {
    return getOrchestrationStatusUseCase(ref);
  }
}

String _$getOrchestrationStatusUseCaseHash() =>
    r'2ad7ba762ab702caa17a4ddc0c92a7944953275b';

@ProviderFor(getUpdateHistoryUseCase)
const getUpdateHistoryUseCaseProvider = GetUpdateHistoryUseCaseProvider._();

final class GetUpdateHistoryUseCaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<GetUpdateHistoryUseCase>,
          GetUpdateHistoryUseCase,
          FutureOr<GetUpdateHistoryUseCase>
        >
    with
        $FutureModifier<GetUpdateHistoryUseCase>,
        $FutureProvider<GetUpdateHistoryUseCase> {
  const GetUpdateHistoryUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getUpdateHistoryUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getUpdateHistoryUseCaseHash();

  @$internal
  @override
  $FutureProviderElement<GetUpdateHistoryUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GetUpdateHistoryUseCase> create(Ref ref) {
    return getUpdateHistoryUseCase(ref);
  }
}

String _$getUpdateHistoryUseCaseHash() =>
    r'c67fbf81a944f15bdcb99fb119821ae554ff54de';

@ProviderFor(manualUpdateUseCase)
const manualUpdateUseCaseProvider = ManualUpdateUseCaseProvider._();

final class ManualUpdateUseCaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<ManualUpdateUseCase>,
          ManualUpdateUseCase,
          FutureOr<ManualUpdateUseCase>
        >
    with
        $FutureModifier<ManualUpdateUseCase>,
        $FutureProvider<ManualUpdateUseCase> {
  const ManualUpdateUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'manualUpdateUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$manualUpdateUseCaseHash();

  @$internal
  @override
  $FutureProviderElement<ManualUpdateUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ManualUpdateUseCase> create(Ref ref) {
    return manualUpdateUseCase(ref);
  }
}

String _$manualUpdateUseCaseHash() =>
    r'4f9f39700db7b0ce4fc1b616c1b0217bc773855e';

@ProviderFor(startMonitoringUseCase)
const startMonitoringUseCaseProvider = StartMonitoringUseCaseProvider._();

final class StartMonitoringUseCaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<StartMonitoringUseCase>,
          StartMonitoringUseCase,
          FutureOr<StartMonitoringUseCase>
        >
    with
        $FutureModifier<StartMonitoringUseCase>,
        $FutureProvider<StartMonitoringUseCase> {
  const StartMonitoringUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'startMonitoringUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$startMonitoringUseCaseHash();

  @$internal
  @override
  $FutureProviderElement<StartMonitoringUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<StartMonitoringUseCase> create(Ref ref) {
    return startMonitoringUseCase(ref);
  }
}

String _$startMonitoringUseCaseHash() =>
    r'71b9f3c2187416833e91f2ea2eed7bd68a7a1116';

@ProviderFor(stopMonitoringUseCase)
const stopMonitoringUseCaseProvider = StopMonitoringUseCaseProvider._();

final class StopMonitoringUseCaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<StopMonitoringUseCase>,
          StopMonitoringUseCase,
          FutureOr<StopMonitoringUseCase>
        >
    with
        $FutureModifier<StopMonitoringUseCase>,
        $FutureProvider<StopMonitoringUseCase> {
  const StopMonitoringUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stopMonitoringUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stopMonitoringUseCaseHash();

  @$internal
  @override
  $FutureProviderElement<StopMonitoringUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<StopMonitoringUseCase> create(Ref ref) {
    return stopMonitoringUseCase(ref);
  }
}

String _$stopMonitoringUseCaseHash() =>
    r'568191e2ecac1affe0f66ab4301ca5452df502cc';

@ProviderFor(AutoSwitcher)
const autoSwitcherProvider = AutoSwitcherProvider._();

final class AutoSwitcherProvider
    extends $AsyncNotifierProvider<AutoSwitcher, AutoSwitcherState> {
  const AutoSwitcherProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'autoSwitcherProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$autoSwitcherHash();

  @$internal
  @override
  AutoSwitcher create() => AutoSwitcher();
}

String _$autoSwitcherHash() => r'dc28ead920ba062df8b2e61beb2d8d1c64b4cb6b';

abstract class _$AutoSwitcher extends $AsyncNotifier<AutoSwitcherState> {
  FutureOr<AutoSwitcherState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<AutoSwitcherState>, AutoSwitcherState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AutoSwitcherState>, AutoSwitcherState>,
              AsyncValue<AutoSwitcherState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
