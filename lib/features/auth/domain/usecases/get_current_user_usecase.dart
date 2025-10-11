import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/twitch_user.dart';
import '../repositories/i_auth_repository.dart';

/// Use case for getting the current authenticated user
/// Encapsulates the business logic for retrieving current user
class GetCurrentUserUseCase {
  final IAuthRepository repository;

  const GetCurrentUserUseCase(this.repository);

  /// Execute the get current user operation
  /// Returns `Either<Failure, TwitchUser?>` with user or null if not authenticated
  Future<Either<Failure, TwitchUser?>> call() async {
    return await repository.getCurrentUser();
  }
}
