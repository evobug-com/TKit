import 'package:drift/drift.dart';
import 'package:tkit/core/database/app_database.dart';
import 'package:tkit/core/errors/exceptions.dart';
import 'package:tkit/core/utils/app_logger.dart';
import 'package:tkit/features/category_mapping/data/models/unknown_process_model.dart';

/// Data source for unknown processes
///
/// Provides CRUD operations for tracking processes without mappings.
/// Helps identify gaps in the mapping database.
class UnknownProcessDataSource {
  final AppDatabase database;
  final _logger = AppLogger();

  UnknownProcessDataSource(this.database);

  /// Log an unknown process detection
  ///
  /// If the process already exists, increments occurrence count.
  /// Otherwise, creates a new entry.
  Future<void> logUnknownProcess(
    String executableName,
    String? windowTitle,
  ) async {
    try {
      // Check if process already logged
      final existing =
          await (database.select(database.unknownProcesses)
                ..where((tbl) => tbl.executableName.equals(executableName)))
              .getSingleOrNull();

      if (existing != null) {
        // Increment occurrence count
        await (database.update(
          database.unknownProcesses,
        )..where((tbl) => tbl.id.equals(existing.id))).write(
          UnknownProcessesCompanion(
            occurrenceCount: Value(existing.occurrenceCount + 1),
            windowTitle: windowTitle != null
                ? Value(windowTitle)
                : const Value.absent(),
          ),
        );
      } else {
        // Create new entry
        await database
            .into(database.unknownProcesses)
            .insert(
              UnknownProcessesCompanion.insert(
                executableName: executableName,
                windowTitle: Value(windowTitle),
                occurrenceCount: const Value(1),
              ),
            );
      }
    } catch (e, stackTrace) {
      _logger.error('Failed to log unknown process', e, stackTrace);
      throw CacheException(
        message: 'Failed to log unknown process: ${e.toString()}',
      );
    }
  }

  /// Get all unknown processes (unresolved first, then by occurrence count)
  Future<List<UnknownProcessModel>> getAllUnknownProcesses() async {
    try {
      final processes =
          await (database.select(database.unknownProcesses)..orderBy([
                (tbl) => OrderingTerm(
                  expression: tbl.resolved,
                  mode: OrderingMode.asc,
                ),
                (tbl) => OrderingTerm(
                  expression: tbl.occurrenceCount,
                  mode: OrderingMode.desc,
                ),
              ]))
              .get();

      return processes
          .map((entity) => UnknownProcessModel.fromDbEntity(entity))
          .toList();
    } catch (e, stackTrace) {
      _logger.error('Failed to get unknown processes', e, stackTrace);
      throw CacheException(
        message: 'Failed to get unknown processes: ${e.toString()}',
      );
    }
  }

  /// Get unresolved unknown processes
  Future<List<UnknownProcessModel>> getUnresolvedProcesses() async {
    try {
      final processes =
          await (database.select(database.unknownProcesses)
                ..where((tbl) => tbl.resolved.equals(false))
                ..orderBy([
                  (tbl) => OrderingTerm(
                    expression: tbl.occurrenceCount,
                    mode: OrderingMode.desc,
                  ),
                ]))
              .get();

      return processes
          .map((entity) => UnknownProcessModel.fromDbEntity(entity))
          .toList();
    } catch (e, stackTrace) {
      _logger.error('Failed to get unresolved processes', e, stackTrace);
      throw CacheException(
        message: 'Failed to get unresolved processes: ${e.toString()}',
      );
    }
  }

  /// Mark a process as resolved
  ///
  /// Called when a mapping is created for a previously unknown process
  Future<void> markAsResolved(String executableName) async {
    try {
      await (database.update(database.unknownProcesses)
            ..where((tbl) => tbl.executableName.equals(executableName)))
          .write(const UnknownProcessesCompanion(resolved: Value(true)));
    } catch (e, stackTrace) {
      _logger.error('Failed to mark process as resolved', e, stackTrace);
      throw CacheException(
        message: 'Failed to mark process as resolved: ${e.toString()}',
      );
    }
  }

  /// Delete an unknown process entry
  Future<void> deleteUnknownProcess(int id) async {
    try {
      await (database.delete(
        database.unknownProcesses,
      )..where((tbl) => tbl.id.equals(id))).go();
    } catch (e, stackTrace) {
      _logger.error('Failed to delete unknown process', e, stackTrace);
      throw CacheException(
        message: 'Failed to delete unknown process: ${e.toString()}',
      );
    }
  }

  /// Export unknown processes to JSON for community contribution
  Future<List<Map<String, dynamic>>> exportToJson() async {
    try {
      final processes = await getUnresolvedProcesses();
      return processes.map((process) => process.toJson()).toList();
    } catch (e, stackTrace) {
      _logger.error('Failed to export unknown processes', e, stackTrace);
      throw CacheException(
        message: 'Failed to export unknown processes: ${e.toString()}',
      );
    }
  }

  /// Clear all resolved processes
  Future<int> clearResolved() async {
    try {
      return await (database.delete(
        database.unknownProcesses,
      )..where((tbl) => tbl.resolved.equals(true))).go();
    } catch (e, stackTrace) {
      _logger.error('Failed to clear resolved processes', e, stackTrace);
      throw CacheException(
        message: 'Failed to clear resolved processes: ${e.toString()}',
      );
    }
  }
}
