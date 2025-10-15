import 'package:dartz/dartz.dart';
import 'package:tkit/core/errors/exceptions.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/core/utils/app_logger.dart';
import 'package:tkit/features/auth/domain/entities/twitch_token.dart';
import 'package:tkit/features/auth/domain/entities/twitch_user.dart';
import 'package:tkit/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:tkit/features/auth/data/datasources/token_local_datasource.dart';
import 'package:tkit/features/auth/data/datasources/twitch_auth_remote_datasource.dart';
import 'package:tkit/features/auth/data/models/device_code_response.dart';

/// Implementation of IAuthRepository
/// Coordinates between local and remote data sources
class AuthRepositoryImpl implements IAuthRepository {
  final TwitchAuthRemoteDataSource _remoteDataSource;
  final TokenLocalDataSource _localDataSource;
  final _logger = AppLogger();

  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<Failure, DeviceCodeResponse>> initiateDeviceCodeAuth() async {
    try {
      _logger.info('Initiating Device Code Flow');

      final deviceCodeResponse = await _remoteDataSource.initiateDeviceCode();

      _logger.info('Device code flow initiated successfully');
      return Right(deviceCodeResponse);
    } on AuthException catch (e) {
      _logger.error('Device code initiation failed', e);
      return Left(
        AuthFailure(
          message: e.message,
          code: e.code,
          originalError: e.originalError,
        ),
      );
    } catch (e) {
      _logger.error('Unexpected error during device code initiation', e);
      return Left(
        UnknownFailure(
          message: 'An unexpected error occurred during device code initiation',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, TwitchUser>> authenticateWithDeviceCode(
    String deviceCode,
  ) async {
    try {
      _logger.info('Polling for device code authorization');

      // Poll for authorization
      final token = await _remoteDataSource.pollDeviceCode(deviceCode);

      // Get user info
      final user = await _remoteDataSource.getCurrentUser(token.accessToken);

      // Save token and user locally
      await _localDataSource.saveToken(token);
      await _localDataSource.saveUser(user);

      _logger.info('Device code authentication successful for user: ${user.login}');
      return Right(user.toEntity());
    } on AuthException catch (e) {
      // Don't log authorization_pending as errors - it's expected during polling
      if (e.code != 'AUTHORIZATION_PENDING' && e.code != 'SLOW_DOWN') {
        _logger.error('Device code authentication failed', e);
      }
      return Left(
        AuthFailure(
          message: e.message,
          code: e.code,
          originalError: e.originalError,
        ),
      );
    } on CacheException catch (e) {
      _logger.error('Cache error during device code authentication', e);
      return Left(
        CacheFailure(
          message: e.message,
          code: e.code,
          originalError: e.originalError,
        ),
      );
    } catch (e) {
      _logger.error('Unexpected error during device code authentication', e);
      return Left(
        UnknownFailure(
          message: 'An unexpected error occurred during device code authentication',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      _logger.info('Starting logout');

      // Get current token to revoke it
      final token = await _localDataSource.getToken();

      if (token != null) {
        // Revoke token on Twitch
        try {
          await _remoteDataSource.revokeToken(token.accessToken);
        } catch (e) {
          // Continue with logout even if revocation fails
          _logger.warning('Token revocation failed, continuing with logout', e);
        }
      }

      // Clear local storage
      await _localDataSource.clearAll();

      _logger.info('Logout successful');
      return const Right(null);
    } on CacheException catch (e) {
      _logger.error('Cache error during logout', e);
      return Left(
        CacheFailure(
          message: e.message,
          code: e.code,
          originalError: e.originalError,
        ),
      );
    } catch (e) {
      _logger.error('Unexpected error during logout', e);
      return Left(
        UnknownFailure(
          message: 'An unexpected error occurred during logout',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, TwitchToken>> refreshToken() async {
    try {
      _logger.info('Refreshing access token');

      // Get current token
      final currentToken = await _localDataSource.getToken();

      if (currentToken == null) {
        _logger.warning('No token available to refresh');
        return const Left(
          AuthFailure(
            message: 'No token available to refresh',
            code: 'NO_TOKEN',
          ),
        );
      }

      // Refresh token
      final newToken = await _remoteDataSource.refreshAccessToken(
        currentToken.refreshToken,
      );

      // Save new token
      await _localDataSource.saveToken(newToken);

      _logger.info('Token refresh successful');
      return Right(newToken.toEntity());
    } on AuthException catch (e) {
      _logger.error('Token refresh failed', e);

      // If refresh fails, clear stored tokens
      try {
        await _localDataSource.clearAll();
      } catch (_) {
        // Ignore cleanup errors
      }

      return Left(
        AuthFailure(
          message: e.message,
          code: e.code,
          originalError: e.originalError,
        ),
      );
    } on CacheException catch (e) {
      _logger.error('Cache error during token refresh', e);
      return Left(
        CacheFailure(
          message: e.message,
          code: e.code,
          originalError: e.originalError,
        ),
      );
    } catch (e) {
      _logger.error('Unexpected error during token refresh', e);
      return Left(
        UnknownFailure(
          message: 'An unexpected error occurred during token refresh',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> isAuthenticated() async {
    try {
      // Check if token exists
      final hasToken = await _localDataSource.hasToken();

      if (!hasToken) {
        return const Right(false);
      }

      // Get token and check if it's valid
      final token = await _localDataSource.getToken();

      if (token == null) {
        return const Right(false);
      }

      // If token is expired, try to refresh it
      if (token.isExpired) {
        _logger.info('Token expired, attempting refresh');
        final refreshResult = await refreshToken();

        return refreshResult.fold((failure) {
          _logger.warning('Token refresh failed, user not authenticated');
          return const Right(false);
        }, (newToken) => const Right(true));
      }

      // Token is valid
      return const Right(true);
    } on CacheException catch (e) {
      _logger.error('Cache error checking authentication status', e);
      return Left(
        CacheFailure(
          message: e.message,
          code: e.code,
          originalError: e.originalError,
        ),
      );
    } catch (e) {
      _logger.error('Unexpected error checking authentication status', e);
      return Left(
        UnknownFailure(
          message:
              'An unexpected error occurred checking authentication status',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, TwitchToken?>> getCurrentToken() async {
    try {
      final token = await _localDataSource.getToken();
      return Right(token?.toEntity());
    } on CacheException catch (e) {
      _logger.error('Cache error getting current token', e);
      return Left(
        CacheFailure(
          message: e.message,
          code: e.code,
          originalError: e.originalError,
        ),
      );
    } catch (e) {
      _logger.error('Unexpected error getting current token', e);
      return Left(
        UnknownFailure(
          message: 'An unexpected error occurred getting current token',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, TwitchUser?>> getCurrentUser() async {
    try {
      final user = await _localDataSource.getUser();
      return Right(user?.toEntity());
    } on CacheException catch (e) {
      _logger.error('Cache error getting current user', e);
      return Left(
        CacheFailure(
          message: e.message,
          code: e.code,
          originalError: e.originalError,
        ),
      );
    } catch (e) {
      _logger.error('Unexpected error getting current user', e);
      return Left(
        UnknownFailure(
          message: 'An unexpected error occurred getting current user',
          originalError: e,
        ),
      );
    }
  }
}
