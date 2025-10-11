import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/auth/domain/entities/twitch_token.dart';
import 'package:tkit/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:tkit/features/auth/domain/usecases/refresh_token_usecase.dart';

import 'refresh_token_usecase_test.mocks.dart';

@GenerateMocks([IAuthRepository])
void main() {
  late RefreshTokenUseCase useCase;
  late MockIAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockIAuthRepository();
    useCase = RefreshTokenUseCase(mockRepository);
  });

  group('RefreshTokenUseCase', () {
    final tToken = TwitchToken(
      accessToken: 'new_access_token',
      refreshToken: 'new_refresh_token',
      expiresAt: DateTime.now().add(const Duration(hours: 4)),
      scopes: ['channel:manage:broadcast'],
    );

    test('should return TwitchToken when token refresh succeeds', () async {
      // Arrange
      when(
        mockRepository.refreshToken(),
      ).thenAnswer((_) async => Right(tToken));

      // Act
      final result = await useCase();

      // Assert
      expect(result, Right(tToken));
      verify(mockRepository.refreshToken()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return AuthFailure when token refresh fails', () async {
      // Arrange
      const failure = AuthFailure(
        message: 'Token refresh failed',
        code: 'TOKEN_REFRESH_ERROR',
      );
      when(
        mockRepository.refreshToken(),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Left(failure));
      verify(mockRepository.refreshToken()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test(
      'should return AuthFailure when no token available to refresh',
      () async {
        // Arrange
        const failure = AuthFailure(
          message: 'No token available to refresh',
          code: 'NO_TOKEN',
        );
        when(
          mockRepository.refreshToken(),
        ).thenAnswer((_) async => const Left(failure));

        // Act
        final result = await useCase();

        // Assert
        expect(result, const Left(failure));
        verify(mockRepository.refreshToken()).called(1);
      },
    );

    test('should propagate repository errors', () async {
      // Arrange
      const failure = CacheFailure(
        message: 'Cache error during token refresh',
        code: 'CACHE_ERROR',
      );
      when(
        mockRepository.refreshToken(),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Left(failure));
      verify(mockRepository.refreshToken()).called(1);
    });
  });
}
