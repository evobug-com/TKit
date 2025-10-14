import 'package:json_annotation/json_annotation.dart';
import 'package:tkit/core/database/app_database.dart';
import 'package:tkit/features/mapping_lists/domain/entities/mapping_list.dart';
import 'package:drift/drift.dart' show Value;

part 'mapping_list_model.g.dart';

/// Data model for MappingList with JSON serialization
///
/// This model extends the domain entity and provides JSON serialization
/// capabilities and conversion to/from Drift database entities.
@JsonSerializable()
class MappingListModel extends MappingList {
  const MappingListModel({
    required super.id,
    required super.name,
    required super.description,
    required super.sourceType,
    super.sourceUrl,
    super.submissionHookUrl,
    required super.isEnabled,
    required super.isReadOnly,
    required super.mappingCount,
    super.lastSyncedAt,
    super.lastSyncError,
    required super.createdAt,
    required super.priority,
  });

  /// Create from domain entity
  factory MappingListModel.fromEntity(MappingList entity) {
    return MappingListModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      sourceType: entity.sourceType,
      sourceUrl: entity.sourceUrl,
      submissionHookUrl: entity.submissionHookUrl,
      isEnabled: entity.isEnabled,
      isReadOnly: entity.isReadOnly,
      mappingCount: entity.mappingCount,
      lastSyncedAt: entity.lastSyncedAt,
      lastSyncError: entity.lastSyncError,
      createdAt: entity.createdAt,
      priority: entity.priority,
    );
  }

  /// Create from Drift database entity
  factory MappingListModel.fromDbEntity(MappingListEntity dbEntity, {int? mappingCount}) {
    return MappingListModel(
      id: dbEntity.id,
      name: dbEntity.name,
      description: dbEntity.description,
      sourceType: _parseSourceType(dbEntity.sourceType),
      sourceUrl: dbEntity.sourceUrl,
      submissionHookUrl: dbEntity.submissionHookUrl,
      isEnabled: dbEntity.isEnabled,
      isReadOnly: dbEntity.isReadOnly,
      mappingCount: mappingCount ?? 0,
      lastSyncedAt: dbEntity.lastSyncedAt,
      lastSyncError: dbEntity.lastSyncError,
      createdAt: dbEntity.createdAt,
      priority: dbEntity.priority,
    );
  }

  /// Create from JSON
  factory MappingListModel.fromJson(Map<String, dynamic> json) =>
      _$MappingListModelFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$MappingListModelToJson(this);

  /// Convert to domain entity
  MappingList toEntity() {
    return MappingList(
      id: id,
      name: name,
      description: description,
      sourceType: sourceType,
      sourceUrl: sourceUrl,
      submissionHookUrl: submissionHookUrl,
      isEnabled: isEnabled,
      isReadOnly: isReadOnly,
      mappingCount: mappingCount,
      lastSyncedAt: lastSyncedAt,
      lastSyncError: lastSyncError,
      createdAt: createdAt,
      priority: priority,
    );
  }

  /// Convert to Drift companion for insert/update
  MappingListsCompanion toCompanion() {
    return MappingListsCompanion.insert(
      id: id,
      name: name,
      description: Value(description),
      sourceType: _sourceTypeToString(sourceType),
      sourceUrl: Value(sourceUrl),
      submissionHookUrl: Value(submissionHookUrl),
      isEnabled: Value(isEnabled),
      isReadOnly: Value(isReadOnly),
      priority: Value(priority),
      lastSyncedAt: Value(lastSyncedAt),
      lastSyncError: Value(lastSyncError),
      createdAt: Value(createdAt),
    );
  }

  /// Parse source type from string
  static MappingListSourceType _parseSourceType(String value) {
    switch (value) {
      case 'local':
        return MappingListSourceType.local;
      case 'official':
        return MappingListSourceType.official;
      case 'remote':
        return MappingListSourceType.remote;
      default:
        return MappingListSourceType.local;
    }
  }

  /// Convert source type to string
  static String _sourceTypeToString(MappingListSourceType type) {
    switch (type) {
      case MappingListSourceType.local:
        return 'local';
      case MappingListSourceType.official:
        return 'official';
      case MappingListSourceType.remote:
        return 'remote';
    }
  }
}
