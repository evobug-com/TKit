import 'package:dartz/dartz.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/category_mapping/domain/repositories/i_category_mapping_repository.dart';

/// Use case for updating the last used timestamp of a mapping
///
/// Called when a mapping is successfully used to track active mappings
class UpdateLastUsedUseCase {
  final ICategoryMappingRepository repository;

  UpdateLastUsedUseCase(this.repository);

  /// Execute the use case
  ///
  /// [id] - The ID of the mapping to update
  ///
  /// Returns success or failure
  Future<Either<Failure, void>> call(int id) async {
    if (id <= 0) {
      return Left(ValidationFailure(message: 'Invalid mapping ID'));
    }

    return await repository.updateLastUsed(id);
  }
}
