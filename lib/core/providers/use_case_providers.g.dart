// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'use_case_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(updateChannelCategoryUseCase)
const updateChannelCategoryUseCaseProvider =
    UpdateChannelCategoryUseCaseProvider._();

final class UpdateChannelCategoryUseCaseProvider
    extends
        $FunctionalProvider<
          UpdateChannelCategoryUseCase,
          UpdateChannelCategoryUseCase,
          UpdateChannelCategoryUseCase
        >
    with $Provider<UpdateChannelCategoryUseCase> {
  const UpdateChannelCategoryUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateChannelCategoryUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateChannelCategoryUseCaseHash();

  @$internal
  @override
  $ProviderElement<UpdateChannelCategoryUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UpdateChannelCategoryUseCase create(Ref ref) {
    return updateChannelCategoryUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateChannelCategoryUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateChannelCategoryUseCase>(value),
    );
  }
}

String _$updateChannelCategoryUseCaseHash() =>
    r'8e6d0efe66f5b50bf5815cc6584b3eb2f3ef5386';

@ProviderFor(updateLastUsedUseCase)
const updateLastUsedUseCaseProvider = UpdateLastUsedUseCaseProvider._();

final class UpdateLastUsedUseCaseProvider
    extends
        $FunctionalProvider<
          UpdateLastUsedUseCase,
          UpdateLastUsedUseCase,
          UpdateLastUsedUseCase
        >
    with $Provider<UpdateLastUsedUseCase> {
  const UpdateLastUsedUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateLastUsedUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateLastUsedUseCaseHash();

  @$internal
  @override
  $ProviderElement<UpdateLastUsedUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UpdateLastUsedUseCase create(Ref ref) {
    return updateLastUsedUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateLastUsedUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateLastUsedUseCase>(value),
    );
  }
}

String _$updateLastUsedUseCaseHash() =>
    r'5871b87476fb368217d4b7776940e49f1fd62d4b';
