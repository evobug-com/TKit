import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/category_mapping_model.dart';

/// Local data source for category mappings using Drift DAO
///
/// Provides CRUD operations and fuzzy matching capabilities using
/// Levenshtein distance algorithm for finding similar process names.
class CategoryMappingLocalDataSource {
  final AppDatabase database;

  CategoryMappingLocalDataSource(this.database);

  /// Find a mapping by process name with fuzzy matching
  ///
  /// Implements a multi-step matching strategy:
  /// 1. Exact match on process name
  /// 2. Exact match on normalized process name (lowercase, no .exe, no spaces/dashes)
  /// 3. Fuzzy match using Levenshtein distance (≤ 3)
  /// 4. Match by executable path if provided
  ///
  /// Returns the best match or null if no suitable match found
  Future<CategoryMappingModel?> findMapping(
    String processName,
    String? executablePath,
  ) async {
    try {
      // Step 1: Try exact match first
      final exactMatches = await (database.select(
        database.categoryMappings,
      )..where((tbl) => tbl.processName.equals(processName))).get();

      if (exactMatches.isNotEmpty) {
        return CategoryMappingModel.fromDbEntity(exactMatches.first);
      }

      // Step 2: Try normalized exact match
      final normalizedInput = _normalizeProcessName(processName);
      final allMappings = await database
          .select(database.categoryMappings)
          .get();

      for (final mapping in allMappings) {
        final normalizedMapping = _normalizeProcessName(mapping.processName);
        if (normalizedMapping == normalizedInput) {
          return CategoryMappingModel.fromDbEntity(mapping);
        }
      }

      // Step 3: Fuzzy matching with Levenshtein distance
      CategoryMappingEntity? bestMatch;
      int bestDistance = 4; // Only accept distance ≤ 3

      for (final mapping in allMappings) {
        final distance = _levenshteinDistance(
          normalizedInput,
          _normalizeProcessName(mapping.processName),
        );

        if (distance < bestDistance) {
          bestDistance = distance;
          bestMatch = mapping;
        }
      }

      if (bestMatch != null) {
        return CategoryMappingModel.fromDbEntity(bestMatch);
      }

      // Step 4: Try matching by executable path if provided
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
    } catch (e) {
      throw CacheException(message: 'Failed to find mapping: ${e.toString()}');
    }
  }

  /// Get all mappings ordered by last used date (most recent first)
  Future<List<CategoryMappingModel>> getAllMappings() async {
    try {
      final mappings =
          await (database.select(database.categoryMappings)..orderBy([
                (tbl) => OrderingTerm(
                  expression: tbl.lastUsedAt,
                  mode: OrderingMode.desc,
                ),
                (tbl) => OrderingTerm(
                  expression: tbl.createdAt,
                  mode: OrderingMode.desc,
                ),
              ]))
              .get();

      return mappings
          .map((entity) => CategoryMappingModel.fromDbEntity(entity))
          .toList();
    } catch (e) {
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
        // Update existing mapping
        await database
            .update(database.categoryMappings)
            .replace(
              CategoryMappingEntity(
                id: mapping.id!,
                processName: mapping.processName,
                executablePath: mapping.executablePath,
                twitchCategoryId: mapping.twitchCategoryId,
                twitchCategoryName: mapping.twitchCategoryName,
                createdAt: mapping.createdAt,
                lastUsedAt: mapping.lastUsedAt,
                lastApiFetch: mapping.lastApiFetch,
                cacheExpiresAt: mapping.cacheExpiresAt,
                manualOverride: mapping.manualOverride,
                isEnabled: mapping.isEnabled,
              ),
            );
      }
    } catch (e) {
      throw CacheException(message: 'Failed to save mapping: ${e.toString()}');
    }
  }

  /// Delete a mapping by ID
  Future<void> deleteMapping(int id) async {
    try {
      await (database.delete(
        database.categoryMappings,
      )..where((tbl) => tbl.id.equals(id))).go();
    } catch (e) {
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
    } catch (e) {
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
    } catch (e) {
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
    } catch (e) {
      throw CacheException(
        message: 'Failed to get expiring mappings: ${e.toString()}',
      );
    }
  }

  /// Delete expired mappings (excluding manual overrides)
  Future<int> deleteExpiredMappings() async {
    try {
      return await database.deleteExpiredMappings();
    } catch (e) {
      throw CacheException(
        message: 'Failed to delete expired mappings: ${e.toString()}',
      );
    }
  }

  /// Calculate Levenshtein distance between two strings
  ///
  /// The Levenshtein distance is the minimum number of single-character edits
  /// (insertions, deletions, or substitutions) required to change one string
  /// into another.
  ///
  /// This implementation uses dynamic programming for efficiency.
  int _levenshteinDistance(String s1, String s2) {
    if (s1 == s2) return 0;
    if (s1.isEmpty) return s2.length;
    if (s2.isEmpty) return s1.length;

    // Create a matrix to store distances
    final matrix = List.generate(
      s1.length + 1,
      (i) => List.generate(s2.length + 1, (j) => 0),
    );

    // Initialize first row and column
    for (int i = 0; i <= s1.length; i++) {
      matrix[i][0] = i;
    }
    for (int j = 0; j <= s2.length; j++) {
      matrix[0][j] = j;
    }

    // Fill the matrix
    for (int i = 1; i <= s1.length; i++) {
      for (int j = 1; j <= s2.length; j++) {
        final cost = s1[i - 1] == s2[j - 1] ? 0 : 1;

        matrix[i][j] = [
          matrix[i - 1][j] + 1, // deletion
          matrix[i][j - 1] + 1, // insertion
          matrix[i - 1][j - 1] + cost, // substitution
        ].reduce((a, b) => a < b ? a : b);
      }
    }

    return matrix[s1.length][s2.length];
  }
}
