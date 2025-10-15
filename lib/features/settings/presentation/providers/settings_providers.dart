import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tkit/core/providers/datasource_providers.dart';
import 'package:tkit/core/providers/providers.dart';
import 'package:tkit/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:tkit/features/settings/domain/repositories/i_settings_repository.dart';
import 'package:tkit/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:tkit/features/settings/domain/usecases/update_settings_usecase.dart';
import 'package:tkit/features/settings/domain/usecases/watch_settings_usecase.dart';
import 'package:tkit/features/settings/presentation/states/settings_state.dart';
import 'package:tkit/features/settings/domain/entities/app_settings.dart';

part 'settings_providers.g.dart';

// =============================================================================
// SETTINGS REPOSITORY
// =============================================================================

@Riverpod(keepAlive: true)
Future<ISettingsRepository> settingsRepository(Ref ref) async {
  final dataSource = await ref.watch(settingsLocalDataSourceProvider.future);
  final logger = ref.watch(appLoggerProvider);
  return SettingsRepositoryImpl(dataSource, logger);
}

// =============================================================================
// SETTINGS USE CASES
// =============================================================================

@Riverpod(keepAlive: true)
Future<GetSettingsUseCase> getSettingsUseCase(Ref ref) async {
  final repository = await ref.watch(settingsRepositoryProvider.future);
  return GetSettingsUseCase(repository);
}

@Riverpod(keepAlive: true)
Future<UpdateSettingsUseCase> updateSettingsUseCase(Ref ref) async {
  final repository = await ref.watch(settingsRepositoryProvider.future);
  return UpdateSettingsUseCase(repository);
}

@Riverpod(keepAlive: true)
Future<WatchSettingsUseCase> watchSettingsUseCase(Ref ref) async {
  final repository = await ref.watch(settingsRepositoryProvider.future);
  return WatchSettingsUseCase(repository);
}

// =============================================================================
// SETTINGS STATE NOTIFIER
// =============================================================================

@Riverpod(keepAlive: true)
class Settings extends _$Settings {
  @override
  SettingsState build() {
    return const SettingsInitial();
  }

  /// Load settings
  Future<void> loadSettings() async {
    final logger = ref.read(appLoggerProvider);
    logger.debug('Loading settings');
    state = const SettingsLoading();

    final useCase = await ref.read(getSettingsUseCaseProvider.future);
    final result = await useCase();

    result.fold(
      (failure) {
        logger.error('Failed to load settings: ${failure.message}');
        state = SettingsError(failure.message);
      },
      (settings) {
        logger.info('Settings loaded successfully');
        state = SettingsLoaded(settings);
      },
    );
  }

  /// Update settings
  Future<void> updateSettings(AppSettings settings) async {
    final logger = ref.read(appLoggerProvider);
    logger.debug('Updating settings');

    // Show saving state
    state = SettingsSaving(settings);

    final useCase = await ref.read(updateSettingsUseCaseProvider.future);
    final result = await useCase(settings);

    result.fold(
      (failure) {
        logger.error('Failed to update settings: ${failure.message}');
        final currentState = state;
        final currentSettings = currentState is SettingsSaving ? currentState.settings : null;
        state = SettingsError(failure.message, currentSettings: currentSettings);
      },
      (_) {
        logger.info('Settings updated successfully');
        state = SettingsSaved(settings);
        // Transition to loaded state after a short delay
        Future.delayed(const Duration(milliseconds: 100), () {
          if (state is SettingsSaved) {
            state = SettingsLoaded(settings);
          }
        });
      },
    );
  }
}
