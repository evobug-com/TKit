import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/i_auth_repository.dart';

/// Use case for logging out the current user
/// Encapsulates the business logic for logout
class LogoutUseCase {
  final IAuthRepository repository;

  const LogoutUseCase(this.repository);

  /// Execute the logout operation
  /// Returns `Either<Failure, void>` on success
  Future<Either<Failure, void>> call() async {
    return await repository.logout();
  }
}
