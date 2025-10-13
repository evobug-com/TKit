import 'package:json_annotation/json_annotation.dart';
import 'package:tkit/features/settings/domain/entities/app_settings.dart';
import 'package:tkit/features/settings/domain/entities/fallback_behavior.dart';
import 'package:tkit/features/settings/domain/entities/update_channel.dart';
import 'package:tkit/features/settings/domain/entities/window_controls_position.dart';

part 'app_settings_model.g.dart';

/// Data model for AppSettings with JSON serialization
/// Extends domain entity to maintain Clean Architecture separation
@JsonSerializable(explicitToJson: true)
class AppSettingsModel extends AppSettings {
  const AppSettingsModel({
    required super.scanIntervalSeconds,
    required super.debounceSeconds,
    required super.fallbackBehavior,
    super.customFallbackCategoryId,
    super.customFallbackCategoryName,
    required super.autoStartWithWindows,
    required super.startMinimized,
    required super.minimizeToTray,
    required super.showNotifications,
    required super.notifyOnMissingCategory,
    required super.autoStartMonitoring,
    super.manualUpdateHotkey,
    required super.updateChannel,
    required super.windowControlsPosition,
    required super.useFramelessWindow,
  });

  /// Create from domain entity
  factory AppSettingsModel.fromEntity(AppSettings settings) {
    return AppSettingsModel(
      scanIntervalSeconds: settings.scanIntervalSeconds,
      debounceSeconds: settings.debounceSeconds,
      fallbackBehavior: settings.fallbackBehavior,
      customFallbackCategoryId: settings.customFallbackCategoryId,
      customFallbackCategoryName: settings.customFallbackCategoryName,
      autoStartWithWindows: settings.autoStartWithWindows,
      startMinimized: settings.startMinimized,
      minimizeToTray: settings.minimizeToTray,
      showNotifications: settings.showNotifications,
      notifyOnMissingCategory: settings.notifyOnMissingCategory,
      autoStartMonitoring: settings.autoStartMonitoring,
      manualUpdateHotkey: settings.manualUpdateHotkey,
      updateChannel: settings.updateChannel,
      windowControlsPosition: settings.windowControlsPosition,
      useFramelessWindow: settings.useFramelessWindow,
    );
  }

  /// Create from JSON
  factory AppSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsModelFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$AppSettingsModelToJson(this);

  /// Create domain entity
  AppSettings toEntity() {
    return AppSettings(
      scanIntervalSeconds: scanIntervalSeconds,
      debounceSeconds: debounceSeconds,
      fallbackBehavior: fallbackBehavior,
      customFallbackCategoryId: customFallbackCategoryId,
      customFallbackCategoryName: customFallbackCategoryName,
      autoStartWithWindows: autoStartWithWindows,
      startMinimized: startMinimized,
      minimizeToTray: minimizeToTray,
      showNotifications: showNotifications,
      notifyOnMissingCategory: notifyOnMissingCategory,
      autoStartMonitoring: autoStartMonitoring,
      manualUpdateHotkey: manualUpdateHotkey,
      updateChannel: updateChannel,
      windowControlsPosition: windowControlsPosition,
      useFramelessWindow: useFramelessWindow,
    );
  }

  /// Default settings model
  /// Automatically detects update channel from app version
  factory AppSettingsModel.defaults({String? appVersion}) {
    final defaults = AppSettings.defaults(appVersion: appVersion);
    return AppSettingsModel.fromEntity(defaults);
  }
}
