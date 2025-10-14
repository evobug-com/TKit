import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart' as sqlite;

part 'app_database.g.dart';

/// Category Mappings table - stores process-to-Twitch-category mappings
///
/// Cache Policy (Twitch Developer Agreement Compliance):
/// - All Twitch-sourced data must be refreshed within 24 hours
/// - lastApiFetch: When category data was fetched from Twitch API
/// - cacheExpiresAt: When this mapping must be refreshed (lastApiFetch + 24h)
/// - manualOverride: User-created mappings that persist indefinitely (but Twitch data still refreshes)
///
/// Privacy-Preserving Path Tracking:
/// - normalizedInstallPaths: JSON array of privacy-safe installation paths
///   (e.g., ["steamapps/common/dota 2", "epic games/dota 2"])
/// - Only stores game-identifying path segments, never usernames or personal folders
/// - executablePath: Deprecated, kept for backward compatibility
@DataClassName('CategoryMappingEntity')
class CategoryMappings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get processName => text()();

  /// @deprecated Use normalizedInstallPaths instead
  TextColumn get executablePath => text().nullable()();

  /// JSON array of normalized, privacy-safe installation paths
  /// Example: ["steamapps/common/dota 2", "program files (x86)/ea games/battlefield"]
  TextColumn get normalizedInstallPaths => text().nullable()();

  TextColumn get twitchCategoryId => text()();
  TextColumn get twitchCategoryName => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastUsedAt => dateTime().nullable()();
  DateTimeColumn get lastApiFetch => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get cacheExpiresAt => dateTime()();
  BoolColumn get manualOverride =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get isEnabled =>
      boolean().withDefault(const Constant(true))();

  /// The ID of the mapping list this mapping belongs to
  /// Nullable for backward compatibility with legacy mappings
  TextColumn get listId => text().nullable()();
}

/// Update History table - stores history of category updates
@DataClassName('UpdateHistoryEntity')
class UpdateHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get processName => text()();
  TextColumn get categoryId => text()();
  TextColumn get categoryName => text()();
  BoolColumn get success => boolean()();
  TextColumn get errorMessage => text().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Unknown Processes table - tracks processes with no mapping for community contribution
@DataClassName('UnknownProcessEntity')
class UnknownProcesses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get executableName => text()();
  TextColumn get windowTitle => text().nullable()();
  DateTimeColumn get firstDetected => dateTime().withDefault(currentDateAndTime)();
  IntColumn get occurrenceCount => integer().withDefault(const Constant(1))();
  BoolColumn get resolved => boolean().withDefault(const Constant(false))();
}

/// Top Games Cache table - stores popular games from Twitch for quick lookups
@DataClassName('TopGameEntity')
class TopGamesCache extends Table {
  TextColumn get twitchCategoryId => text()();
  TextColumn get gameName => text()();
  TextColumn get boxArtUrl => text().nullable()();
  DateTimeColumn get lastUpdated => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get expiresAt => dateTime()();

  @override
  Set<Column> get primaryKey => {twitchCategoryId};
}

/// Community Mappings table - stores crowdsourced game mappings from GitHub
///
/// Privacy-Preserving Path Tracking:
/// - normalizedInstallPaths: JSON array of common privacy-safe installation paths
///   reported by the community (e.g., ["steamapps/common/dota 2"])
@DataClassName('CommunityMappingEntity')
class CommunityMappings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get processName => text()();

  /// JSON array of normalized, privacy-safe installation paths from community
  /// Example: ["steamapps/common/dota 2", "program files (x86)/ea games/battlefield"]
  TextColumn get normalizedInstallPaths => text().nullable()();

  TextColumn get twitchCategoryId => text()();
  TextColumn get twitchCategoryName => text()();
  IntColumn get verificationCount => integer().withDefault(const Constant(1))();
  DateTimeColumn get lastVerified => dateTime().nullable()();
  TextColumn get source => text().withDefault(const Constant('community'))();

  /// Category type: 'game' (default), 'system', 'launcher', 'browser', etc.
  /// Used to group and filter mappings (e.g., show ignored programs separately)
  TextColumn get category => text().nullable()();

  DateTimeColumn get syncedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>>? get uniqueKeys => [
        {processName, twitchCategoryId}
      ];
}

