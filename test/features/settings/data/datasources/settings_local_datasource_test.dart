import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tkit/core/errors/exceptions.dart';
import 'package:tkit/core/utils/app_logger.dart';
import 'package:tkit/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:tkit/features/settings/data/models/app_settings_model.dart';
import 'package:tkit/features/settings/domain/entities/fallback_behavior.dart';
import 'package:tkit/features/settings/domain/entities/update_channel.dart';
import 'package:tkit/features/settings/domain/entities/window_controls_position.dart';

@GenerateNiceMocks([MockSpec<SharedPreferences>(), MockSpec<AppLogger>()])
import 'settings_local_datasource_test.mocks.dart';

void main() {
  late SettingsLocalDataSource dataSource;
  late MockSharedPreferences mockPrefs;
  late MockAppLogger mockLogger;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    mockLogger = MockAppLogger();
    dataSource = SettingsLocalDataSource(mockPrefs, mockLogger);
  });

  tearDown(() {
    dataSource.dispose();
  });

  group('getSettings', () {
    test('should return default settings when no data exists', () async {
      // Arrange
      when(mockPrefs.getString(any)).thenReturn(null);

      // Act
      final result = await dataSource.getSettings();

      // Assert
      expect(result, isA<AppSettingsModel>());
      expect(result.scanIntervalSeconds, 5);
      expect(result.debounceSeconds, 10);
      verify(mockPrefs.getString('app_settings')).called(1);
    });

    test('should return settings from storage when data exists', () async {
      // Arrange
      final testSettings = AppSettingsModel(
        scanIntervalSeconds: 15,
        debounceSeconds: 20,
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
        enableErrorTracking: true,
        enablePerformanceMonitoring: true,
        enableSessionReplay: false,
        autoCheckForUpdates: true,
        autoInstallUpdates: false,
      );
      final jsonString = jsonEncode(testSettings.toJson());

      when(mockPrefs.getString(any)).thenReturn(jsonString);

      // Act
      final result = await dataSource.getSettings();

      // Assert
      expect(result.scanIntervalSeconds, 15);
      expect(result.debounceSeconds, 20);
      expect(result.fallbackBehavior, FallbackBehavior.justChatting);
      verify(mockPrefs.getString('app_settings')).called(1);
    });

    test('should throw CacheException when JSON decode fails', () async {
      // Arrange
      when(mockPrefs.getString(any)).thenReturn('invalid json');

      // Act & Assert
      expect(() => dataSource.getSettings(), throwsA(isA<CacheException>()));
    });
  });

  group('saveSettings', () {
    test('should save settings to storage', () async {
      // Arrange
      final testSettings = AppSettingsModel(
        scanIntervalSeconds: 15,
        debounceSeconds: 20,
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
        enableErrorTracking: true,
        enablePerformanceMonitoring: true,
        enableSessionReplay: false,
        autoCheckForUpdates: true,
        autoInstallUpdates: false,
      );

      when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);

      // Act
      await dataSource.saveSettings(testSettings);

      // Assert
      final captured = verify(
        mockPrefs.setString('app_settings', captureAny),
      ).captured;

      expect(captured.length, 1);
      final savedJson = jsonDecode(captured[0] as String);
      expect(savedJson['scanIntervalSeconds'], 15);
      expect(savedJson['debounceSeconds'], 20);
      expect(savedJson['fallbackBehavior'], 'justChatting');
    });

    test('should emit settings to stream after save', () async {
      // Arrange
      final testSettings = AppSettingsModel.defaults();
      when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);

      // Act
      final streamFuture = dataSource.watchSettings().first;
      await dataSource.saveSettings(testSettings);
      final emittedSettings = await streamFuture;

      // Assert
      expect(emittedSettings, testSettings);
    });

    test('should throw CacheException when save fails', () async {
      // Arrange
      final testSettings = AppSettingsModel.defaults();
      when(mockPrefs.setString(any, any)).thenAnswer((_) async => false);

      // Act & Assert
      expect(
        () => dataSource.saveSettings(testSettings),
        throwsA(isA<CacheException>()),
      );
    });
  });

  group('watchSettings', () {
    test('should emit current settings initially', () async {
      // Arrange
      final testSettings = AppSettingsModel(
        scanIntervalSeconds: 15,
        debounceSeconds: 20,
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
        enableErrorTracking: true,
        enablePerformanceMonitoring: true,
        enableSessionReplay: false,
        autoCheckForUpdates: true,
        autoInstallUpdates: false,
      );
      final jsonString = jsonEncode(testSettings.toJson());
      when(mockPrefs.getString(any)).thenReturn(jsonString);

      // Act
      final stream = dataSource.watchSettings();

      // Assert
      await expectLater(
        stream.first,
        completion(
          predicate<AppSettingsModel>(
            (s) => s.scanIntervalSeconds == 15 && s.debounceSeconds == 20,
          ),
        ),
      );
    });

    test('should emit updates when settings are saved', () async {
      // Arrange
      when(mockPrefs.getString(any)).thenReturn(null);
      when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);

      final settings1 = AppSettingsModel.defaults();
      final settings2 = AppSettingsModel.fromEntity(
        settings1.toEntity().copyWith(scanIntervalSeconds: 20),
      );

      // Start watching
      final streamFuture = dataSource.watchSettings().skip(1).first;

      // Wait for initial emit
      await Future.delayed(const Duration(milliseconds: 100));

      // Save updated settings
      await dataSource.saveSettings(settings2);

      // Verify the emitted updated settings
      final emitted = await streamFuture;
      expect(emitted.scanIntervalSeconds, 20);
    });
  });
}
