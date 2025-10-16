// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'twitch_api_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(twitchApiRepository)
const twitchApiRepositoryProvider = TwitchApiRepositoryProvider._();

final class TwitchApiRepositoryProvider
    extends
        $FunctionalProvider<
          ITwitchApiRepository,
          ITwitchApiRepository,
          ITwitchApiRepository
        >
    with $Provider<ITwitchApiRepository> {
  const TwitchApiRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'twitchApiRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$twitchApiRepositoryHash();

  @$internal
  @override
  $ProviderElement<ITwitchApiRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ITwitchApiRepository create(Ref ref) {
    return twitchApiRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ITwitchApiRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ITwitchApiRepository>(value),
    );
  }
}

String _$twitchApiRepositoryHash() =>
    r'e8f8a34da4b8db0ba530b1bbb02bc5e4e31f6d5e';

@ProviderFor(searchCategoriesUseCase)
const searchCategoriesUseCaseProvider = SearchCategoriesUseCaseProvider._();

final class SearchCategoriesUseCaseProvider
    extends
        $FunctionalProvider<
          SearchCategoriesUseCase,
          SearchCategoriesUseCase,
          SearchCategoriesUseCase
        >
    with $Provider<SearchCategoriesUseCase> {
  const SearchCategoriesUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchCategoriesUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchCategoriesUseCaseHash();

  @$internal
  @override
  $ProviderElement<SearchCategoriesUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SearchCategoriesUseCase create(Ref ref) {
    return searchCategoriesUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchCategoriesUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchCategoriesUseCase>(value),
    );
  }
}

String _$searchCategoriesUseCaseHash() =>
    r'8345142b39dfce6aa4accda04f496afce4929360';

@ProviderFor(TwitchApi)
const twitchApiProvider = TwitchApiProvider._();

final class TwitchApiProvider
    extends $NotifierProvider<TwitchApi, TwitchApiState> {
  const TwitchApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'twitchApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$twitchApiHash();

  @$internal
  @override
  TwitchApi create() => TwitchApi();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TwitchApiState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TwitchApiState>(value),
    );
  }
}

String _$twitchApiHash() => r'fd3b1c0bfbe56eabfc326569f4d45b15fdf8ed00';

abstract class _$TwitchApi extends $Notifier<TwitchApiState> {
  TwitchApiState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<TwitchApiState, TwitchApiState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TwitchApiState, TwitchApiState>,
              TwitchApiState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
