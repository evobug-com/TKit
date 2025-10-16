import 'package:drift/drift.dart';
import 'package:tkit/core/database/app_database.dart';
import 'package:tkit/core/errors/exceptions.dart';
import 'package:tkit/core/utils/app_logger.dart';
import 'package:tkit/features/category_mapping/data/models/category_mapping_model.dart';
import 'package:tkit/features/category_mapping/data/utils/path_normalizer.dart';

/// Local data source for category mappings using Drift DAO
///
/// Provides CRUD operations and exact/normalized matching for finding mappings.
/// No fuzzy matching to avoid false positives.
class CategoryMappingLocalDataSource {
  final AppDatabase database;
  final _logger = AppLogger();

  CategoryMappingLocalDataSource(this.database);

  /// Find a mapping by process name and path
  ///
  /// Implements a multi-step matching strategy with privacy-preserving path matching:
  /// 1. Exact match: processName + path in normalizedInstallPaths array
  /// 2. Exact match: processName only
  /// 3. Normalized match: processName (lowercase, no .exe, no spaces/dashes)
  /// 4. Legacy: Match by deprecated executablePath if provided (backward compatibility)
  ///
  /// Only returns mappings from enabled lists
  /// Returns the best match or null if no suitable match found
  Future<CategoryMappingModel?> findMapping(
    String processName,
    String? executablePath,
  ) async {
    try {
      // Extract normalized path from executablePath for matching
      String? normalizedPath;
      if (executablePath != null && executablePath.isNotEmpty) {
        normalizedPath = PathNormalizer.extractGamePath(executablePath);
      }

      // Only get mappings from enabled lists
      final allResults = await database.getMappingsFromEnabledLists();

      // Step 1: Try exact match with processName + normalizedPath
      if (normalizedPath != null) {
        for (final result in allResults) {
          final mapping = result['mapping'] as CategoryMappingEntity;
          final listName = result['listName'] as String;
          final isReadOnly = result['isReadOnly'] as bool;
          // Check if this mapping has the normalized path in its array
          if (mapping.processName == processName &&
              mapping.normalizedInstallPaths != null) {
            final model = CategoryMappingModel.fromDbEntity(
              mapping,
              sourceListName: listName,
              sourceListIsReadOnly: isReadOnly,
            );
            if (model.normalizedInstallPaths.contains(normalizedPath)) {
              return model;
            }
          }
        }
      }

      // Step 2: Try exact match on process name only
      final exactMatches = allResults.where((result) {
        final mapping = result['mapping'] as CategoryMappingEntity;
        return mapping.processName == processName;
      }).toList();

      if (exactMatches.isNotEmpty) {
        final result = exactMatches.first;
        final mapping = result['mapping'] as CategoryMappingEntity;
        final listName = result['listName'] as String;
        final isReadOnly = result['isReadOnly'] as bool;
        return CategoryMappingModel.fromDbEntity(
          mapping,
          sourceListName: listName,
          sourceListIsReadOnly: isReadOnly,
        );
      }

      // Step 3: Try normalized exact match
      final normalizedInput = _normalizeProcessName(processName);

      for (final result in allResults) {
        final mapping = result['mapping'] as CategoryMappingEntity;
        final listName = result['listName'] as String;
        final isReadOnly = result['isReadOnly'] as bool;
        final normalizedMapping = _normalizeProcessName(mapping.processName);
        if (normalizedMapping == normalizedInput) {
          return CategoryMappingModel.fromDbEntity(
            mapping,
            sourceListName: listName,
            sourceListIsReadOnly: isReadOnly,
          );
        }
      }

      // Step 4: Legacy - Try matching by deprecated executablePath (backward compatibility)
      if (executablePath != null && executablePath.isNotEmpty) {
        final pathMatch =
            await (database.select(database.categoryMappings)
                  ..where((tbl) => tbl.executablePath.equals(executablePath)))
                .getSingleOrNull();

        if (pathMatch != null) {
          return CategoryMappingModel.fromDbEntity(pathMatch);
        }
      }

      return null;
    } catch (e, stackTrace) {
      _logger.error('Failed to find mapping', e, stackTrace);
      throw CacheException(message: 'Failed to find mapping: ${e.toString()}');
    }
  }

