import 'package:drift/drift.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/category_mapping.dart';

part 'category_mapping_model.g.dart';

/// Data model for CategoryMapping with JSON serialization
///
/// This model extends the domain entity and provides JSON serialization
/// capabilities and conversion to/from Drift database entities.
@JsonSerializable()
class CategoryMappingModel extends CategoryMapping {
  const CategoryMappingModel({
    super.id,
    required super.processName,
    super.executablePath,
    required super.twitchCategoryId,
    required super.twitchCategoryName,
    required super.createdAt,
    super.lastUsedAt,
    required super.lastApiFetch,
    required super.cacheExpiresAt,
    required super.manualOverride,
    super.isEnabled = true,
  });

  /// Create from domain entity
  factory CategoryMappingModel.fromEntity(CategoryMapping entity) {
    return CategoryMappingModel(
      id: entity.id,
      processName: entity.processName,
      executablePath: entity.executablePath,
      twitchCategoryId: entity.twitchCategoryId,
      twitchCategoryName: entity.twitchCategoryName,
      createdAt: entity.createdAt,
      lastUsedAt: entity.lastUsedAt,
      lastApiFetch: entity.lastApiFetch,
      cacheExpiresAt: entity.cacheExpiresAt,
      manualOverride: entity.manualOverride,
      isEnabled: entity.isEnabled,
    );
  }

  /// Create from Drift database entity
  factory CategoryMappingModel.fromDbEntity(CategoryMappingEntity dbEntity) {
    return CategoryMappingModel(
      id: dbEntity.id,
      processName: dbEntity.processName,
      executablePath: dbEntity.executablePath,
      twitchCategoryId: dbEntity.twitchCategoryId,
      twitchCategoryName: dbEntity.twitchCategoryName,
      createdAt: dbEntity.createdAt,
      lastUsedAt: dbEntity.lastUsedAt,
      lastApiFetch: dbEntity.lastApiFetch,
      cacheExpiresAt: dbEntity.cacheExpiresAt,
      manualOverride: dbEntity.manualOverride,
      isEnabled: dbEntity.isEnabled,
    );
  }

  /// Create from JSON
  factory CategoryMappingModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryMappingModelFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$CategoryMappingModelToJson(this);

  /// Convert to domain entity
  CategoryMapping toEntity() {
    return CategoryMapping(
      id: id,
      processName: processName,
      executablePath: executablePath,
      twitchCategoryId: twitchCategoryId,
      twitchCategoryName: twitchCategoryName,
      createdAt: createdAt,
      lastUsedAt: lastUsedAt,
      lastApiFetch: lastApiFetch,
      cacheExpiresAt: cacheExpiresAt,
      manualOverride: manualOverride,
      isEnabled: isEnabled,
    );
  }

  /// Convert to Drift companion for insert/update
  CategoryMappingsCompanion toCompanion() {
    return CategoryMappingsCompanion.insert(
      id: id != null ? Value(id!) : const Value.absent(),
      processName: processName,
      executablePath: Value(executablePath),
      twitchCategoryId: twitchCategoryId,
      twitchCategoryName: twitchCategoryName,
      createdAt: Value(createdAt),
      lastUsedAt: Value(lastUsedAt),
      lastApiFetch: Value(lastApiFetch),
      cacheExpiresAt: cacheExpiresAt,
      manualOverride: Value(manualOverride),
      isEnabled: Value(isEnabled),
    );
  }
}
