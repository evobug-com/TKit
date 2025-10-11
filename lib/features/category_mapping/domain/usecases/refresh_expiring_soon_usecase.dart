import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../twitch_api/domain/repositories/i_twitch_api_repository.dart';
import '../../data/datasources/category_mapping_local_datasource.dart';
import '../../data/models/category_mapping_model.dart';

/// Use case for proactively refreshing category mappings before they expire
///
/// Implements proactive cache refresh strategy to avoid cache misses.
/// This use case should run periodically (e.g., every 6 hours) to:
/// 1. Find mappings expiring within threshold (e.g., 1 hour)
/// 2. Fetch fresh data from Twitch API
/// 3. Update the mappings before they expire
///
/// This ensures smooth operation without cache misses affecting users.
class RefreshExpiringSoonUseCase {
  final CategoryMappingLocalDataSource localDataSource;
  final ITwitchApiRepository twitchApiRepository;

  RefreshExpiringSoonUseCase(
    this.localDataSource,
    this.twitchApiRepository,
  );

  /// Execute the use case
  ///
  /// [threshold] - Duration before expiry to trigger refresh (default: 1 hour)
  ///
  /// Returns the number of mappings refreshed or failure
  Future<Either<Failure, int>> call({
    Duration threshold = const Duration(hours: 1),
  }) async {
    try {
      // Step 1: Get mappings expiring soon (excluding manual overrides)
      final expiringMappings = await localDataSource.getMappingsExpiringSoon(
        threshold,
      );

      if (expiringMappings.isEmpty) {
        return const Right(0);
      }

      // Step 2: Extract category IDs for batch lookup
      final categoryIds = expiringMappings
          .map((mapping) => mapping.twitchCategoryId)
          .toList();

      // Step 3: Fetch fresh data from Twitch API
      // Split into batches of 100 (Twitch API limit)
      final Map<String, String> categoryNameUpdates = {};

      for (int i = 0; i < categoryIds.length; i += 100) {
        final batch = categoryIds.skip(i).take(100).toList();
        final result = await twitchApiRepository.getGamesByIds(batch);

        result.fold(
          (failure) {
            // Log failure but continue with other batches
            // We'll keep the old data for failed fetches
          },
          (categories) {
            // Store category name updates
            for (final category in categories) {
              categoryNameUpdates[category.id] = category.name;
            }
          },
        );
      }

      // Step 4: Update mappings with fresh data
      int refreshedCount = 0;
      final now = DateTime.now();
      final expiresAt = now.add(const Duration(hours: 24));

      for (final mapping in expiringMappings) {
        final categoryId = mapping.twitchCategoryId;

        if (categoryNameUpdates.containsKey(categoryId)) {
          // Update mapping with fresh data
          final updatedMapping = mapping.copyWith(
            twitchCategoryName: categoryNameUpdates[categoryId]!,
            lastApiFetch: now,
            cacheExpiresAt: expiresAt,
          );
          await localDataSource.saveMapping(
            CategoryMappingModel.fromEntity(updatedMapping),
          );
          refreshedCount++;
        } else {
          // No fresh data available - extend expiry slightly to retry later
          final updatedMapping = mapping.copyWith(
            lastApiFetch: now,
            cacheExpiresAt: now.add(const Duration(hours: 6)),
          );
          await localDataSource.saveMapping(
            CategoryMappingModel.fromEntity(updatedMapping),
          );
        }
      }

      return Right(refreshedCount);
    } catch (e) {
      return Left(
        UnknownFailure(
          message: 'Failed to refresh expiring mappings: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }
}
