import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/category_mapping/domain/entities/category_mapping.dart';
import 'package:tkit/features/category_mapping/domain/repositories/i_category_mapping_repository.dart';
import 'package:tkit/features/category_mapping/domain/usecases/find_mapping_usecase.dart';

@GenerateMocks([ICategoryMappingRepository])
import 'find_mapping_usecase_test.mocks.dart';

void main() {
  late FindMappingUseCase useCase;
  late MockICategoryMappingRepository mockRepository;

  setUp(() {
    mockRepository = MockICategoryMappingRepository();
    useCase = FindMappingUseCase(mockRepository);
  });

  group('FindMappingUseCase', () {
    const testProcessName = 'League of Legends.exe';
    const testPath = 'C:\\Games\\League of Legends.exe';
    final testMapping = CategoryMapping(
      id: 1,
      processName: testProcessName,
      executablePath: testPath,
      twitchCategoryId: '21779',
      twitchCategoryName: 'League of Legends',
      createdAt: DateTime(2024, 1, 1),
      lastUsedAt: DateTime(2024, 1, 2),
      lastApiFetch: DateTime(2024, 1, 1),
      cacheExpiresAt: DateTime(2024, 1, 2),
      manualOverride: false,
    );

    test('should return mapping from repository when found', () async {
      // arrange
      when(
        mockRepository.findMapping(any, any),
      ).thenAnswer((_) async => Right(testMapping));

      // act
      final result = await useCase(
        processName: testProcessName,
        executablePath: testPath,
      );

      // assert
      expect(result, Right(testMapping));
      verify(mockRepository.findMapping(testProcessName, testPath));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return null when no mapping found', () async {
      // arrange
      when(
        mockRepository.findMapping(any, any),
      ).thenAnswer((_) async => const Right(null));

      // act
      final result = await useCase(
        processName: testProcessName,
        executablePath: testPath,
      );

      // assert
      expect(result, const Right(null));
      verify(mockRepository.findMapping(testProcessName, testPath));
    });

    test('should return failure when repository fails', () async {
      // arrange
      const failure = CacheFailure(message: 'Database error');
      when(
        mockRepository.findMapping(any, any),
      ).thenAnswer((_) async => const Left(failure));

      // act
      final result = await useCase(
        processName: testProcessName,
        executablePath: testPath,
      );

      // assert
      expect(result, const Left(failure));
      verify(mockRepository.findMapping(testProcessName, testPath));
    });

    test('should work with null executable path', () async {
      // arrange
      when(
        mockRepository.findMapping(any, any),
      ).thenAnswer((_) async => Right(testMapping));

      // act
      final result = await useCase(
        processName: testProcessName,
        executablePath: null,
      );

      // assert
      expect(result, Right(testMapping));
      verify(mockRepository.findMapping(testProcessName, null));
    });
  });
}
