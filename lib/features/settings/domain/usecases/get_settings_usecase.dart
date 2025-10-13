import 'package:dartz/dartz.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/settings/domain/entities/app_settings.dart';
import 'package:tkit/features/settings/domain/repositories/i_settings_repository.dart';

/// Use case for getting current settings
/// Follows Single Responsibility Principle
class GetSettingsUseCase {
  final ISettingsRepository _repository;

  GetSettingsUseCase(this._repository);

  /// Execute the use case
  /// Returns [AppSettings] on success, [Failure] on error
  Future<Either<Failure, AppSettings>> call() async {
    return await _repository.getSettings();
  }
}
