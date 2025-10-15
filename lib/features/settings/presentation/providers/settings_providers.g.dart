// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(settingsRepository)
const settingsRepositoryProvider = SettingsRepositoryProvider._();

final class SettingsRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<ISettingsRepository>,
          ISettingsRepository,
          FutureOr<ISettingsRepository>
        >
    with
        $FutureModifier<ISettingsRepository>,
        $FutureProvider<ISettingsRepository> {
  const SettingsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsRepositoryHash();

  @$internal
  @override
  $FutureProviderElement<ISettingsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ISettingsRepository> create(Ref ref) {
    return settingsRepository(ref);
  }
}

String _$settingsRepositoryHash() =>
    r'b5b60af526c734633ea9509fa9d7493a4c040926';

@ProviderFor(getSettingsUseCase)
const getSettingsUseCaseProvider = GetSettingsUseCaseProvider._();

final class GetSettingsUseCaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<GetSettingsUseCase>,
          GetSettingsUseCase,
          FutureOr<GetSettingsUseCase>
        >
    with
        $FutureModifier<GetSettingsUseCase>,
        $FutureProvider<GetSettingsUseCase> {
  const GetSettingsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getSettingsUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getSettingsUseCaseHash();

  @$internal
  @override
  $FutureProviderElement<GetSettingsUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GetSettingsUseCase> create(Ref ref) {
    return getSettingsUseCase(ref);
  }
}

String _$getSettingsUseCaseHash() =>
    r'ff8a1bd33059d43ac64f82cc0263dec60eb7f533';

@ProviderFor(updateSettingsUseCase)
const updateSettingsUseCaseProvider = UpdateSettingsUseCaseProvider._();

final class UpdateSettingsUseCaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<UpdateSettingsUseCase>,
          UpdateSettingsUseCase,
          FutureOr<UpdateSettingsUseCase>
        >
    with
        $FutureModifier<UpdateSettingsUseCase>,
        $FutureProvider<UpdateSettingsUseCase> {
  const UpdateSettingsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateSettingsUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateSettingsUseCaseHash();

  @$internal
  @override
  $FutureProviderElement<UpdateSettingsUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<UpdateSettingsUseCase> create(Ref ref) {
    return updateSettingsUseCase(ref);
  }
}

String _$updateSettingsUseCaseHash() =>
    r'49cee34449aaf20c6d35c29218a97a7cf8fc9050';

@ProviderFor(watchSettingsUseCase)
const watchSettingsUseCaseProvider = WatchSettingsUseCaseProvider._();

final class WatchSettingsUseCaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<WatchSettingsUseCase>,
          WatchSettingsUseCase,
          FutureOr<WatchSettingsUseCase>
        >
    with
        $FutureModifier<WatchSettingsUseCase>,
        $FutureProvider<WatchSettingsUseCase> {
  const WatchSettingsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchSettingsUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchSettingsUseCaseHash();

  @$internal
  @override
  $FutureProviderElement<WatchSettingsUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<WatchSettingsUseCase> create(Ref ref) {
    return watchSettingsUseCase(ref);
  }
}

String _$watchSettingsUseCaseHash() =>
    r'bd1d1bc0fd2bfcf9a2de574db5482b7ec7e03f27';

@ProviderFor(factoryResetUseCase)
const factoryResetUseCaseProvider = FactoryResetUseCaseProvider._();

final class FactoryResetUseCaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<FactoryResetUseCase>,
          FactoryResetUseCase,
          FutureOr<FactoryResetUseCase>
        >
    with
        $FutureModifier<FactoryResetUseCase>,
        $FutureProvider<FactoryResetUseCase> {
  const FactoryResetUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'factoryResetUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$factoryResetUseCaseHash();

  @$internal
  @override
  $FutureProviderElement<FactoryResetUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<FactoryResetUseCase> create(Ref ref) {
    return factoryResetUseCase(ref);
  }
}

String _$factoryResetUseCaseHash() =>
    r'abe92be7ec5649baf701481bcbb8d59813177c90';

@ProviderFor(Settings)
const settingsProvider = SettingsProvider._();

final class SettingsProvider
    extends $NotifierProvider<Settings, SettingsState> {
  const SettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsHash();

  @$internal
  @override
  Settings create() => Settings();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsState>(value),
    );
  }
}

String _$settingsHash() => r'39949f82902078af65d1e9650c4e17b0b31b58fc';

abstract class _$Settings extends $Notifier<SettingsState> {
  SettingsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SettingsState, SettingsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SettingsState, SettingsState>,
              SettingsState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
