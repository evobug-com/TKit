import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/category_mapping/domain/repositories/i_category_mapping_repository.dart';

/// Use case for exporting category mappings to JSON
///
/// Allows users to:
/// - Backup their mappings
/// - Share mappings with others
/// - Contribute to community databases
class ExportMappingsUseCase {
  final ICategoryMappingRepository repository;

  ExportMappingsUseCase(this.repository);

  /// Execute the use case
  ///
  /// [includeManualOnly] - Export only manual overrides
  /// [prettyPrint] - Format JSON with indentation
  ///
  /// Returns JSON string or failure
  Future<Either<Failure, String>> call({
    bool includeManualOnly = false,
    bool prettyPrint = true,
  }) async {
    try {
      // Get all mappings
      final result = await repository.getAllMappings();

      return result.fold(
        (failure) => Left(failure),
        (mappings) {
          // Filter if needed
          final filteredMappings = includeManualOnly
              ? mappings.where((m) => m.manualOverride).toList()
              : mappings;

          // Convert to JSON-serializable format
          final jsonData = filteredMappings.map((mapping) {
            return {
              'processName': mapping.processName,
              'executablePath': mapping.executablePath,
              'twitchCategoryId': mapping.twitchCategoryId,
              'twitchCategoryName': mapping.twitchCategoryName,
              'manualOverride': mapping.manualOverride,
              'createdAt': mapping.createdAt.toIso8601String(),
              'lastUsedAt': mapping.lastUsedAt?.toIso8601String(),
              'lastApiFetch': mapping.lastApiFetch.toIso8601String(),
              'cacheExpiresAt': mapping.cacheExpiresAt.toIso8601String(),
            };
          }).toList();

          // Encode to JSON
          final encoder = prettyPrint
              ? const JsonEncoder.withIndent('  ')
              : const JsonEncoder();

          final jsonString = encoder.convert(jsonData);

          return Right(jsonString);
        },
      );
    } catch (e) {
      return Left(
        UnknownFailure(
          message: 'Failed to export mappings: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }
}
