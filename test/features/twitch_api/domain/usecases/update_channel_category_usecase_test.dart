import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/twitch_api/domain/repositories/i_twitch_api_repository.dart';
import 'package:tkit/features/twitch_api/domain/usecases/update_channel_category_usecase.dart';

import 'update_channel_category_usecase_test.mocks.dart';

@GenerateMocks([ITwitchApiRepository])
void main() {
  late UpdateChannelCategoryUseCase useCase;
  late MockITwitchApiRepository mockRepository;

  setUp(() {
    mockRepository = MockITwitchApiRepository();
    useCase = UpdateChannelCategoryUseCase(mockRepository);
  });

  group('UpdateChannelCategoryUseCase', () {
    const tCategoryId = '12345';

    test('should return void when repository call is successful', () async {
      // Arrange
      when(
        mockRepository.updateChannelCategory(any),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(tCategoryId);

      // Assert
      expect(result, const Right(null));
      verify(mockRepository.updateChannelCategory(tCategoryId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when repository call fails', () async {
      // Arrange
      const tFailure = ServerFailure(message: 'Update failed', code: '500');
      when(
        mockRepository.updateChannelCategory(any),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase(tCategoryId);

      // Assert
      expect(result, const Left(tFailure));
      verify(mockRepository.updateChannelCategory(tCategoryId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ValidationFailure when categoryId is empty', () async {
      // Act
      final result = await useCase('');

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, 'Category ID cannot be empty');
        expect((failure as ValidationFailure).code, 'EMPTY_CATEGORY_ID');
      }, (_) => fail('Should return failure'));
      verifyNever(mockRepository.updateChannelCategory(any));
    });

    test(
      'should return ValidationFailure when categoryId is only whitespace',
      () async {
        // Act
        final result = await useCase('   ');

        // Assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, 'Category ID cannot be empty');
        }, (_) => fail('Should return failure'));
        verifyNever(mockRepository.updateChannelCategory(any));
      },
    );

    test('should trim categoryId before calling repository', () async {
      // Arrange
      when(
        mockRepository.updateChannelCategory(any),
      ).thenAnswer((_) async => const Right(null));

      // Act
      await useCase('  12345  ');

      // Assert
      verify(mockRepository.updateChannelCategory('12345'));
    });

    test('should handle AuthFailure from repository', () async {
      // Arrange
      const tFailure = AuthFailure(message: 'Not authenticated', code: '401');
      when(
        mockRepository.updateChannelCategory(any),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase(tCategoryId);

      // Assert
      expect(result, const Left(tFailure));
      verify(mockRepository.updateChannelCategory(tCategoryId));
    });

    test('should handle NetworkFailure from repository', () async {
      // Arrange
      const tFailure = NetworkFailure(message: 'Network error');
      when(
        mockRepository.updateChannelCategory(any),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase(tCategoryId);

      // Assert
      expect(result, const Left(tFailure));
      verify(mockRepository.updateChannelCategory(tCategoryId));
    });
  });
}
