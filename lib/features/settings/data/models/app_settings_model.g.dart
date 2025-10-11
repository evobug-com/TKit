// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSettingsModel _$AppSettingsModelFromJson(Map<String, dynamic> json) =>
    AppSettingsModel(
      scanIntervalSeconds: (json['scanIntervalSeconds'] as num).toInt(),
      debounceSeconds: (json['debounceSeconds'] as num).toInt(),
      fallbackBehavior: $enumDecode(
        _$FallbackBehaviorEnumMap,
        json['fallbackBehavior'],
      ),
      customFallbackCategoryId: json['customFallbackCategoryId'] as String?,
      customFallbackCategoryName: json['customFallbackCategoryName'] as String?,
      autoStartWithWindows: json['autoStartWithWindows'] as bool,
      startMinimized: json['startMinimized'] as bool,
      minimizeToTray: json['minimizeToTray'] as bool,
      showNotifications: json['showNotifications'] as bool,
      notifyOnMissingCategory: json['notifyOnMissingCategory'] as bool,
      autoStartMonitoring: json['autoStartMonitoring'] as bool,
      manualUpdateHotkey: json['manualUpdateHotkey'] as String?,
      updateChannel: $enumDecode(_$UpdateChannelEnumMap, json['updateChannel']),
      windowControlsPosition: $enumDecode(
        _$WindowControlsPositionEnumMap,
        json['windowControlsPosition'],
      ),
    );

Map<String, dynamic> _$AppSettingsModelToJson(AppSettingsModel instance) =>
    <String, dynamic>{
      'scanIntervalSeconds': instance.scanIntervalSeconds,
      'debounceSeconds': instance.debounceSeconds,
      'fallbackBehavior': instance.fallbackBehavior.toJson(),
      'customFallbackCategoryId': instance.customFallbackCategoryId,
      'customFallbackCategoryName': instance.customFallbackCategoryName,
      'autoStartWithWindows': instance.autoStartWithWindows,
      'startMinimized': instance.startMinimized,
      'minimizeToTray': instance.minimizeToTray,
      'showNotifications': instance.showNotifications,
      'notifyOnMissingCategory': instance.notifyOnMissingCategory,
      'autoStartMonitoring': instance.autoStartMonitoring,
      'manualUpdateHotkey': instance.manualUpdateHotkey,
      'updateChannel': _$UpdateChannelEnumMap[instance.updateChannel]!,
      'windowControlsPosition':
          _$WindowControlsPositionEnumMap[instance.windowControlsPosition]!,
    };

const _$FallbackBehaviorEnumMap = {
  FallbackBehavior.doNothing: 'doNothing',
  FallbackBehavior.justChatting: 'justChatting',
  FallbackBehavior.custom: 'custom',
};

const _$UpdateChannelEnumMap = {
  UpdateChannel.stable: 'stable',
  UpdateChannel.rc: 'rc',
  UpdateChannel.beta: 'beta',
  UpdateChannel.dev: 'dev',
};

const _$WindowControlsPositionEnumMap = {
  WindowControlsPosition.left: 'left',
  WindowControlsPosition.center: 'center',
  WindowControlsPosition.right: 'right',
};
