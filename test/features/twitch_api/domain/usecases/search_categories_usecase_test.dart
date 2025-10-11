import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/twitch_api/domain/entities/twitch_category.dart';
import 'package:tkit/features/twitch_api/domain/repositories/i_twitch_api_repository.dart';
import 'package:tkit/features/twitch_api/domain/usecases/search_categories_usecase.dart';

import 'search_categories_usecase_test.mocks.dart';

@GenerateMocks([ITwitchApiRepository])
void main() {
  late SearchCategoriesUseCase useCase;
  late MockITwitchApiRepository mockRepository;

  setUp(() {
    mockRepository = MockITwitchApiRepository();
    useCase = SearchCategoriesUseCase(mockRepository);
  });

  group('SearchCategoriesUseCase', () {
    const tQuery = 'League of Legends';
    const tFirst = 20;
    const tCategories = [
      TwitchCategory(id: '1', name: 'League of Legends', boxArtUrl: 'url1'),
      TwitchCategory(id: '2', name: 'Legends of Runeterra', boxArtUrl: 'url2'),
    ];

    test(
      'should return categories when repository call is successful',
      () async {
        // Arrange
        when(
          mockRepository.searchCategories(any, first: anyNamed('first')),
        ).thenAnswer((_) async => const Right(tCategories));

        // Act
        final result = await useCase(tQuery, first: tFirst);

        // Assert
        expect(result, const Right(tCategories));
        verify(mockRepository.searchCategories(tQuery, first: tFirst));
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('should return failure when repository call fails', () async {
      // Arrange
      const tFailure = ServerFailure(message: 'Server error', code: '500');
      when(
        mockRepository.searchCategories(any, first: anyNamed('first')),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase(tQuery, first: tFirst);

      // Assert
      expect(result, const Left(tFailure));
      verify(mockRepository.searchCategories(tQuery, first: tFirst));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ValidationFailure when query is empty', () async {
      // Act
      final result = await useCase('', first: tFirst);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, 'Search query cannot be empty');
        expect((failure as ValidationFailure).code, 'EMPTY_QUERY');
      }, (_) => fail('Should return failure'));
      verifyNever(
        mockRepository.searchCategories(any, first: anyNamed('first')),
      );
    });

    test(
      'should return ValidationFailure when query is only whitespace',
      () async {
        // Act
        final result = await useCase('   ', first: tFirst);

        // Assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, 'Search query cannot be empty');
        }, (_) => fail('Should return failure'));
        verifyNever(
          mockRepository.searchCategories(any, first: anyNamed('first')),
        );
      },
    );

    test('should trim query before calling repository', () async {
      // Arrange
      when(
        mockRepository.searchCategories(any, first: anyNamed('first')),
      ).thenAnswer((_) async => const Right(tCategories));

      // Act
      await useCase('  League of Legends  ', first: tFirst);

      // Assert
      verify(
        mockRepository.searchCategories('League of Legends', first: tFirst),
      );
    });

    test('should return ValidationFailure when first is less than 1', () async {
      // Act
      final result = await useCase(tQuery, first: 0);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, 'Result count must be between 1 and 100');
      }, (_) => fail('Should return failure'));
      verifyNever(
        mockRepository.searchCategories(any, first: anyNamed('first')),
      );
    });

    test(
      'should return ValidationFailure when first is greater than 100',
      () async {
        // Act
        final result = await useCase(tQuery, first: 101);

        // Assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, 'Result count must be between 1 and 100');
        }, (_) => fail('Should return failure'));
        verifyNever(
          mockRepository.searchCategories(any, first: anyNamed('first')),
        );
      },
    );

    test('should use default first value of 20 when not specified', () async {
      // Arrange
      when(
        mockRepository.searchCategories(any, first: anyNamed('first')),
      ).thenAnswer((_) async => const Right(tCategories));

      // Act
      await useCase(tQuery);

      // Assert
      verify(mockRepository.searchCategories(tQuery, first: 20));
    });

    test('should accept valid first values at boundaries', () async {
      // Arrange
      when(
        mockRepository.searchCategories(any, first: anyNamed('first')),
      ).thenAnswer((_) async => const Right(tCategories));

      // Act - Test minimum valid value
      await useCase(tQuery, first: 1);
      // Act - Test maximum valid value
      await useCase(tQuery, first: 100);

      // Assert
      verify(mockRepository.searchCategories(tQuery, first: 1));
      verify(mockRepository.searchCategories(tQuery, first: 100));
    });
  });
}
