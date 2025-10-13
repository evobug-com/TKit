import 'package:dartz/dartz.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/twitch_api/domain/entities/twitch_user.dart';
import 'package:tkit/features/twitch_api/domain/repositories/i_twitch_api_repository.dart';

/// Use case for getting the current authenticated user's information
/// Encapsulates the business logic for fetching user data
class GetCurrentUserUseCase {
  final ITwitchApiRepository _repository;

  GetCurrentUserUseCase(this._repository);

  /// Execute the get current user operation
  ///
  /// Returns the authenticated user's information or Failure
  Future<Either<Failure, TwitchUser>> call() async {
    return await _repository.getCurrentUser();
  }
}
