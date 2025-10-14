import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tkit/core/database/app_database.dart';
import 'package:tkit/features/category_mapping/domain/entities/category_mapping.dart';

part 'category_mapping_model.g.dart';

/// Data model for CategoryMapping with JSON serialization
///
/// This model extends the domain entity and provides JSON serialization
/// capabilities and conversion to/from Drift database entities.
///
/// Handles serialization of normalizedInstallPaths array to/from JSON in database.
@JsonSerializable()
class CategoryMappingModel extends CategoryMapping {
  const CategoryMappingModel({
    super.id,
    required super.processName,
    super.executablePath,
    super.normalizedInstallPaths = const [],
    required super.twitchCategoryId,
    required super.twitchCategoryName,
    required super.createdAt,
    super.lastUsedAt,
    required super.lastApiFetch,
    required super.cacheExpiresAt,
    required super.manualOverride,
    super.isEnabled = true,
    super.listId,
    super.sourceListName,
    super.sourceListIsReadOnly = false,
  });

  /// Create from domain entity
  factory CategoryMappingModel.fromEntity(CategoryMapping entity) {
    return CategoryMappingModel(
      id: entity.id,
      processName: entity.processName,
      executablePath: entity.executablePath,
      normalizedInstallPaths: entity.normalizedInstallPaths,
      twitchCategoryId: entity.twitchCategoryId,
      twitchCategoryName: entity.twitchCategoryName,
      createdAt: entity.createdAt,
      lastUsedAt: entity.lastUsedAt,
      lastApiFetch: entity.lastApiFetch,
      cacheExpiresAt: entity.cacheExpiresAt,
      manualOverride: entity.manualOverride,
      isEnabled: entity.isEnabled,
      listId: entity.listId,
      sourceListName: entity.sourceListName,
      sourceListIsReadOnly: entity.sourceListIsReadOnly,
    );
  }

  /// Create from Drift database entity
  factory CategoryMappingModel.fromDbEntity(
    CategoryMappingEntity dbEntity, {
    String? sourceListName,
    bool sourceListIsReadOnly = false,
  }) {
    // Parse normalizedInstallPaths from JSON string
    List<String> paths = [];
    if (dbEntity.normalizedInstallPaths != null &&
        dbEntity.normalizedInstallPaths!.isNotEmpty) {
      try {
        final decoded = jsonDecode(dbEntity.normalizedInstallPaths!);
        if (decoded is List) {
          paths = decoded.cast<String>();
        }
      } catch (e) {
        // If parsing fails, leave empty list
        paths = [];
      }
    }

    return CategoryMappingModel(
      id: dbEntity.id,
      processName: dbEntity.processName,
      executablePath: dbEntity.executablePath,
      normalizedInstallPaths: paths,
      twitchCategoryId: dbEntity.twitchCategoryId,
      twitchCategoryName: dbEntity.twitchCategoryName,
      createdAt: dbEntity.createdAt,
      lastUsedAt: dbEntity.lastUsedAt,
      lastApiFetch: dbEntity.lastApiFetch,
      cacheExpiresAt: dbEntity.cacheExpiresAt,
      manualOverride: dbEntity.manualOverride,
      isEnabled: dbEntity.isEnabled,
      listId: dbEntity.listId,
      sourceListName: sourceListName,
      sourceListIsReadOnly: sourceListIsReadOnly,
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
      normalizedInstallPaths: normalizedInstallPaths,
      twitchCategoryId: twitchCategoryId,
      twitchCategoryName: twitchCategoryName,
      createdAt: createdAt,
      lastUsedAt: lastUsedAt,
      lastApiFetch: lastApiFetch,
      cacheExpiresAt: cacheExpiresAt,
      manualOverride: manualOverride,
      isEnabled: isEnabled,
      listId: listId,
      sourceListName: sourceListName,
      sourceListIsReadOnly: sourceListIsReadOnly,
    );
  }

  /// Convert to Drift companion for insert/update
  CategoryMappingsCompanion toCompanion() {
    // Serialize normalizedInstallPaths to JSON string
    String? pathsJson;
    if (normalizedInstallPaths.isNotEmpty) {
      pathsJson = jsonEncode(normalizedInstallPaths);
    }

    return CategoryMappingsCompanion.insert(
      id: id != null ? Value(id!) : const Value.absent(),
      processName: processName,
      executablePath: Value(executablePath),
      normalizedInstallPaths: Value(pathsJson),
      twitchCategoryId: twitchCategoryId,
      twitchCategoryName: twitchCategoryName,
      createdAt: Value(createdAt),
      lastUsedAt: Value(lastUsedAt),
      lastApiFetch: Value(lastApiFetch),
      cacheExpiresAt: cacheExpiresAt,
      manualOverride: Value(manualOverride),
      isEnabled: Value(isEnabled),
      listId: Value(listId),
    );
  }
}
