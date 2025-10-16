import 'package:dartz/dartz.dart';
import 'package:tkit/core/errors/exceptions.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/category_mapping/domain/entities/category_mapping.dart';
import 'package:tkit/features/category_mapping/domain/repositories/i_category_mapping_repository.dart';
import 'package:tkit/features/category_mapping/data/datasources/category_mapping_local_datasource.dart';
import 'package:tkit/features/category_mapping/data/datasources/memory_cache.dart';
import 'package:tkit/features/category_mapping/data/models/category_mapping_model.dart';

/// Implementation of ICategoryMappingRepository
///
/// Implements cascade lookup strategy:
/// 1. Memory cache (fast, in-memory)
/// 2. User's custom mappings database (persistent, with fuzzy matching)
/// 3. Falls through if not found
///
/// This minimizes database queries for frequently accessed mappings.
class CategoryMappingRepositoryImpl implements ICategoryMappingRepository {
  final CategoryMappingLocalDataSource localDataSource;
  final MemoryCache memoryCache;

  CategoryMappingRepositoryImpl(this.localDataSource, this.memoryCache);

  @override
  Future<Either<Failure, CategoryMapping?>> findMapping(
    String processName,
    String? path,
  ) async {
    try {
      // Step 1: Check memory cache first
      final cached = memoryCache.get(processName);
      if (cached != null) {
        // Return the mapping regardless of isEnabled
        // Let the caller decide what to do with disabled mappings
        return Right(cached);
      }

      // Step 2: Check user's custom mappings database
      final result = await localDataSource.findMapping(processName, path);

      if (result != null) {
        final entity = result.toEntity();
        // Cache for future lookups
        memoryCache.put(processName, entity);
        // Return the mapping regardless of isEnabled
        return Right(entity);
      }

      // Not found in cache or local database
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
      // First, get the mapping to retrieve its process name for cache invalidation
      final allMappings = await localDataSource.getAllMappings();
      final mappingToDelete = allMappings.where((m) => m.id == id).firstOrNull;

      // Delete from database
      await localDataSource.deleteMapping(id);

      // Remove from cache if we found the mapping
      if (mappingToDelete != null) {
        memoryCache.remove(mappingToDelete.processName);
      }

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
