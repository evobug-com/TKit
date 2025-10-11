import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/twitch_category.dart';
import '../repositories/i_twitch_api_repository.dart';

/// Use case for fetching multiple games/categories by their names
///
/// Performs batch lookup of Twitch categories using their names.
/// This is more efficient than making individual search requests.
/// Supports up to 100 names per request (Twitch API limit).
class GetGamesByNamesUseCase {
  final ITwitchApiRepository repository;

  GetGamesByNamesUseCase(this.repository);

  /// Execute the use case
  ///
  /// [gameNames] - List of game names to fetch (max 100)
  ///
  /// Returns list of matching categories or failure
  Future<Either<Failure, List<TwitchCategory>>> call(
    List<String> gameNames,
  ) async {
    // Validation
    if (gameNames.isEmpty) {
      return Left(
        ValidationFailure(message: 'Game names list cannot be empty'),
      );
    }

    if (gameNames.length > 100) {
      return Left(
        ValidationFailure(
          message: 'Maximum 100 game names allowed per request',
        ),
      );
    }

    // Remove duplicates and empty strings, trim whitespace
    final cleanedNames = gameNames
        .map((name) => name.trim())
        .where((name) => name.isNotEmpty)
        .toSet()
        .toList();

    if (cleanedNames.isEmpty) {
      return Left(
        ValidationFailure(message: 'No valid game names provided'),
      );
    }

    return await repository.getGamesByNames(cleanedNames);
  }
}
