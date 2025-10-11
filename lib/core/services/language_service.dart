import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_logger.dart';

/// Service for managing app language/locale
class LanguageService {
  static const String _languageKey = 'app_language';
  static const String _languageSetupCompletedKey = 'language_setup_completed';

  final SharedPreferences _prefs;
  final AppLogger _logger;

  LanguageService(this._prefs, this._logger);

  /// Get the saved language code (e.g., 'en', 'cs')
  String? getSavedLanguage() {
    final language = _prefs.getString(_languageKey);
    _logger.info('Retrieved saved language: $language');
    return language;
  }

  /// Save the selected language
  Future<void> saveLanguage(String languageCode) async {
    await _prefs.setString(_languageKey, languageCode);
    _logger.info('Saved language: $languageCode');
  }

  /// Check if language setup was completed
  bool isLanguageSetupCompleted() {
    final completed = _prefs.getBool(_languageSetupCompletedKey) ?? false;
    _logger.info('Language setup completed: $completed');
    return completed;
  }

  /// Mark language setup as completed
  Future<void> markSetupCompleted() async {
    await _prefs.setBool(_languageSetupCompletedKey, true);
    _logger.info('Marked language setup as completed');
  }

  /// Detect system language and return 'en' or 'cs' based on system locale
  /// Falls back to 'en' if system language is not Czech
  String detectSystemLanguage() {
    final systemLocale = PlatformDispatcher.instance.locale;
    final languageCode = systemLocale.languageCode;

    _logger.info('System locale detected: $languageCode (full: ${systemLocale.toString()})');

    // Return 'cs' for Czech, 'en' for everything else
    final detectedLanguage = languageCode == 'cs' ? 'cs' : 'en';
    _logger.info('Detected language: $detectedLanguage');

    return detectedLanguage;
  }

  /// Get the current locale based on saved or detected language
  Locale getCurrentLocale() {
    final savedLanguage = getSavedLanguage();
    if (savedLanguage != null) {
      return Locale(savedLanguage);
    }

    // If no saved language, detect from system
    final detectedLanguage = detectSystemLanguage();
    return Locale(detectedLanguage);
  }
}
