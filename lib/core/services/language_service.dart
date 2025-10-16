import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tkit/core/utils/app_logger.dart';
import 'package:tkit/l10n/app_localizations.dart';

/// Service for managing app language/locale
class LanguageService {
  static const _languageKey = 'app_language';
  static const _languageSetupCompletedKey = 'language_setup_completed';

  final SharedPreferences _prefs;
  final AppLogger _logger;

  LanguageService(this._prefs, this._logger);

  /// Get the saved language code (e.g., 'en', 'cs')
  String? getSavedLanguage() {
    final language = _prefs.getString(_languageKey);
    return language;
  }

  /// Save the selected language
  Future<void> saveLanguage(String languageCode) async {
    await _prefs.setString(_languageKey, languageCode);
  }

  /// Check if language setup was completed
  bool isLanguageSetupCompleted() {
    final completed = _prefs.getBool(_languageSetupCompletedKey) ?? false;
    return completed;
  }

  /// Mark language setup as completed
  Future<void> markSetupCompleted() async {
    await _prefs.setBool(_languageSetupCompletedKey, true);
  }

  /// Detect system language and return it if supported
  /// Falls back to 'en' if system language is not in supported languages
  ///
  /// Automatically checks against all supported languages defined in AppLocalizations
  String detectSystemLanguage() {
    final systemLocale = PlatformDispatcher.instance.locale;
    final languageCode = systemLocale.languageCode;

    _logger.info(
      'System locale detected: $languageCode (full: ${systemLocale.toString()})',
    );

    // Get supported language codes from AppLocalizations (single source of truth)
    final supportedLanguages = AppLocalizations.supportedLocales
        .map((locale) => locale.languageCode)
        .toSet();

    // Return detected language if supported, otherwise default to English
    final detectedLanguage = supportedLanguages.contains(languageCode)
        ? languageCode
        : 'en';

    if (languageCode != detectedLanguage) {
      _logger.info(
        'Language "$languageCode" not supported, falling back to English',
      );
    } else {
      _logger.info('Detected supported language: $detectedLanguage');
    }

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
