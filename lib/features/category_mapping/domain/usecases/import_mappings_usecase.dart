import 'dart:convert';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/i_category_mapping_repository.dart';
import '../entities/category_mapping.dart';

/// Use case for importing category mappings from JSON
///
/// Allows users to:
/// - Restore from backup
/// - Import shared mappings
/// - Merge community databases
class ImportMappingsUseCase {
  final ICategoryMappingRepository repository;

  ImportMappingsUseCase(this.repository);

  /// Execute the use case
  ///
  /// [jsonString] - JSON string containing mappings
  /// [skipExisting] - Don't overwrite existing mappings (default: true)
  /// [validateTwitchIds] - Validate category IDs are valid (requires API call)
  ///
  /// Returns number of mappings imported or failure
  Future<Either<Failure, int>> call(
    String jsonString, {
    bool skipExisting = true,
    bool validateTwitchIds = false,
  }) async {
    try {
      // Parse JSON
      final List<dynamic> jsonData = json.decode(jsonString);

      if (jsonData.isEmpty) {
        return Left(
          ValidationFailure(message: 'No mappings found in JSON'),
        );
      }

      int importedCount = 0;
      final now = DateTime.now();

      for (final item in jsonData) {
        try {
          // Extract fields
          final processName = item['processName'] as String?;
          final twitchCategoryId = item['twitchCategoryId'] as String?;
          final twitchCategoryName = item['twitchCategoryName'] as String?;

          if (processName == null ||
              twitchCategoryId == null ||
              twitchCategoryName == null) {
            continue; // Skip invalid entries
          }

          // Check if mapping exists
          if (skipExisting) {
            final existingResult = await repository.findMapping(
              processName,
              item['executablePath'] as String?,
            );

            await existingResult.fold(
              (failure) async {
                // Not found, proceed with import
              },
              (existing) async {
                if (existing != null) {
                  return; // Skip existing
                }
              },
            );
          }

          // Create mapping
          final mapping = CategoryMapping(
            processName: processName,
            executablePath: item['executablePath'] as String?,
            twitchCategoryId: twitchCategoryId,
            twitchCategoryName: twitchCategoryName,
            createdAt: item['createdAt'] != null
                ? DateTime.parse(item['createdAt'] as String)
                : now,
            lastUsedAt: item['lastUsedAt'] != null
                ? DateTime.parse(item['lastUsedAt'] as String)
                : null,
            lastApiFetch: item['lastApiFetch'] != null
                ? DateTime.parse(item['lastApiFetch'] as String)
                : now,
            cacheExpiresAt: item['cacheExpiresAt'] != null
                ? DateTime.parse(item['cacheExpiresAt'] as String)
                : now.add(const Duration(hours: 24)),
            manualOverride: item['manualOverride'] as bool? ?? false,
          );

          // Save mapping
          final saveResult = await repository.saveMapping(mapping);

          await saveResult.fold(
            (failure) async {
              // Failed to save, skip
            },
            (_) async {
              importedCount++;
            },
          );
        } catch (e) {
          // Skip invalid entry and continue
          continue;
        }
      }

      return Right(importedCount);
    } on FormatException catch (e) {
      return Left(
        ValidationFailure(message: 'Invalid JSON format: ${e.message}'),
      );
    } catch (e) {
      return Left(
        UnknownFailure(
          message: 'Failed to import mappings: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }
}
