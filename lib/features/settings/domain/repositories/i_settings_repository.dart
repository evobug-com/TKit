import 'package:dartz/dartz.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/settings/domain/entities/app_settings.dart';

/// Abstract repository interface for settings management
/// Follows Repository pattern from Clean Architecture
abstract class ISettingsRepository {
  /// Get current settings
  /// Returns [AppSettings] on success, [Failure] on error
  Future<Either<Failure, AppSettings>> getSettings();

  /// Update settings
  /// Returns [void] on success, [Failure] on error
  Future<Either<Failure, void>> updateSettings(AppSettings settings);

  /// Watch settings for real-time updates
  /// Returns a stream that emits settings changes
  Stream<AppSettings> watchSettings();

  /// Clear all settings and return to defaults
  /// Returns [void] on success, [Failure] on error
  Future<Either<Failure, void>> clearSettings();
}
