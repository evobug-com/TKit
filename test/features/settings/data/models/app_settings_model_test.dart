import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:tkit/features/settings/data/models/app_settings_model.dart';
import 'package:tkit/features/settings/domain/entities/app_settings.dart';
import 'package:tkit/features/settings/domain/entities/fallback_behavior.dart';
import 'package:tkit/features/settings/domain/entities/update_channel.dart';
import 'package:tkit/features/settings/domain/entities/window_controls_position.dart';

void main() {
  group('AppSettingsModel', () {
    final testSettings = AppSettingsModel(
      scanIntervalSeconds: 10,
      debounceSeconds: 15,
      fallbackBehavior: FallbackBehavior.justChatting,
      customFallbackCategoryId: null,
      customFallbackCategoryName: null,
      autoStartWithWindows: true,
      minimizeToTray: false,
      showNotifications: true,
      notifyOnMissingCategory: true,
      startMinimized: false,
      autoStartMonitoring: true,
      updateChannel: UpdateChannel.stable,
      windowControlsPosition: WindowControlsPosition.right,
      useFramelessWindow: false,
      invertFooterHeader: false,
      autoSyncMappingsOnStart: true,
      mappingsSyncIntervalHours: 6,
    );

    final testJson = {
      'scanIntervalSeconds': 10,
      'debounceSeconds': 15,
      'fallbackBehavior': 'justChatting',
      'customFallbackCategoryId': null,
      'customFallbackCategoryName': null,
      'autoStartWithWindows': true,
      'minimizeToTray': false,
      'showNotifications': true,
      'notifyOnMissingCategory': true,
      'startMinimized': false,
      'autoStartMonitoring': true,
      'manualUpdateHotkey': null,
      'updateChannel': 'stable',
    };

    test('should be a subclass of AppSettings', () {
      expect(testSettings, isA<AppSettings>());
    });

    test('should create from entity', () {
      // Arrange
      const entity = AppSettings(
        scanIntervalSeconds: 10,
        debounceSeconds: 15,
        fallbackBehavior: FallbackBehavior.justChatting,
        autoStartWithWindows: true,
        minimizeToTray: false,
        showNotifications: true,
        notifyOnMissingCategory: true,
        startMinimized: false,
        autoStartMonitoring: true,
        updateChannel: UpdateChannel.stable,
        windowControlsPosition: WindowControlsPosition.right,
        useFramelessWindow: false,
        invertFooterHeader: false,
        autoSyncMappingsOnStart: true,
        mappingsSyncIntervalHours: 6,
      );

      // Act
      final model = AppSettingsModel.fromEntity(entity);

      // Assert
      expect(model.scanIntervalSeconds, entity.scanIntervalSeconds);
      expect(model.debounceSeconds, entity.debounceSeconds);
      expect(model.fallbackBehavior, entity.fallbackBehavior);
      expect(model.autoStartWithWindows, entity.autoStartWithWindows);
      expect(model.minimizeToTray, entity.minimizeToTray);
      expect(model.showNotifications, entity.showNotifications);
    });

    test('should convert to entity', () {
      // Act
      final entity = testSettings.toEntity();

      // Assert
      expect(entity, isA<AppSettings>());
      expect(entity.scanIntervalSeconds, testSettings.scanIntervalSeconds);
      expect(entity.debounceSeconds, testSettings.debounceSeconds);
      expect(entity.fallbackBehavior, testSettings.fallbackBehavior);
      expect(entity.autoStartWithWindows, testSettings.autoStartWithWindows);
      expect(entity.minimizeToTray, testSettings.minimizeToTray);
      expect(entity.showNotifications, testSettings.showNotifications);
    });

    test('should serialize to JSON', () {
      // Act
      final json = testSettings.toJson();

      // Assert
      expect(json, testJson);
    });

    test('should deserialize from JSON', () {
      // Act
      final model = AppSettingsModel.fromJson(testJson);

      // Assert
      expect(model.scanIntervalSeconds, testSettings.scanIntervalSeconds);
      expect(model.debounceSeconds, testSettings.debounceSeconds);
      expect(model.fallbackBehavior, testSettings.fallbackBehavior);
      expect(model.autoStartWithWindows, testSettings.autoStartWithWindows);
      expect(model.minimizeToTray, testSettings.minimizeToTray);
      expect(model.showNotifications, testSettings.showNotifications);
    });

    test('should handle custom fallback in JSON', () {
      // Arrange
      final jsonWithCustom = {
        'scanIntervalSeconds': 10,
        'debounceSeconds': 15,
        'fallbackBehavior': 'custom',
        'customFallbackCategoryId': '12345',
        'customFallbackCategoryName': 'Test Category',
        'autoStartWithWindows': true,
        'minimizeToTray': false,
        'showNotifications': true,
        'notifyOnMissingCategory': true,
        'startMinimized': false,
        'autoStartMonitoring': true,
        'updateChannel': 'stable',
      };

      // Act
      final model = AppSettingsModel.fromJson(jsonWithCustom);

      // Assert
      expect(model.fallbackBehavior, FallbackBehavior.custom);
      expect(model.customFallbackCategoryId, '12345');
      expect(model.customFallbackCategoryName, 'Test Category');
    });

    test('should create default settings', () {
      // Act
      final defaults = AppSettingsModel.defaults();

      // Assert
      expect(defaults.scanIntervalSeconds, 5);
      expect(defaults.debounceSeconds, 10);
      expect(defaults.fallbackBehavior, FallbackBehavior.doNothing);
      expect(defaults.autoStartWithWindows, false);
      expect(defaults.minimizeToTray, true);
      expect(defaults.showNotifications, true);
    });

    test('should roundtrip through JSON', () {
      // Act
      final json = testSettings.toJson();
      final jsonString = jsonEncode(json);
      final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
      final model = AppSettingsModel.fromJson(decoded);

      // Assert
      expect(model.scanIntervalSeconds, testSettings.scanIntervalSeconds);
      expect(model.debounceSeconds, testSettings.debounceSeconds);
      expect(model.fallbackBehavior, testSettings.fallbackBehavior);
      expect(model.autoStartWithWindows, testSettings.autoStartWithWindows);
      expect(model.minimizeToTray, testSettings.minimizeToTray);
      expect(model.showNotifications, testSettings.showNotifications);
    });
  });
}
