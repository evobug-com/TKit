import 'package:drift/drift.dart';
import 'package:tkit/core/database/app_database.dart';
import 'package:tkit/features/auto_switcher/data/models/update_history_model.dart';

/// Local data source for update history
///
/// Handles CRUD operations on the UpdateHistory table using Drift
class UpdateHistoryLocalDataSource {
  final AppDatabase _database;

  const UpdateHistoryLocalDataSource(this._database);

  /// Save an update history entry to the database
  ///
  /// Returns the ID of the inserted record
  Future<int> saveUpdateHistory(UpdateHistoryModel history) async {
    return await _database
        .into(_database.updateHistory)
        .insert(history.toCompanion());
  }

  /// Get update history entries
  ///
  /// [limit] Maximum number of entries to return (default: 100)
  /// Returns entries ordered by update time (most recent first)
  Future<List<UpdateHistoryModel>> getUpdateHistory({int limit = 100}) async {
    final query = _database.select(_database.updateHistory)
      ..orderBy([
        (t) => OrderingTerm(expression: t.updatedAt, mode: OrderingMode.desc),
      ])
      ..limit(limit);

    final entities = await query.get();
    return entities
        .map((entity) => UpdateHistoryModel.fromEntity(entity))
        .toList();
  }

  /// Get the most recent update history entry
  ///
  /// Returns null if no history exists
  Future<UpdateHistoryModel?> getLatestUpdateHistory() async {
    final query = _database.select(_database.updateHistory)
      ..orderBy([
        (t) => OrderingTerm(expression: t.updatedAt, mode: OrderingMode.desc),
      ])
      ..limit(1);

    final results = await query.get();
    if (results.isEmpty) {
      return null;
    }

    return UpdateHistoryModel.fromEntity(results.first);
  }

  /// Get update history for a specific process
  ///
  /// [processName] The process name to filter by
  /// [limit] Maximum number of entries to return
  Future<List<UpdateHistoryModel>> getHistoryForProcess(
    String processName, {
    int limit = 50,
  }) async {
    final query = _database.select(_database.updateHistory)
      ..where((t) => t.processName.equals(processName))
      ..orderBy([
        (t) => OrderingTerm(expression: t.updatedAt, mode: OrderingMode.desc),
      ])
      ..limit(limit);

    final entities = await query.get();
    return entities
        .map((entity) => UpdateHistoryModel.fromEntity(entity))
        .toList();
  }

  /// Get count of successful updates
  Future<int> getSuccessCount() async {
    final query = _database.selectOnly(_database.updateHistory)
      ..addColumns([_database.updateHistory.id.count()])
      ..where(_database.updateHistory.success.equals(true));

    final result = await query.getSingle();
    return result.read(_database.updateHistory.id.count()) ?? 0;
  }

  /// Get count of failed updates
  Future<int> getFailureCount() async {
    final query = _database.selectOnly(_database.updateHistory)
      ..addColumns([_database.updateHistory.id.count()])
      ..where(_database.updateHistory.success.equals(false));

    final result = await query.getSingle();
    return result.read(_database.updateHistory.id.count()) ?? 0;
  }

  /// Clear all update history
  Future<int> clearAllHistory() async {
    return await _database.delete(_database.updateHistory).go();
  }

  /// Clear old history entries
  ///
  /// [olderThan] Delete entries older than this date
  Future<int> clearOldHistory(DateTime olderThan) async {
    return await (_database.delete(
      _database.updateHistory,
    )..where((t) => t.updatedAt.isSmallerThanValue(olderThan))).go();
  }
}
