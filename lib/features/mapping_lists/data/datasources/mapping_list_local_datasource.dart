import 'package:drift/drift.dart';
import 'package:tkit/core/database/app_database.dart';
import 'package:tkit/features/mapping_lists/data/models/mapping_list_model.dart';

/// Local data source for mapping lists using Drift database
class MappingListLocalDataSource {
  final AppDatabase _database;

  MappingListLocalDataSource(this._database);

  /// Get all mapping lists ordered by priority
  Future<List<MappingListModel>> getAllLists() async {
    final entities = await _database.getAllMappingLists();

    // Get mapping counts for each list
    final models = <MappingListModel>[];
    for (final entity in entities) {
      final count = await _database.getMappingCountForList(entity.id);
      models.add(MappingListModel.fromDbEntity(entity, mappingCount: count));
    }

    return models;
  }

  /// Get enabled mapping lists ordered by priority
  Future<List<MappingListModel>> getEnabledLists() async {
    final entities = await _database.getEnabledMappingLists();

    // Get mapping counts for each list
    final models = <MappingListModel>[];
    for (final entity in entities) {
      final count = await _database.getMappingCountForList(entity.id);
      models.add(MappingListModel.fromDbEntity(entity, mappingCount: count));
    }

    return models;
  }

  /// Get mapping list by ID
  Future<MappingListModel?> getListById(String id) async {
    final entity = await _database.getMappingListById(id);
    if (entity == null) return null;

    final count = await _database.getMappingCountForList(id);
    return MappingListModel.fromDbEntity(entity, mappingCount: count);
  }

  /// Create a new mapping list
  Future<void> createList(MappingListModel list) async {
    await _database.into(_database.mappingLists).insert(list.toCompanion());
  }

  /// Update an existing mapping list
  Future<bool> updateList(String id, MappingListModel list) async {
    return await _database.updateMappingList(id, list.toCompanion());
  }

  /// Delete a mapping list
  Future<void> deleteList(String id, {bool deleteMappings = false}) async {
    await _database.deleteMappingList(id, deleteMappings: deleteMappings);
  }

  /// Toggle list enabled state
  Future<bool> toggleListEnabled(String id, bool isEnabled) async {
    return await _database.updateMappingList(
      id,
      MappingListsCompanion(isEnabled: Value(isEnabled)),
    );
  }

  /// Update list sync timestamp
  Future<bool> updateSyncTimestamp(String id, DateTime timestamp) async {
    return await _database.updateMappingList(
      id,
      MappingListsCompanion(lastSyncedAt: Value(timestamp)),
    );
  }

  /// Update sync timestamp and clear error on successful sync
  Future<bool> updateSyncSuccess(String id, DateTime timestamp) async {
    return await _database.updateMappingList(
      id,
      MappingListsCompanion(
        lastSyncedAt: Value(timestamp),
        lastSyncError: const Value(null),
      ),
    );
  }

  /// Update sync error on failed sync
  Future<bool> updateSyncError(String id, String errorMessage) async {
    return await _database.updateMappingList(
      id,
      MappingListsCompanion(lastSyncError: Value(errorMessage)),
    );
  }

  /// Get lists that need syncing (have URL and haven't synced in 6 hours)
  Future<List<MappingListModel>> getListsNeedingSync() async {
    final allLists = await getAllLists();
    return allLists.where((list) => list.needsSync).toList();
  }
}
