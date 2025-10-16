import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tkit/core/errors/exceptions.dart';
import 'package:tkit/core/utils/app_logger.dart';
import 'package:tkit/core/config/app_config.dart';
import 'package:tkit/features/settings/data/models/app_settings_model.dart';

/// Local data source for settings persistence using SharedPreferences
/// Provides reactive stream for settings changes
class SettingsLocalDataSource {
  static const _settingsKey = 'app_settings';

  final SharedPreferences _prefs;
  final AppLogger _logger;

  // Stream controller for reactive settings updates
  final _settingsController = StreamController<AppSettingsModel>.broadcast();

  SettingsLocalDataSource(this._prefs, this._logger);

  /// Get current settings from local storage
  /// Returns default settings if none exist
  Future<AppSettingsModel> getSettings() async {
    try {
      final settingsJson = _prefs.getString(_settingsKey);

      if (settingsJson == null || settingsJson.isEmpty) {
        _logger.info(
          'No settings found, returning defaults with channel auto-detection',
        );
        final appVersion = AppConfig.appVersion;
        _logger.info(
          'Detected app version: $appVersion, auto-selecting update channel',
        );
        return AppSettingsModel.defaults(appVersion: appVersion);
      }

      final json = jsonDecode(settingsJson) as Map<String, dynamic>;
      final settings = AppSettingsModel.fromJson(json);

      return settings;
    } catch (e, stackTrace) {
      _logger.error('Error loading settings', e, stackTrace);
      throw CacheException(
        message: 'Failed to load settings: ${e.toString()}',
        originalError: e,
      );
    }
  }

  /// Save settings to local storage
  /// Emits update to stream for reactive listeners
  Future<void> saveSettings(AppSettingsModel settings) async {
    try {
      _logger.debug('Saving settings to local storage');

      final json = settings.toJson();
      final settingsJson = jsonEncode(json);

      final success = await _prefs.setString(_settingsKey, settingsJson);

      if (!success) {
        throw const CacheException(
          message: 'Failed to save settings to SharedPreferences',
        );
      }

      _logger.info('Settings saved successfully');

      // Emit update to stream
      _settingsController.add(settings);
    } catch (e, stackTrace) {
      _logger.error('Error saving settings', e, stackTrace);
      throw CacheException(
        message: 'Failed to save settings: ${e.toString()}',
        originalError: e,
      );
    }
  }

  /// Watch settings for changes
  /// Returns a stream that emits when settings are updated
  Stream<AppSettingsModel> watchSettings() {
    // Emit current settings first
    getSettings().then((settings) {
      if (!_settingsController.isClosed) {
        _settingsController.add(settings);
      }
    });

    return _settingsController.stream;
  }

  /// Clear all settings from local storage
  /// Returns settings to default values
  Future<void> clearSettings() async {
    try {
      _logger.info('Clearing all settings from local storage');

      final success = await _prefs.remove(_settingsKey);

      if (!success) {
        throw const CacheException(
          message: 'Failed to clear settings from SharedPreferences',
        );
      }

      _logger.info('Settings cleared successfully');

      // Emit default settings to stream with channel auto-detection
      final appVersion = AppConfig.appVersion;
      _settingsController.add(
        AppSettingsModel.defaults(appVersion: appVersion),
      );
    } catch (e, stackTrace) {
      _logger.error('Error clearing settings', e, stackTrace);
      throw CacheException(
        message: 'Failed to clear settings: ${e.toString()}',
        originalError: e,
      );
    }
  }

  /// Dispose resources
  void dispose() {
    _settingsController.close();
  }
}
