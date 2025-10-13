import 'package:dartz/dartz.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/twitch_api/domain/entities/twitch_category.dart';
import 'package:tkit/features/twitch_api/domain/repositories/i_twitch_api_repository.dart';

/// Use case for searching Twitch categories
/// Encapsulates the business logic for category search
class SearchCategoriesUseCase {
  final ITwitchApiRepository _repository;

  SearchCategoriesUseCase(this._repository);

  /// Execute the category search
  ///
  /// [query] Search term for categories
  /// [first] Maximum number of results (default: 20)
  /// Returns a list of matching categories or Failure
  Future<Either<Failure, List<TwitchCategory>>> call(
    String query, {
    int first = 20,
  }) async {
    // Validate input
    if (query.trim().isEmpty) {
      return const Left(
        ValidationFailure(
          message: 'Search query cannot be empty',
          code: 'EMPTY_QUERY',
        ),
      );
    }

    if (first < 1 || first > 100) {
      return const Left(
        ValidationFailure(
          message: 'Result count must be between 1 and 100',
          code: 'INVALID_RESULT_COUNT',
        ),
      );
    }

    return await _repository.searchCategories(query.trim(), first: first);
  }
}
