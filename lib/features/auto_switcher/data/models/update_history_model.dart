import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart' as db;
import '../../domain/entities/update_history.dart' as domain;

/// Data layer model for UpdateHistory
/// Bridges between Drift database entities and domain entities
class UpdateHistoryModel extends domain.UpdateHistory {
  const UpdateHistoryModel({
    super.id,
    required super.processName,
    required super.categoryId,
    required super.categoryName,
    required super.success,
    super.errorMessage,
    required super.updatedAt,
  });

  /// Convert from Drift database entity
  factory UpdateHistoryModel.fromEntity(db.UpdateHistoryEntity entity) {
    return UpdateHistoryModel(
      id: entity.id,
      processName: entity.processName,
      categoryId: entity.categoryId,
      categoryName: entity.categoryName,
      success: entity.success,
      errorMessage: entity.errorMessage,
      updatedAt: entity.updatedAt,
    );
  }

  /// Convert from domain entity
  factory UpdateHistoryModel.fromDomain(domain.UpdateHistory history) {
    return UpdateHistoryModel(
      id: history.id,
      processName: history.processName,
      categoryId: history.categoryId,
      categoryName: history.categoryName,
      success: history.success,
      errorMessage: history.errorMessage,
      updatedAt: history.updatedAt,
    );
  }

  /// Convert to Drift companion for database operations
  db.UpdateHistoryCompanion toCompanion() {
    return db.UpdateHistoryCompanion.insert(
      processName: processName,
      categoryId: categoryId,
      categoryName: categoryName,
      success: success,
      errorMessage: Value(errorMessage),
      updatedAt: Value(updatedAt),
    );
  }

  /// Convert to domain entity
  domain.UpdateHistory toDomain() {
    return domain.UpdateHistory(
      id: id,
      processName: processName,
      categoryId: categoryId,
      categoryName: categoryName,
      success: success,
      errorMessage: errorMessage,
      updatedAt: updatedAt,
    );
  }
}