  /// Get all mappings ordered by last used date (most recent first)
  /// Only returns mappings from enabled lists
  Future<List<CategoryMappingModel>> getAllMappings() async {
    try {
      final results = await database.getMappingsFromEnabledLists();

      return results.map((result) {
        final entity = result['mapping'] as CategoryMappingEntity;
        final listName = result['listName'] as String;
        final isReadOnly = result['isReadOnly'] as bool;
        return CategoryMappingModel.fromDbEntity(
          entity,
          sourceListName: listName,
          sourceListIsReadOnly: isReadOnly,
        );
      }).toList();
    } catch (e, stackTrace) {
      _logger.error('Failed to get all mappings', e, stackTrace);
      throw CacheException(
        message: 'Failed to get all mappings: ${e.toString()}',
      );
    }
  }

  /// Save a mapping (create or update)
  Future<void> saveMapping(CategoryMappingModel mapping) async {
    try {
      final companion = mapping.toCompanion();

      if (mapping.id == null) {
        // Insert new mapping
        await database.into(database.categoryMappings).insert(companion);
      } else {
        // Update existing mapping - use companion to preserve all fields
        await (database.update(
          database.categoryMappings,
        )..where((tbl) => tbl.id.equals(mapping.id!))).write(companion);
      }
    } catch (e, stackTrace) {
      _logger.error('Failed to save mapping', e, stackTrace);
      throw CacheException(message: 'Failed to save mapping: ${e.toString()}');
    }
  }

  /// Delete a mapping by ID
  Future<void> deleteMapping(int id) async {
    try {
      await (database.delete(
        database.categoryMappings,
      )..where((tbl) => tbl.id.equals(id))).go();
    } catch (e, stackTrace) {
      _logger.error('Failed to delete mapping', e, stackTrace);
      throw CacheException(
        message: 'Failed to delete mapping: ${e.toString()}',
      );
    }
  }

  /// Update the last used timestamp for a mapping
  Future<void> updateLastUsed(int id) async {
    try {
      await (database.update(database.categoryMappings)
            ..where((tbl) => tbl.id.equals(id)))
          .write(CategoryMappingsCompanion(lastUsedAt: Value(DateTime.now())));
    } catch (e, stackTrace) {
      _logger.error('Failed to update last used', e, stackTrace);
      throw CacheException(
        message: 'Failed to update last used: ${e.toString()}',
      );
    }
  }

  /// Normalize process name for comparison
  ///
  /// Removes common variations:
  /// - Converts to lowercase
  /// - Removes .exe extension
  /// - Removes spaces, dashes, and underscores
  String _normalizeProcessName(String name) {
    return name
        .toLowerCase()
        .replaceAll('.exe', '')
        .replaceAll(' ', '')
        .replaceAll('-', '')
        .replaceAll('_', '');
  }

  /// Get expired mappings (excluding manual overrides)
  Future<List<CategoryMappingModel>> getExpiredMappings() async {
    try {
      final mappings = await database.getExpiredMappings();
      return mappings
          .map((entity) => CategoryMappingModel.fromDbEntity(entity))
          .toList();
    } catch (e, stackTrace) {
      _logger.error('Failed to get expired mappings', e, stackTrace);
      throw CacheException(
        message: 'Failed to get expired mappings: ${e.toString()}',
      );
    }
  }

  /// Get mappings expiring soon (within threshold)
  Future<List<CategoryMappingModel>> getMappingsExpiringSoon(
    Duration threshold,
  ) async {
    try {
      final mappings = await database.getMappingsExpiringSoon(threshold);
      return mappings
          .map((entity) => CategoryMappingModel.fromDbEntity(entity))
          .toList();
    } catch (e, stackTrace) {
      _logger.error('Failed to get expiring mappings', e, stackTrace);
      throw CacheException(
        message: 'Failed to get expiring mappings: ${e.toString()}',
      );
    }
  }

  /// Delete expired mappings (excluding manual overrides)
  Future<int> deleteExpiredMappings() async {
    try {
      return await database.deleteExpiredMappings();
    } catch (e, stackTrace) {
      _logger.error('Failed to delete expired mappings', e, stackTrace);
      throw CacheException(
        message: 'Failed to delete expired mappings: ${e.toString()}',
      );
    }
  }
}
