import 'package:dartz/dartz.dart';
import 'package:tkit/core/errors/exceptions.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/core/utils/app_logger.dart';
import 'package:tkit/features/settings/domain/entities/app_settings.dart';
import 'package:tkit/features/settings/domain/repositories/i_settings_repository.dart';
import 'package:tkit/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:tkit/features/settings/data/models/app_settings_model.dart';

/// Implementation of settings repository
/// Handles data layer logic and error conversion
class SettingsRepositoryImpl implements ISettingsRepository {
  final SettingsLocalDataSource _localDataSource;
  final AppLogger _logger;

  SettingsRepositoryImpl(this._localDataSource, this._logger);

  @override
  Future<Either<Failure, AppSettings>> getSettings() async {
    try {
      _logger.debug('Getting settings from repository');
      final settingsModel = await _localDataSource.getSettings();
      return Right(settingsModel.toEntity());
    } on CacheException catch (e) {
      _logger.error('Cache exception while getting settings', e);
      return Left(
        CacheFailure(message: e.message, originalError: e.originalError),
      );
    } catch (e, stackTrace) {
      _logger.error('Unexpected error getting settings', e, stackTrace);
      return Left(
        UnknownFailure(
          message: 'An unexpected error occurred while loading settings',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateSettings(AppSettings settings) async {
    try {
      _logger.debug('Updating settings in repository');

      // Validate settings first
      final validationError = settings.validate();
      if (validationError != null) {
        _logger.warning('Settings validation failed: $validationError');
        return Left(ValidationFailure(message: validationError));
      }

      // Convert to model and save
      final settingsModel = AppSettingsModel.fromEntity(settings);
      await _localDataSource.saveSettings(settingsModel);

      _logger.info('Settings updated successfully');
      return const Right(null);
    } on CacheException catch (e) {
      _logger.error('Cache exception while updating settings', e);
      return Left(
        CacheFailure(message: e.message, originalError: e.originalError),
      );
    } catch (e, stackTrace) {
      _logger.error('Unexpected error updating settings', e, stackTrace);
      return Left(
        UnknownFailure(
          message: 'An unexpected error occurred while saving settings',
          originalError: e,
        ),
      );
    }
  }

  @override
  Stream<AppSettings> watchSettings() {
    try {
      _logger.debug('Watching settings from repository');
      return _localDataSource.watchSettings().map((model) => model.toEntity());
    } catch (e, stackTrace) {
      _logger.error('Error setting up settings watch', e, stackTrace);
      // Return a stream with default settings in case of error
      return Stream.value(AppSettings.defaults());
    }
  }

  @override
  Future<Either<Failure, void>> clearSettings() async {
    try {
      _logger.info('Clearing all settings from repository');
      await _localDataSource.clearSettings();
      _logger.info('Settings cleared successfully');
      return const Right(null);
    } on CacheException catch (e) {
      _logger.error('Cache exception while clearing settings', e);
      return Left(
        CacheFailure(message: e.message, originalError: e.originalError),
      );
    } catch (e, stackTrace) {
      _logger.error('Unexpected error clearing settings', e, stackTrace);
      return Left(
        UnknownFailure(
          message: 'An unexpected error occurred while clearing settings',
          originalError: e,
        ),
      );
    }
  }
}
