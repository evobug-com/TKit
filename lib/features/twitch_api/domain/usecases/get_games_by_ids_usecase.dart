import 'package:dartz/dartz.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/twitch_api/domain/entities/twitch_category.dart';
import 'package:tkit/features/twitch_api/domain/repositories/i_twitch_api_repository.dart';

/// Use case for fetching multiple games/categories by their IDs
///
/// Performs batch lookup of Twitch categories using their IDs.
/// This is more efficient than making individual requests.
/// Supports up to 100 IDs per request (Twitch API limit).
class GetGamesByIdsUseCase {
  final ITwitchApiRepository repository;

  GetGamesByIdsUseCase(this.repository);

  /// Execute the use case
  ///
  /// [categoryIds] - List of Twitch category IDs to fetch (max 100)
  ///
  /// Returns list of matching categories or failure
  Future<Either<Failure, List<TwitchCategory>>> call(
    List<String> categoryIds,
  ) async {
    // Validation
    if (categoryIds.isEmpty) {
      return const Left(
        ValidationFailure(message: 'Category IDs list cannot be empty'),
      );
    }

    if (categoryIds.length > 100) {
      return const Left(
        ValidationFailure(
          message: 'Maximum 100 category IDs allowed per request',
        ),
      );
    }

    // Remove duplicates and empty strings
    final cleanedIds = categoryIds
        .where((id) => id.trim().isNotEmpty)
        .toSet()
        .toList();

    if (cleanedIds.isEmpty) {
      return const Left(
        ValidationFailure(message: 'No valid category IDs provided'),
      );
    }

    return await repository.getGamesByIds(cleanedIds);
  }
}
