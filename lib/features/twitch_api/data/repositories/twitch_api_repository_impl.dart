import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/twitch_category.dart';
import '../../domain/entities/twitch_user.dart';
import '../../domain/repositories/i_twitch_api_repository.dart';
import '../datasources/twitch_api_remote_datasource.dart';

/// Implementation of ITwitchApiRepository
/// Coordinates between data sources and handles error conversion
class TwitchApiRepositoryImpl implements ITwitchApiRepository {
  final TwitchApiRemoteDataSource _remoteDataSource;
  final AppLogger _logger;

  // Cache for current user to avoid repeated API calls
  TwitchUser? _cachedUser;
  DateTime? _userCacheTime;
  static const _userCacheDuration = Duration(minutes: 5);

  TwitchApiRepositoryImpl(this._remoteDataSource, this._logger);

  /// Set the token provider for the remote data source
  /// This should be called by the auth module when token is available
  void setTokenProvider(String? Function() provider) {
    _remoteDataSource.setTokenProvider(provider);
  }

  /// Set the refresh token callback for the remote data source
  /// This should be called during initialization to enable automatic
  /// token refresh on 401 errors
  void setRefreshTokenCallback(Future<String?> Function() callback) {
    _remoteDataSource.setRefreshTokenCallback(callback);
  }

