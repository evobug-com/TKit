import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/twitch_api/domain/entities/twitch_user.dart';
import 'package:tkit/features/twitch_api/domain/repositories/i_twitch_api_repository.dart';
import 'package:tkit/features/twitch_api/domain/usecases/get_current_user_usecase.dart';

import 'get_current_user_usecase_test.mocks.dart';

@GenerateMocks([ITwitchApiRepository])
void main() {
  late GetCurrentUserUseCase useCase;
  late MockITwitchApiRepository mockRepository;

  setUp(() {
    mockRepository = MockITwitchApiRepository();
    useCase = GetCurrentUserUseCase(mockRepository);
  });

  group('GetCurrentUserUseCase', () {
    const tUser = TwitchUser(
      id: '123456',
      login: 'testuser',
      displayName: 'TestUser',
      profileImageUrl: 'https://example.com/avatar.png',
      email: 'test@example.com',
      broadcasterType: 'affiliate',
    );

    test(
      'should return TwitchUser when repository call is successful',
      () async {
        // Arrange
        when(
          mockRepository.getCurrentUser(),
        ).thenAnswer((_) async => const Right(tUser));

        // Act
        final result = await useCase();

        // Assert
        expect(result, const Right(tUser));
        verify(mockRepository.getCurrentUser());
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('should return failure when repository call fails', () async {
      // Arrange
      const tFailure = ServerFailure(
        message: 'Failed to get user',
        code: '500',
      );
      when(
        mockRepository.getCurrentUser(),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Left(tFailure));
      verify(mockRepository.getCurrentUser());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle AuthFailure from repository', () async {
      // Arrange
      const tFailure = AuthFailure(message: 'Not authenticated', code: '401');
      when(
        mockRepository.getCurrentUser(),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Left(tFailure));
      verify(mockRepository.getCurrentUser());
    });

    test('should handle NetworkFailure from repository', () async {
      // Arrange
      const tFailure = NetworkFailure(message: 'Network timeout');
      when(
        mockRepository.getCurrentUser(),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Left(tFailure));
      verify(mockRepository.getCurrentUser());
    });

    test('should return user without optional fields', () async {
      // Arrange
      const tUserMinimal = TwitchUser(
        id: '123456',
        login: 'testuser',
        displayName: 'TestUser',
      );
      when(
        mockRepository.getCurrentUser(),
      ).thenAnswer((_) async => const Right(tUserMinimal));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Right(tUserMinimal));
      verify(mockRepository.getCurrentUser());
    });
  });
}
