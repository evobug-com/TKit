import 'package:dartz/dartz.dart';
import 'package:tkit/core/errors/exceptions.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/core/database/app_database.dart';
import 'package:tkit/core/utils/app_logger.dart';
import 'package:tkit/features/mapping_lists/domain/entities/mapping_list.dart';
import 'package:tkit/features/mapping_lists/domain/entities/mapping_list_item.dart';
import 'package:tkit/features/mapping_lists/domain/repositories/i_mapping_list_repository.dart';
import 'package:tkit/features/mapping_lists/data/datasources/mapping_list_local_datasource.dart';
import 'package:tkit/features/mapping_lists/data/datasources/mapping_list_sync_datasource.dart';
import 'package:tkit/features/mapping_lists/data/models/mapping_list_model.dart';
import 'package:tkit/features/category_mapping/data/models/category_mapping_model.dart';
import 'package:drift/drift.dart';

/// Implementation of mapping list repository
class MappingListRepositoryImpl implements IMappingListRepository {
  final MappingListLocalDataSource _localDataSource;
  final MappingListSyncDataSource _syncDataSource;
  final AppDatabase _database;
  final AppLogger _logger;

  MappingListRepositoryImpl(
    this._localDataSource,
    this._syncDataSource,
    this._database,
    this._logger,
  );

