import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/i_twitch_api_repository.dart';

/// Use case for updating the channel's category/game
/// Encapsulates the business logic for channel updates
class UpdateChannelCategoryUseCase {
  final ITwitchApiRepository _repository;

  UpdateChannelCategoryUseCase(this._repository);

  /// Execute the channel category update
  ///
  /// [categoryId] The Twitch category ID to set
  /// Returns void on success or Failure on error
  Future<Either<Failure, void>> call(String categoryId) async {
    // Validate input
    if (categoryId.trim().isEmpty) {
      return const Left(
        ValidationFailure(
          message: 'Category ID cannot be empty',
          code: 'EMPTY_CATEGORY_ID',
        ),
      );
    }

    return await _repository.updateChannelCategory(categoryId.trim());
  }
}
