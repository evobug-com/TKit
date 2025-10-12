import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/auth/data/datasources/token_local_datasource.dart';
import 'package:tkit/features/auth/domain/entities/twitch_token.dart';
import 'package:tkit/features/auth/domain/entities/twitch_user.dart';
import 'package:tkit/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:tkit/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:tkit/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:tkit/features/auth/domain/usecases/logout_usecase.dart';
import 'package:tkit/features/auth/domain/usecases/refresh_token_usecase.dart';
import 'package:tkit/features/auth/presentation/providers/auth_provider.dart';
import 'package:tkit/features/auth/presentation/states/auth_state.dart';

import 'auth_provider_test.mocks.dart';

@GenerateMocks([
  LogoutUseCase,
  CheckAuthStatusUseCase,
  RefreshTokenUseCase,
  GetCurrentUserUseCase,
  TokenLocalDataSource,
  IAuthRepository,
])
void main() {
  late AuthProvider authProvider;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockCheckAuthStatusUseCase mockCheckAuthStatusUseCase;
  late MockRefreshTokenUseCase mockRefreshTokenUseCase;
  late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;
  late MockTokenLocalDataSource mockTokenLocalDataSource;
  late MockIAuthRepository mockAuthRepository;

  setUp(() {
    mockLogoutUseCase = MockLogoutUseCase();
    mockCheckAuthStatusUseCase = MockCheckAuthStatusUseCase();
    mockRefreshTokenUseCase = MockRefreshTokenUseCase();
    mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();
    mockTokenLocalDataSource = MockTokenLocalDataSource();
    mockAuthRepository = MockIAuthRepository();

    authProvider = AuthProvider(
      mockLogoutUseCase,
      mockCheckAuthStatusUseCase,
      mockRefreshTokenUseCase,
      mockGetCurrentUserUseCase,
      mockTokenLocalDataSource,
      mockAuthRepository,
    );
  });

  tearDown(() {
    authProvider.dispose();
  });

  group('AuthProvider', () {
    const tUser = TwitchUser(
      id: '12345',
      login: 'testuser',
      displayName: 'Test User',
    );

    final tToken = TwitchToken(
      accessToken: 'test_access_token',
      refreshToken: 'test_refresh_token',
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
      scopes: ['channel:manage:broadcast'],
    );

    test('initial state should be AuthInitial', () {
      expect(authProvider.state, isA<AuthInitial>());
    });

    group('logout', () {
      test('should emit [AuthLoading, Unauthenticated] when logout succeeds',
          () async {
        // arrange
        when(mockLogoutUseCase()).thenAnswer((_) async => const Right(null));

        // act
        final states = <AuthState>[];
        authProvider.addListener(() {
          states.add(authProvider.state);
        });

        await authProvider.logout();

        // assert
        expect(states.length, 2);
        expect(states[0], isA<AuthLoading>());
        expect(states[1], isA<Unauthenticated>());
        verify(mockLogoutUseCase()).called(1);
      });

      test('should emit [AuthLoading, AuthError] when logout fails', () async {
        // arrange
        when(mockLogoutUseCase()).thenAnswer(
          (_) async => const Left(AuthFailure(message: 'Logout failed')),
        );

        // act
        final states = <AuthState>[];
        authProvider.addListener(() {
          states.add(authProvider.state);
        });

        await authProvider.logout();

        // assert
        expect(states.length, 2);
        expect(states[0], isA<AuthLoading>());
        expect(states[1], isA<AuthError>());
        expect((states[1] as AuthError).message, 'Logout failed');
      });
    });

    group('checkAuthStatus', () {
      test(
          'should emit [AuthLoading, Authenticated] when user is authenticated',
          () async {
        // arrange
        when(mockCheckAuthStatusUseCase())
            .thenAnswer((_) async => const Right(true));
        when(mockGetCurrentUserUseCase())
            .thenAnswer((_) async => const Right(tUser));

        // act
        final states = <AuthState>[];
        authProvider.addListener(() {
          states.add(authProvider.state);
        });

        await authProvider.checkAuthStatus();

        // assert
        expect(states.length, 2);
        expect(states[0], isA<AuthLoading>());
        expect(states[1], isA<Authenticated>());
        expect((states[1] as Authenticated).user, tUser);
        verify(mockCheckAuthStatusUseCase()).called(1);
        verify(mockGetCurrentUserUseCase()).called(1);
      });

      test(
          'should emit [AuthLoading, Unauthenticated] when user is not authenticated',
          () async {
        // arrange
        when(mockCheckAuthStatusUseCase())
            .thenAnswer((_) async => const Right(false));

        // act
        final states = <AuthState>[];
        authProvider.addListener(() {
          states.add(authProvider.state);
        });

        await authProvider.checkAuthStatus();

        // assert
        expect(states.length, 2);
        expect(states[0], isA<AuthLoading>());
        expect(states[1], isA<Unauthenticated>());
        verify(mockCheckAuthStatusUseCase()).called(1);
        verifyNever(mockGetCurrentUserUseCase());
      });

      test('should emit [AuthLoading, AuthError] when checkAuthStatus fails',
          () async {
        // arrange
        when(mockCheckAuthStatusUseCase()).thenAnswer(
          (_) async =>
              const Left(AuthFailure(message: 'Check auth status failed')),
        );

        // act
        final states = <AuthState>[];
        authProvider.addListener(() {
          states.add(authProvider.state);
        });

        await authProvider.checkAuthStatus();

        // assert
        expect(states.length, 2);
        expect(states[0], isA<AuthLoading>());
        expect(states[1], isA<AuthError>());
        expect((states[1] as AuthError).message, 'Check auth status failed');
      });

      test(
          'should emit [AuthLoading, Unauthenticated] when authenticated but get user fails',
          () async {
        // arrange
        when(mockCheckAuthStatusUseCase())
            .thenAnswer((_) async => const Right(true));
        when(mockGetCurrentUserUseCase())
            .thenAnswer((_) async => const Right(null));

        // act
        final states = <AuthState>[];
        authProvider.addListener(() {
          states.add(authProvider.state);
        });

        await authProvider.checkAuthStatus();

        // assert
        expect(states.length, 2);
        expect(states[0], isA<AuthLoading>());
        expect(states[1], isA<Unauthenticated>());
      });
    });

    group('refreshToken', () {
      test('should emit [TokenRefreshing] when refresh token is called',
          () async {
        // arrange
        when(mockRefreshTokenUseCase())
            .thenAnswer((_) async => Right(tToken));
        when(mockGetCurrentUserUseCase())
            .thenAnswer((_) async => const Right(tUser));

        // act
        final states = <AuthState>[];
        authProvider.addListener(() {
          states.add(authProvider.state);
        });

        await authProvider.refreshToken();

        // assert
        expect(states.isNotEmpty, true);
        expect(states[0], isA<TokenRefreshing>());
        verify(mockRefreshTokenUseCase()).called(1);
      });

      test(
          'should emit [TokenRefreshing, AuthError] when refresh fails',
          () async {
        // arrange
        when(mockRefreshTokenUseCase()).thenAnswer(
          (_) async => const Left(AuthFailure(message: 'Token refresh failed')),
        );

        // act
        final states = <AuthState>[];
        authProvider.addListener(() {
          states.add(authProvider.state);
        });

        await authProvider.refreshToken();

        // assert - check immediate states before delayed transition
        expect(states.length, 2);
        expect(states[0], isA<TokenRefreshing>());
        expect(states[1], isA<AuthError>());
        expect((states[1] as AuthError).message, 'Token refresh failed');

        // Note: The provider transitions to Unauthenticated after a 2-second delay,
        // but we don't test that here to avoid flaky tests in the test suite
      });
    });
  });
}