  @override
  Future<Either<Failure, List<TwitchCategory>>> searchCategories(
    String query, {
    int first = 20,
  }) async {
    try {
      _logger.info('Searching categories: query="$query", first=$first');
      final models = await _remoteDataSource.searchCategories(
        query,
        first: first,
      );
      final entities = models.map((model) => model.toEntity()).toList();
      _logger.info('Found ${entities.length} categories');
      return Right(entities);
    } on ServerException catch (e) {
      _logger.error('Server error searching categories', e);
      return Left(
        ServerFailure(message: e.message, code: e.code, originalError: e),
      );
    } on NetworkException catch (e) {
      _logger.error('Network error searching categories', e);
      return Left(NetworkFailure(message: e.message, originalError: e));
    } on AuthException catch (e) {
      _logger.error('Auth error searching categories', e);
      return Left(
        AuthFailure(message: e.message, code: e.code, originalError: e),
      );
    } catch (e) {
      _logger.error('Unknown error searching categories', e);
      return Left(
        UnknownFailure(
          message: 'Failed to search categories: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateChannelCategory(String categoryId) async {
    try {
      // First, get current user to get broadcaster ID
      final userResult = await getCurrentUser();
      if (userResult.isLeft()) {
        return Left((userResult as Left<Failure, TwitchUser>).value);
      }

      final user = (userResult as Right<Failure, TwitchUser>).value;
      _logger.info(
        'Updating channel category: broadcasterId=${user.id}, categoryId=$categoryId',
      );

      await _remoteDataSource.updateChannelCategory(user.id, categoryId);
      _logger.info('Successfully updated channel category');
      return const Right(null);
    } on ServerException catch (e) {
      _logger.error('Server error updating channel category', e);
      return Left(
        ServerFailure(message: e.message, code: e.code, originalError: e),
      );
    } on NetworkException catch (e) {
      _logger.error('Network error updating channel category', e);
      return Left(NetworkFailure(message: e.message, originalError: e));
    } on AuthException catch (e) {
      _logger.error('Auth error updating channel category', e);
      return Left(
        AuthFailure(message: e.message, code: e.code, originalError: e),
      );
    } catch (e) {
      _logger.error('Unknown error updating channel category', e);
      return Left(
        UnknownFailure(
          message: 'Failed to update channel category: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, TwitchUser>> getCurrentUser() async {
    try {
      // Check cache first
      if (_cachedUser != null && _userCacheTime != null) {
        final cacheAge = DateTime.now().difference(_userCacheTime!);
        if (cacheAge < _userCacheDuration) {
          _logger.debug(
            'Returning cached user data (age: ${cacheAge.inSeconds}s)',
          );
          return Right(_cachedUser!);
        }
      }

      _logger.info('Fetching current user from API');
      final model = await _remoteDataSource.getCurrentUser();
      final entity = model.toEntity();

      // Update cache
      _cachedUser = entity;
      _userCacheTime = DateTime.now();

      _logger.info(
        'Fetched current user: ${entity.displayName} (${entity.id})',
      );
      return Right(entity);
    } on ServerException catch (e) {
      _logger.error('Server error getting current user', e);
      return Left(
        ServerFailure(message: e.message, code: e.code, originalError: e),
      );
    } on NetworkException catch (e) {
      _logger.error('Network error getting current user', e);
      return Left(NetworkFailure(message: e.message, originalError: e));
    } on AuthException catch (e) {
      _logger.error('Auth error getting current user', e);
      return Left(
        AuthFailure(message: e.message, code: e.code, originalError: e),
      );
    } catch (e) {
      _logger.error('Unknown error getting current user', e);
      return Left(
        UnknownFailure(
          message: 'Failed to get current user: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, TwitchCategory>> getCategoryById(
    String categoryId,
  ) async {
    try {
      _logger.info('Fetching category by ID: $categoryId');
      final model = await _remoteDataSource.getCategoryById(categoryId);
      final entity = model.toEntity();
      _logger.info('Fetched category: ${entity.name}');
      return Right(entity);
    } on ServerException catch (e) {
      _logger.error('Server error getting category', e);
      return Left(
        ServerFailure(message: e.message, code: e.code, originalError: e),
      );
    } on NetworkException catch (e) {
      _logger.error('Network error getting category', e);
      return Left(NetworkFailure(message: e.message, originalError: e));
    } on AuthException catch (e) {
      _logger.error('Auth error getting category', e);
      return Left(
        AuthFailure(message: e.message, code: e.code, originalError: e),
      );
    } catch (e) {
      _logger.error('Unknown error getting category', e);
      return Left(
        UnknownFailure(
          message: 'Failed to get category: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<TwitchCategory>>> getGamesByIds(
    List<String> categoryIds,
  ) async {
    try {
      _logger.info('Fetching ${categoryIds.length} games by IDs');
      final models = await _remoteDataSource.getGamesByIds(categoryIds);
      final entities = models.map((model) => model.toEntity()).toList();
      _logger.info('Fetched ${entities.length} games');
      return Right(entities);
    } on ServerException catch (e) {
      _logger.error('Server error getting games by IDs', e);
      return Left(
        ServerFailure(message: e.message, code: e.code, originalError: e),
      );
    } on NetworkException catch (e) {
      _logger.error('Network error getting games by IDs', e);
      return Left(NetworkFailure(message: e.message, originalError: e));
    } on AuthException catch (e) {
      _logger.error('Auth error getting games by IDs', e);
      return Left(
        AuthFailure(message: e.message, code: e.code, originalError: e),
      );
    } catch (e) {
      _logger.error('Unknown error getting games by IDs', e);
      return Left(
        UnknownFailure(
          message: 'Failed to get games by IDs: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<TwitchCategory>>> getGamesByNames(
    List<String> gameNames,
  ) async {
    try {
      _logger.info('Fetching ${gameNames.length} games by names');
      final models = await _remoteDataSource.getGamesByNames(gameNames);
      final entities = models.map((model) => model.toEntity()).toList();
      _logger.info('Fetched ${entities.length} games');
      return Right(entities);
    } on ServerException catch (e) {
      _logger.error('Server error getting games by names', e);
      return Left(
        ServerFailure(message: e.message, code: e.code, originalError: e),
      );
    } on NetworkException catch (e) {
      _logger.error('Network error getting games by names', e);
      return Left(NetworkFailure(message: e.message, originalError: e));
    } on AuthException catch (e) {
      _logger.error('Auth error getting games by names', e);
      return Left(
        AuthFailure(message: e.message, code: e.code, originalError: e),
      );
    } catch (e) {
      _logger.error('Unknown error getting games by names', e);
      return Left(
        UnknownFailure(
          message: 'Failed to get games by names: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<TwitchCategory>>> getTopGames({
    int first = 20,
    String? after,
  }) async {
    try {
      _logger.info('Fetching top $first games');
      final models = await _remoteDataSource.getTopGames(
        first: first,
        after: after,
      );
      final entities = models.map((model) => model.toEntity()).toList();
      _logger.info('Fetched ${entities.length} top games');
      return Right(entities);
    } on ServerException catch (e) {
      _logger.error('Server error getting top games', e);
      return Left(
        ServerFailure(message: e.message, code: e.code, originalError: e),
      );
    } on NetworkException catch (e) {
      _logger.error('Network error getting top games', e);
      return Left(NetworkFailure(message: e.message, originalError: e));
    } on AuthException catch (e) {
      _logger.error('Auth error getting top games', e);
      return Left(
        AuthFailure(message: e.message, code: e.code, originalError: e),
      );
    } catch (e) {
      _logger.error('Unknown error getting top games', e);
      return Left(
        UnknownFailure(
          message: 'Failed to get top games: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }

  /// Clear user cache (useful when user logs out)
  void clearCache() {
    _cachedUser = null;
    _userCacheTime = null;
    _logger.debug('Cleared user cache');
  }
}
