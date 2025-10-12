import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tkit/core/database/app_database.dart';
import 'package:tkit/features/category_mapping/data/datasources/category_mapping_local_datasource.dart';
import 'package:tkit/features/category_mapping/data/models/category_mapping_model.dart';

void main() {
  late AppDatabase database;
  late CategoryMappingLocalDataSource dataSource;

  setUp(() async {
    // Use in-memory database for testing
    database = AppDatabase.test(NativeDatabase.memory());
    dataSource = CategoryMappingLocalDataSource(database);

    // Insert test data
    await database
        .into(database.categoryMappings)
        .insert(
          CategoryMappingsCompanion.insert(
            processName: 'League of Legends.exe',
            twitchCategoryId: '21779',
            twitchCategoryName: 'League of Legends',
            cacheExpiresAt: DateTime.now().add(const Duration(hours: 24)),
            manualOverride: const Value(false),
          ),
        );
    await database
        .into(database.categoryMappings)
        .insert(
          CategoryMappingsCompanion.insert(
            processName: 'Valorant.exe',
            twitchCategoryId: '516575',
            twitchCategoryName: 'VALORANT',
            cacheExpiresAt: DateTime.now().add(const Duration(hours: 24)),
            manualOverride: const Value(false),
          ),
        );
  });

  tearDown(() async {
    await database.close();
  });

  group('CategoryMappingLocalDataSource - findMapping', () {
    test('should find exact match', () async {
      // act
      final result = await dataSource.findMapping(
        'League of Legends.exe',
        null,
      );

      // assert
      expect(result, isNotNull);
      expect(result!.processName, 'League of Legends.exe');
      expect(result.twitchCategoryId, '21779');
    });

    test('should find normalized match (case insensitive)', () async {
      // act
      final result = await dataSource.findMapping(
        'LEAGUE OF LEGENDS.EXE',
        null,
      );

      // assert
      expect(result, isNotNull);
      expect(result!.twitchCategoryId, '21779');
    });

    test('should find match without .exe extension', () async {
      // act
      final result = await dataSource.findMapping('League of Legends', null);

      // assert
      expect(result, isNotNull);
      expect(result!.twitchCategoryId, '21779');
    });

    test('should find match ignoring spaces and dashes', () async {
      // act
      final result = await dataSource.findMapping('LeagueofLegends', null);

      // assert
      expect(result, isNotNull);
      expect(result!.twitchCategoryId, '21779');
    });

    test('should return null when no match found', () async {
      // act
      final result = await dataSource.findMapping('Nonexistent.exe', null);

      // assert
      expect(result, isNull);
    });

    test('should match by executable path if provided', () async {
      // arrange
      const path = 'C:\\Games\\Valorant\\Valorant.exe';
      await database
          .into(database.categoryMappings)
          .insert(
            CategoryMappingsCompanion.insert(
              processName: 'Valorant-Win64-Shipping.exe',
              executablePath: const Value(path),
              twitchCategoryId: '516575',
              twitchCategoryName: 'VALORANT',
              cacheExpiresAt: DateTime.now().add(const Duration(hours: 24)),
              manualOverride: const Value(false),
            ),
          );

      // act
      final result = await dataSource.findMapping('Different.exe', path);

      // assert
      expect(result, isNotNull);
      expect(result!.twitchCategoryId, '516575');
    });
  });

  group('CategoryMappingLocalDataSource - getAllMappings', () {
    test('should return all mappings ordered by last used', () async {
      // arrange
      final now = DateTime.now();
      await database
          .into(database.categoryMappings)
          .insert(
            CategoryMappingsCompanion.insert(
              processName: 'Recent.exe',
              twitchCategoryId: '12345',
              twitchCategoryName: 'Recent Game',
              cacheExpiresAt: DateTime.now().add(const Duration(hours: 24)),
              lastUsedAt: Value(now),
              manualOverride: const Value(true),
            ),
          );

      // act
      final result = await dataSource.getAllMappings();

      // assert
      expect(result.length, greaterThanOrEqualTo(2));
      // Most recently used should be first
      expect(result.first.processName, 'Recent.exe');
    });

    test('should return empty list when no mappings exist', () async {
      // arrange
      await database.delete(database.categoryMappings).go();

      // act
      final result = await dataSource.getAllMappings();

      // assert
      expect(result, isEmpty);
    });
  });

  group('CategoryMappingLocalDataSource - saveMapping', () {
    test('should insert new mapping', () async {
      // arrange
      final newMapping = CategoryMappingModel(
        processName: 'NewGame.exe',
        twitchCategoryId: '99999',
        twitchCategoryName: 'New Game',
        createdAt: DateTime.now(),
        lastApiFetch: DateTime.now(),
        cacheExpiresAt: DateTime.now().add(const Duration(hours: 24)),
        manualOverride: true,
      );

      // act
      await dataSource.saveMapping(newMapping);

      // assert
      final result = await dataSource.findMapping('NewGame.exe', null);
      expect(result, isNotNull);
      expect(result!.twitchCategoryId, '99999');
    });

    test('should update existing mapping', () async {
      // arrange
      final existing = await dataSource.findMapping('Valorant.exe', null);
      final updated = CategoryMappingModel(
        id: existing!.id,
        processName: 'Valorant.exe',
        twitchCategoryId: '999999',
        twitchCategoryName: 'Updated VALORANT',
        createdAt: existing.createdAt,
        lastApiFetch: existing.lastApiFetch,
        cacheExpiresAt: existing.cacheExpiresAt,
        manualOverride: true,
      );

      // act
      await dataSource.saveMapping(updated);

      // assert
      final result = await dataSource.findMapping('Valorant.exe', null);
      expect(result!.twitchCategoryId, '999999');
      expect(result.twitchCategoryName, 'Updated VALORANT');
    });
  });

  group('CategoryMappingLocalDataSource - deleteMapping', () {
    test('should delete mapping by id', () async {
      // arrange
      final allBefore = await dataSource.getAllMappings();
      final countBefore = allBefore.length;
      final mapping = await dataSource.findMapping(
        'League of Legends.exe',
        null,
      );
      final id = mapping!.id!;

      // act
      await dataSource.deleteMapping(id);

      // assert
      final allAfter = await dataSource.getAllMappings();
      expect(allAfter.length, countBefore - 1);
      // The specific mapping should be gone
      expect(allAfter.where((m) => m.id == id).isEmpty, true);
    });
  });

  group('CategoryMappingLocalDataSource - updateLastUsed', () {
    test('should update last used timestamp', () async {
      // arrange
      final mapping = await dataSource.findMapping('Valorant.exe', null);
      final id = mapping!.id!;
      await Future.delayed(const Duration(milliseconds: 100));

      // act
      await dataSource.updateLastUsed(id);

      // assert
      final result = await dataSource.findMapping('Valorant.exe', null);
      expect(result!.lastUsedAt, isNotNull);
    });
  });
}
