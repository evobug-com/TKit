import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:tkit/core/utils/app_logger.dart';
import 'package:tkit/features/twitch_api/domain/repositories/i_twitch_api_repository.dart';
import 'package:tkit/features/category_mapping/data/datasources/category_mapping_local_datasource.dart';
import 'package:tkit/features/category_mapping/data/models/category_mapping_model.dart';
import 'package:tkit/features/category_mapping/domain/entities/category_mapping.dart';

/// Service for importing category mappings from community sources
///
/// Supports importing from:
/// - Gr3gorywolf GitHub Gist (500+ exe mappings)
/// - Nerothos/TwitchGameList (all Twitch categories)
/// - Local JSON files
class MappingImporter {
  final CategoryMappingLocalDataSource localDataSource;
  final ITwitchApiRepository twitchApiRepository;
  final AppLogger logger;
  final Dio dio;

  MappingImporter({
    required this.localDataSource,
    required this.twitchApiRepository,
    required this.logger,
    required this.dio,
  });

  /// Import mappings from Gr3gorywolf GitHub Gist
  ///
  /// URL: https://gist.githubusercontent.com/Gr3gorywolf/f1a8ad246b8f26cca41e6f26fa3b343b/raw/Game_Database.json
  ///
  /// Format: Array of objects with:
  /// - exe: string (e.g., "League of Legends.exe")
  /// - game_name: string (e.g., "League of Legends")
  /// - twitch_id: string (e.g., "21779")
  Future<int> importFromGr3gorywolf() async {
    const url =
        'https://gist.githubusercontent.com/Gr3gorywolf/f1a8ad246b8f26cca41e6f26fa3b343b/raw/Game_Database.json';

    try {
      logger.info('Importing mappings from Gr3gorywolf GitHub Gist');

      final response = await dio.get<String>(url);
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }

      final data = json.decode(response.data.toString()) as List<dynamic>;
      var importedCount = 0;
      final now = DateTime.now();
      final expiresAt = now.add(const Duration(hours: 24));

      for (final item in data) {
        try {
          final itemMap = item as Map<String, dynamic>;
          final exe = itemMap['exe'] as String?;
          final gameName = itemMap['game_name'] as String?;
          final twitchId = itemMap['twitch_id'] as String?;

          if (exe == null || gameName == null || twitchId == null) {
            continue; // Skip invalid entries
          }

          // Check if mapping already exists
          final existing = await localDataSource.findMapping(exe, null);
          if (existing == null) {
            // Verify the Twitch ID is still valid
            final categoryResult =
                await twitchApiRepository.getCategoryById(twitchId);

            await categoryResult.fold(
              (failure) async {
                // Category doesn't exist or API error - skip
                logger.warning('Skipping $exe: ${failure.message}');
              },
              (category) async {
                // Create mapping with fresh Twitch data
                final mapping = CategoryMapping(
                  processName: exe,
                  twitchCategoryId: category.id,
                  twitchCategoryName: category.name,
                  createdAt: now,
                  lastApiFetch: now,
                  cacheExpiresAt: expiresAt,
                  manualOverride: false,
                );

                await localDataSource.saveMapping(CategoryMappingModel.fromEntity(mapping));
                importedCount++;
              },
            );
          }
        } catch (e) {
          logger.error('Error importing mapping: $e');
          continue; // Skip and continue with next
        }
      }

      logger.info('Imported $importedCount mappings from Gr3gorywolf');
      return importedCount;
    } catch (e) {
      logger.error('Failed to import from Gr3gorywolf', e);
      throw Exception('Import failed: ${e.toString()}');
    }
  }

  /// Import mappings from Nerothos/TwitchGameList
  ///
  /// URL: https://raw.githubusercontent.com/Nerothos/TwitchGameList/master/gamelist.json
  ///
  /// This contains all Twitch categories. We'll match them with common
  /// executable name patterns.
  Future<int> importFromNerothos() async {
    const url =
        'https://raw.githubusercontent.com/Nerothos/TwitchGameList/master/gamelist.json';

    try {
      logger.info('Importing game list from Nerothos/TwitchGameList');

      final response = await dio.get<String>(url);
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }

      final data = json.decode(response.data.toString()) as List<dynamic>;
      var importedCount = 0;
      final now = DateTime.now();
      final expiresAt = now.add(const Duration(hours: 24));

      // Common patterns to generate executable names from game names
      final patterns = [
        (String name) => '$name.exe',
        (String name) => '${name.replaceAll(' ', '')}.exe',
        (String name) => '${name.replaceAll(' ', '_')}.exe',
        (String name) => '${name.replaceAll(':', '')}.exe',
      ];

      for (final item in data) {
        try {
          final itemMap = item as Map<String, dynamic>;
          final gameName = itemMap['name'] as String?;
          final twitchId = itemMap['id'] as String?;

          if (gameName == null || twitchId == null) {
            continue;
          }

          // Try common executable name patterns
          for (final pattern in patterns) {
            final exe = pattern(gameName);

            // Check if mapping already exists
            final existing = await localDataSource.findMapping(exe, null);
            if (existing == null) {
              final mapping = CategoryMapping(
                processName: exe,
                twitchCategoryId: twitchId.toString(),
                twitchCategoryName: gameName,
                createdAt: now,
                lastApiFetch: now,
                cacheExpiresAt: expiresAt,
                manualOverride: false,
              );

              await localDataSource.saveMapping(CategoryMappingModel.fromEntity(mapping));
              importedCount++;
              break; // Only create one mapping per game
            }
          }
        } catch (e) {
          logger.error('Error importing game: $e');
          continue;
        }
      }

      logger.info('Imported $importedCount mappings from Nerothos');
      return importedCount;
    } catch (e) {
      logger.error('Failed to import from Nerothos', e);
      throw Exception('Import failed: ${e.toString()}');
    }
  }

  /// Import mappings from local JSON file
  ///
  /// Expected format:
  /// [
  ///   {
  ///     "processName": "game.exe",
  ///     "twitchCategoryId": "123456",
  ///     "twitchCategoryName": "Game Name"
  ///   }
  /// ]
  Future<int> importFromJson(String jsonString) async {
    try {
      logger.info('Importing mappings from JSON');

      final data = json.decode(jsonString) as List<dynamic>;
      var importedCount = 0;
      final now = DateTime.now();
      final expiresAt = now.add(const Duration(hours: 24));

      for (final item in data) {
        try {
          final itemMap = item as Map<String, dynamic>;
          final processName = itemMap['processName'] as String?;
          final twitchCategoryId = itemMap['twitchCategoryId'] as String?;
          final twitchCategoryName = itemMap['twitchCategoryName'] as String?;

          if (processName == null ||
              twitchCategoryId == null ||
              twitchCategoryName == null) {
            continue;
          }

          // Check if mapping already exists
          final existing = await localDataSource.findMapping(processName, null);
          if (existing == null) {
            final mapping = CategoryMapping(
              processName: processName,
              twitchCategoryId: twitchCategoryId,
              twitchCategoryName: twitchCategoryName,
              createdAt: now,
              lastApiFetch: now,
              cacheExpiresAt: expiresAt,
              manualOverride: false,
            );

            await localDataSource.saveMapping(CategoryMappingModel.fromEntity(mapping));
            importedCount++;
          }
        } catch (e) {
          logger.error('Error importing mapping: $e');
          continue;
        }
      }

      logger.info('Imported $importedCount mappings from JSON');
      return importedCount;
    } catch (e) {
      logger.error('Failed to import from JSON', e);
      throw Exception('Import failed: ${e.toString()}');
    }
  }
}
