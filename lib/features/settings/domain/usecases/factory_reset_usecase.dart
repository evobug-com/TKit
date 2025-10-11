import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/i_settings_repository.dart';

/// Use case for performing factory reset
/// Clears all app data: settings, database, auth tokens, and preferences
class FactoryResetUseCase {
  final ISettingsRepository _settingsRepository;
  final AppDatabase _database;
  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _sharedPreferences;

  FactoryResetUseCase(
    this._settingsRepository,
    this._database,
    this._secureStorage,
    this._sharedPreferences,
  );

  /// Execute the factory reset
  /// Clears all app data and returns to factory defaults
  /// Returns [void] on success, [Failure] on error
  Future<Either<Failure, void>> call() async {
    try {
      // Clear settings (returns to defaults)
      final settingsResult = await _settingsRepository.clearSettings();
      if (settingsResult.isLeft()) {
        return settingsResult;
      }

      // Clear database (deletes all tables and reseeds)
      await _database.clearAllData();

      // Clear auth tokens from secure storage
      await _secureStorage.deleteAll();

      // Clear all SharedPreferences keys for true factory reset
      await _sharedPreferences.clear();

      return const Right(null);
    } catch (e) {
      return Left(
        UnknownFailure(
          message: 'Failed to perform factory reset: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }
}