  @override
  Future<Either<Failure, List<MappingList>>> getAllLists() async {
    try {
      final models = await _localDataSource.getAllLists();
      return Right(models.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get lists: $e'));
    }
  }

  @override
  Future<Either<Failure, List<MappingList>>> getEnabledLists() async {
    try {
      final models = await _localDataSource.getEnabledLists();
      return Right(models.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get enabled lists: $e'));
    }
  }

  @override
  Future<Either<Failure, MappingList>> getListById(String id) async {
    try {
      final model = await _localDataSource.getListById(id);
      if (model == null) {
        return Left(CacheFailure(message: 'List not found: $id'));
      }
      return Right(model.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get list: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> createList(MappingList list) async {
    try {
      final model = MappingListModel.fromEntity(list);
      await _localDataSource.createList(model);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to create list: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateList(MappingList list) async {
    try {
      final model = MappingListModel.fromEntity(list);
      final success = await _localDataSource.updateList(list.id, model);
      if (!success) {
        return const Left(
          CacheFailure(message: 'Failed to update list: not found'),
        );
      }
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to update list: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteList(
    String id, {
    bool deleteMappings = false,
  }) async {
    try {
      await _localDataSource.deleteList(id, deleteMappings: deleteMappings);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to delete list: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> toggleListEnabled(
    String id, {
    required bool isEnabled,
  }) async {
    try {
      final success = await _localDataSource.toggleListEnabled(
        id,
        isEnabled: isEnabled,
      );
      if (!success) {
        return const Left(
          CacheFailure(message: 'Failed to toggle list: not found'),
        );
      }
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to toggle list: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> syncList(String listId) async {
    try {
      // Get the list
      final model = await _localDataSource.getListById(listId);
      if (model == null) {
        return Left(CacheFailure(message: 'List not found: $listId'));
      }

      // Check if it has a sync URL
      if (model.sourceUrl == null) {
        return const Left(CacheFailure(message: 'List has no sync URL'));
      }

      // Fetch mappings and metadata from URL
      final remoteData = await _syncDataSource.fetchListFromUrl(
        model.sourceUrl!,
      );

      // Update list metadata from remote JSON if provided
      if (remoteData.name != null ||
          remoteData.description != null ||
          remoteData.submissionHookUrl != null) {
        await (_database.update(
          _database.mappingLists,
        )..where((tbl) => tbl.id.equals(listId))).write(
          MappingListsCompanion(
            name: remoteData.name != null
                ? Value(remoteData.name!)
                : const Value.absent(),
            description: remoteData.description != null
                ? Value(remoteData.description!)
                : const Value.absent(),
            isReadOnly: Value(remoteData.isReadOnly),
            submissionHookUrl: Value(remoteData.submissionHookUrl),
          ),
        );
      }

      // Convert mapping items to category mappings and insert into database
      await _importMappingsToList(listId, remoteData.mappings);

      // Update sync timestamp and clear error on success
      await _localDataSource.updateSyncSuccess(listId, DateTime.now());

      // After syncing official/remote lists, check for and remove duplicates
      // from local lists that were marked as pending submission
      await _removeDuplicatesFromLocalList(listId);

      return const Right(null);
    } on NetworkException catch (e) {
      // Store error message
      await _localDataSource.updateSyncError(listId, e.message);
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      // Store error message
      await _localDataSource.updateSyncError(listId, e.message);
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      // Store generic error message
      final errorMsg = 'Failed to sync: ${e.toString()}';
      await _localDataSource.updateSyncError(listId, errorMsg);
      return Left(ServerFailure(message: errorMsg));
    }
  }

  @override
  Future<Either<Failure, int>> syncAllLists() async {
    try {
      final listsToSync = await _localDataSource.getListsNeedingSync();
      var successCount = 0;

      for (final list in listsToSync) {
        final result = await syncList(list.id);
        result.fold((failure) {
          // Log failure but continue syncing other lists
          _logger.warning('Failed to sync list ${list.name}', failure);
        }, (_) => successCount++);
      }

      return Right(successCount);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to sync lists: $e'));
    }
  }

  @override
  Future<Either<Failure, MappingList>> importListFromUrl({
    required String url,
    required String name,
    String? description,
  }) async {
    try {
      // Validate URL first
      final isValid = await _syncDataSource.validateListUrl(url);
      if (!isValid) {
        return const Left(
          NetworkFailure(message: 'Invalid URL or unreachable'),
        );
      }

      // Fetch mappings and metadata from remote source
      final remoteData = await _syncDataSource.fetchListFromUrl(url);
      if (remoteData.mappings.isEmpty) {
        return const Left(ServerFailure(message: 'List is empty or invalid'));
      }

      // Create list entity using metadata from JSON (fallback to user-provided values)
      final listId = 'remote-${DateTime.now().millisecondsSinceEpoch}';
      final list = MappingList(
        id: listId,
        name: remoteData.name ?? name, // Prefer name from JSON
        description: remoteData.description ?? description ?? '',
        sourceType: MappingListSourceType.remote,
        sourceUrl: url,
        submissionHookUrl: remoteData.submissionHookUrl, // Use value from JSON
        isEnabled: true,
        isReadOnly: remoteData.isReadOnly, // Use value from JSON
        mappingCount: remoteData.mappings.length,
        lastSyncedAt: DateTime.now(),
        createdAt: DateTime.now(),
        priority: 50, // Medium priority
      );

      // Save list
      final model = MappingListModel.fromEntity(list);
      await _localDataSource.createList(model);

      // Import mappings
      await _importMappingsToList(listId, remoteData.mappings);

      return Right(list);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to import list: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> validateListUrl(String url) async {
    try {
      final isValid = await _syncDataSource.validateListUrl(url);
      return Right(isValid);
    } catch (e) {
      return const Right(false);
    }
  }

  /// Import mapping items into a list
  Future<void> _importMappingsToList(
    String listId,
    List<MappingListItem> items,
  ) async {
    await _database.transaction(() async {
      // First, delete all existing mappings for this list to avoid duplicates
      await (_database.delete(
        _database.categoryMappings,
      )..where((tbl) => tbl.listId.equals(listId))).go();

      // Then insert the new mappings
      for (final item in items) {
        // Convert to CategoryMapping
        final now = DateTime.now();
        final expiresAt = now.add(const Duration(hours: 24));

        final mapping = CategoryMappingModel(
          processName: item.processName,
          normalizedInstallPaths: item.normalizedInstallPaths,
          twitchCategoryId: item.twitchCategoryId,
          twitchCategoryName: item.twitchCategoryName,
          createdAt: now,
          lastApiFetch: now,
          cacheExpiresAt: expiresAt,
          manualOverride: false,
          isEnabled: true,
          listId: listId,
        );

        // Insert mapping
        await _database
            .into(_database.categoryMappings)
            .insert(mapping.toCompanion(), mode: InsertMode.insert);
      }
    });
  }

  /// Remove duplicate mappings from local lists after syncing official/remote lists
  ///
  /// When a user submits a mapping to a community list, it's saved locally with
  /// pendingSubmission=true. After the submission is accepted and appears in the
  /// official list, we want to remove the local duplicate to avoid confusion.
  ///
  /// This method compares mappings from the just-synced list against local mappings
  /// marked as pendingSubmission and removes matches based on processName + categoryId.
  Future<void> _removeDuplicatesFromLocalList(String syncedListId) async {
    try {
      // Only check for duplicates if we just synced an official or remote list
      final syncedList = await _localDataSource.getListById(syncedListId);
      if (syncedList == null ||
          syncedList.sourceType == MappingListSourceType.local) {
        return; // Nothing to do for local lists
      }

      // Get all mappings from the synced list
      final syncedMappings = await (_database.select(
        _database.categoryMappings,
      )..where((tbl) => tbl.listId.equals(syncedListId))).get();

      // Get all pending submission mappings from local lists
      final pendingMappings =
          await (_database.select(_database.categoryMappings)
                ..where((tbl) => tbl.pendingSubmission.equals(true))
                ..where((tbl) => tbl.listId.equals('my-custom-mappings')))
              .get();

      if (pendingMappings.isEmpty) {
        return; // No pending submissions to check
      }

      // Find and remove duplicates
      var removedCount = 0;
      for (final pending in pendingMappings) {
        // Check if this pending mapping now exists in the synced list
        final isDuplicate = syncedMappings.any(
          (synced) =>
              synced.processName.toLowerCase() ==
                  pending.processName.toLowerCase() &&
              synced.twitchCategoryId == pending.twitchCategoryId,
        );

        if (isDuplicate) {
          await (_database.delete(
            _database.categoryMappings,
          )..where((tbl) => tbl.id.equals(pending.id))).go();
          removedCount++;
        }
      }

      if (removedCount > 0) {
        _logger.info(
          'Removed $removedCount duplicate mapping(s) from local list after sync',
        );
      }
    } catch (e) {
      // Log error but don't fail the sync
      _logger.error('Error removing duplicates from local list', e);
    }
  }
}
