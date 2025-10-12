import 'package:dio/dio.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/app_logger.dart';
import '../models/twitch_category_model.dart';
import '../models/twitch_user_model.dart';

/// Remote data source for Twitch Helix API
/// Handles all HTTP communication with Twitch servers
class TwitchApiRemoteDataSource {
  final Dio _dio;
  final AppLogger _logger;

  // Token provider callback - will be set by the repository
  String? Function()? _tokenProvider;

  // Refresh token callback - will be set by the repository
  // Returns new access token after refresh, or null if refresh fails
  Future<String?> Function()? _refreshTokenCallback;

  TwitchApiRemoteDataSource(this._dio, this._logger) {
    _configureDio();
  }

  /// Set the token provider callback
  /// This allows the auth module to provide fresh tokens
  void setTokenProvider(String? Function() provider) {
    _tokenProvider = provider;
  }

  /// Set the refresh token callback
  /// This allows the data source to force token refresh on 401 errors
  void setRefreshTokenCallback(Future<String?> Function() callback) {
    _refreshTokenCallback = callback;
  }

  /// Configure Dio with base URL and interceptors
  void _configureDio() {
    _dio.options.baseUrl = AppConfig.twitchApiBaseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);

    // Add request interceptor for auth headers
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = _tokenProvider?.call();
          if (token == null) {
            _logger.error('No access token available for Twitch API request');
            return handler.reject(
              DioException(
                requestOptions: options,
                error: 'Not authenticated',
                type: DioExceptionType.cancel,
              ),
            );
          }

          // Add required Twitch headers
          options.headers['Authorization'] = 'Bearer $token';
          options.headers['Client-Id'] = AppConfig.twitchClientId;

