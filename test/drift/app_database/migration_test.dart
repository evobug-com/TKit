// dart format width=80
// ignore_for_file: unused_local_variable, unused_import
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:tkit/core/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'generated/schema.dart';

import 'generated/schema_v5.dart' as v5;
import 'generated/schema_v6.dart' as v6;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  group('simple database migrations', () {
    // These simple tests verify all possible schema updates with a simple (no
    // data) migration. This is a quick way to ensure that written database
    // migrations properly alter the schema.
    const versions = GeneratedHelper.versions;
    for (final (i, fromVersion) in versions.indexed) {
      group('from $fromVersion', () {
        for (final toVersion in versions.skip(i + 1)) {
          test('to $toVersion', () async {
            final schema = await verifier.schemaAt(fromVersion);
            final db = AppDatabase(schema.newConnection());
            await verifier.migrateAndValidate(db, toVersion);
            await db.close();
          });
        }
      });
    }
  });

  // The following template shows how to write tests ensuring your migrations
  // preserve existing data.
  // Testing this can be useful for migrations that change existing columns
  // (e.g. by alterating their type or constraints). Migrations that only add
  // tables or columns typically don't need these advanced tests. For more
  // information, see https://drift.simonbinder.eu/migrations/tests/#verifying-data-integrity
  // TODO: This generated template shows how these tests could be written. Adopt
  // it to your own needs when testing migrations with data integrity.
  test('migration from v5 to v6 does not corrupt data', () async {
    // Add data to insert into the old database, and the expected rows after the
    // migration.
    // TODO: Fill these lists
    final oldCategoryMappingsData = <v5.CategoryMappingsData>[];
    final expectedNewCategoryMappingsData = <v6.CategoryMappingsData>[];

    final oldUpdateHistoryData = <v5.UpdateHistoryData>[];
    final expectedNewUpdateHistoryData = <v6.UpdateHistoryData>[];

    final oldUnknownProcessesData = <v5.UnknownProcessesData>[];
    final expectedNewUnknownProcessesData = <v6.UnknownProcessesData>[];

    final oldTopGamesCacheData = <v5.TopGamesCacheData>[];
    final expectedNewTopGamesCacheData = <v6.TopGamesCacheData>[];

    final oldCommunityMappingsData = <v5.CommunityMappingsData>[];
    final expectedNewCommunityMappingsData = <v6.CommunityMappingsData>[];

    await verifier.testWithDataIntegrity(
      oldVersion: 5,
      newVersion: 6,
      createOld: v5.DatabaseAtV5.new,
      createNew: v6.DatabaseAtV6.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insertAll(oldDb.categoryMappings, oldCategoryMappingsData);
        batch.insertAll(oldDb.updateHistory, oldUpdateHistoryData);
        batch.insertAll(oldDb.unknownProcesses, oldUnknownProcessesData);
        batch.insertAll(oldDb.topGamesCache, oldTopGamesCacheData);
        batch.insertAll(oldDb.communityMappings, oldCommunityMappingsData);
      },
      validateItems: (newDb) async {
        expect(
          expectedNewCategoryMappingsData,
          await newDb.select(newDb.categoryMappings).get(),
        );
        expect(
          expectedNewUpdateHistoryData,
          await newDb.select(newDb.updateHistory).get(),
        );
        expect(
          expectedNewUnknownProcessesData,
          await newDb.select(newDb.unknownProcesses).get(),
        );
        expect(
          expectedNewTopGamesCacheData,
          await newDb.select(newDb.topGamesCache).get(),
        );
        expect(
          expectedNewCommunityMappingsData,
          await newDb.select(newDb.communityMappings).get(),
        );
      },
    );
  });
}
