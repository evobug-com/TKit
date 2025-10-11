import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/usecases/get_settings_usecase.dart';
import '../../domain/usecases/update_settings_usecase.dart';
import '../../domain/usecases/watch_settings_usecase.dart';
import '../states/settings_state.dart';

/// Provider for managing settings state using ChangeNotifier
class SettingsProvider extends ChangeNotifier {
  final GetSettingsUseCase _getSettingsUseCase;
  final UpdateSettingsUseCase _updateSettingsUseCase;
  final WatchSettingsUseCase _watchSettingsUseCase;
  final AppLogger _logger;

  StreamSubscription<AppSettings>? _settingsSubscription;
  AppSettings? _originalSettings;
  SettingsState _state = const SettingsInitial();

  SettingsProvider(
    this._getSettingsUseCase,
    this._updateSettingsUseCase,
    this._watchSettingsUseCase,
    this._logger,
  );

  /// Current state
  SettingsState get state => _state;

  /// Update state and notify listeners
  void _setState(SettingsState newState) {
    _state = newState;
    notifyListeners();
  }

  /// Load settings
  Future<void> loadSettings() async {
    _logger.debug('Loading settings');
    _setState(const SettingsLoading());

    final result = await _getSettingsUseCase();

    result.fold(
      (failure) {
        _logger.error('Failed to load settings: ${failure.message}');
        _setState(SettingsError(failure.message));
      },
      (settings) {
        _logger.info('Settings loaded successfully');
        _originalSettings = settings;
        _setState(SettingsLoaded(settings));
      },
    );
  }

  /// Update settings
  Future<void> updateSettings(AppSettings settings) async {
    _logger.debug('Updating settings');

    // Show saving state
    _setState(SettingsSaving(settings));

    final result = await _updateSettingsUseCase(settings);

    result.fold(
      (failure) {
        _logger.error('Failed to update settings: ${failure.message}');
        _setState(
          SettingsError(failure.message, currentSettings: _originalSettings),
        );
      },
      (_) {
        _logger.info('Settings updated successfully');
        _originalSettings = settings;
        _setState(SettingsSaved(settings));
        // Transition to loaded state after a short delay
        // This allows the UI to process the SettingsSaved state first
        Future.delayed(const Duration(milliseconds: 100), () {
          _setState(SettingsLoaded(settings));
        });
      },
    );
  }

  /// Start watching settings for changes
  Future<void> startWatchingSettings() async {
    _logger.debug('Starting settings watch');

    await _settingsSubscription?.cancel();
    _settingsSubscription = _watchSettingsUseCase().listen(
      (settings) {
        _onSettingsChanged(settings);
      },
      onError: (error) {
        _logger.error('Error in settings watch stream', error);
      },
    );
  }

  /// Handle settings changed (from watch stream)
  void _onSettingsChanged(AppSettings settings) {
    _logger.debug('Settings changed from watch stream');

    // Only emit if not currently saving (avoid conflicts)
    if (_state is! SettingsSaving) {
      _originalSettings = settings;
      _setState(SettingsLoaded(settings));
    }
  }

  /// Check if current settings have unsaved changes
  bool hasUnsavedChanges(AppSettings currentSettings) {
    if (_originalSettings == null) return false;
    return currentSettings != _originalSettings;
  }

  @override
  void dispose() {
    _settingsSubscription?.cancel();
    super.dispose();
  }
}
