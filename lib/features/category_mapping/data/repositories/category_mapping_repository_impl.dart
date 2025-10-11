import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../community_mappings/domain/repositories/i_community_mappings_repository.dart';
import '../../domain/entities/category_mapping.dart';
import '../../domain/repositories/i_category_mapping_repository.dart';
import '../datasources/category_mapping_local_datasource.dart';
import '../datasources/memory_cache.dart';
import '../models/category_mapping_model.dart';

/// Implementation of ICategoryMappingRepository
///
/// Implements cascade lookup strategy:
/// 1. Memory cache (fast, in-memory)
/// 2. User's custom mappings database (persistent, with fuzzy matching)
/// 3. Community mappings (crowdsourced, synced from GitHub)
/// 4. Falls through if not found
///
/// This minimizes database queries for frequently accessed mappings.
class CategoryMappingRepositoryImpl implements ICategoryMappingRepository {
  final CategoryMappingLocalDataSource localDataSource;
  final MemoryCache memoryCache;
  final ICommunityMappingsRepository? communityMappingsRepository;

  CategoryMappingRepositoryImpl(
    this.localDataSource,
    this.memoryCache, {
    this.communityMappingsRepository,
  });

  @override
  Future<Either<Failure, CategoryMapping?>> findMapping(
    String processName,
    String? path,
  ) async {
    try {
      // Step 1: Check memory cache first
      final cached = memoryCache.get(processName);
      if (cached != null) {
        return Right(cached);
      }

      // Step 2: Check user's custom mappings database
      final result = await localDataSource.findMapping(processName, path);

      if (result != null) {
        final entity = result.toEntity();
        // Cache for future lookups
        memoryCache.put(processName, entity);
        return Right(entity);
      }

      // Step 3: Check community mappings as fallback
      if (communityMappingsRepository != null) {
        final communityResult =
            await communityMappingsRepository!.findMapping(processName);

        return communityResult.fold(
          (failure) => Left(failure),
          (communityMapping) {
            if (communityMapping != null) {
              // Convert community mapping to category mapping
              final categoryMapping = CategoryMapping(
                processName: communityMapping.processName,
                twitchCategoryId: communityMapping.twitchCategoryId,
                twitchCategoryName: communityMapping.twitchCategoryName,
                createdAt: communityMapping.syncedAt,
                lastApiFetch: communityMapping.syncedAt,
                cacheExpiresAt: communityMapping.syncedAt
                    .add(const Duration(hours: 24)),
                manualOverride: false,
              );

              // Cache it (but don't save to user's database)
              memoryCache.put(processName, categoryMapping);
              return Right(categoryMapping);
            }
            return const Right(null);
          },
        );
      }

      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<CategoryMapping>>> getAllMappings() async {
    try {
      final results = await localDataSource.getAllMappings();
      return Right(results.map((model) => model.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> saveMapping(CategoryMapping mapping) async {
    try {
      final model = CategoryMappingModel.fromEntity(mapping);
      await localDataSource.saveMapping(model);

      // Update memory cache
      memoryCache.put(mapping.processName, mapping);

      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMapping(int id) async {
    try {
      await localDataSource.deleteMapping(id);

      // Note: Can't easily remove from cache by ID, so we clear expired entries
      memoryCache.clearExpired();

      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateLastUsed(int id) async {
    try {
      await localDataSource.updateLastUsed(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<CategoryMapping>>> getExpiredMappings() async {
    try {
      final results = await localDataSource.getExpiredMappings();
      return Right(results.map((model) => model.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<CategoryMapping>>> getMappingsExpiringSoon(
    Duration threshold,
  ) async {
    try {
      final results = await localDataSource.getMappingsExpiringSoon(threshold);
      return Right(results.map((model) => model.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, int>> deleteExpiredMappings() async {
    try {
      final count = await localDataSource.deleteExpiredMappings();

      // Clear expired entries from memory cache too
      memoryCache.clearExpired();

      return Right(count);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  /// Clear all caches (memory and database)
  void clearAllCaches() {
    memoryCache.clear();
  }

  /// Get cache statistics
  String getCacheStats() {
    return memoryCache.stats.toString();
  }
}
