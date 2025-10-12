import 'package:flutter/foundation.dart';
import '../../data/datasources/token_local_datasource.dart';
import '../../data/models/device_code_response.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/refresh_token_usecase.dart';
import '../states/auth_state.dart';

/// Provider for managing authentication state
class AuthProvider extends ChangeNotifier {
  final LogoutUseCase _logoutUseCase;
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;
  final RefreshTokenUseCase _refreshTokenUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final TokenLocalDataSource _tokenLocalDataSource;
  final IAuthRepository _authRepository;

  AuthState _state = const AuthInitial();

  AuthState get state => _state;

  AuthProvider(
    this._logoutUseCase,
    this._checkAuthStatusUseCase,
    this._refreshTokenUseCase,
    this._getCurrentUserUseCase,
    this._tokenLocalDataSource,
    this._authRepository,
  );

  void _updateState(AuthState newState) {
    _state = newState;
    notifyListeners();
  }

  /// Logout user
  Future<void> logout() async {
    _updateState(const AuthLoading(message: null));

    final result = await _logoutUseCase();

    result.fold(
      (failure) =>
          _updateState(AuthError(message: failure.message, code: failure.code)),
      (_) => _updateState(const Unauthenticated()),
    );
  }

  /// Check authentication status
  Future<void> checkAuthStatus() async {
    _updateState(const AuthLoading(message: null));

    final result = await _checkAuthStatusUseCase();

    await result.fold(
      (failure) async =>
          _updateState(AuthError(message: failure.message, code: failure.code)),
      (isAuthenticated) async {
        if (isAuthenticated) {
          // Get user info if authenticated
          final userResult = await _getCurrentUserUseCase();
          userResult.fold(
            (failure) => _updateState(
              AuthError(message: failure.message, code: failure.code),
            ),
            (user) {
              if (user != null) {
                _updateState(Authenticated(user));
              } else {
                _updateState(const Unauthenticated());
              }
            },
          );
        } else {
          _updateState(const Unauthenticated());
        }
      },
    );
  }

  /// Refresh authentication token
  Future<void> refreshToken() async {
    final currentState = _state;

    _updateState(const TokenRefreshing());

    final result = await _refreshTokenUseCase();

    result.fold(
      (failure) {
        // If refresh fails, user needs to re-authenticate
        _updateState(AuthError(message: failure.message, code: failure.code));
        // Transition to unauthenticated after error
        Future.delayed(
          const Duration(seconds: 2),
          () => _updateState(const Unauthenticated()),
        );
      },
      (token) {
        // Token refreshed successfully, restore previous state if was authenticated
        if (currentState is Authenticated) {
          _updateState(currentState);
        } else {
          // Get user info to transition to authenticated state
          _getCurrentUserUseCase().then((userResult) {
            userResult.fold(
              (failure) => _updateState(const Unauthenticated()),
              (user) {
                if (user != null) {
                  _updateState(Authenticated(user));
                } else {
                  _updateState(const Unauthenticated());
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
      final token = await _tokenLocalDataSource.getToken();
      return token?.expiresAt;
    } catch (e) {
      return null;
    }
  }

  /// Initiate Device Code Flow authentication
  /// Returns DeviceCodeResponse with user code and verification URI
  Future<DeviceCodeResponse?> initiateDeviceCodeAuth() async {
    _updateState(const AuthLoading(message: 'Initiating authentication...'));

    final result = await _authRepository.initiateDeviceCodeAuth();

    return result.fold(
      (failure) {
        _updateState(AuthError(message: failure.message, code: failure.code));
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
          _updateState(AuthError(message: failure.message, code: failure.code));
        }
        // Re-throw so the UI can handle it
        throw Exception(failure.code);
      },
      (user) => _updateState(Authenticated(user)),
    );
  }
}
