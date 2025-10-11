// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unknown_process_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnknownProcessModel _$UnknownProcessModelFromJson(Map<String, dynamic> json) =>
    UnknownProcessModel(
      id: (json['id'] as num?)?.toInt(),
      executableName: json['executableName'] as String,
      windowTitle: json['windowTitle'] as String?,
      firstDetected: DateTime.parse(json['firstDetected'] as String),
      occurrenceCount: (json['occurrenceCount'] as num).toInt(),
      resolved: json['resolved'] as bool,
    );

Map<String, dynamic> _$UnknownProcessModelToJson(
  UnknownProcessModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'executableName': instance.executableName,
  'windowTitle': instance.windowTitle,
  'firstDetected': instance.firstDetected.toIso8601String(),
  'occurrenceCount': instance.occurrenceCount,
  'resolved': instance.resolved,
};
