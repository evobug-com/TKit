import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/twitch_api/domain/entities/twitch_category.dart';
import 'package:tkit/features/twitch_api/domain/repositories/i_twitch_api_repository.dart';
import 'package:tkit/features/twitch_api/domain/usecases/get_category_by_id_usecase.dart';

import 'get_category_by_id_usecase_test.mocks.dart';

@GenerateMocks([ITwitchApiRepository])
void main() {
  late GetCategoryByIdUseCase useCase;
  late MockITwitchApiRepository mockRepository;

  setUp(() {
    mockRepository = MockITwitchApiRepository();
    useCase = GetCategoryByIdUseCase(mockRepository);
  });

  group('GetCategoryByIdUseCase', () {
    const tCategoryId = '12345';
    const tCategory = TwitchCategory(
      id: '12345',
      name: 'League of Legends',
      boxArtUrl: 'https://static-cdn.jtvnw.net/ttv-boxart/{width}x{height}.jpg',
    );

    test(
      'should return TwitchCategory when repository call is successful',
      () async {
        // Arrange
        when(
          mockRepository.getCategoryById(any),
        ).thenAnswer((_) async => const Right(tCategory));

        // Act
        final result = await useCase(tCategoryId);

        // Assert
        expect(result, const Right(tCategory));
        verify(mockRepository.getCategoryById(tCategoryId));
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('should return failure when repository call fails', () async {
      // Arrange
      const tFailure = ServerFailure(
        message: 'Category not found',
        code: '404',
      );
      when(
        mockRepository.getCategoryById(any),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase(tCategoryId);

      // Assert
      expect(result, const Left(tFailure));
      verify(mockRepository.getCategoryById(tCategoryId));
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
      verifyNever(mockRepository.getCategoryById(any));
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
        verifyNever(mockRepository.getCategoryById(any));
      },
    );

    test('should trim categoryId before calling repository', () async {
      // Arrange
      when(
        mockRepository.getCategoryById(any),
      ).thenAnswer((_) async => const Right(tCategory));

      // Act
      await useCase('  12345  ');

      // Assert
      verify(mockRepository.getCategoryById('12345'));
    });

    test('should handle NetworkFailure from repository', () async {
      // Arrange
      const tFailure = NetworkFailure(message: 'Network error');
      when(
        mockRepository.getCategoryById(any),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase(tCategoryId);

      // Assert
      expect(result, const Left(tFailure));
      verify(mockRepository.getCategoryById(tCategoryId));
    });

    test('should return category without boxArtUrl', () async {
      // Arrange
      const tCategoryNoArt = TwitchCategory(id: '12345', name: 'Just Chatting');
      when(
        mockRepository.getCategoryById(any),
      ).thenAnswer((_) async => const Right(tCategoryNoArt));

      // Act
      final result = await useCase(tCategoryId);

      // Assert
      expect(result, const Right(tCategoryNoArt));
      verify(mockRepository.getCategoryById(tCategoryId));
    });
  });
}
