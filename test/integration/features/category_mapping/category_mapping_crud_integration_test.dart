import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tkit/core/database/app_database.dart';
import 'package:tkit/features/category_mapping/data/datasources/category_mapping_local_datasource.dart';
import 'package:tkit/features/category_mapping/data/datasources/memory_cache.dart';
import 'package:tkit/features/category_mapping/data/repositories/category_mapping_repository_impl.dart';
import 'package:tkit/features/category_mapping/domain/entities/category_mapping.dart';

void main() {
  late AppDatabase database;
  late CategoryMappingLocalDataSource dataSource;
  late MemoryCache memoryCache;
  late CategoryMappingRepositoryImpl repository;

  setUp(() async {
    // Initialize in-memory database for testing
    database = AppDatabase.test(NativeDatabase.memory());

    // Initialize data source, memory cache, and repository
    dataSource = CategoryMappingLocalDataSource(database);
    memoryCache = MemoryCache();
    repository = CategoryMappingRepositoryImpl(dataSource, memoryCache);
  });

  tearDown(() async {
    await database.close();
  });

  group('Category Mapping CRUD Integration Tests', () {
    test('should create, read, update, and delete a mapping', () async {
      // CREATE
      final newMapping = CategoryMapping(
        processName: 'TestGame.exe',
        twitchCategoryId: '12345',
        twitchCategoryName: 'Test Game',
        createdAt: DateTime.now(),
        lastApiFetch: DateTime.now(),
        cacheExpiresAt: DateTime.now().add(const Duration(hours: 24)),
        manualOverride: true,
      );

      final saveResult = await repository.saveMapping(newMapping);
      expect(saveResult.isRight(), true);

      // Clear cache to force database fetch which will have the ID
      memoryCache.clear();

      // READ
      final getAllResult = await repository.getAllMappings();
      expect(getAllResult.isRight(), true);

      getAllResult.fold((_) => fail('Should return success'), (mappings) {
        expect(mappings.length, greaterThan(0));
        // Find our mapping in the list
        final ourMapping = mappings.firstWhere(
          (m) => m.processName == 'TestGame.exe',
        );
        expect(ourMapping.twitchCategoryName, 'Test Game');
      });

      // Find by process name
      final findResult = await repository.findMapping('TestGame.exe', null);
      expect(findResult.isRight(), true);

      int? mappingId;
      findResult.fold((_) => fail('Should return success'), (mapping) {
        expect(mapping, isNotNull);
        expect(mapping!.processName, 'TestGame.exe');
        mappingId = mapping.id;
      });

      // UPDATE
      final updatedMapping = newMapping.copyWith(
        id: mappingId,
        twitchCategoryName: 'Updated Test Game',
      );

      final updateResult = await repository.saveMapping(updatedMapping);
      expect(updateResult.isRight(), true);

      // Verify update
      final verifyUpdateResult = await repository.findMapping(
        'TestGame.exe',
        null,
      );
      verifyUpdateResult.fold((_) => fail('Should return success'), (mapping) {
        expect(mapping, isNotNull);
        expect(mapping!.twitchCategoryName, 'Updated Test Game');
      });

      // UPDATE LAST USED
      final updateLastUsedResult = await repository.updateLastUsed(mappingId!);
      expect(updateLastUsedResult.isRight(), true);

      // Clear cache to force database fetch with updated lastUsedAt
      memoryCache.clear();

      // Verify last used was updated
      final verifyLastUsedResult = await repository.findMapping(
        'TestGame.exe',
        null,
      );
      verifyLastUsedResult.fold((_) => fail('Should return success'), (
        mapping,
      ) {
        expect(mapping, isNotNull);
        expect(mapping!.lastUsedAt, isNotNull);
      });

      // DELETE
      final deleteResult = await repository.deleteMapping(mappingId!);
      expect(deleteResult.isRight(), true);

      // Verify deletion - the specific mapping should be gone
      // Note: findMapping might still return a fuzzy match to another process
      // So we verify by getting all mappings and checking the ID is not present
      final allMappingsAfterDelete = await repository.getAllMappings();
      allMappingsAfterDelete.fold((_) => fail('Should return success'), (
        mappings,
      ) {
        final testGameMapping = mappings
            .where((m) => m.id == mappingId)
            .toList();
        expect(testGameMapping, isEmpty);
      });
    });

    test('should handle fuzzy matching correctly', () async {
      // Create test mapping for fuzzy matching
      final testMapping = CategoryMapping(
        processName: 'League of Legends.exe',
        twitchCategoryId: '21779',
        twitchCategoryName: 'League of Legends',
        createdAt: DateTime.now(),
        lastApiFetch: DateTime.now(),
        cacheExpiresAt: DateTime.now().add(const Duration(hours: 24)),
        manualOverride: true,
      );
      await repository.saveMapping(testMapping);

      // Test exact match
      final exactMatch = await repository.findMapping(
        'League of Legends.exe',
        null,
      );
      exactMatch.fold((_) => fail('Should return success'), (mapping) {
        expect(mapping, isNotNull);
        expect(mapping!.processName, 'League of Legends.exe');
      });

      // Test normalized match (case insensitive, no .exe)
      final normalizedMatch = await repository.findMapping(
        'leagueoflegends',
        null,
      );
      normalizedMatch.fold((_) => fail('Should return success'), (mapping) {
        expect(mapping, isNotNull);
        expect(mapping!.twitchCategoryName, 'League of Legends');
      });

      // Test fuzzy match (with typo - Legands instead of Legends)
      final fuzzyMatch = await repository.findMapping(
        'League of Legands.exe',
        null,
      );
      fuzzyMatch.fold((_) => fail('Should return success'), (mapping) {
        expect(mapping, isNotNull);
        expect(mapping!.twitchCategoryName, 'League of Legends');
      });

      // Test no match (too different)
      final noMatch = await repository.findMapping(
        'CompletelyDifferent.exe',
        null,
      );
      noMatch.fold((_) => fail('Should return success'), (mapping) {
        expect(mapping, isNull);
      });
    });

    test('should retrieve mappings ordered by last used', () async {
      // Create mappings
      final mapping1 = CategoryMapping(
        processName: 'Game1.exe',
        twitchCategoryId: '1',
        twitchCategoryName: 'Game 1',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        lastApiFetch: DateTime.now().subtract(const Duration(days: 10)),
        cacheExpiresAt: DateTime.now().add(const Duration(hours: 24)),
        manualOverride: true,
      );

      final mapping2 = CategoryMapping(
        processName: 'Game2.exe',
        twitchCategoryId: '2',
        twitchCategoryName: 'Game 2',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        lastApiFetch: DateTime.now().subtract(const Duration(days: 5)),
        cacheExpiresAt: DateTime.now().add(const Duration(hours: 24)),
        manualOverride: true,
      );

      await repository.saveMapping(mapping1);
      await repository.saveMapping(mapping2);

      // Clear cache to force database fetch which will have the IDs
      memoryCache.clear();

      // Get all mappings
      final getAllResult = await repository.getAllMappings();
      getAllResult.fold((_) => fail('Should return success'), (mappings) {
        expect(mappings.length, greaterThan(0));
        // Most recently created should be first (Game2) - among our test mappings
        final ourMappings = mappings
            .where(
              (m) =>
                  m.processName == 'Game1.exe' || m.processName == 'Game2.exe',
            )
            .toList();
        expect(ourMappings.length, 2);
        expect(ourMappings.first.processName, 'Game2.exe');
      });

      // Update last used for mapping1
      final findMapping1 = await repository.findMapping('Game1.exe', null);
      int? mapping1Id;
      findMapping1.fold((_) => fail('Should return success'), (mapping) {
        mapping1Id = mapping!.id;
      });

      await repository.updateLastUsed(mapping1Id!);

      // Now Game1 should be first (most recently used) - among our test mappings
      final getUpdatedResult = await repository.getAllMappings();
      getUpdatedResult.fold((_) => fail('Should return success'), (mappings) {
        final ourMappings = mappings
            .where(
              (m) =>
                  m.processName == 'Game1.exe' || m.processName == 'Game2.exe',
            )
            .toList();
        expect(ourMappings.length, 2);
        expect(ourMappings.first.processName, 'Game1.exe');
      });
    });
  });
}
