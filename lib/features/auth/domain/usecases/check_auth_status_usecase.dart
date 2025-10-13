import 'package:dartz/dartz.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/auth/domain/repositories/i_auth_repository.dart';

/// Use case for checking if the user is authenticated
/// Encapsulates the business logic for auth status check
class CheckAuthStatusUseCase {
  final IAuthRepository repository;

  const CheckAuthStatusUseCase(this.repository);

  /// Execute the authentication status check
  /// Returns `Either<Failure, bool>` indicating if user is authenticated
  Future<Either<Failure, bool>> call() async {
    return await repository.isAuthenticated();
  }
}
