import 'package:dartz/dartz.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/twitch_api/domain/repositories/i_twitch_api_repository.dart';
import 'package:tkit/features/category_mapping/data/datasources/category_mapping_local_datasource.dart';
import 'package:tkit/features/category_mapping/data/models/category_mapping_model.dart';

/// Use case for refreshing expired category mappings
///
/// Implements 24-hour cache expiry compliance for Twitch Developer Agreement.
/// This use case should be run daily to:
/// 1. Find all expired mappings (excluding manual overrides)
/// 2. Fetch fresh data from Twitch API
/// 3. Update the mappings with new data and reset expiry time
/// 4. Delete mappings for games that no longer exist on Twitch
class RefreshExpiredMappingsUseCase {
  final CategoryMappingLocalDataSource localDataSource;
  final ITwitchApiRepository twitchApiRepository;

  RefreshExpiredMappingsUseCase(
    this.localDataSource,
    this.twitchApiRepository,
  );

  /// Execute the use case
  ///
  /// Returns the number of mappings refreshed or failure
  Future<Either<Failure, int>> call() async {
    try {
      // Step 1: Get all expired mappings (excluding manual overrides)
      final expiredMappings = await localDataSource.getExpiredMappings();

      if (expiredMappings.isEmpty) {
        return const Right(0);
      }

      // Step 2: Extract category IDs (batch lookup for efficiency)
      final categoryIds = expiredMappings
          .map((mapping) => mapping.twitchCategoryId)
          .toList();

      // Step 3: Fetch fresh data from Twitch API
      // Split into batches of 100 (Twitch API limit)
      final List<String> successfulIds = [];
      final List<String> failedIds = [];

      for (int i = 0; i < categoryIds.length; i += 100) {
        final batch = categoryIds.skip(i).take(100).toList();
        final result = await twitchApiRepository.getGamesByIds(batch);

        result.fold(
          (failure) {
            // If batch fails, mark all as failed
            failedIds.addAll(batch);
          },
          (categories) {
            // Track which IDs were successfully fetched
            successfulIds.addAll(categories.map((cat) => cat.id));
          },
        );
      }

      // Step 4: Update mappings with fresh data
      int refreshedCount = 0;
      final now = DateTime.now();
      final expiresAt = now.add(const Duration(hours: 24));

      for (final mapping in expiredMappings) {
        final categoryId = mapping.twitchCategoryId;

        if (successfulIds.contains(categoryId)) {
          // Fetch the fresh category data
          final categoryResult = await twitchApiRepository.getCategoryById(categoryId);

          await categoryResult.fold(
            (failure) async {
              // Keep old mapping if refresh fails
              // Just update the timestamps to retry later
              final updatedMapping = mapping.copyWith(
                lastApiFetch: now,
                cacheExpiresAt: expiresAt,
              );
              await localDataSource.saveMapping(
                CategoryMappingModel.fromEntity(updatedMapping),
              );
            },
            (category) async {
              // Update mapping with fresh data
              final updatedMapping = mapping.copyWith(
                twitchCategoryName: category.name,
                lastApiFetch: now,
                cacheExpiresAt: expiresAt,
              );
              await localDataSource.saveMapping(
                CategoryMappingModel.fromEntity(updatedMapping),
              );
              refreshedCount++;
            },
          );
        } else if (failedIds.contains(categoryId)) {
          // Keep old mapping if API call failed
          // Just update the timestamps to retry later
          final updatedMapping = mapping.copyWith(
            lastApiFetch: now,
            cacheExpiresAt: expiresAt,
          );
          await localDataSource.saveMapping(
            CategoryMappingModel.fromEntity(updatedMapping),
          );
        } else {
          // Category no longer exists on Twitch - delete mapping
          await localDataSource.deleteMapping(mapping.id!);
        }
      }

      return Right(refreshedCount);
    } catch (e) {
      return Left(
        UnknownFailure(
          message: 'Failed to refresh expired mappings: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }
}
