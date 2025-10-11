import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/category_mapping/domain/entities/category_mapping.dart';
import 'package:tkit/features/category_mapping/domain/usecases/delete_mapping_usecase.dart';
import 'package:tkit/features/category_mapping/domain/usecases/find_mapping_usecase.dart';
import 'package:tkit/features/category_mapping/domain/usecases/get_all_mappings_usecase.dart';
import 'package:tkit/features/category_mapping/domain/usecases/save_mapping_usecase.dart';
import 'package:tkit/features/category_mapping/presentation/providers/category_mapping_provider.dart';

@GenerateMocks([
  GetAllMappingsUseCase,
  FindMappingUseCase,
  SaveMappingUseCase,
  DeleteMappingUseCase,
])
import 'category_mapping_provider_test.mocks.dart';

void main() {
  late CategoryMappingProvider provider;
  late MockGetAllMappingsUseCase mockGetAllMappingsUseCase;
  late MockFindMappingUseCase mockFindMappingUseCase;
  late MockSaveMappingUseCase mockSaveMappingUseCase;
  late MockDeleteMappingUseCase mockDeleteMappingUseCase;

  setUp(() {
    mockGetAllMappingsUseCase = MockGetAllMappingsUseCase();
    mockFindMappingUseCase = MockFindMappingUseCase();
    mockSaveMappingUseCase = MockSaveMappingUseCase();
    mockDeleteMappingUseCase = MockDeleteMappingUseCase();

    provider = CategoryMappingProvider(
      getAllMappingsUseCase: mockGetAllMappingsUseCase,
      findMappingUseCase: mockFindMappingUseCase,
      saveMappingUseCase: mockSaveMappingUseCase,
      deleteMappingUseCase: mockDeleteMappingUseCase,
    );
  });

  tearDown(() {
    provider.dispose();
  });

  group('CategoryMappingProvider', () {
    final testMappings = [
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

    test('initial state is correct', () {
      expect(provider.isLoading, false);
      expect(provider.errorMessage, null);
      expect(provider.successMessage, null);
      expect(provider.mappings, []);
    });

    test('loadMappings sets loading state and loads mappings successfully', () async {
      when(mockGetAllMappingsUseCase.call())
          .thenAnswer((_) async => Right(testMappings));

      final futures = <Future>[];
      provider.addListener(() {
        futures.add(Future.value());
      });

      await provider.loadMappings();

      expect(provider.isLoading, false);
      expect(provider.errorMessage, null);
      expect(provider.mappings, testMappings);
      verify(mockGetAllMappingsUseCase.call()).called(1);
    });

    test('loadMappings sets error when loading fails', () async {
      when(mockGetAllMappingsUseCase.call()).thenAnswer(
        (_) async => const Left(CacheFailure(message: 'Database error')),
      );

      await provider.loadMappings();

      expect(provider.isLoading, false);
      expect(provider.errorMessage, 'Database error');
      expect(provider.mappings, []);
    });

    test('addMapping successfully adds mapping and reloads list', () async {
      when(mockSaveMappingUseCase.call(any))
          .thenAnswer((_) async => const Right(null));
      when(mockGetAllMappingsUseCase.call())
          .thenAnswer((_) async => Right(testMappings));

      await provider.addMapping(testMappings.first);

      expect(provider.isLoading, false);
      expect(provider.successMessage, 'Mapping added successfully');
      expect(provider.errorMessage, null);
      expect(provider.mappings, testMappings);
      verify(mockSaveMappingUseCase.call(testMappings.first)).called(1);
      verify(mockGetAllMappingsUseCase.call()).called(1);
    });

    test('addMapping sets error when save fails', () async {
      when(mockSaveMappingUseCase.call(any)).thenAnswer(
        (_) async => const Left(CacheFailure(message: 'Save failed')),
      );

      await provider.addMapping(testMappings.first);

      expect(provider.isLoading, false);
      expect(provider.errorMessage, 'Save failed');
      expect(provider.successMessage, null);
    });

    test('updateMapping successfully updates mapping and reloads list', () async {
      when(mockSaveMappingUseCase.call(any))
          .thenAnswer((_) async => const Right(null));
      when(mockGetAllMappingsUseCase.call())
          .thenAnswer((_) async => Right(testMappings));

      await provider.updateMapping(testMappings.first);

      expect(provider.isLoading, false);
      expect(provider.successMessage, 'Mapping updated successfully');
      expect(provider.errorMessage, null);
      expect(provider.mappings, testMappings);
      verify(mockSaveMappingUseCase.call(testMappings.first)).called(1);
      verify(mockGetAllMappingsUseCase.call()).called(1);
    });

    test('deleteMapping successfully deletes mapping and reloads list', () async {
      when(mockDeleteMappingUseCase.call(any))
          .thenAnswer((_) async => const Right(null));
      when(mockGetAllMappingsUseCase.call())
          .thenAnswer((_) async => Right(testMappings));

      await provider.deleteMapping(1);

      expect(provider.isLoading, false);
      expect(provider.successMessage, 'Mapping deleted successfully');
      expect(provider.errorMessage, null);
      expect(provider.mappings, testMappings);
      verify(mockDeleteMappingUseCase.call(1)).called(1);
      verify(mockGetAllMappingsUseCase.call()).called(1);
    });

    test('searchMapping finds mapping successfully', () async {
      when(
        mockFindMappingUseCase.call(
          processName: anyNamed('processName'),
          executablePath: anyNamed('executablePath'),
        ),
      ).thenAnswer((_) async => Right(testMappings.first));

      await provider.searchMapping(processName: 'League of Legends.exe');

      expect(provider.isLoading, false);
      expect(provider.errorMessage, null);
      expect(provider.foundMapping, testMappings.first);
      expect(provider.searchQuery, 'League of Legends.exe');
    });

    test('searchMapping handles null result', () async {
      when(
        mockFindMappingUseCase.call(
          processName: anyNamed('processName'),
          executablePath: anyNamed('executablePath'),
        ),
      ).thenAnswer((_) async => const Right(null));

      await provider.searchMapping(processName: 'Nonexistent.exe');

      expect(provider.isLoading, false);
      expect(provider.errorMessage, null);
      expect(provider.foundMapping, null);
      expect(provider.searchQuery, 'Nonexistent.exe');
    });

    test('clearMessages clears error and success messages', () async {
      when(mockGetAllMappingsUseCase.call()).thenAnswer(
        (_) async => const Left(CacheFailure(message: 'Error')),
      );

      await provider.loadMappings();
      expect(provider.errorMessage, 'Error');

      provider.clearMessages();

      expect(provider.errorMessage, null);
      expect(provider.successMessage, null);
    });
  });
}
