import 'package:dartz/dartz.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/category_mapping/domain/entities/category_mapping.dart';
import 'package:tkit/features/category_mapping/domain/repositories/i_category_mapping_repository.dart';

/// Use case for saving (creating or updating) a category mapping
///
/// Validates the mapping and delegates to the repository for persistence
class SaveMappingUseCase {
  final ICategoryMappingRepository repository;

  SaveMappingUseCase(this.repository);

  /// Execute the use case
  ///
  /// [mapping] - The CategoryMapping to save (create if id is null, update otherwise)
  ///
  /// Returns success or failure
  Future<Either<Failure, void>> call(CategoryMapping mapping) async {
    // Validation
    if (mapping.processName.trim().isEmpty) {
      return const Left(
        ValidationFailure(message: 'Process name cannot be empty'),
      );
    }

    if (mapping.twitchCategoryId.trim().isEmpty) {
      return const Left(
        ValidationFailure(message: 'Twitch category ID cannot be empty'),
      );
    }

    if (mapping.twitchCategoryName.trim().isEmpty) {
      return const Left(
        ValidationFailure(message: 'Twitch category name cannot be empty'),
      );
    }

    return await repository.saveMapping(mapping);
  }
}