          _logger.debug(
            'Twitch API Request: ${options.method} ${options.path}',
          );
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.debug(
            'Twitch API Response: ${response.statusCode} ${response.requestOptions.path}',
          );
          return handler.next(response);
        },
        onError: (error, handler) async {
          _logger.error('Twitch API Error: ${error.message}', error);

          // Handle rate limiting (429 Too Many Requests)
          if (error.response?.statusCode == 429) {
            final retryAfter = _getRetryAfter(error.response);
            _logger.warning('Rate limited. Retry after: $retryAfter seconds');

            // Wait and retry with exponential backoff
            if (retryAfter > 0 && retryAfter <= 60) {
              await Future.delayed(Duration(seconds: retryAfter));

              // Retry the request
              try {
                final response = await _dio.fetch(error.requestOptions);
                return handler.resolve(response);
              } catch (e) {
                return handler.next(error);
              }
            }
          }

          // Handle unauthorized (401) - token expired or invalid
          if (error.response?.statusCode == 401) {
            _logger.warning('Unauthorized (401) - attempting token refresh');

            // Only retry once to avoid infinite loops
            final isRetry = error.requestOptions.extra['_tokenRefreshRetry'] == true;
            if (!isRetry && _refreshTokenCallback != null) {
              try {
                // Force token refresh
                final newToken = await _refreshTokenCallback!();

                if (newToken != null) {
                  _logger.info('Token refreshed successfully, retrying request');

                  // Mark this request as a retry to prevent infinite loops
                  error.requestOptions.extra['_tokenRefreshRetry'] = true;

                  // Update the authorization header with new token
                  error.requestOptions.headers['Authorization'] = 'Bearer $newToken';

                  // Retry the request
                  try {
                    final response = await _dio.fetch(error.requestOptions);
                    return handler.resolve(response);
                  } catch (e) {
                    _logger.error('Retry after token refresh failed', e);
                    return handler.next(error);
                  }
                } else {
                  _logger.error('Token refresh returned null - refresh failed');
                }
              } catch (e) {
                _logger.error('Token refresh failed', e);
              }
            } else if (isRetry) {
              _logger.error('Request failed with 401 after token refresh - not retrying again');
            } else {
              _logger.error('No refresh token callback configured');
            }
          }

          return handler.next(error);
        },
      ),
    );

    // Add logging interceptor in debug mode
    if (AppConfig.enableVerboseLogging) {
      _dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true, error: true),
      );
    }
  }

  /// Extract retry-after duration from rate limit response
  int _getRetryAfter(Response? response) {
    if (response == null) return 0;

    // Try Ratelimit-Reset header (Unix timestamp)
    final resetHeader = response.headers.value('Ratelimit-Reset');
    if (resetHeader != null) {
      try {
        final resetTime = int.parse(resetHeader);
        final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        return (resetTime - now).clamp(1, 60);
      } catch (e) {
        _logger.error('Failed to parse Ratelimit-Reset header', e);
      }
    }

    // Try Retry-After header (seconds)
    final retryAfter = response.headers.value('Retry-After');
    if (retryAfter != null) {
      try {
        return int.parse(retryAfter).clamp(1, 60);
      } catch (e) {
        _logger.error('Failed to parse Retry-After header', e);
      }
    }

    // Default to 5 seconds
    return 5;
  }

  /// Search for categories by query
  ///
  /// GET https://api.twitch.tv/helix/search/categories
  /// Returns list of matching categories
  Future<List<TwitchCategoryModel>> searchCategories(
    String query, {
    int first = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/search/categories',
        queryParameters: {'query': query, 'first': first},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data
            .map(
              (json) =>
                  TwitchCategoryModel.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw ServerException(
          message: 'Failed to search categories: ${response.statusCode}',
          code: response.statusCode?.toString(),
        );
      }
    } on DioException catch (e) {
      _handleDioException(e, 'searchCategories');
      rethrow;
    }
  }

  /// Update channel category
  ///
  /// PATCH https://api.twitch.tv/helix/channels
  /// Requires channel:manage:broadcast scope
  Future<void> updateChannelCategory(
    String broadcasterId,
    String categoryId,
  ) async {
    try {
      final response = await _dio.patch(
        '/channels',
        queryParameters: {'broadcaster_id': broadcasterId},
        data: {'game_id': categoryId},
      );

      if (response.statusCode != 204) {
        throw ServerException(
          message: 'Failed to update channel category: ${response.statusCode}',
          code: response.statusCode?.toString(),
        );
      }
    } on DioException catch (e) {
      _handleDioException(e, 'updateChannelCategory');
      rethrow;
    }
  }

  /// Get current user information
  ///
  /// GET https://api.twitch.tv/helix/users
  /// Returns authenticated user's data
  Future<TwitchUserModel> getCurrentUser() async {
    try {
      final response = await _dio.get('/users');

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        if (data.isEmpty) {
          throw ServerException(message: 'No user data returned', code: '404');
        }
        return TwitchUserModel.fromJson(data.first as Map<String, dynamic>);
      } else {
        throw ServerException(
          message: 'Failed to get current user: ${response.statusCode}',
          code: response.statusCode?.toString(),
        );
      }
    } on DioException catch (e) {
      _handleDioException(e, 'getCurrentUser');
      rethrow;
    }
  }

  /// Get category by ID
  ///
  /// GET https://api.twitch.tv/helix/games
  /// Returns category details
  Future<TwitchCategoryModel> getCategoryById(String categoryId) async {
    try {
      final response = await _dio.get(
        '/games',
        queryParameters: {'id': categoryId},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        if (data.isEmpty) {
          throw ServerException(message: 'Category not found', code: '404');
        }
        return TwitchCategoryModel.fromJson(data.first as Map<String, dynamic>);
      } else {
        throw ServerException(
          message: 'Failed to get category: ${response.statusCode}',
          code: response.statusCode?.toString(),
        );
      }
    } on DioException catch (e) {
      _handleDioException(e, 'getCategoryById');
      rethrow;
    }
  }

  /// Get multiple games/categories by IDs (batch lookup)
  ///
  /// GET https://api.twitch.tv/helix/games
  /// Supports up to 100 IDs per request
  /// Returns list of matching categories
  Future<List<TwitchCategoryModel>> getGamesByIds(List<String> categoryIds) async {
    if (categoryIds.isEmpty) {
      return [];
    }

    // Twitch API supports up to 100 IDs per request
    if (categoryIds.length > 100) {
      throw ServerException(
        message: 'Maximum 100 category IDs allowed per request',
        code: '400',
      );
    }

    try {
      final response = await _dio.get(
        '/games',
        queryParameters: {
          'id': categoryIds,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data
            .map(
              (json) =>
                  TwitchCategoryModel.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw ServerException(
          message: 'Failed to get games by IDs: ${response.statusCode}',
          code: response.statusCode?.toString(),
        );
      }
    } on DioException catch (e) {
      _handleDioException(e, 'getGamesByIds');
      rethrow;
    }
  }

  /// Get multiple games/categories by names (batch lookup)
  ///
  /// GET https://api.twitch.tv/helix/games
  /// Supports up to 100 names per request
  /// Returns list of matching categories
  Future<List<TwitchCategoryModel>> getGamesByNames(
    List<String> gameNames,
  ) async {
    if (gameNames.isEmpty) {
      return [];
    }

    // Twitch API supports up to 100 names per request
    if (gameNames.length > 100) {
      throw ServerException(
        message: 'Maximum 100 game names allowed per request',
        code: '400',
      );
    }

    try {
      final response = await _dio.get(
        '/games',
        queryParameters: {
          'name': gameNames,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data
            .map(
              (json) =>
                  TwitchCategoryModel.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw ServerException(
          message: 'Failed to get games by names: ${response.statusCode}',
          code: response.statusCode?.toString(),
        );
      }
    } on DioException catch (e) {
      _handleDioException(e, 'getGamesByNames');
      rethrow;
    }
  }

  /// Get top games/categories on Twitch
  ///
  /// GET https://api.twitch.tv/helix/games/top
  /// Returns list of most popular games currently being streamed
  Future<List<TwitchCategoryModel>> getTopGames({
    int first = 20,
    String? after,
  }) async {
    if (first < 1 || first > 100) {
      throw ServerException(
        message: 'first parameter must be between 1 and 100',
        code: '400',
      );
    }

    try {
      final queryParams = <String, dynamic>{'first': first};
      if (after != null) {
        queryParams['after'] = after;
      }

      final response = await _dio.get(
        '/games/top',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data
            .map(
              (json) =>
                  TwitchCategoryModel.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw ServerException(
          message: 'Failed to get top games: ${response.statusCode}',
          code: response.statusCode?.toString(),
        );
      }
    } on DioException catch (e) {
      _handleDioException(e, 'getTopGames');
      rethrow;
    }
  }

  /// Handle Dio exceptions and convert to custom exceptions
  void _handleDioException(DioException e, String operation) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw NetworkException(
          message: 'Network timeout during $operation',
          originalError: e,
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          throw AuthException(
            message: 'Authentication failed - token may be expired',
            code: '401',
          );
        } else if (statusCode == 429) {
          throw ServerException(message: 'Rate limit exceeded', code: '429');
        } else {
          throw ServerException(
            message: 'Server error during $operation: $statusCode',
            code: statusCode?.toString(),
          );
        }
      case DioExceptionType.cancel:
        throw CacheException(message: 'Request cancelled during $operation');
      case DioExceptionType.unknown:
      default:
        throw NetworkException(
          message: 'Network error during $operation: ${e.message}',
          originalError: e,
        );
    }
  }
}
