import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/app_logger.dart';
import '../models/device_code_response.dart';
import '../models/twitch_token_model.dart';
import '../models/twitch_user_model.dart';

/// Remote data source for Twitch OAuth authentication
/// Implements OAuth 2.0 Device Code Flow (recommended for desktop apps)
class TwitchAuthRemoteDataSource {
  final Dio _dio;
  final AppLogger _logger = AppLogger();

  // OAuth state management
  String? _state;
  HttpServer? _localServer;

  TwitchAuthRemoteDataSource(this._dio);

  /// Generate a random string for state parameter
  String _generateRandomString(int length) {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => chars[random.nextInt(chars.length)],
    ).join();
  }

  /// Generate the OAuth authorization URL using Implicit Flow
  String generateAuthUrl() {
    // Generate state parameter for CSRF protection
    _state = _generateRandomString(32);

    final params = {
      'client_id': AppConfig.twitchClientId,
      'redirect_uri': AppConfig.twitchRedirectUri,
      'response_type': 'token',  // Implicit flow - token directly in fragment
      'scope': AppConfig.twitchScopes.join(' '),
      'state': _state,
    };

    final uri = Uri.parse(
      AppConfig.twitchAuthUrl,
    ).replace(queryParameters: params);
    _logger.info('Generated OAuth URL using Implicit Flow');
    return uri.toString();
  }

  /// Start local HTTP server to receive OAuth callback
  /// Returns the token model from implicit flow
  Future<TwitchTokenModel> startLocalServerAndWaitForCallback() async {
    try {
      _localServer = await HttpServer.bind('localhost', 3000);
      _logger.info('Local OAuth callback server started on port 3000');

      await for (final request in _localServer!) {
        if (request.uri.path == '/callback') {
          // For implicit flow, the token is in the URL fragment (not sent to server)
          // We serve HTML with JavaScript to extract it and send it back
          request.response
            ..statusCode = 200
            ..headers.set('Content-Type', 'text/html')
            ..write('''
              <!DOCTYPE html>
              <html>
              <head><title>TKit - Authorization</title></head>
              <body style="font-family: Arial, sans-serif; text-align: center; padding: 50px; background: #0E0E10; color: #EFEFF1;">
                <h1 style="color: #9147FF;">Processing Authorization...</h1>
                <p>Please wait...</p>
                <script>
                  // Extract token from URL fragment
                  const fragment = window.location.hash.substring(1);
                  const params = new URLSearchParams(fragment);
                  const accessToken = params.get('access_token');
                  const state = params.get('state');
                  const error = params.get('error');

                  if (error) {
                    // Send error back to server
                    fetch('/token?error=' + encodeURIComponent(error) + '&error_description=' + encodeURIComponent(params.get('error_description') || ''));
                  } else if (accessToken && state) {
                    // Send all token parameters back to server
                    const tokenParams = new URLSearchParams({
                      access_token: accessToken,
                      state: state,
                      token_type: params.get('token_type') || 'bearer',
                      scope: params.get('scope') || '',
                      expires_in: params.get('expires_in') || '3600'
                    });
                    fetch('/token?' + tokenParams.toString())
                      .then(() => {
                        document.body.innerHTML = '<h1 style="color: #9147FF;">Authorization Successful!</h1><p>You can close this window and return to TKit.</p>';
                      });
                  } else {
                    fetch('/token?error=no_token');
                  }
                </script>
              </body>
              </html>
            ''');
          await request.response.close();
        } else if (request.uri.path == '/token') {
          // Receive the token from JavaScript
          final queryParams = request.uri.queryParameters;

          request.response
            ..statusCode = 200
            ..headers.set('Content-Type', 'text/plain')
            ..write('OK');
          await request.response.close();

          await _localServer?.close();
          _localServer = null;

          // Validate state parameter
          final receivedState = queryParams['state'];
          if (receivedState != _state) {
            throw AuthException(
              message: 'OAuth state mismatch - possible CSRF attack',
              code: 'STATE_MISMATCH',
            );
          }

          // Check for error
          final error = queryParams['error'];
          if (error != null) {
            final errorDescription =
                queryParams['error_description'] ?? 'Unknown error';
            throw AuthException(
              message: 'OAuth authorization failed: $errorDescription',
              code: error,
            );
          }

          // Get access token
          final accessToken = queryParams['access_token'];
          if (accessToken == null) {
            throw AuthException(
              message: 'No access token received',
              code: 'NO_TOKEN',
            );
          }

          // Extract other token parameters
          final expiresInStr = queryParams['expires_in'] ?? '3600';
          final expiresIn = int.tryParse(expiresInStr) ?? 3600;
          final expiresAt = DateTime.now().add(Duration(seconds: expiresIn));

          final scopeString = queryParams['scope'] ?? '';
          final scopes = scopeString.isNotEmpty ? scopeString.split(' ') : <String>[];

          // Create token model (implicit flow doesn't provide refresh token)
          final token = TwitchTokenModel(
            accessToken: accessToken,
            refreshToken: '', // Implicit flow doesn't provide refresh token
            expiresAt: expiresAt,
            scopes: scopes,
          );

          _logger.info('Access token received from implicit flow');
          return token;
        }
      }

      throw AuthException(
        message: 'OAuth callback server closed unexpectedly',
        code: 'SERVER_CLOSED',
      );
    } catch (e) {
      await _localServer?.close();
      _localServer = null;
      if (e is AuthException) rethrow;
      _logger.error('Failed to start OAuth callback server', e);
      throw AuthException(
        message: 'Failed to start OAuth callback server',
        code: 'SERVER_ERROR',
        originalError: e,
      );
    }
  }

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
          message: 'Device code request failed with status ${response.statusCode}',
          code: 'DEVICE_CODE_FAILED',
        );
      }

      final deviceCodeResponse = DeviceCodeResponse.fromJson(response.data);
      _logger.info('Device code generated: ${deviceCodeResponse.userCode}');
      return deviceCodeResponse;
    } on DioException catch (e) {
      _logger.error('Device code request failed', e);
      throw AuthException(
        message: 'Failed to initiate device code flow: ${e.message}',
        code: 'DEVICE_CODE_ERROR',
        originalError: e,
      );
    } catch (e) {
      if (e is AuthException) rethrow;
      _logger.error('Unexpected error during device code request', e);
      throw AuthException(
        message: 'Unexpected error during device code request',
        code: 'UNKNOWN_ERROR',
        originalError: e,
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
          throw AuthException(
            message: 'Authorization pending',
            code: 'AUTHORIZATION_PENDING',
          );
        } else if (error == 'slow_down') {
          throw AuthException(
            message: 'Polling too fast',
            code: 'SLOW_DOWN',
          );
        } else if (error == 'expired_token') {
          throw AuthException(
            message: 'Device code expired',
            code: 'EXPIRED_TOKEN',
          );
        } else if (error == 'access_denied') {
          throw AuthException(
            message: 'User denied authorization',
            code: 'ACCESS_DENIED',
          );
        }
      }

      throw AuthException(
        message: 'Device code polling failed with status ${response.statusCode}',
        code: 'POLLING_FAILED',
      );
    } on DioException catch (e) {
      _logger.error('Device code polling failed', e);
      throw AuthException(
        message: 'Failed to poll device code: ${e.message}',
        code: 'POLLING_ERROR',
        originalError: e,
      );
    } catch (e) {
      if (e is AuthException) rethrow;
      _logger.error('Unexpected error during device code polling', e);
      throw AuthException(
        message: 'Unexpected error during device code polling',
        code: 'UNKNOWN_ERROR',
        originalError: e,
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
          message: 'Token refresh failed with status ${response.statusCode}',
          code: 'TOKEN_REFRESH_FAILED',
        );
      }

      final token = TwitchTokenModel.fromTokenResponse(response.data);
      _logger.info('Access token refreshed successfully');
      return token;
    } on DioException catch (e) {
      _logger.error('Token refresh request failed', e);
      throw AuthException(
        message: 'Failed to refresh token: ${e.message}',
        code: 'TOKEN_REFRESH_ERROR',
        originalError: e,
      );
    } catch (e) {
      if (e is AuthException) rethrow;
      _logger.error('Unexpected error during token refresh', e);
      throw AuthException(
        message: 'Unexpected error during token refresh',
        code: 'UNKNOWN_ERROR',
        originalError: e,
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
    } on DioException catch (e) {
      _logger.error('Token revocation request failed', e);
      throw AuthException(
        message: 'Failed to revoke token: ${e.message}',
        code: 'TOKEN_REVOKE_ERROR',
        originalError: e,
      );
    } catch (e) {
      if (e is AuthException) rethrow;
      _logger.error('Unexpected error during token revocation', e);
      throw AuthException(
        message: 'Unexpected error during token revocation',
        code: 'UNKNOWN_ERROR',
        originalError: e,
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
          message: 'Failed to get user info with status ${response.statusCode}',
          code: 'USER_INFO_FAILED',
        );
      }

      final data = response.data as Map<String, dynamic>;
      final users = data['data'] as List<dynamic>;

      if (users.isEmpty) {
        throw AuthException(
          message: 'No user data returned from Twitch API',
          code: 'NO_USER_DATA',
        );
      }

      final user = TwitchUserModel.fromApiResponse(
        users.first as Map<String, dynamic>,
      );
      _logger.info('User info retrieved: ${user.login}');
      return user;
    } on DioException catch (e) {
      _logger.error('Failed to get user info', e);
      throw AuthException(
        message: 'Failed to get user info: ${e.message}',
        code: 'USER_INFO_ERROR',
        originalError: e,
      );
    } catch (e) {
      if (e is AuthException) rethrow;
      _logger.error('Unexpected error getting user info', e);
      throw AuthException(
        message: 'Unexpected error getting user info',
        code: 'UNKNOWN_ERROR',
        originalError: e,
      );
    }
  }

  /// Launch browser with OAuth URL
  Future<void> launchAuthUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        throw AuthException(
          message: 'Failed to launch browser for authentication',
          code: 'LAUNCH_FAILED',
        );
      }

      _logger.info('Browser launched for OAuth authentication');
    } catch (e) {
      if (e is AuthException) rethrow;
      _logger.error('Failed to launch auth URL', e);
      throw AuthException(
        message: 'Failed to launch browser: ${e.toString()}',
        code: 'LAUNCH_ERROR',
        originalError: e,
      );
    }
  }

  /// Cancel OAuth flow and clean up
  Future<void> cancelAuth() async {
    if (_localServer != null) {
      await _localServer?.close();
      _localServer = null;
      _logger.info('OAuth flow cancelled');
    }
    _state = null;
  }
}
