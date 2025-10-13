import 'package:dartz/dartz.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/category_mapping/domain/entities/category_mapping.dart';
import 'package:tkit/features/category_mapping/domain/repositories/i_category_mapping_repository.dart';

/// Use case for retrieving all category mappings
///
/// Returns all mappings ordered by last used date for display in the UI
class GetAllMappingsUseCase {
  final ICategoryMappingRepository repository;

  GetAllMappingsUseCase(this.repository);

  /// Execute the use case
  ///
  /// Returns a list of all CategoryMapping entities
  Future<Either<Failure, List<CategoryMapping>>> call() async {
    return await repository.getAllMappings();
  }
}
