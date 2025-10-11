import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:tkit/features/auth/data/datasources/token_local_datasource.dart';
import 'package:tkit/features/auth/data/datasources/twitch_auth_remote_datasource.dart';
import 'package:tkit/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:tkit/features/auth/domain/usecases/authenticate_usecase.dart';
import 'package:tkit/features/auth/domain/usecases/logout_usecase.dart';
import 'package:tkit/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:tkit/features/auth/domain/usecases/refresh_token_usecase.dart';
import 'package:tkit/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:tkit/features/auth/presentation/providers/auth_provider.dart';
import 'package:tkit/features/auth/presentation/states/auth_state.dart';

import 'auth_integration_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<FlutterSecureStorage>(),
  MockSpec<Dio>(),
])
void main() {
  group('Authentication Integration Tests', () {
    late MockFlutterSecureStorage mockSecureStorage;
    late MockDio mockDio;
    late TokenLocalDataSource localDataSource;
    late TwitchAuthRemoteDataSource remoteDataSource;
    late AuthRepositoryImpl repository;
    late AuthenticateUseCase authenticateUseCase;
    late LogoutUseCase logoutUseCase;
    late CheckAuthStatusUseCase checkAuthStatusUseCase;
    late RefreshTokenUseCase refreshTokenUseCase;
    late GetCurrentUserUseCase getCurrentUserUseCase;

    setUp(() {
      // Create fresh mock instances for each test
      mockSecureStorage = MockFlutterSecureStorage();
      mockDio = MockDio();

      localDataSource = TokenLocalDataSource(mockSecureStorage);
      remoteDataSource = TwitchAuthRemoteDataSource(mockDio);
      repository = AuthRepositoryImpl(remoteDataSource, localDataSource);

      authenticateUseCase = AuthenticateUseCase(repository);
      logoutUseCase = LogoutUseCase(repository);
      checkAuthStatusUseCase = CheckAuthStatusUseCase(repository);
      refreshTokenUseCase = RefreshTokenUseCase(repository);
      getCurrentUserUseCase = GetCurrentUserUseCase(repository);
    });

    group('Full OAuth Flow (Mocked)', () {
      test('should complete full authentication flow successfully', () async {
        // This test demonstrates the integration between layers
        // Note: Full OAuth flow requires browser interaction, so this is conceptual

        // Arrange
        when(
          mockSecureStorage.read(key: 'twitch_token'),
        ).thenAnswer((_) async => null);

        // Assert initial state: not authenticated
        final initialAuthStatus = await checkAuthStatusUseCase();
        expect(initialAuthStatus.isRight(), true);
        initialAuthStatus.fold(
          (failure) => fail('Should not fail'),
          (isAuthenticated) => expect(isAuthenticated, false),
        );

        // Note: Actual OAuth flow would involve:
        // 1. Launching browser
        // 2. User authorization
        // 3. Callback with authorization code
        // 4. Token exchange
        // 5. Saving token locally

        // For integration testing, we verify the data flow between layers
        verify(
          mockSecureStorage.read(key: 'twitch_token'),
        ).called(greaterThan(0));
      });

      test('should persist token across sessions', () async {
        // Arrange
        const tokenJson =
            '{"accessToken":"test_token","refreshToken":"test_refresh","expiresAt":"2025-12-31T23:59:59.000Z","scopes":["channel:manage:broadcast"]}';

        when(
          mockSecureStorage.read(key: 'twitch_token'),
        ).thenAnswer((_) async => tokenJson);

        // Act
        final authStatus = await checkAuthStatusUseCase();

        // Assert
        expect(authStatus.isRight(), true);
        verify(
          mockSecureStorage.read(key: 'twitch_token'),
        ).called(greaterThan(0));
      });

      test('should clear all data on logout', () async {
        // Arrange
        when(
          mockSecureStorage.read(key: 'twitch_token'),
        ).thenAnswer((_) async => null);
        when(
          mockSecureStorage.delete(key: 'twitch_token'),
        ).thenAnswer((_) async => {});
        when(
          mockSecureStorage.delete(key: 'twitch_user'),
        ).thenAnswer((_) async => {});

        // Act
        final logoutResult = await logoutUseCase();

        // Assert
        expect(logoutResult.isRight(), true);
        verify(mockSecureStorage.delete(key: 'twitch_token')).called(1);
        verify(mockSecureStorage.delete(key: 'twitch_user')).called(1);
      });
    });

    group('Auth Provider Integration', () {
      late AuthProvider authProvider;

      setUp(() {
        authProvider = AuthProvider(
          authenticateUseCase,
          logoutUseCase,
          checkAuthStatusUseCase,
          refreshTokenUseCase,
          getCurrentUserUseCase,
          localDataSource,
          repository,
        );
      });

      tearDown(() {
        authProvider.dispose();
      });

      test('should transition through states during logout', () async {
        // Arrange
        when(
          mockSecureStorage.read(key: 'twitch_token'),
        ).thenAnswer((_) async => null);
        when(
          mockSecureStorage.delete(key: 'twitch_token'),
        ).thenAnswer((_) async => {});
        when(
          mockSecureStorage.delete(key: 'twitch_user'),
        ).thenAnswer((_) async => {});

        final states = <AuthState>[];
        authProvider.addListener(() {
          states.add(authProvider.state);
        });

        // Act
        await authProvider.logout();

        // Assert
        expect(states.length, 2);
        expect(states[0], const AuthLoading(message: null));
        expect(states[1], const Unauthenticated());
        verify(mockSecureStorage.delete(key: 'twitch_token')).called(1);
        verify(mockSecureStorage.delete(key: 'twitch_user')).called(1);
      });

      test('should check auth status on initialization', () async {
        // Arrange
        when(
          mockSecureStorage.read(key: 'twitch_token'),
        ).thenAnswer((_) async => null);

        final states = <AuthState>[];
        authProvider.addListener(() {
          states.add(authProvider.state);
        });

        // Act
        await authProvider.checkAuthStatus();

        // Assert
        expect(states.length, 2);
        expect(states[0], const AuthLoading(message: null));
        expect(states[1], const Unauthenticated());
        verify(
          mockSecureStorage.read(key: 'twitch_token'),
        ).called(greaterThan(0));
      });
    });

    group('Token Refresh Integration', () {
      test('should automatically refresh expired token', () async {
        // Arrange - Expired token
        const expiredTokenJson =
            '{"accessToken":"old_token","refreshToken":"refresh_token","expiresAt":"2020-01-01T00:00:00.000Z","scopes":["channel:manage:broadcast"]}';

        when(
          mockSecureStorage.read(key: 'twitch_token'),
        ).thenAnswer((_) async => expiredTokenJson);

        when(
          mockDio.post(
            any,
            data: anyNamed('data'),
            options: anyNamed('options'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 200,
            data: {
              'access_token': 'new_token',
              'refresh_token': 'new_refresh_token',
              'expires_in': 14400,
              'scope': 'channel:manage:broadcast',
            },
          ),
        );

        when(
          mockSecureStorage.write(
            key: 'twitch_token',
            value: anyNamed('value'),
          ),
        ).thenAnswer((_) async => {});

        // Act
        final result = await refreshTokenUseCase();

        // Assert
        expect(result.isRight(), true);
        verify(
          mockSecureStorage.read(key: 'twitch_token'),
        ).called(greaterThan(0));
        verify(
          mockSecureStorage.write(
            key: 'twitch_token',
            value: anyNamed('value'),
          ),
        ).called(1);
      });
    });

    group('Error Handling Integration', () {
      test('should handle secure storage errors gracefully', () async {
        // Arrange
        when(
          mockSecureStorage.read(key: 'twitch_token'),
        ).thenThrow(Exception('Storage error'));

        // Act
        final result = await checkAuthStatusUseCase();

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.message, isNotEmpty),
          (_) => fail('Should have failed'),
        );
      });

      test('should handle token revocation failure during logout', () async {
        // Arrange
        const tokenJson =
            '{"accessToken":"test_token","refreshToken":"test_refresh","expiresAt":"2025-12-31T23:59:59.000Z","scopes":["channel:manage:broadcast"]}';

        when(
          mockSecureStorage.read(key: 'twitch_token'),
        ).thenAnswer((_) async => tokenJson);

        // Set up mockDio to throw exception for revoke token call
        when(
          mockDio.post<dynamic>(
            'https://id.twitch.tv/oauth2/revoke',
            data: anyNamed('data'),
            queryParameters: anyNamed('queryParameters'),
            options: anyNamed('options'),
            cancelToken: anyNamed('cancelToken'),
            onSendProgress: anyNamed('onSendProgress'),
            onReceiveProgress: anyNamed('onReceiveProgress'),
          ),
        ).thenAnswer(
          (_) => Future<Response<dynamic>>.error(
            DioException(
              requestOptions: RequestOptions(path: ''),
              message: 'Network error',
            ),
          ),
        );

        when(
          mockSecureStorage.delete(key: 'twitch_token'),
        ).thenAnswer((_) async => {});
        when(
          mockSecureStorage.delete(key: 'twitch_user'),
        ).thenAnswer((_) async => {});

        // Act - Logout should still succeed even if revocation fails
        final result = await logoutUseCase();

        // Assert
        expect(result.isRight(), true);
        verify(mockSecureStorage.delete(key: 'twitch_token')).called(1);
        verify(mockSecureStorage.delete(key: 'twitch_user')).called(1);
      });
    });
  });
}
