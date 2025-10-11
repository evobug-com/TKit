import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/twitch_category.dart';
import '../entities/twitch_user.dart';

/// Repository interface for Twitch API operations
/// This defines the contract that the data layer must implement
abstract class ITwitchApiRepository {
  /// Search for Twitch categories by query string
  ///
  /// Returns a list of matching categories or a Failure
  /// [query] Search term (game name, category name)
  /// [first] Maximum number of results to return (default: 20, max: 100)
  Future<Either<Failure, List<TwitchCategory>>> searchCategories(
    String query, {
    int first = 20,
  });

  /// Update the current channel's category/game
  ///
  /// [categoryId] The Twitch category ID to set
  /// Returns void on success or Failure on error
  Future<Either<Failure, void>> updateChannelCategory(String categoryId);

  /// Get the current authenticated user's information
  ///
  /// Returns the TwitchUser or Failure
  Future<Either<Failure, TwitchUser>> getCurrentUser();

  /// Get category details by ID
  ///
  /// [categoryId] The Twitch category ID
  /// Returns the TwitchCategory or Failure
  Future<Either<Failure, TwitchCategory>> getCategoryById(String categoryId);

  /// Get multiple games/categories by IDs (batch lookup)
  ///
  /// [categoryIds] List of Twitch category IDs (max 100)
  /// Returns list of matching categories or Failure
  Future<Either<Failure, List<TwitchCategory>>> getGamesByIds(
    List<String> categoryIds,
  );

  /// Get multiple games/categories by names (batch lookup)
  ///
  /// [gameNames] List of game names (max 100)
  /// Returns list of matching categories or Failure
  Future<Either<Failure, List<TwitchCategory>>> getGamesByNames(
    List<String> gameNames,
  );

  /// Get top games/categories on Twitch
  ///
  /// [first] Number of results to return (1-100, default: 20)
  /// [after] Pagination cursor for next page
  /// Returns list of top games or Failure
  Future<Either<Failure, List<TwitchCategory>>> getTopGames({
    int first = 20,
    String? after,
  });
}
