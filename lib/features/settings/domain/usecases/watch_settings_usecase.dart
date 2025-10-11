import '../entities/app_settings.dart';
import '../repositories/i_settings_repository.dart';

/// Use case for watching settings changes
/// Returns a stream that emits settings updates in real-time
class WatchSettingsUseCase {
  final ISettingsRepository _repository;

  WatchSettingsUseCase(this._repository);

  /// Execute the use case
  /// Returns a stream of [AppSettings]
  Stream<AppSettings> call() {
    return _repository.watchSettings();
  }
}
