import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tkit/core/errors/exceptions.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/category_mapping/data/datasources/category_mapping_local_datasource.dart';
import 'package:tkit/features/category_mapping/data/datasources/memory_cache.dart';
import 'package:tkit/features/category_mapping/data/models/category_mapping_model.dart';
import 'package:tkit/features/category_mapping/data/repositories/category_mapping_repository_impl.dart';
import 'package:tkit/features/category_mapping/domain/entities/category_mapping.dart';

@GenerateMocks([CategoryMappingLocalDataSource, MemoryCache])
import 'category_mapping_repository_impl_test.mocks.dart';

void main() {
  late CategoryMappingRepositoryImpl repository;
  late MockCategoryMappingLocalDataSource mockLocalDataSource;
  late MockMemoryCache mockMemoryCache;

  setUp(() {
    mockLocalDataSource = MockCategoryMappingLocalDataSource();
    mockMemoryCache = MockMemoryCache();
    repository = CategoryMappingRepositoryImpl(
      mockLocalDataSource,
      mockMemoryCache,
    );
  });

  group('CategoryMappingRepositoryImpl', () {
    final testMappingModel = CategoryMappingModel(
      id: 1,
      processName: 'League of Legends.exe',
      twitchCategoryId: '21779',
      twitchCategoryName: 'League of Legends',
      createdAt: DateTime(2024, 1, 1),
      lastApiFetch: DateTime(2024, 1, 1),
      cacheExpiresAt: DateTime(2024, 1, 2),
      manualOverride: true,
    );

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

    group('findMapping', () {
      test(
        'should return mapping when data source returns a mapping',
        () async {
          // arrange
          when(mockMemoryCache.get(any)).thenReturn(null);
          when(
            mockLocalDataSource.findMapping(any, any),
          ).thenAnswer((_) async => testMappingModel);

          // act
          final result = await repository.findMapping(
            'League of Legends.exe',
            null,
          );

          // assert
          expect(result, Right(testMapping));
          verify(mockMemoryCache.get('League of Legends.exe'));
          verify(
            mockLocalDataSource.findMapping('League of Legends.exe', null),
          );
          verify(mockMemoryCache.put('League of Legends.exe', testMapping));
        },
      );

      test('should return null when data source returns null', () async {
        // arrange
        when(mockMemoryCache.get(any)).thenReturn(null);
        when(
          mockLocalDataSource.findMapping(any, any),
        ).thenAnswer((_) async => null);

        // act
        final result = await repository.findMapping('Unknown.exe', null);

        // assert
        expect(result, const Right(null));
        verify(mockMemoryCache.get('Unknown.exe'));
        verify(mockLocalDataSource.findMapping('Unknown.exe', null));
      });

      test(
        'should return CacheFailure when data source throws CacheException',
        () async {
          // arrange
          when(mockMemoryCache.get(any)).thenReturn(null);
          when(
            mockLocalDataSource.findMapping(any, any),
          ).thenThrow(CacheException(message: 'Database error'));

          // act
          final result = await repository.findMapping('Test.exe', null);

          // assert
          expect(result.isLeft(), true);
          result.fold((failure) {
            expect(failure, isA<CacheFailure>());
            expect((failure as CacheFailure).message, 'Database error');
          }, (_) => fail('Should return failure'));
        },
      );

      test(
        'should return CacheFailure when data source throws unexpected error',
        () async {
          // arrange
          when(mockMemoryCache.get(any)).thenReturn(null);
          when(
            mockLocalDataSource.findMapping(any, any),
          ).thenThrow(Exception('Unexpected error'));

          // act
          final result = await repository.findMapping('Test.exe', null);

          // assert
          expect(result.isLeft(), true);
          result.fold((failure) {
            expect(failure, isA<CacheFailure>());
            expect(
              (failure as CacheFailure).message,
              contains('Unexpected error'),
            );
          }, (_) => fail('Should return failure'));
        },
      );
    });

    group('getAllMappings', () {
      test('should return list of mappings from data source', () async {
        // arrange
        final mappingModels = [testMappingModel];
        when(
          mockLocalDataSource.getAllMappings(),
        ).thenAnswer((_) async => mappingModels);

        // act
        final result = await repository.getAllMappings();

        // assert
        expect(result.isRight(), true);
        result.fold((_) => fail('Should return success'), (mappings) {
          expect(mappings.length, 1);
          expect(mappings.first, testMapping);
        });
        verify(mockLocalDataSource.getAllMappings());
      });

      test(
        'should return empty list when data source returns empty list',
        () async {
          // arrange
          when(
            mockLocalDataSource.getAllMappings(),
          ).thenAnswer((_) async => []);

          // act
          final result = await repository.getAllMappings();

          // assert
          expect(result.isRight(), true);
          result.fold(
            (_) => fail('Should return success'),
            (mappings) => expect(mappings, isEmpty),
          );
          verify(mockLocalDataSource.getAllMappings());
        },
      );

      test(
        'should return CacheFailure when data source throws CacheException',
        () async {
          // arrange
          when(
            mockLocalDataSource.getAllMappings(),
          ).thenThrow(CacheException(message: 'Database error'));

          // act
          final result = await repository.getAllMappings();

          // assert
          expect(result.isLeft(), true);
          result.fold(
            (failure) =>
                expect((failure as CacheFailure).message, 'Database error'),
            (_) => fail('Should return failure'),
          );
        },
      );
    });

    group('saveMapping', () {
      test('should save mapping through data source', () async {
        // arrange
        when(
          mockLocalDataSource.saveMapping(any),
        ).thenAnswer((_) async => Future.value());

        // act
        final result = await repository.saveMapping(testMapping);

        // assert
        expect(result, const Right(null));
        verify(mockLocalDataSource.saveMapping(any));
        verify(mockMemoryCache.put(testMapping.processName, testMapping));
      });

      test(
        'should return CacheFailure when data source throws CacheException',
        () async {
          // arrange
          when(
            mockLocalDataSource.saveMapping(any),
          ).thenThrow(CacheException(message: 'Failed to save'));

          // act
          final result = await repository.saveMapping(testMapping);

          // assert
          expect(result.isLeft(), true);
          result.fold(
            (failure) =>
                expect((failure as CacheFailure).message, 'Failed to save'),
            (_) => fail('Should return failure'),
          );
        },
      );
    });

    group('deleteMapping', () {
      test('should delete mapping and remove from cache', () async {
        // arrange
        when(
          mockLocalDataSource.getAllMappings(),
        ).thenAnswer((_) async => [testMappingModel]);
        when(
          mockLocalDataSource.deleteMapping(any),
        ).thenAnswer((_) async => Future.value());

        // act
        final result = await repository.deleteMapping(1);

        // assert
        expect(result, const Right(null));
        verify(mockLocalDataSource.getAllMappings());
        verify(mockLocalDataSource.deleteMapping(1));
        verify(mockMemoryCache.remove('League of Legends.exe'));
      });

      test('should delete mapping even when not found in cache', () async {
        // arrange
        when(
          mockLocalDataSource.getAllMappings(),
        ).thenAnswer((_) async => []); // Mapping not found
        when(
          mockLocalDataSource.deleteMapping(any),
        ).thenAnswer((_) async => Future.value());

        // act
        final result = await repository.deleteMapping(1);

        // assert
        expect(result, const Right(null));
        verify(mockLocalDataSource.getAllMappings());
        verify(mockLocalDataSource.deleteMapping(1));
        verifyNever(mockMemoryCache.remove(any)); // Should not try to remove
      });

      test(
        'should return CacheFailure when data source throws CacheException',
        () async {
          // arrange
          when(
            mockLocalDataSource.getAllMappings(),
          ).thenAnswer((_) async => [testMappingModel]);
          when(
            mockLocalDataSource.deleteMapping(any),
          ).thenThrow(CacheException(message: 'Failed to delete'));

          // act
          final result = await repository.deleteMapping(1);

          // assert
          expect(result.isLeft(), true);
          result.fold(
            (failure) =>
                expect((failure as CacheFailure).message, 'Failed to delete'),
            (_) => fail('Should return failure'),
          );
        },
      );
    });

    group('updateLastUsed', () {
      test('should update last used timestamp through data source', () async {
        // arrange
        when(
          mockLocalDataSource.updateLastUsed(any),
        ).thenAnswer((_) async => Future.value());

        // act
        final result = await repository.updateLastUsed(1);

        // assert
        expect(result, const Right(null));
        verify(mockLocalDataSource.updateLastUsed(1));
      });

      test(
        'should return CacheFailure when data source throws CacheException',
        () async {
          // arrange
          when(
            mockLocalDataSource.updateLastUsed(any),
          ).thenThrow(CacheException(message: 'Failed to update'));

          // act
          final result = await repository.updateLastUsed(1);

          // assert
          expect(result.isLeft(), true);
          result.fold(
            (failure) =>
                expect((failure as CacheFailure).message, 'Failed to update'),
            (_) => fail('Should return failure'),
          );
        },
      );
    });
  });
}
