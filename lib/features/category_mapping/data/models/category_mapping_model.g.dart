// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_mapping_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryMappingModel _$CategoryMappingModelFromJson(
  Map<String, dynamic> json,
) => CategoryMappingModel(
  id: (json['id'] as num?)?.toInt(),
  processName: json['processName'] as String,
  executablePath: json['executablePath'] as String?,
  twitchCategoryId: json['twitchCategoryId'] as String,
  twitchCategoryName: json['twitchCategoryName'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  lastUsedAt: json['lastUsedAt'] == null
      ? null
      : DateTime.parse(json['lastUsedAt'] as String),
  lastApiFetch: DateTime.parse(json['lastApiFetch'] as String),
  cacheExpiresAt: DateTime.parse(json['cacheExpiresAt'] as String),
  manualOverride: json['manualOverride'] as bool,
);

Map<String, dynamic> _$CategoryMappingModelToJson(
  CategoryMappingModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'processName': instance.processName,
  'executablePath': instance.executablePath,
  'twitchCategoryId': instance.twitchCategoryId,
  'twitchCategoryName': instance.twitchCategoryName,
  'createdAt': instance.createdAt.toIso8601String(),
  'lastUsedAt': instance.lastUsedAt?.toIso8601String(),
  'lastApiFetch': instance.lastApiFetch.toIso8601String(),
  'cacheExpiresAt': instance.cacheExpiresAt.toIso8601String(),
  'manualOverride': instance.manualOverride,
};
