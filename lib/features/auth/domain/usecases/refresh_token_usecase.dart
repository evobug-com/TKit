import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/twitch_token.dart';
import '../repositories/i_auth_repository.dart';

/// Use case for refreshing the authentication token
/// Encapsulates the business logic for token refresh
class RefreshTokenUseCase {
  final IAuthRepository repository;

  const RefreshTokenUseCase(this.repository);

  /// Execute the token refresh operation
  /// Returns `Either<Failure, TwitchToken>` with new token on success
  Future<Either<Failure, TwitchToken>> call() async {
    return await repository.refreshToken();
  }
}
