import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tkit/core/providers/datasource_providers.dart';
import 'package:tkit/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:tkit/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:tkit/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:tkit/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:tkit/features/auth/domain/usecases/logout_usecase.dart';
import 'package:tkit/features/auth/domain/usecases/refresh_token_usecase.dart';
import 'package:tkit/features/auth/presentation/states/auth_state.dart';

part 'auth_providers.g.dart';

// =============================================================================
// AUTH REPOSITORY
// =============================================================================

@Riverpod(keepAlive: true)
IAuthRepository authRepository(Ref ref) {
  final twitchAuthRemoteDataSource = ref.watch(twitchAuthRemoteDataSourceProvider);
  final tokenLocalDataSource = ref.watch(tokenLocalDataSourceProvider);

  return AuthRepositoryImpl(
    twitchAuthRemoteDataSource,
    tokenLocalDataSource,
  );
}

// =============================================================================
// AUTH USE CASES
// =============================================================================

@Riverpod(keepAlive: true)
CheckAuthStatusUseCase checkAuthStatusUseCase(Ref ref) {
  final repository = ref.watch(authRepositoryProvider);
  return CheckAuthStatusUseCase(repository);
}

@Riverpod(keepAlive: true)
GetCurrentUserUseCase getCurrentUserUseCase(Ref ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GetCurrentUserUseCase(repository);
}

@Riverpod(keepAlive: true)
LogoutUseCase logoutUseCase(Ref ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LogoutUseCase(repository);
}

@Riverpod(keepAlive: true)
RefreshTokenUseCase refreshTokenUseCase(Ref ref) {
  final repository = ref.watch(authRepositoryProvider);
  return RefreshTokenUseCase(repository);
}

// =============================================================================
// AUTH STATE NOTIFIER
// =============================================================================

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  @override
  AuthState build() {
    return const AuthInitial();
  }

  // Get dependencies from ref
  IAuthRepository get _authRepository => ref.read(authRepositoryProvider);
  LogoutUseCase get _logoutUseCase => ref.read(logoutUseCaseProvider);
  CheckAuthStatusUseCase get _checkAuthStatusUseCase => ref.read(checkAuthStatusUseCaseProvider);
  RefreshTokenUseCase get _refreshTokenUseCase => ref.read(refreshTokenUseCaseProvider);
  GetCurrentUserUseCase get _getCurrentUserUseCase => ref.read(getCurrentUserUseCaseProvider);

  /// Logout user
  Future<void> logout() async {
    state = const AuthLoading(message: null);

    final result = await _logoutUseCase();

    result.fold(
      (failure) => state = AuthError(message: failure.message, code: failure.code),
      (_) => state = const Unauthenticated(),
    );
  }

  /// Check authentication status
  Future<void> checkAuthStatus() async {
    state = const AuthLoading(message: null);

    final result = await _checkAuthStatusUseCase();

    await result.fold(
      (failure) async {
        state = AuthError(message: failure.message, code: failure.code);
      },
      (isAuthenticated) async {
        if (isAuthenticated) {
          // Get user info if authenticated
          final userResult = await _getCurrentUserUseCase();
          userResult.fold(
            (failure) {
              state = AuthError(message: failure.message, code: failure.code);
            },
            (user) {
              if (user != null) {
                state = Authenticated(user);
              } else {
                state = const Unauthenticated();
              }
            },
          );
        } else {
          state = const Unauthenticated();
        }
      },
    );
  }

  /// Refresh authentication token
  Future<void> refreshToken() async {
    final currentState = state;

    state = const TokenRefreshing();

    final result = await _refreshTokenUseCase();

    result.fold(
      (failure) {
        // If refresh fails, user needs to re-authenticate
        state = AuthError(message: failure.message, code: failure.code);
        // Transition to unauthenticated after error
        Future.delayed(
          const Duration(seconds: 2),
          () => state = const Unauthenticated(),
        );
      },
      (token) {
        // Token refreshed successfully, restore previous state if was authenticated
        if (currentState is Authenticated) {
          state = currentState;
        } else {
          // Get user info to transition to authenticated state
          _getCurrentUserUseCase().then((userResult) {
            userResult.fold(
              (failure) => state = const Unauthenticated(),
              (user) {
                if (user != null) {
                  state = Authenticated(user);
                } else {
                  state = const Unauthenticated();
                }
              },
            );
          });
        }
      },
    );
  }

  /// Get token expiration date/time
  /// Returns null if no token is stored or an error occurs
  Future<DateTime?> getTokenExpiration() async {
    try {
      final tokenDataSource = ref.read(tokenLocalDataSourceProvider);
      final token = await tokenDataSource.getToken();
      return token?.expiresAt;
    } catch (e) {
      return null;
    }
  }

  /// Initiate Device Code Flow authentication
  /// Returns DeviceCodeResponse with user code and verification URI
  Future<dynamic> initiateDeviceCodeAuth() async {
    state = const AuthLoading(message: 'Initiating authentication...');

    final result = await _authRepository.initiateDeviceCodeAuth();

    return result.fold(
      (failure) {
        state = AuthError(message: failure.message, code: failure.code);
        return null;
      },
      (deviceCodeResponse) {
        return deviceCodeResponse;
      },
    );
  }

  /// Complete Device Code Flow authentication by polling
  /// Called automatically by DeviceCodeAuthPage
  Future<void> authenticateWithDeviceCode(String deviceCode) async {
    final result = await _authRepository.authenticateWithDeviceCode(deviceCode);

    result.fold(
      (failure) {
        // Only update state for real errors, not authorization_pending
        if (failure.code != 'AUTHORIZATION_PENDING' &&
            failure.code != 'SLOW_DOWN') {
          state = AuthError(message: failure.message, code: failure.code);
        }
        // Re-throw so the UI can handle it
        throw Exception(failure.code);
      },
      (user) => state = Authenticated(user),
    );
  }
}
