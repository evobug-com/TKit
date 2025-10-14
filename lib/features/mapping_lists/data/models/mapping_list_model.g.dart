// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mapping_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MappingListModel _$MappingListModelFromJson(Map<String, dynamic> json) =>
    MappingListModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      sourceType: $enumDecode(
        _$MappingListSourceTypeEnumMap,
        json['sourceType'],
      ),
      sourceUrl: json['sourceUrl'] as String?,
      submissionHookUrl: json['submissionHookUrl'] as String?,
      isEnabled: json['isEnabled'] as bool,
      isReadOnly: json['isReadOnly'] as bool,
      mappingCount: (json['mappingCount'] as num).toInt(),
      lastSyncedAt: json['lastSyncedAt'] == null
          ? null
          : DateTime.parse(json['lastSyncedAt'] as String),
      lastSyncError: json['lastSyncError'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      priority: (json['priority'] as num).toInt(),
    );

Map<String, dynamic> _$MappingListModelToJson(MappingListModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'sourceType': _$MappingListSourceTypeEnumMap[instance.sourceType]!,
      'sourceUrl': instance.sourceUrl,
      'submissionHookUrl': instance.submissionHookUrl,
      'isEnabled': instance.isEnabled,
      'isReadOnly': instance.isReadOnly,
      'mappingCount': instance.mappingCount,
      'lastSyncedAt': instance.lastSyncedAt?.toIso8601String(),
      'lastSyncError': instance.lastSyncError,
      'createdAt': instance.createdAt.toIso8601String(),
      'priority': instance.priority,
    };

const _$MappingListSourceTypeEnumMap = {
  MappingListSourceType.local: 'local',
  MappingListSourceType.official: 'official',
  MappingListSourceType.remote: 'remote',
};
