import 'package:dio/dio.dart';
import 'package:tkit/core/config/app_config.dart';
import 'package:tkit/core/errors/exceptions.dart';
import 'package:tkit/core/utils/app_logger.dart';
import 'package:tkit/features/auth/data/models/device_code_response.dart';
import 'package:tkit/features/auth/data/models/twitch_token_model.dart';
import 'package:tkit/features/auth/data/models/twitch_user_model.dart';

/// Remote data source for Twitch OAuth authentication
/// Implements OAuth 2.0 Device Code Flow (recommended for desktop apps)
class TwitchAuthRemoteDataSource {
  final Dio _dio;
  final _logger = AppLogger();


  TwitchAuthRemoteDataSource(this._dio);

  /// Initiate Device Code Flow
  /// Returns device code and user code for authorization
  Future<DeviceCodeResponse> initiateDeviceCode() async {
    try {
      final response = await _dio.post(
        'https://id.twitch.tv/oauth2/device',
        data: {
          'client_id': AppConfig.twitchClientId,
          'scopes': AppConfig.twitchScopes.join(' '),
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response.statusCode != 200) {
        throw AuthException(
          message: 'Unable to start authentication. Please try again.',
          code: 'DEVICE_CODE_FAILED',
          technicalDetails: 'HTTP ${response.statusCode}',
        );
      }

      final deviceCodeResponse = DeviceCodeResponse.fromJson(response.data);
      _logger.info('Device code generated: ${deviceCodeResponse.userCode}');
      return deviceCodeResponse;
    } on DioException catch (e, stackTrace) {
      _logger.error('Device code request failed', e, stackTrace);
      throw AuthException(
        message: 'Unable to connect to Twitch. Please check your internet connection.',
        code: 'DEVICE_CODE_ERROR',
        originalError: e,
        technicalDetails: 'Network error: ${e.message}',
      );
    } catch (e, stackTrace) {
      if (e is AuthException) rethrow;
      _logger.error('Unexpected error during device code request', e, stackTrace);
      throw AuthException(
        message: 'Authentication failed. Please try again.',
        code: 'UNKNOWN_ERROR',
        originalError: e,
        technicalDetails: e.toString(),
      );
    }
  }

  /// Poll for device code authorization
  /// Returns token when user completes authorization
  /// Throws AuthException if authorization is denied or times out
  Future<TwitchTokenModel> pollDeviceCode(String deviceCode) async {
    try {
      final response = await _dio.post(
        AppConfig.twitchTokenUrl,
        data: {
          'client_id': AppConfig.twitchClientId,
          'device_code': deviceCode,
          'grant_type': 'urn:ietf:params:oauth:grant-type:device_code',
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      // Debug: Log response status and data
      _logger.debug('Poll response status: ${response.statusCode}');
      _logger.debug('Poll response data: ${response.data}');
      _logger.debug('Poll response data type: ${response.data.runtimeType}');

      // Handle different response codes
      if (response.statusCode == 200) {
        _logger.debug('Attempting to parse token from 200 response');
        _logger.debug('Response data before parsing: ${response.data}');
        final token = TwitchTokenModel.fromTokenResponse(response.data);
        _logger.info('Device code authorization successful');
        return token;
      } else if (response.statusCode == 400) {
        // Debug: Print the actual response to see what we're getting
        _logger.debug('400 response data: ${response.data}');
        _logger.debug('400 response data type: ${response.data.runtimeType}');

        // Twitch uses 'message' field for device code errors
        final errorData = response.data;
        String? error;

        _logger.debug('errorData is Map: ${errorData is Map}');

        if (errorData is Map) {
          // Check for 'message' field first (Twitch uses this for device code)
          final messageField = errorData['message'];
          _logger.debug('messageField value: $messageField');
          _logger.debug('messageField type: ${messageField.runtimeType}');

          if (messageField is String) {
            _logger.debug('messageField is String, assigning to error');
            error = messageField;
          } else if (messageField is List && messageField.isNotEmpty) {
            _logger.debug('messageField is List, converting first element');
            error = messageField.first.toString();
          }

          _logger.debug('error after message check: $error');

          // Fall back to 'error' field if message is not found
          if (error == null) {
            final errorField = errorData['error'];
            _logger.debug('Checking error field: $errorField');
            if (errorField is String) {
              error = errorField;
            } else if (errorField is List && errorField.isNotEmpty) {
              error = errorField.first.toString();
            }
          }
        }

        _logger.debug('Final error value: $error');

        if (error == 'authorization_pending') {
          throw const AuthException(
            message: 'Authorization pending',
            code: 'AUTHORIZATION_PENDING',
          );
        } else if (error == 'slow_down') {
          throw const AuthException(
            message: 'Polling too fast',
            code: 'SLOW_DOWN',
          );
        } else if (error == 'expired_token') {
          throw const AuthException(
            message: 'Device code expired',
            code: 'EXPIRED_TOKEN',
          );
        } else if (error == 'access_denied') {
          throw const AuthException(
            message: 'User denied authorization',
            code: 'ACCESS_DENIED',
          );
        }
      }

      throw AuthException(
        message: 'Authentication failed. Please try logging in again.',
        code: 'POLLING_FAILED',
        technicalDetails: 'HTTP ${response.statusCode}',
      );
    } on DioException catch (e, stackTrace) {
      _logger.error('Device code polling failed', e, stackTrace);
      throw AuthException(
        message: 'Unable to connect to Twitch. Please check your internet connection.',
        code: 'POLLING_ERROR',
        originalError: e,
        technicalDetails: 'Network error: ${e.message}',
      );
    } catch (e, stackTrace) {
      if (e is AuthException) rethrow;
      _logger.error('Unexpected error during device code polling', e, stackTrace);
      throw AuthException(
        message: 'Authentication failed. Please try again.',
        code: 'UNKNOWN_ERROR',
        originalError: e,
        technicalDetails: e.toString(),
      );
    }
  }

  /// Refresh the access token using the refresh token
  /// For public clients (no client secret required)
  Future<TwitchTokenModel> refreshAccessToken(String refreshToken) async {
    try {
      final response = await _dio.post(
        AppConfig.twitchTokenUrl,
        data: {
          'client_id': AppConfig.twitchClientId,
          'grant_type': 'refresh_token',
          'refresh_token': refreshToken,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response.statusCode != 200) {
        throw AuthException(
          message: 'Your session has expired. Please log in again.',
          code: 'TOKEN_REFRESH_FAILED',
          technicalDetails: 'HTTP ${response.statusCode}',
        );
      }

      final token = TwitchTokenModel.fromTokenResponse(response.data);
      _logger.info('Access token refreshed successfully');
      return token;
    } on DioException catch (e, stackTrace) {
      _logger.error('Token refresh request failed', e, stackTrace);
      throw AuthException(
        message: 'Your session has expired. Please log in again.',
        code: 'TOKEN_REFRESH_ERROR',
        originalError: e,
        technicalDetails: 'Network error: ${e.message}',
      );
    } catch (e, stackTrace) {
      if (e is AuthException) rethrow;
      _logger.error('Unexpected error during token refresh', e, stackTrace);
      throw AuthException(
        message: 'Your session has expired. Please log in again.',
        code: 'UNKNOWN_ERROR',
        originalError: e,
        technicalDetails: e.toString(),
      );
    }
  }

  /// Revoke the access token
  Future<void> revokeToken(String token) async {
    try {
      await _dio.post(
        'https://id.twitch.tv/oauth2/revoke',
        data: {'client_id': AppConfig.twitchClientId, 'token': token},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      _logger.info('Access token revoked successfully');
    } on DioException catch (e, stackTrace) {
      _logger.error('Token revocation request failed', e, stackTrace);
      throw AuthException(
        message: 'Unable to complete logout. You may already be logged out.',
        code: 'TOKEN_REVOKE_ERROR',
        originalError: e,
        technicalDetails: 'Network error: ${e.message}',
      );
    } catch (e, stackTrace) {
      if (e is AuthException) rethrow;
      _logger.error('Unexpected error during token revocation', e, stackTrace);
      throw AuthException(
        message: 'Unable to complete logout. Please try again.',
        code: 'UNKNOWN_ERROR',
        originalError: e,
        technicalDetails: e.toString(),
      );
    }
  }

  /// Get current user info from Twitch API
  Future<TwitchUserModel> getCurrentUser(String accessToken) async {
    try {
      final response = await _dio.get(
        '${AppConfig.twitchApiBaseUrl}/users',
        options: Options(
          headers: {
            'Client-ID': AppConfig.twitchClientId,
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw AuthException(
          message: 'Unable to retrieve your account information. Please try logging in again.',
          code: 'USER_INFO_FAILED',
          technicalDetails: 'HTTP ${response.statusCode}',
        );
      }

      final data = response.data as Map<String, dynamic>;
      final users = data['data'] as List<dynamic>;

      if (users.isEmpty) {
        throw const AuthException(
          message: 'Unable to retrieve your account information. Please try logging in again.',
          code: 'NO_USER_DATA',
          technicalDetails: 'Empty user data response',
        );
      }

      final user = TwitchUserModel.fromApiResponse(
        users.first as Map<String, dynamic>,
      );
      _logger.info('User info retrieved: ${user.login}');
      return user;
    } on DioException catch (e, stackTrace) {
      _logger.error('Failed to get user info', e, stackTrace);
      throw AuthException(
        message: 'Unable to connect to Twitch. Please check your internet connection.',
        code: 'USER_INFO_ERROR',
        originalError: e,
        technicalDetails: 'Network error: ${e.message}',
      );
    } catch (e, stackTrace) {
      if (e is AuthException) rethrow;
      _logger.error('Unexpected error getting user info', e, stackTrace);
      throw AuthException(
        message: 'Unable to retrieve your account information. Please try again.',
        code: 'UNKNOWN_ERROR',
        originalError: e,
        technicalDetails: e.toString(),
      );
    }
  }
}
