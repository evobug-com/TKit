import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/app_logger.dart';
import '../models/twitch_token_model.dart';
import '../models/twitch_user_model.dart';

/// Local data source for securely storing authentication tokens and user info
/// Uses flutter_secure_storage for encrypted storage
class TokenLocalDataSource {
  final FlutterSecureStorage _secureStorage;
  final AppLogger _logger = AppLogger();

  // Storage keys
  static const String _tokenKey = 'twitch_token';
  static const String _userKey = 'twitch_user';

  TokenLocalDataSource(this._secureStorage);

  /// Save token to secure storage
  Future<void> saveToken(TwitchTokenModel token) async {
    try {
      final jsonString = jsonEncode(token.toJson());
      await _secureStorage.write(key: _tokenKey, value: jsonString);
      _logger.debug('Token saved to secure storage');
    } catch (e) {
      _logger.error('Failed to save token', e);
      throw CacheException(
        message: 'Failed to save token to secure storage',
        originalError: e,
      );
    }
  }

  /// Get token from secure storage
  /// Returns null if no token is stored
  Future<TwitchTokenModel?> getToken() async {
    try {
      final jsonString = await _secureStorage.read(key: _tokenKey);
      if (jsonString == null) {
        _logger.debug('No token found in secure storage');
        return null;
      }

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final token = TwitchTokenModel.fromJson(json);
      _logger.debug('Token retrieved from secure storage');
      return token;
    } catch (e) {
      _logger.error('Failed to get token', e);
      throw CacheException(
        message: 'Failed to retrieve token from secure storage',
        originalError: e,
      );
    }
  }

  /// Delete token from secure storage
  Future<void> deleteToken() async {
    try {
      await _secureStorage.delete(key: _tokenKey);
      _logger.debug('Token deleted from secure storage');
    } catch (e) {
      _logger.error('Failed to delete token', e);
      throw CacheException(
        message: 'Failed to delete token from secure storage',
        originalError: e,
      );
    }
  }

  /// Check if token exists in secure storage
  Future<bool> hasToken() async {
    try {
      final jsonString = await _secureStorage.read(key: _tokenKey);
      final exists = jsonString != null;
      _logger.debug('Token exists: $exists');
      return exists;
    } catch (e) {
      _logger.error('Failed to check token existence', e);
      throw CacheException(
        message: 'Failed to check token existence',
        originalError: e,
      );
    }
  }

  /// Save user info to secure storage
  Future<void> saveUser(TwitchUserModel user) async {
    try {
      final jsonString = jsonEncode(user.toJson());
      await _secureStorage.write(key: _userKey, value: jsonString);
      _logger.debug('User info saved to secure storage');
    } catch (e) {
      _logger.error('Failed to save user info', e);
      throw CacheException(
        message: 'Failed to save user info to secure storage',
        originalError: e,
      );
    }
  }

  /// Get user info from secure storage
  /// Returns null if no user is stored
  Future<TwitchUserModel?> getUser() async {
    try {
      final jsonString = await _secureStorage.read(key: _userKey);
      if (jsonString == null) {
        _logger.debug('No user found in secure storage');
        return null;
      }

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final user = TwitchUserModel.fromJson(json);
      _logger.debug('User info retrieved from secure storage');
      return user;
    } catch (e) {
      _logger.error('Failed to get user info', e);
      throw CacheException(
        message: 'Failed to retrieve user info from secure storage',
        originalError: e,
      );
    }
  }

  /// Delete user info from secure storage
  Future<void> deleteUser() async {
    try {
      await _secureStorage.delete(key: _userKey);
      _logger.debug('User info deleted from secure storage');
    } catch (e) {
      _logger.error('Failed to delete user info', e);
      throw CacheException(
        message: 'Failed to delete user info from secure storage',
        originalError: e,
      );
    }
  }

  /// Clear all authentication data (token and user)
  Future<void> clearAll() async {
    try {
      await deleteToken();
      await deleteUser();
      _logger.info('All authentication data cleared');
    } catch (e) {
      _logger.error('Failed to clear authentication data', e);
      throw CacheException(
        message: 'Failed to clear authentication data',
        originalError: e,
      );
    }
  }
}
