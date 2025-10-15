import 'package:dartz/dartz.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/category_mapping/domain/repositories/i_category_mapping_repository.dart';

/// Use case for deleting a category mapping
///
/// Removes a mapping from the database by its ID
class DeleteMappingUseCase {
  final ICategoryMappingRepository repository;

  DeleteMappingUseCase(this.repository);

  /// Execute the use case
  ///
  /// [id] - The ID of the mapping to delete
  ///
  /// Returns success or failure
  Future<Either<Failure, void>> call(int id) async {
    if (id <= 0) {
      return const Left(ValidationFailure(message: 'Invalid mapping ID'));
    }

    return await repository.deleteMapping(id);
  }
}
