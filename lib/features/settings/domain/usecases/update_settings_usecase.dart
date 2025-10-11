import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/app_settings.dart';
import '../repositories/i_settings_repository.dart';

/// Use case for updating settings
/// Validates settings before updating
class UpdateSettingsUseCase {
  final ISettingsRepository _repository;

  UpdateSettingsUseCase(this._repository);

  /// Execute the use case
  /// Validates settings first, then updates if valid
  /// Returns [void] on success, [Failure] on error
  Future<Either<Failure, void>> call(AppSettings settings) async {
    // Validate settings
    final validationError = settings.validate();
    if (validationError != null) {
      return Left(ValidationFailure(message: validationError));
    }

    // Update if valid
    return await _repository.updateSettings(settings);
  }
}
