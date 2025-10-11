import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:tkit/features/auth/domain/usecases/logout_usecase.dart';

import 'logout_usecase_test.mocks.dart';

@GenerateMocks([IAuthRepository])
void main() {
  late LogoutUseCase useCase;
  late MockIAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockIAuthRepository();
    useCase = LogoutUseCase(mockRepository);
  });

  group('LogoutUseCase', () {
    test('should return void when logout succeeds', () async {
      // Arrange
      when(mockRepository.logout()).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Right(null));
      verify(mockRepository.logout()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return AuthFailure when logout fails', () async {
      // Arrange
      const failure = AuthFailure(
        message: 'Logout failed',
        code: 'LOGOUT_ERROR',
      );
      when(
        mockRepository.logout(),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Left(failure));
      verify(mockRepository.logout()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should propagate repository errors', () async {
      // Arrange
      const failure = CacheFailure(
        message: 'Cache error during logout',
        code: 'CACHE_ERROR',
      );
      when(
        mockRepository.logout(),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Left(failure));
      verify(mockRepository.logout()).called(1);
    });
  });
}
