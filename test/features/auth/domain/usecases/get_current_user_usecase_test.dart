import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/auth/domain/entities/twitch_user.dart';
import 'package:tkit/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:tkit/features/auth/domain/usecases/get_current_user_usecase.dart';

import 'get_current_user_usecase_test.mocks.dart';

@GenerateMocks([IAuthRepository])
void main() {
  late GetCurrentUserUseCase useCase;
  late MockIAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockIAuthRepository();
    useCase = GetCurrentUserUseCase(mockRepository);
  });

  group('GetCurrentUserUseCase', () {
    const tUser = TwitchUser(
      id: '123456',
      login: 'testuser',
      displayName: 'TestUser',
      profileImageUrl: 'https://example.com/avatar.png',
      email: 'test@example.com',
    );

    test('should return TwitchUser when user is authenticated', () async {
      // Arrange
      when(
        mockRepository.getCurrentUser(),
      ).thenAnswer((_) async => const Right(tUser));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Right(tUser));
      verify(mockRepository.getCurrentUser()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return null when user is not authenticated', () async {
      // Arrange
      when(
        mockRepository.getCurrentUser(),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Right(null));
      verify(mockRepository.getCurrentUser()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return CacheFailure when getting user fails', () async {
      // Arrange
      const failure = CacheFailure(
        message: 'Failed to get current user',
        code: 'CACHE_ERROR',
      );
      when(
        mockRepository.getCurrentUser(),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Left(failure));
      verify(mockRepository.getCurrentUser()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should propagate repository errors', () async {
      // Arrange
      const failure = UnknownFailure(message: 'Unexpected error');
      when(
        mockRepository.getCurrentUser(),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Left(failure));
      verify(mockRepository.getCurrentUser()).called(1);
    });
  });
}
