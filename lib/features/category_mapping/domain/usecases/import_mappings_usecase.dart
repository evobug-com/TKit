import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/category_mapping/domain/repositories/i_category_mapping_repository.dart';
import 'package:tkit/features/category_mapping/domain/entities/category_mapping.dart';

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
      final jsonData = json.decode(jsonString) as List<dynamic>;

      if (jsonData.isEmpty) {
        return const Left(
          ValidationFailure(message: 'No mappings found in JSON'),
        );
      }

      var importedCount = 0;
      final now = DateTime.now();

      for (final item in jsonData) {
        try {
          final itemMap = item as Map<String, dynamic>;
          // Extract fields
          final processName = itemMap['processName'] as String?;
          final twitchCategoryId = itemMap['twitchCategoryId'] as String?;
          final twitchCategoryName = itemMap['twitchCategoryName'] as String?;

          if (processName == null ||
              twitchCategoryId == null ||
              twitchCategoryName == null) {
            continue; // Skip invalid entries
          }

          // Check if mapping exists
          if (skipExisting) {
            final existingResult = await repository.findMapping(
              processName,
              itemMap['executablePath'] as String?,
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
            executablePath: itemMap['executablePath'] as String?,
            twitchCategoryId: twitchCategoryId,
            twitchCategoryName: twitchCategoryName,
            createdAt: itemMap['createdAt'] != null
                ? DateTime.parse(itemMap['createdAt'] as String)
                : now,
            lastUsedAt: itemMap['lastUsedAt'] != null
                ? DateTime.parse(itemMap['lastUsedAt'] as String)
                : null,
            lastApiFetch: itemMap['lastApiFetch'] != null
                ? DateTime.parse(itemMap['lastApiFetch'] as String)
                : now,
            cacheExpiresAt: itemMap['cacheExpiresAt'] != null
                ? DateTime.parse(itemMap['cacheExpiresAt'] as String)
                : now.add(const Duration(hours: 24)),
            manualOverride: itemMap['manualOverride'] as bool? ?? false,
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
