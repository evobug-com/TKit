import 'package:dartz/dartz.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/category_mapping/domain/entities/category_mapping.dart';
import 'package:tkit/features/category_mapping/domain/repositories/i_category_mapping_repository.dart';

/// Use case for finding a category mapping by process name
///
/// Encapsulates the business logic for finding the best matching category
/// for a given process, including fuzzy matching logic.
class FindMappingUseCase {
  final ICategoryMappingRepository repository;

  FindMappingUseCase(this.repository);

  /// Execute the use case
  ///
  /// [processName] - The name of the process to find a mapping for
  /// [executablePath] - Optional path to the executable for more precise matching
  ///
  /// Returns the best matching CategoryMapping or null if no suitable match found
  Future<Either<Failure, CategoryMapping?>> call({
    required String processName,
    String? executablePath,
  }) async {
    return await repository.findMapping(processName, executablePath);
  }
}
