import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/category_mapping/domain/entities/category_mapping.dart';
import 'package:tkit/features/category_mapping/domain/repositories/i_category_mapping_repository.dart';
import 'package:tkit/features/category_mapping/domain/usecases/get_all_mappings_usecase.dart';

@GenerateMocks([ICategoryMappingRepository])
import 'get_all_mappings_usecase_test.mocks.dart';

void main() {
  late GetAllMappingsUseCase useCase;
  late MockICategoryMappingRepository mockRepository;

  setUp(() {
    mockRepository = MockICategoryMappingRepository();
    useCase = GetAllMappingsUseCase(mockRepository);
  });

  group('GetAllMappingsUseCase', () {
    final testMappings = <CategoryMapping>[
      CategoryMapping(
        id: 1,
        processName: 'League of Legends.exe',
        twitchCategoryId: '21779',
        twitchCategoryName: 'League of Legends',
        createdAt: DateTime(2024, 1, 1),
        lastApiFetch: DateTime(2024, 1, 1),
        cacheExpiresAt: DateTime(2024, 1, 2),
        manualOverride: false,
      ),
      CategoryMapping(
        id: 2,
        processName: 'Valorant.exe',
        twitchCategoryId: '516575',
        twitchCategoryName: 'VALORANT',
        createdAt: DateTime(2024, 1, 2),
        lastApiFetch: DateTime(2024, 1, 2),
        cacheExpiresAt: DateTime(2024, 1, 3),
        manualOverride: true,
      ),
    ];

    test('should return list of mappings from repository', () async {
      // arrange
      when(
        mockRepository.getAllMappings(),
      ).thenAnswer((_) async => Right(testMappings));

      // act
      final result = await useCase();

      // assert
      expect(result, Right(testMappings));
      verify(mockRepository.getAllMappings());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return empty list when no mappings exist', () async {
      // arrange
      when(
        mockRepository.getAllMappings(),
      ).thenAnswer((_) async => const Right([]));

      // act
      final result = await useCase();

      // assert
      expect(result, const Right(<CategoryMapping>[]));
      verify(mockRepository.getAllMappings());
    });

    test('should return failure when repository fails', () async {
      // arrange
      const failure = CacheFailure(message: 'Database error');
      when(
        mockRepository.getAllMappings(),
      ).thenAnswer((_) async => const Left(failure));

      // act
      final result = await useCase();

      // assert
      expect(result, const Left(failure));
      verify(mockRepository.getAllMappings());
    });
  });
}