/// Mapping Lists table - stores collections of mappings
///
/// Lists can be Local (user-created), Official (verified by TKit), or Remote (third-party).
/// Each list can be enabled/disabled and has a priority for conflict resolution.
@DataClassName('MappingListEntity')
class MappingLists extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get sourceType => text()(); // 'local', 'official', 'remote'
  TextColumn get sourceUrl => text().nullable()();
  TextColumn get submissionHookUrl => text().nullable()(); // URL for submitting unknown processes
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();
  BoolColumn get isReadOnly => boolean().withDefault(const Constant(false))();
  IntColumn get priority => integer().withDefault(const Constant(100))(); // Lower = higher priority
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
  TextColumn get lastSyncError => text().nullable()(); // Error message from last sync attempt
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  CategoryMappings,
  UpdateHistory,
  UnknownProcesses,
  TopGamesCache,
  CommunityMappings,
  MappingLists,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Test constructor for in-memory database
  AppDatabase.test(super.e);

  @override
  int get schemaVersion => 9;

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'tkit.db'));

      // Setup native library on Linux
      if (Platform.isLinux) {
        sqlite.sqlite3.tempDirectory = (await getTemporaryDirectory()).path;
      }

      return NativeDatabase.createInBackground(file);
    });
  }

  /// Get community mapping by process name
  Future<CommunityMappingEntity?> getCommunityMapping(String processName) async {
    return (select(communityMappings)
          ..where((tbl) => tbl.processName.equals(processName)))
        .getSingleOrNull();
  }

  /// Get all community mappings
  Future<List<CommunityMappingEntity>> getAllCommunityMappings() async {
    return select(communityMappings).get();
  }

  /// Update or insert community mappings from sync
  Future<void> upsertCommunityMappings(
    List<Map<String, dynamic>> mappingsData,
  ) async {
    await transaction(() async {
      for (final data in mappingsData) {
        // Use insertOrReplace to handle the unique constraint on (processName, twitchCategoryId)
        await into(communityMappings).insert(
          CommunityMappingsCompanion.insert(
            processName: data['processName'] as String,
            normalizedInstallPaths: Value(
              data['normalizedInstallPaths'] != null
                  ? (data['normalizedInstallPaths'] as List)
                      .map((e) => e.toString())
                      .toList()
                      .join(',')
                  : null,
            ),
            twitchCategoryId: data['twitchCategoryId'] as String,
            twitchCategoryName: data['twitchCategoryName'] as String,
            verificationCount:
                Value(data['verificationCount'] as int? ?? 1),
            lastVerified: Value(
              data['lastVerified'] != null
                  ? DateTime.parse(data['lastVerified'] as String)
                  : null,
            ),
            source: Value(data['source'] as String? ?? 'community'),
            category: Value(data['category'] as String?),
            syncedAt: Value(DateTime.now()),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  /// Clear community mappings (for fresh sync)
  Future<void> clearCommunityMappings() async {
    await delete(communityMappings).go();
  }

  /// Get expired category mappings
  Future<List<CategoryMappingEntity>> getExpiredMappings() async {
    return (select(categoryMappings)
          ..where((tbl) => tbl.cacheExpiresAt.isSmallerThanValue(DateTime.now()))
          ..where((tbl) => tbl.manualOverride.equals(false)))
        .get();
  }

  /// Get mappings expiring soon (within threshold)
  Future<List<CategoryMappingEntity>> getMappingsExpiringSoon(
    Duration threshold,
  ) async {
    final expiryTime = DateTime.now().add(threshold);
    return (select(categoryMappings)
          ..where((tbl) => tbl.cacheExpiresAt.isSmallerThanValue(expiryTime))
          ..where((tbl) => tbl.manualOverride.equals(false)))
        .get();
  }

  /// Delete expired mappings (excluding manual overrides)
  Future<int> deleteExpiredMappings() async {
    return (delete(categoryMappings)
          ..where((tbl) => tbl.cacheExpiresAt.isSmallerThanValue(DateTime.now()))
          ..where((tbl) => tbl.manualOverride.equals(false)))
        .go();
  }

  /// Clear all data from the database
  Future<void> clearAllData() async {
    await transaction(() async {
      // Delete all data from all tables
      await delete(categoryMappings).go();
      await delete(updateHistory).go();
      await delete(unknownProcesses).go();
      await delete(topGamesCache).go();
      await delete(communityMappings).go();
    });
  }

  /// Seed default mappings on first run
  /// This method populates the database with default ignored processes
  Future<void> seedDefaultMappings() async {
    // Check if already seeded by looking for tkit.exe mapping
    final existing = await (select(categoryMappings)
          ..where((tbl) => tbl.processName.equals('tkit.exe')))
        .getSingleOrNull();

    if (existing != null) {
      // Already seeded, skip
      return;
    }

    await transaction(() async {
      final now = DateTime.now();
      final expiresAt = now.add(const Duration(hours: 24));

      // List of default ignored processes
      final defaultIgnored = [
        // TKit itself - should be ignored by default
        {
          'processName': 'tkit.exe',
          'twitchCategoryId': 'IGNORE',
          'twitchCategoryName': 'Ignored Process',
          'isEnabled': false,
        },
      ];

      // Insert default ignored processes
      for (final mapping in defaultIgnored) {
        await into(categoryMappings).insert(
          CategoryMappingsCompanion.insert(
            processName: mapping['processName']! as String,
            twitchCategoryId: mapping['twitchCategoryId']! as String,
            twitchCategoryName: mapping['twitchCategoryName']! as String,
            lastApiFetch: Value(now),
            cacheExpiresAt: expiresAt,
            manualOverride: const Value(true), // User can modify these
            isEnabled: Value(mapping['isEnabled'] as bool),
          ),
          mode: InsertMode.insertOrIgnore, // Avoid duplicates
        );
      }
    });
  }

  /// Seed initial mappings for testing purposes
  /// This method populates the database with common game-to-category mappings
  Future<void> seedInitialMappings() async {
    await transaction(() async {
      final now = DateTime.now();
      final expiresAt = now.add(const Duration(hours: 24));

      // List of initial mappings - popular games
      final seedMappings = [
        {
          'processName': 'League of Legends.exe',
          'twitchCategoryId': '21779',
          'twitchCategoryName': 'League of Legends',
        },
        {
          'processName': 'Dota2.exe',
          'twitchCategoryId': '29595',
          'twitchCategoryName': 'Dota 2',
        },
        {
          'processName': 'csgo.exe',
          'twitchCategoryId': '32399',
          'twitchCategoryName': 'Counter-Strike: Global Offensive',
        },
        {
          'processName': 'Overwatch.exe',
          'twitchCategoryId': '488552',
          'twitchCategoryName': 'Overwatch',
        },
        {
          'processName': 'Valorant.exe',
          'twitchCategoryId': '516575',
          'twitchCategoryName': 'VALORANT',
        },
        {
          'processName': 'FortniteClient-Win64-Shipping.exe',
          'twitchCategoryId': '33214',
          'twitchCategoryName': 'Fortnite',
        },
        {
          'processName': 'RocketLeague.exe',
          'twitchCategoryId': '30921',
          'twitchCategoryName': 'Rocket League',
        },
        {
          'processName': 'ApexLegends.exe',
          'twitchCategoryId': '511224',
          'twitchCategoryName': 'Apex Legends',
        },
        {
          'processName': 'Minecraft.exe',
          'twitchCategoryId': '27471',
          'twitchCategoryName': 'Minecraft',
        },
        {
          'processName': 'javaw.exe',
          'twitchCategoryId': '27471',
          'twitchCategoryName': 'Minecraft',
        },
        {
          'processName': 'wow.exe',
          'twitchCategoryId': '18122',
          'twitchCategoryName': 'World of Warcraft',
        },
        {
          'processName': 'GTA5.exe',
          'twitchCategoryId': '32982',
          'twitchCategoryName': 'Grand Theft Auto V',
        },
        {
          'processName': 'RainbowSix.exe',
          'twitchCategoryId': '460630',
          'twitchCategoryName': "Tom Clancy's Rainbow Six Siege",
        },
        {
          'processName': 'PUBG.exe',
          'twitchCategoryId': '493057',
          'twitchCategoryName': "PLAYERUNKNOWN'S BATTLEGROUNDS",
        },
        {
          'processName': 'warzone.exe',
          'twitchCategoryId': '512710',
          'twitchCategoryName': 'Call of Duty: Warzone',
        },
        {
          'processName': 'EscapeFromTarkov.exe',
          'twitchCategoryId': '491931',
          'twitchCategoryName': 'Escape from Tarkov',
        },
        {
          'processName': 'Among Us.exe',
          'twitchCategoryId': '510218',
          'twitchCategoryName': 'Among Us',
        },
        {
          'processName': 'StarCraft II.exe',
          'twitchCategoryId': '490422',
          'twitchCategoryName': 'StarCraft II',
        },
        {
          'processName': 'hearthstone.exe',
          'twitchCategoryId': '138585',
          'twitchCategoryName': 'Hearthstone',
        },
        {
          'processName': 'RustClient.exe',
          'twitchCategoryId': '263490',
          'twitchCategoryName': 'Rust',
        },
        {
          'processName': 'ARK.exe',
          'twitchCategoryId': '489635',
          'twitchCategoryName': 'ARK: Survival Evolved',
        },
        {
          'processName': 'Destiny2.exe',
          'twitchCategoryId': '497057',
          'twitchCategoryName': 'Destiny 2',
        },
        {
          'processName': 'r5apex.exe',
          'twitchCategoryId': '511224',
          'twitchCategoryName': 'Apex Legends',
        },
        {
          'processName': 'FallGuys_client.exe',
          'twitchCategoryId': '512980',
          'twitchCategoryName': 'Fall Guys',
        },
        {
          'processName': 'EldenRing.exe',
          'twitchCategoryId': '512953',
          'twitchCategoryName': 'Elden Ring',
        },
        {
          'processName': 'LostArk.exe',
          'twitchCategoryId': '490100',
          'twitchCategoryName': 'Lost Ark',
        },
        {
          'processName': 'DeadByDaylight-Win64-Shipping.exe',
          'twitchCategoryId': '491487',
          'twitchCategoryName': 'Dead by Daylight',
        },
        {
          'processName': 'Terraria.exe',
          'twitchCategoryId': '31376',
          'twitchCategoryName': 'Terraria',
        },
        {
          'processName': 'SeaOfThieves.exe',
          'twitchCategoryId': '490377',
          'twitchCategoryName': 'Sea of Thieves',
        },
        {
          'processName': 'Phasmophobia.exe',
          'twitchCategoryId': '518184',
          'twitchCategoryName': 'Phasmophobia',
        },
      ];

      // Insert all seed mappings
      for (final mapping in seedMappings) {
        await into(categoryMappings).insert(
          CategoryMappingsCompanion.insert(
            processName: mapping['processName']!,
            twitchCategoryId: mapping['twitchCategoryId']!,
            twitchCategoryName: mapping['twitchCategoryName']!,
            lastApiFetch: Value(now),
            cacheExpiresAt: expiresAt,
            manualOverride: const Value(false),
          ),
          mode: InsertMode.insertOrIgnore, // Avoid duplicates
        );
      }
    });
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();

      // Create indexes
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_category_mappings_process_name '
        'ON category_mappings(process_name)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_category_mappings_last_used '
        'ON category_mappings(last_used_at)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_category_mappings_cache_expires '
        'ON category_mappings(cache_expires_at)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_update_history_updated_at '
        'ON update_history(updated_at DESC)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_unknown_processes_resolved '
        'ON unknown_processes(resolved)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_community_mappings_process_name '
        'ON community_mappings(process_name)',
      );

      // No seed data - will be populated from community sync
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from == 1 && to >= 2) {
        // Migration v1 → v2: Add cache expiry fields and new tables
        // SQLite doesn't support non-constant defaults in ALTER TABLE,
        // so we recreate the table with data migration

        // Get current timestamp in milliseconds for migration
        final nowMs = DateTime.now().millisecondsSinceEpoch;
        final expiresMs = DateTime.now().add(const Duration(hours: 24)).millisecondsSinceEpoch;

        // Create new table with updated schema
        await customStatement(
          'CREATE TABLE category_mappings_new ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'process_name TEXT NOT NULL, '
          'executable_path TEXT, '
          'twitch_category_id TEXT NOT NULL, '
          'twitch_category_name TEXT NOT NULL, '
          'created_at INTEGER NOT NULL, '
          'last_used_at INTEGER, '
          'last_api_fetch INTEGER NOT NULL, '
          'cache_expires_at INTEGER NOT NULL, '
          'manual_override INTEGER NOT NULL DEFAULT 0'
          ')',
        );

        // Copy data from old table to new table with new timestamp fields
        await customStatement(
          'INSERT INTO category_mappings_new '
          '(id, process_name, executable_path, twitch_category_id, twitch_category_name, '
          'created_at, last_used_at, last_api_fetch, cache_expires_at, manual_override) '
          'SELECT id, process_name, executable_path, twitch_category_id, twitch_category_name, '
          'created_at, last_used_at, $nowMs, $expiresMs, is_user_defined '
          'FROM category_mappings',
        );

        // Drop old table and rename new one
        await customStatement('DROP TABLE category_mappings');
        await customStatement('ALTER TABLE category_mappings_new RENAME TO category_mappings');

        // Create new tables
        await m.createTable(unknownProcesses);
        await m.createTable(topGamesCache);

        // Create indexes
        await customStatement(
          'CREATE INDEX idx_category_mappings_process_name '
          'ON category_mappings(process_name)',
        );
        await customStatement(
          'CREATE INDEX idx_category_mappings_last_used '
          'ON category_mappings(last_used_at)',
        );
        await customStatement(
          'CREATE INDEX idx_category_mappings_cache_expires '
          'ON category_mappings(cache_expires_at)',
        );
        await customStatement(
          'CREATE INDEX idx_unknown_processes_resolved '
          'ON unknown_processes(resolved)',
        );
      }

      if (from == 2 && to >= 3) {
        // Migration v2 → v3: Add community_mappings table
        await m.createTable(communityMappings);

        // Create index for community mappings
        await customStatement(
          'CREATE INDEX idx_community_mappings_process_name '
          'ON community_mappings(process_name)',
        );

        // Migrate existing hardcoded mappings to community_mappings as 'verified' source
        // These will serve as initial seed data until first sync
        await customStatement(
          'INSERT INTO community_mappings '
          '(process_name, twitch_category_id, twitch_category_name, verification_count, source, synced_at) '
          'SELECT process_name, twitch_category_id, twitch_category_name, 100, \'verified\', ${DateTime.now().millisecondsSinceEpoch} '
          'FROM category_mappings WHERE manual_override = 0',
        );
      }

      if (from == 3 && to >= 4) {
        // Migration v3 → v4: Add isEnabled field
        // Check if column already exists to make migration idempotent
        final result = await customSelect(
          'PRAGMA table_info(category_mappings)',
        ).get();

        final hasIsEnabled = result.any((row) => row.data['name'] == 'is_enabled');

        if (!hasIsEnabled) {
          await customStatement(
            'ALTER TABLE category_mappings ADD COLUMN is_enabled INTEGER NOT NULL DEFAULT 1',
          );
        }
      }

      if (from == 4 && to >= 5) {
        // Migration v4 → v5: Add normalizedInstallPaths for privacy-preserving path tracking
        // Check if column already exists to make migration idempotent
        final categoryMappingsInfo = await customSelect(
          'PRAGMA table_info(category_mappings)',
        ).get();

        final hasNormalizedPaths = categoryMappingsInfo.any(
          (row) => row.data['name'] == 'normalized_install_paths',
        );

        if (!hasNormalizedPaths) {
          await customStatement(
            'ALTER TABLE category_mappings ADD COLUMN normalized_install_paths TEXT',
          );
        }

        // Also add to community_mappings table
        final communityMappingsInfo = await customSelect(
          'PRAGMA table_info(community_mappings)',
        ).get();

        final hasNormalizedPathsCommunity = communityMappingsInfo.any(
          (row) => row.data['name'] == 'normalized_install_paths',
        );

        if (!hasNormalizedPathsCommunity) {
          await customStatement(
            'ALTER TABLE community_mappings ADD COLUMN normalized_install_paths TEXT',
          );
        }

        // Note: We don't auto-migrate executablePath to normalizedInstallPaths
        // because we need PathNormalizer to extract privacy-safe paths.
        // The app will handle this migration on-the-fly when mappings are accessed.
      }

      if (from == 5 && to >= 6) {
        // Migration v5 → v6: Add category field to community_mappings
        // This allows grouping mappings by type (game, system, launcher, etc.)
        final communityMappingsInfo = await customSelect(
          'PRAGMA table_info(community_mappings)',
        ).get();

        final hasCategory = communityMappingsInfo.any(
          (row) => row.data['name'] == 'category',
        );

        if (!hasCategory) {
          await customStatement(
            'ALTER TABLE community_mappings ADD COLUMN category TEXT',
          );
        }
      }

      if (from == 6 && to >= 7) {
        // Migration v6 → v7: Add mapping_lists table and listId to category_mappings
        // This introduces the list-based mapping system

        // Create mapping_lists table
        await m.createTable(mappingLists);

        // Create index for mapping lists
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_mapping_lists_priority '
          'ON mapping_lists(priority, is_enabled)',
        );

        // Add listId column to category_mappings
        final categoryMappingsInfo = await customSelect(
          'PRAGMA table_info(category_mappings)',
        ).get();

        final hasListId = categoryMappingsInfo.any(
          (row) => row.data['name'] == 'list_id',
        );

        if (!hasListId) {
          await customStatement(
            'ALTER TABLE category_mappings ADD COLUMN list_id TEXT',
          );
        }

        // Create default lists
        await _createDefaultLists();

        // Migrate existing mappings to appropriate lists
        await _migrateExistingMappingsToLists();
      }

      if (from == 7 && to >= 8) {
        // Migration v7 → v8: Add submissionHookUrl to mapping_lists
        // This allows lists to have custom submission endpoints for unknown processes
        final mappingListsInfo = await customSelect(
          'PRAGMA table_info(mapping_lists)',
        ).get();

        final hasSubmissionHookUrl = mappingListsInfo.any(
          (row) => row.data['name'] == 'submission_hook_url',
        );

        if (!hasSubmissionHookUrl) {
          await customStatement(
            'ALTER TABLE mapping_lists ADD COLUMN submission_hook_url TEXT',
          );
        }

        // Update official TKit mappings list with submission hook
        await customStatement(
          "UPDATE mapping_lists SET submission_hook_url = 'https://tkit-api.evobug.workers.dev/submit-mapping' WHERE id = 'official-tkit-mappings'",
        );
      }

      if (from == 8 && to >= 9) {
        // Migration v8 → v9: Add lastSyncError to mapping_lists
        // This allows showing sync errors in the UI
        final mappingListsInfo = await customSelect(
          'PRAGMA table_info(mapping_lists)',
        ).get();

        final hasLastSyncError = mappingListsInfo.any(
          (row) => row.data['name'] == 'last_sync_error',
        );

        if (!hasLastSyncError) {
          await customStatement(
            'ALTER TABLE mapping_lists ADD COLUMN last_sync_error TEXT',
          );
        }
      }
    },
  );

  /// Create default mapping lists for migration and first-run setup
  Future<void> _createDefaultLists() async {
    final now = DateTime.now();

    // 1. Official TKit Mappings list (from community sync)
    await into(mappingLists).insert(
      MappingListsCompanion.insert(
        id: 'official-tkit-mappings',
        name: 'Official TKit Mappings',
        description: const Value('Verified game mappings from the TKit community'),
        sourceType: 'official',
        sourceUrl: const Value('https://raw.githubusercontent.com/evobug-com/tkit-community-mapping/refs/heads/main/mappings.json'),
        submissionHookUrl: const Value('https://tkit-api.evobug.workers.dev/submit-mapping'),
        isEnabled: const Value(true),
        isReadOnly: const Value(true),
        priority: const Value(10),
        createdAt: Value(now),
      ),
      mode: InsertMode.insertOrIgnore,
    );

    // 2. Official Ignored Programs list
    await into(mappingLists).insert(
      MappingListsCompanion.insert(
        id: 'official-ignored-programs',
        name: 'Official Ignored Programs',
        description: const Value('System apps, launchers, and other programs to ignore'),
        sourceType: 'official',
        sourceUrl: const Value('https://raw.githubusercontent.com/evobug-com/tkit-community-mapping/refs/heads/main/programs.json'),
        isEnabled: const Value(true),
        isReadOnly: const Value(true),
        priority: const Value(20),
        createdAt: Value(now),
      ),
      mode: InsertMode.insertOrIgnore,
    );

    // 3. My Custom Mappings list (user's personal mappings)
    await into(mappingLists).insert(
      MappingListsCompanion.insert(
        id: 'my-custom-mappings',
        name: 'My Custom Mappings',
        description: const Value('Your personal game and program mappings'),
        sourceType: 'local',
        isEnabled: const Value(true),
        isReadOnly: const Value(false),
        priority: const Value(0), // Highest priority
        createdAt: Value(now),
      ),
      mode: InsertMode.insertOrIgnore,
    );
  }

  /// Migrate existing mappings to the new list-based system
  Future<void> _migrateExistingMappingsToLists() async {
    // Get all existing category mappings without a listId
    final unmappedMappings = await (select(categoryMappings)
          ..where((tbl) => tbl.listId.isNull()))
        .get();

    for (final mapping in unmappedMappings) {
      // Assign to appropriate list based on whether it's user-defined or preset
      final targetListId = mapping.manualOverride
          ? 'my-custom-mappings'
          : 'official-tkit-mappings';

      await (update(categoryMappings)
            ..where((tbl) => tbl.id.equals(mapping.id)))
          .write(CategoryMappingsCompanion(
        listId: Value(targetListId),
      ));
    }
  }

  /// Get all mapping lists
  /// Ordered by source type (official first), then by priority
  Future<List<MappingListEntity>> getAllMappingLists() async {
    return (select(mappingLists)
          ..orderBy([
            (tbl) => OrderingTerm(
              expression: tbl.sourceType.caseMatch(
                when: {
                  const Constant('official'): const Constant(0),
                  const Constant('local'): const Constant(1),
                  const Constant('remote'): const Constant(2),
                },
                orElse: const Constant(999),
              ),
            ),
            (tbl) => OrderingTerm(expression: tbl.priority),
          ]))
        .get();
  }

  /// Get enabled mapping lists ordered by source type (official first), then priority
  Future<List<MappingListEntity>> getEnabledMappingLists() async {
    return (select(mappingLists)
          ..where((tbl) => tbl.isEnabled.equals(true))
          ..orderBy([
            (tbl) => OrderingTerm(
              expression: tbl.sourceType.caseMatch(
                when: {
                  const Constant('official'): const Constant(0),
                  const Constant('local'): const Constant(1),
                  const Constant('remote'): const Constant(2),
                },
                orElse: const Constant(999),
              ),
            ),
            (tbl) => OrderingTerm(expression: tbl.priority),
          ]))
        .get();
  }

  /// Get mapping list by ID
  Future<MappingListEntity?> getMappingListById(String id) async {
    return (select(mappingLists)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  /// Update mapping list
  Future<bool> updateMappingList(String id, MappingListsCompanion data) async {
    final count = await (update(mappingLists)..where((tbl) => tbl.id.equals(id))).write(data);
    return count > 0;
  }

  /// Delete mapping list (and optionally its mappings)
  Future<void> deleteMappingList(String id, {bool deleteMappings = false}) async {
    await transaction(() async {
      if (deleteMappings) {
        // Delete all mappings in this list
        await (delete(categoryMappings)..where((tbl) => tbl.listId.equals(id))).go();
      } else {
        // Reassign mappings to "My Custom Mappings"
        await (update(categoryMappings)..where((tbl) => tbl.listId.equals(id)))
            .write(const CategoryMappingsCompanion(
          listId: Value('my-custom-mappings'),
        ));
      }

      // Delete the list
      await (delete(mappingLists)..where((tbl) => tbl.id.equals(id))).go();
    });
  }

  /// Get count of mappings in a list
  Future<int> getMappingCountForList(String listId) async {
    final countQuery = selectOnly(categoryMappings)
      ..addColumns([categoryMappings.id.count()])
      ..where(categoryMappings.listId.equals(listId));

    final result = await countQuery.getSingleOrNull();
    return result?.read(categoryMappings.id.count()) ?? 0;
  }

  /// Get mappings only from enabled lists
  /// Joins with mapping_lists table and filters by isEnabled = true
  /// Returns a map with 'mapping' and 'listName' keys
  Future<List<Map<String, dynamic>>> getMappingsFromEnabledLists() async {
    final query = select(categoryMappings).join([
      leftOuterJoin(
        mappingLists,
        mappingLists.id.equalsExp(categoryMappings.listId),
      ),
    ])
      ..where(mappingLists.isEnabled.equals(true) | categoryMappings.listId.isNull())
      ..orderBy([
        OrderingTerm(expression: categoryMappings.lastUsedAt, mode: OrderingMode.desc),
        OrderingTerm(expression: categoryMappings.createdAt, mode: OrderingMode.desc),
      ]);

    final results = await query.get();
    return results.map((row) {
      final mapping = row.readTable(categoryMappings);
      final list = row.readTableOrNull(mappingLists);
      return {
        'mapping': mapping,
        'listName': list?.name ?? 'Unknown',
        'isReadOnly': list?.isReadOnly ?? false,
      };
    }).toList();
  }
}
