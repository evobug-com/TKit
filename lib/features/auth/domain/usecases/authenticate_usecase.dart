import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/twitch_user.dart';
import '../repositories/i_auth_repository.dart';

/// Use case for authenticating a user via OAuth 2.0 with PKCE
/// Encapsulates the business logic for authentication
class AuthenticateUseCase {
  final IAuthRepository repository;

  const AuthenticateUseCase(this.repository);

  /// Execute the authentication flow
  /// Returns `Either<Failure, TwitchUser>` with user info on success
  Future<Either<Failure, TwitchUser>> call() async {
    return await repository.authenticate();
  }
}
