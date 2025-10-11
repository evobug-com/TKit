import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/category_mapping/domain/entities/category_mapping.dart';
import 'package:tkit/features/category_mapping/domain/repositories/i_category_mapping_repository.dart';
import 'package:tkit/features/category_mapping/domain/usecases/save_mapping_usecase.dart';

@GenerateMocks([ICategoryMappingRepository])
import 'save_mapping_usecase_test.mocks.dart';

void main() {
  late SaveMappingUseCase useCase;
  late MockICategoryMappingRepository mockRepository;

  setUp(() {
    mockRepository = MockICategoryMappingRepository();
    useCase = SaveMappingUseCase(mockRepository);
  });

  group('SaveMappingUseCase', () {
    final testMapping = CategoryMapping(
      id: 1,
      processName: 'League of Legends.exe',
      twitchCategoryId: '21779',
      twitchCategoryName: 'League of Legends',
      createdAt: DateTime(2024, 1, 1),
      lastApiFetch: DateTime(2024, 1, 1),
      cacheExpiresAt: DateTime(2024, 1, 2),
      manualOverride: true,
    );

    test('should save mapping through repository', () async {
      // arrange
      when(
        mockRepository.saveMapping(any),
      ).thenAnswer((_) async => const Right(null));

      // act
      final result = await useCase(testMapping);

      // assert
      expect(result, const Right(null));
      verify(mockRepository.saveMapping(testMapping));
      verifyNoMoreInteractions(mockRepository);
    });

    test(
      'should return validation failure when process name is empty',
      () async {
        // arrange
        final invalidMapping = CategoryMapping(
          processName: '',
          twitchCategoryId: '21779',
          twitchCategoryName: 'League of Legends',
          createdAt: DateTime(2024, 1, 1),
          lastApiFetch: DateTime(2024, 1, 1),
          cacheExpiresAt: DateTime(2024, 1, 2),
          manualOverride: true,
        );

        // act
        final result = await useCase(invalidMapping);

        // assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(
            failure,
            const ValidationFailure(message: 'Process name cannot be empty'),
          ),
          (_) => fail('Should return failure'),
        );
        verifyNever(mockRepository.saveMapping(any));
      },
    );

    test(
      'should return validation failure when category ID is empty',
      () async {
        // arrange
        final invalidMapping = CategoryMapping(
          processName: 'Test.exe',
          twitchCategoryId: '',
          twitchCategoryName: 'Test Category',
          createdAt: DateTime(2024, 1, 1),
          lastApiFetch: DateTime(2024, 1, 1),
          cacheExpiresAt: DateTime(2024, 1, 2),
          manualOverride: true,
        );

        // act
        final result = await useCase(invalidMapping);

        // assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(
            failure,
            const ValidationFailure(
              message: 'Twitch category ID cannot be empty',
            ),
          ),
          (_) => fail('Should return failure'),
        );
        verifyNever(mockRepository.saveMapping(any));
      },
    );

    test(
      'should return validation failure when category name is empty',
      () async {
        // arrange
        final invalidMapping = CategoryMapping(
          processName: 'Test.exe',
          twitchCategoryId: '12345',
          twitchCategoryName: '',
          createdAt: DateTime(2024, 1, 1),
          lastApiFetch: DateTime(2024, 1, 1),
          cacheExpiresAt: DateTime(2024, 1, 2),
          manualOverride: true,
        );

        // act
        final result = await useCase(invalidMapping);

        // assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(
            failure,
            const ValidationFailure(
              message: 'Twitch category name cannot be empty',
            ),
          ),
          (_) => fail('Should return failure'),
        );
        verifyNever(mockRepository.saveMapping(any));
      },
    );

    test('should trim whitespace before validation', () async {
      // arrange
      final mappingWithWhitespace = CategoryMapping(
        processName: '  League of Legends.exe  ',
        twitchCategoryId: '  21779  ',
        twitchCategoryName: '  League of Legends  ',
        createdAt: DateTime(2024, 1, 1),
        lastApiFetch: DateTime(2024, 1, 1),
        cacheExpiresAt: DateTime(2024, 1, 2),
        manualOverride: true,
      );
      when(
        mockRepository.saveMapping(any),
      ).thenAnswer((_) async => const Right(null));

      // act
      final result = await useCase(mappingWithWhitespace);

      // assert
      expect(result, const Right(null));
      verify(mockRepository.saveMapping(mappingWithWhitespace));
    });

    test('should return failure when repository fails', () async {
      // arrange
      const failure = CacheFailure(message: 'Database error');
      when(
        mockRepository.saveMapping(any),
      ).thenAnswer((_) async => const Left(failure));

      // act
      final result = await useCase(testMapping);

      // assert
      expect(result, const Left(failure));
      verify(mockRepository.saveMapping(testMapping));
    });
  });
}
