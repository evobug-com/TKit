import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tkit/core/providers/datasource_providers.dart';
import 'package:tkit/core/providers/providers.dart';
import 'package:tkit/features/twitch_api/data/repositories/twitch_api_repository_impl.dart';
import 'package:tkit/features/twitch_api/domain/repositories/i_twitch_api_repository.dart';
import 'package:tkit/features/twitch_api/domain/usecases/search_categories_usecase.dart';
import 'package:tkit/features/twitch_api/domain/entities/twitch_category.dart';

part 'twitch_api_providers.g.dart';

// =============================================================================
// TWITCH API REPOSITORY
// =============================================================================

@Riverpod(keepAlive: true)
ITwitchApiRepository twitchApiRepository(Ref ref) {
  final dataSource = ref.watch(twitchApiRemoteDataSourceProvider);
  final logger = ref.watch(appLoggerProvider);
  return TwitchApiRepositoryImpl(dataSource, logger);
}

// =============================================================================
// TWITCH API USE CASES
// =============================================================================

@Riverpod(keepAlive: true)
SearchCategoriesUseCase searchCategoriesUseCase(Ref ref) {
  final repository = ref.watch(twitchApiRepositoryProvider);
  return SearchCategoriesUseCase(repository);
}

// =============================================================================
// TWITCH API STATE NOTIFIER
// =============================================================================

@Riverpod(keepAlive: true)
class TwitchApi extends _$TwitchApi {
  @override
  TwitchApiState build() {
    return const TwitchApiState();
  }

  /// Search for categories
  Future<void> searchCategories(String query, {int maxResults = 20}) async {
    final trimmedQuery = query.trim();

    // Don't search for empty queries
    if (trimmedQuery.isEmpty) {
      clearSearch();
      return;
    }

    final logger = ref.read(appLoggerProvider);
    logger.info('Searching for categories: "$trimmedQuery"');

    state = state.copyWith(
      isLoading: true,
      currentQuery: trimmedQuery,
      errorMessage: null,
    );

    final useCase = ref.read(searchCategoriesUseCaseProvider);
    final result = await useCase(trimmedQuery, first: maxResults);

    result.fold(
      (failure) {
        logger.error('Category search failed: ${failure.message}');
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
          categories: [],
        );
      },
      (categories) {
        logger.info(
          'Found ${categories.length} categories for "$trimmedQuery"',
        );
        state = state.copyWith(
          isLoading: false,
          categories: categories,
          errorMessage: null,
        );
      },
    );
  }

  /// Clear search results
  void clearSearch() {
    final logger = ref.read(appLoggerProvider);
    logger.debug('Clearing category search');
    state = const TwitchApiState();
  }

  /// Set error message manually (for pre-flight checks)
  void setError(String message) {
    final logger = ref.read(appLoggerProvider);
    logger.warning('Manual error set: $message');
    state = state.copyWith(
      isLoading: false,
      errorMessage: message,
      categories: [],
    );
  }
}

// State class for TwitchApi
class TwitchApiState {
  final bool isLoading;
  final List<TwitchCategory> categories;
  final String? errorMessage;
  final String currentQuery;

  const TwitchApiState({
    this.isLoading = false,
    this.categories = const [],
    this.errorMessage,
    this.currentQuery = '',
  });

  bool get hasSearched => currentQuery.isNotEmpty || errorMessage != null;

  TwitchApiState copyWith({
    bool? isLoading,
    List<TwitchCategory>? categories,
    String? errorMessage,
    String? currentQuery,
  }) {
    return TwitchApiState(
      isLoading: isLoading ?? this.isLoading,
      categories: categories ?? this.categories,
      errorMessage: errorMessage,
      currentQuery: currentQuery ?? this.currentQuery,
    );
  }
}
