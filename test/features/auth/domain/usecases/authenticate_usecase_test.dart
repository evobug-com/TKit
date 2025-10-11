import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/auth/domain/entities/twitch_user.dart';
import 'package:tkit/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:tkit/features/auth/domain/usecases/authenticate_usecase.dart';

import 'authenticate_usecase_test.mocks.dart';

@GenerateMocks([IAuthRepository])
void main() {
  late AuthenticateUseCase useCase;
  late MockIAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockIAuthRepository();
    useCase = AuthenticateUseCase(mockRepository);
  });

  group('AuthenticateUseCase', () {
    const tUser = TwitchUser(
      id: '12345',
      login: 'testuser',
      displayName: 'Test User',
      profileImageUrl: 'https://example.com/avatar.png',
      email: 'test@example.com',
    );

    test('should return TwitchUser when authentication succeeds', () async {
      // Arrange
      when(
        mockRepository.authenticate(),
      ).thenAnswer((_) async => const Right(tUser));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Right(tUser));
      verify(mockRepository.authenticate());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return AuthFailure when authentication fails', () async {
      // Arrange
      const tFailure = AuthFailure(
        message: 'Authentication failed',
        code: 'AUTH_ERROR',
      );
      when(
        mockRepository.authenticate(),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Left(tFailure));
      verify(mockRepository.authenticate());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should propagate repository errors', () async {
      // Arrange
      when(
        mockRepository.authenticate(),
      ).thenThrow(Exception('Unexpected error'));

      // Act & Assert
      expect(() => useCase(), throwsException);
    });
  });
}
