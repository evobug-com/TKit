import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../data/models/device_code_response.dart';
import '../entities/twitch_token.dart';
import '../entities/twitch_user.dart';

/// Abstract repository interface for authentication operations
/// Defines the contract that the data layer must implement
abstract class IAuthRepository {
  /// Initiates Device Code Flow authentication
  /// Returns `Either<Failure, DeviceCodeResponse>` with device code and user code
  Future<Either<Failure, DeviceCodeResponse>> initiateDeviceCodeAuth();

  /// Polls for device code authorization and completes authentication
  /// Returns `Either<Failure, TwitchUser>` on success with user info
  Future<Either<Failure, TwitchUser>> authenticateWithDeviceCode(String deviceCode);

  /// Logs out the current user by revoking tokens and clearing local storage
  /// Returns `Either<Failure, void>` on success
  Future<Either<Failure, void>> logout();

  /// Refreshes the current access token using the refresh token
  /// Returns `Either<Failure, TwitchToken>` with new token on success
  Future<Either<Failure, TwitchToken>> refreshToken();

  /// Checks if the user is currently authenticated (has valid token)
  /// Returns `Either<Failure, bool>` indicating authentication status
  Future<Either<Failure, bool>> isAuthenticated();

  /// Gets the current stored token if available
  /// Returns `Either<Failure, TwitchToken?>` with token or null if not authenticated
  Future<Either<Failure, TwitchToken?>> getCurrentToken();

  /// Gets the current authenticated user info
  /// Returns `Either<Failure, TwitchUser?>` with user or null if not authenticated
  Future<Either<Failure, TwitchUser?>> getCurrentUser();
}
