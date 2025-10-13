import 'package:dartz/dartz.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/community_mappings/domain/repositories/i_community_mappings_repository.dart';

/// Use case for submitting a new mapping or verification to the community
///
/// Checks for duplicates and creates either a new mapping submission
/// or a verification issue for existing mappings.
class SubmitMappingUseCase {
  final ICommunityMappingsRepository repository;

  SubmitMappingUseCase(this.repository);

  /// Execute the use case
  ///
  /// Validates and submits the mapping to GitHub Issues
  ///
  /// Returns a map with submission details:
  /// - success: bool
  /// - isVerification: bool (true if verifying existing mapping)
  /// - issueUrl: String? (GitHub issue URL)
  /// - issueNumber: int? (GitHub issue number)
  /// - message: String (user-friendly message)
  Future<Either<Failure, Map<String, dynamic>>> call({
    required String processName,
    required String twitchCategoryId,
    required String twitchCategoryName,
    String? windowTitle,
    String? normalizedInstallPath,
  }) async {
    // Validation
    if (processName.trim().isEmpty) {
      return Left(
        ValidationFailure(
          message: 'Process name cannot be empty',
          code: 'INVALID_PROCESS_NAME',
        ),
      );
    }

    if (twitchCategoryId.trim().isEmpty) {
      return Left(
        ValidationFailure(
          message: 'Category ID cannot be empty',
          code: 'INVALID_CATEGORY_ID',
        ),
      );
    }

    if (twitchCategoryName.trim().isEmpty) {
      return Left(
        ValidationFailure(
          message: 'Category name cannot be empty',
          code: 'INVALID_CATEGORY_NAME',
        ),
      );
    }

    return await repository.submitMapping(
      processName: processName.trim(),
      twitchCategoryId: twitchCategoryId.trim(),
      twitchCategoryName: twitchCategoryName.trim(),
      windowTitle: windowTitle?.trim(),
      normalizedInstallPath: normalizedInstallPath,
    );
  }
}
