import 'package:dartz/dartz.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/category_mapping/domain/entities/category_mapping.dart';

/// Repository interface for category mapping operations
///
/// Defines the contract for CRUD operations on process-to-category mappings,
/// including fuzzy matching capabilities for finding mappings.
abstract class ICategoryMappingRepository {
  /// Find a mapping for the given process name and optional path
  ///
  /// Uses fuzzy matching (Levenshtein distance) to find the best match
  /// even if the process name doesn't exactly match.
  ///
  /// [processName] - The name of the process (e.g., "League of Legends.exe")
  /// [path] - Optional executable path for more precise matching
  ///
  /// Returns the best matching CategoryMapping or null if no match found
  Future<Either<Failure, CategoryMapping?>> findMapping(
    String processName,
    String? path,
  );

  /// Get all category mappings
  ///
  /// Returns all mappings ordered by last used date (most recent first)
  Future<Either<Failure, List<CategoryMapping>>> getAllMappings();

  /// Save a new mapping or update an existing one
  ///
  /// If [mapping.id] is null, creates a new mapping.
  /// If [mapping.id] is not null, updates the existing mapping.
  Future<Either<Failure, void>> saveMapping(CategoryMapping mapping);

  /// Delete a mapping by ID
  ///
  /// [id] - The ID of the mapping to delete
  Future<Either<Failure, void>> deleteMapping(int id);

  /// Update the last used timestamp for a mapping
  ///
  /// This is called when a mapping is successfully used to update a category
  /// to track which mappings are actively being used.
  ///
  /// [id] - The ID of the mapping to update
  Future<Either<Failure, void>> updateLastUsed(int id);

  /// Get expired mappings (excluding manual overrides)
  ///
  /// Returns mappings where cacheExpiresAt is in the past
  Future<Either<Failure, List<CategoryMapping>>> getExpiredMappings();

  /// Get mappings expiring soon (within threshold)
  ///
  /// [threshold] - Duration before expiry to trigger (e.g., 1 hour)
  /// Returns mappings that will expire within the threshold
  Future<Either<Failure, List<CategoryMapping>>> getMappingsExpiringSoon(
    Duration threshold,
  );

  /// Delete expired mappings (excluding manual overrides)
  ///
  /// Returns the number of mappings deleted
  Future<Either<Failure, int>> deleteExpiredMappings();
}
