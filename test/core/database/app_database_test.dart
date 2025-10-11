import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tkit/core/database/app_database.dart';
import 'package:matcher/matcher.dart' as matcher;

void main() {
  late AppDatabase database;

  setUp(() {
    // Create in-memory database for testing
    database = AppDatabase.test(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  group('AppDatabase', () {
    group('Schema', () {
      test('should create all tables', () async {
        // Tables should be created automatically
        final mappings = await database.select(database.categoryMappings).get();
        final history = await database.select(database.updateHistory).get();

        // Database starts empty (no seed data - uses community sync)
        expect(mappings, isEmpty);
        expect(history, isEmpty);
      });

      test('should have correct indexes', () async {
        // Insert test data to verify indexes work
        await database
            .into(database.categoryMappings)
            .insert(
              CategoryMappingsCompanion.insert(
                processName: 'test.exe',
                twitchCategoryId: '12345',
                twitchCategoryName: 'Test Game',
                cacheExpiresAt: DateTime.now().add(const Duration(hours: 24)),
              ),
            );

        // Query using indexed column should work
        final result = await (database.select(
          database.categoryMappings,
        )..where((tbl) => tbl.processName.equals('test.exe'))).get();

        expect(result, hasLength(1));
        expect(result.first.processName, 'test.exe');
      });
    });

    group('CategoryMappings', () {
      test('should insert category mapping with default values', () async {
        // Clear seeded data first
        await database.delete(database.categoryMappings).go();

        final now = DateTime.now();

        await database
            .into(database.categoryMappings)
            .insert(
              CategoryMappingsCompanion.insert(
                processName: 'game.exe',
                twitchCategoryId: '54321',
                twitchCategoryName: 'Cool Game',
                cacheExpiresAt: DateTime.now().add(const Duration(hours: 24)),
              ),
            );

        final mappings = await database.select(database.categoryMappings).get();

        expect(mappings, hasLength(1));
        expect(mappings.first.processName, 'game.exe');
        expect(mappings.first.twitchCategoryId, '54321');
        expect(mappings.first.twitchCategoryName, 'Cool Game');
        expect(mappings.first.executablePath, matcher.isNull);
        expect(mappings.first.manualOverride, false);
        expect(mappings.first.createdAt.difference(now).inSeconds, lessThan(2));
        expect(mappings.first.lastUsedAt, matcher.isNull);
      });

      test('should insert category mapping with all fields', () async {
        // Clear seeded data first
        await database.delete(database.categoryMappings).go();

        await database
            .into(database.categoryMappings)
            .insert(
              CategoryMappingsCompanion.insert(
                processName: 'custom.exe',
                executablePath: const Value('C:\\Games\\custom.exe'),
                twitchCategoryId: '99999',
                twitchCategoryName: 'Custom Game',
                cacheExpiresAt: DateTime.now().add(const Duration(hours: 24)),
                manualOverride: const Value(true),
                lastUsedAt: Value(DateTime.now()),
              ),
            );

        final mappings = await database.select(database.categoryMappings).get();

        expect(mappings, hasLength(1));
        expect(mappings.first.processName, 'custom.exe');
        expect(mappings.first.executablePath, 'C:\\Games\\custom.exe');
        expect(mappings.first.manualOverride, true);
        expect(mappings.first.lastUsedAt, matcher.isNotNull);
      });

      test('should update existing mapping', () async {
        // Clear seeded data first
        await database.delete(database.categoryMappings).go();

        // Insert
        final id = await database
            .into(database.categoryMappings)
            .insert(
              CategoryMappingsCompanion.insert(
                processName: 'test.exe',
                twitchCategoryId: '11111',
                twitchCategoryName: 'Test',
                cacheExpiresAt: DateTime.now().add(const Duration(hours: 24)),
              ),
            );

        // Update
        final updatedAt = DateTime.now();
        await (database.update(database.categoryMappings)
              ..where((tbl) => tbl.id.equals(id)))
            .write(CategoryMappingsCompanion(lastUsedAt: Value(updatedAt)));

        final mapping = await (database.select(
          database.categoryMappings,
        )..where((tbl) => tbl.id.equals(id))).getSingle();

        expect(mapping.lastUsedAt, matcher.isNotNull);
        expect(
          mapping.lastUsedAt!.difference(updatedAt).inSeconds,
          lessThan(2),
        );
      });

      test('should delete mapping', () async {
        // Clear seeded data first
        await database.delete(database.categoryMappings).go();

        final id = await database
            .into(database.categoryMappings)
            .insert(
              CategoryMappingsCompanion.insert(
                processName: 'delete.exe',
                twitchCategoryId: '77777',
                twitchCategoryName: 'Delete Me',
                cacheExpiresAt: DateTime.now().add(const Duration(hours: 24)),
              ),
            );

        await (database.delete(
          database.categoryMappings,
        )..where((tbl) => tbl.id.equals(id))).go();

        final mappings = await database.select(database.categoryMappings).get();
        expect(mappings, isEmpty);
      });

      test('should query by process name', () async {
        // Clear seeded data first
        await database.delete(database.categoryMappings).go();

        await database
            .into(database.categoryMappings)
            .insert(
              CategoryMappingsCompanion.insert(
                processName: 'game1.exe',
                twitchCategoryId: '1',
                twitchCategoryName: 'Game 1',
                cacheExpiresAt: DateTime.now().add(const Duration(hours: 24)),
              ),
            );

        await database
            .into(database.categoryMappings)
            .insert(
              CategoryMappingsCompanion.insert(
                processName: 'game2.exe',
                twitchCategoryId: '2',
                twitchCategoryName: 'Game 2',
                cacheExpiresAt: DateTime.now().add(const Duration(hours: 24)),
              ),
            );

        final result = await (database.select(
          database.categoryMappings,
        )..where((tbl) => tbl.processName.equals('game1.exe'))).get();

        expect(result, hasLength(1));
        expect(result.first.processName, 'game1.exe');
      });
    });

    group('UpdateHistory', () {
      test('should insert update history entry', () async {
        final now = DateTime.now();

        await database
            .into(database.updateHistory)
            .insert(
              UpdateHistoryCompanion.insert(
                processName: 'test.exe',
                categoryId: '12345',
                categoryName: 'Test Game',
                success: true,
              ),
            );

        final history = await database.select(database.updateHistory).get();

        expect(history, hasLength(1));
        expect(history.first.processName, 'test.exe');
        expect(history.first.categoryId, '12345');
        expect(history.first.categoryName, 'Test Game');
        expect(history.first.success, true);
        expect(history.first.errorMessage, matcher.isNull);
        expect(history.first.updatedAt.difference(now).inSeconds, lessThan(2));
      });

      test('should insert failed update with error message', () async {
        await database
            .into(database.updateHistory)
            .insert(
              UpdateHistoryCompanion.insert(
                processName: 'failed.exe',
                categoryId: '99999',
                categoryName: 'Failed Game',
                success: false,
                errorMessage: const Value('Network error'),
              ),
            );

        final history = await database.select(database.updateHistory).get();

        expect(history, hasLength(1));
        expect(history.first.success, false);
        expect(history.first.errorMessage, 'Network error');
      });

      test('should query history ordered by date descending', () async {
        // Insert multiple entries with explicit timestamps to ensure ordering
        final oldTime = DateTime.now().subtract(const Duration(seconds: 10));
        final newTime = DateTime.now();

        await database
            .into(database.updateHistory)
            .insert(
              UpdateHistoryCompanion.insert(
                processName: 'old.exe',
                categoryId: '1',
                categoryName: 'Old',
                success: true,
                updatedAt: Value(oldTime),
              ),
            );

        await database
            .into(database.updateHistory)
            .insert(
              UpdateHistoryCompanion.insert(
                processName: 'new.exe',
                categoryId: '2',
                categoryName: 'New',
                success: true,
                updatedAt: Value(newTime),
              ),
            );

        final history = await (database.select(
          database.updateHistory,
        )..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)])).get();

        expect(history, hasLength(2));
        expect(history.first.processName, 'new.exe');
        expect(history.last.processName, 'old.exe');
      });
    });

    group('CommunityMappings', () {
      test('should insert community mapping', () async {
        await database.into(database.communityMappings).insert(
              CommunityMappingsCompanion.insert(
                processName: 'League of Legends.exe',
                twitchCategoryId: '21779',
                twitchCategoryName: 'League of Legends',
                verificationCount: const Value(10),
              ),
            );

        final mappings = await database.select(database.communityMappings).get();

        expect(mappings.length, 1);
        expect(mappings.first.processName, 'League of Legends.exe');
        expect(mappings.first.twitchCategoryId, '21779');
        expect(mappings.first.verificationCount, 10);
      });

      test('should upsert community mappings', () async {
        final mappingsData = [
          {
            'processName': 'Valorant.exe',
            'twitchCategoryId': '516575',
            'twitchCategoryName': 'Valorant',
            'verificationCount': 5,
          },
          {
            'processName': 'Minecraft.exe',
            'twitchCategoryId': '27471',
            'twitchCategoryName': 'Minecraft',
            'verificationCount': 15,
          },
        ];

        await database.upsertCommunityMappings(mappingsData);

        final mappings = await database.select(database.communityMappings).get();

        expect(mappings.length, 2);
        expect(mappings.any((m) => m.processName == 'Valorant.exe'), true);
        expect(mappings.any((m) => m.processName == 'Minecraft.exe'), true);
      });

      test('should get community mapping by process name', () async {
        await database.into(database.communityMappings).insert(
              CommunityMappingsCompanion.insert(
                processName: 'TestGame.exe',
                twitchCategoryId: '12345',
                twitchCategoryName: 'Test Game',
              ),
            );

        final mapping = await database.getCommunityMapping('TestGame.exe');

        expect(mapping, matcher.isNotNull);
        expect(mapping!.processName, 'TestGame.exe');
        expect(mapping.twitchCategoryId, '12345');
      });
    });

    group('Migration', () {
      test('should have correct schema version', () {
        expect(database.schemaVersion, 3);
      });
    });
  });
}
