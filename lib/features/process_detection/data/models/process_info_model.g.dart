// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'process_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProcessInfoModel _$ProcessInfoModelFromJson(Map<String, dynamic> json) =>
    ProcessInfoModel(
      processName: json['processName'] as String,
      pid: (json['pid'] as num).toInt(),
      windowTitle: json['windowTitle'] as String,
      executablePath: json['executablePath'] as String?,
    );

Map<String, dynamic> _$ProcessInfoModelToJson(ProcessInfoModel instance) =>
    <String, dynamic>{
      'processName': instance.processName,
      'pid': instance.pid,
      'windowTitle': instance.windowTitle,
      'executablePath': instance.executablePath,
    };
