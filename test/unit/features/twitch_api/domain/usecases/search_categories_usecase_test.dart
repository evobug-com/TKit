import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/twitch_api/domain/entities/twitch_category.dart';
import 'package:tkit/features/twitch_api/domain/repositories/i_twitch_api_repository.dart';
import 'package:tkit/features/twitch_api/domain/usecases/search_categories_usecase.dart';

@GenerateMocks([ITwitchApiRepository])
import 'search_categories_usecase_test.mocks.dart';

void main() {
  late SearchCategoriesUseCase usecase;
  late MockITwitchApiRepository mockRepository;

  setUp(() {
    mockRepository = MockITwitchApiRepository();
    usecase = SearchCategoriesUseCase(mockRepository);
  });

  const testQuery = 'Just Chatting';
  const testCategories = [
    TwitchCategory(id: '1', name: 'Just Chatting'),
    TwitchCategory(id: '2', name: 'Just Dancing'),
  ];

  group('SearchCategoriesUseCase', () {
    test('should return categories from repository when successful', () async {
      // Arrange
      when(
        mockRepository.searchCategories(any, first: anyNamed('first')),
      ).thenAnswer((_) async => const Right(testCategories));

      // Act
      final result = await usecase(testQuery);

      // Assert
      expect(result, const Right(testCategories));
      verify(mockRepository.searchCategories(testQuery, first: 20)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return categories with custom result count', () async {
      // Arrange
      when(
        mockRepository.searchCategories(any, first: anyNamed('first')),
      ).thenAnswer((_) async => const Right(testCategories));

      // Act
      final result = await usecase(testQuery, first: 50);

      // Assert
      expect(result, const Right(testCategories));
      verify(mockRepository.searchCategories(testQuery, first: 50)).called(1);
    });

    test('should return ValidationFailure when query is empty', () async {
      // Act
      final result = await usecase('');

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, 'Search query cannot be empty');
        expect(failure.code, 'EMPTY_QUERY');
      }, (_) => fail('Should return Left'));
      verifyZeroInteractions(mockRepository);
    });

    test(
      'should return ValidationFailure when query is only whitespace',
      () async {
        // Act
        final result = await usecase('   ');

        // Assert
        expect(result.isLeft(), true);
        verifyZeroInteractions(mockRepository);
      },
    );

    test('should trim whitespace from query', () async {
      // Arrange
      when(
        mockRepository.searchCategories(any, first: anyNamed('first')),
      ).thenAnswer((_) async => const Right(testCategories));

      // Act
      await usecase('  Just Chatting  ');

      // Assert
      verify(
        mockRepository.searchCategories('Just Chatting', first: 20),
      ).called(1);
    });

    test(
      'should return ValidationFailure when result count is less than 1',
      () async {
        // Act
        final result = await usecase(testQuery, first: 0);

        // Assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, 'Result count must be between 1 and 100');
        }, (_) => fail('Should return Left'));
        verifyZeroInteractions(mockRepository);
      },
    );

    test(
      'should return ValidationFailure when result count is greater than 100',
      () async {
        // Act
        final result = await usecase(testQuery, first: 101);

        // Assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.code, 'INVALID_RESULT_COUNT');
        }, (_) => fail('Should return Left'));
        verifyZeroInteractions(mockRepository);
      },
    );

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      const serverFailure = ServerFailure(message: 'Server error');
      when(
        mockRepository.searchCategories(any, first: anyNamed('first')),
      ).thenAnswer((_) async => const Left(serverFailure));

      // Act
      final result = await usecase(testQuery);

      // Assert
      expect(result, const Left(serverFailure));
      verify(mockRepository.searchCategories(testQuery, first: 20)).called(1);
    });
  });
}
