import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:tkit/features/auth/domain/usecases/check_auth_status_usecase.dart';

import 'check_auth_status_usecase_test.mocks.dart';

@GenerateMocks([IAuthRepository])
void main() {
  late CheckAuthStatusUseCase useCase;
  late MockIAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockIAuthRepository();
    useCase = CheckAuthStatusUseCase(mockRepository);
  });

  group('CheckAuthStatusUseCase', () {
    test('should return true when user is authenticated', () async {
      // Arrange
      when(
        mockRepository.isAuthenticated(),
      ).thenAnswer((_) async => const Right(true));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Right(true));
      verify(mockRepository.isAuthenticated()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return false when user is not authenticated', () async {
      // Arrange
      when(
        mockRepository.isAuthenticated(),
      ).thenAnswer((_) async => const Right(false));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Right(false));
      verify(mockRepository.isAuthenticated()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return CacheFailure when auth status check fails', () async {
      // Arrange
      const failure = CacheFailure(
        message: 'Failed to check authentication status',
        code: 'CACHE_ERROR',
      );
      when(
        mockRepository.isAuthenticated(),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Left(failure));
      verify(mockRepository.isAuthenticated()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should propagate repository errors', () async {
      // Arrange
      const failure = UnknownFailure(message: 'Unexpected error');
      when(
        mockRepository.isAuthenticated(),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Left(failure));
      verify(mockRepository.isAuthenticated()).called(1);
    });
  });
}
