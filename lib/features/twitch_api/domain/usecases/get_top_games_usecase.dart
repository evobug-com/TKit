import 'package:dartz/dartz.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/twitch_api/domain/entities/twitch_category.dart';
import 'package:tkit/features/twitch_api/domain/repositories/i_twitch_api_repository.dart';

/// Use case for fetching top games on Twitch
///
/// Retrieves the most popular games currently being streamed on Twitch.
/// Useful for pre-populating category mappings and showing popular games.
class GetTopGamesUseCase {
  final ITwitchApiRepository repository;

  GetTopGamesUseCase(this.repository);

  /// Execute the use case
  ///
  /// [first] - Number of games to fetch (1-100, default: 20)
  /// [after] - Pagination cursor for next page (optional)
  ///
  /// Returns list of top games or failure
  Future<Either<Failure, List<TwitchCategory>>> call({
    int first = 20,
    String? after,
  }) async {
    // Validation
    if (first < 1 || first > 100) {
      return const Left(
        ValidationFailure(message: 'first parameter must be between 1 and 100'),
      );
    }

    return await repository.getTopGames(first: first, after: after);
  }
}
