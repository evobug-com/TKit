import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/twitch_category.dart';
import '../repositories/i_twitch_api_repository.dart';

/// Use case for getting a category by its ID
/// Useful for retrieving detailed information about a specific category
class GetCategoryByIdUseCase {
  final ITwitchApiRepository _repository;

  GetCategoryByIdUseCase(this._repository);

  /// Execute the get category by ID operation
  ///
  /// [categoryId] The Twitch category ID
  /// Returns the category details or Failure
  Future<Either<Failure, TwitchCategory>> call(String categoryId) async {
    // Validate input
    if (categoryId.trim().isEmpty) {
      return const Left(
        ValidationFailure(
          message: 'Category ID cannot be empty',
          code: 'EMPTY_CATEGORY_ID',
        ),
      );
    }

    return await _repository.getCategoryById(categoryId.trim());
  }
}
