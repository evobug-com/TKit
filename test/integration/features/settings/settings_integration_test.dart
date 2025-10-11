import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tkit/core/utils/app_logger.dart';
import 'package:tkit/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:tkit/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:tkit/features/settings/domain/entities/app_settings.dart';
import 'package:tkit/features/settings/domain/entities/fallback_behavior.dart';
import 'package:tkit/features/settings/domain/entities/update_channel.dart';
import 'package:tkit/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:tkit/features/settings/domain/usecases/update_settings_usecase.dart';
import 'package:tkit/features/settings/domain/usecases/watch_settings_usecase.dart';

/// Integration test for Settings module
/// Tests the full stack from use cases -> repository -> data source -> storage
void main() {
  group('Settings Integration Test', () {
    late SettingsLocalDataSource dataSource;
    late SettingsRepositoryImpl repository;
    late GetSettingsUseCase getSettingsUseCase;
    late UpdateSettingsUseCase updateSettingsUseCase;
    late WatchSettingsUseCase watchSettingsUseCase;
    late SharedPreferences prefs;
    late AppLogger logger;

    setUp(() async {
      // Initialize SharedPreferences with in-memory implementation
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      logger = AppLogger();

      // Build the dependency chain
      dataSource = SettingsLocalDataSource(prefs, logger);
      repository = SettingsRepositoryImpl(dataSource, logger);
      getSettingsUseCase = GetSettingsUseCase(repository);
      updateSettingsUseCase = UpdateSettingsUseCase(repository);
      watchSettingsUseCase = WatchSettingsUseCase(repository);
    });

    tearDown(() async {
      await prefs.clear();
      dataSource.dispose();
    });

    test('should return default settings when none exist', () async {
      // Act
      final result = await getSettingsUseCase();

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (settings) {
        expect(settings.scanIntervalSeconds, 5);
        expect(settings.debounceSeconds, 10);
        expect(settings.fallbackBehavior, FallbackBehavior.doNothing);
        expect(settings.autoStartWithWindows, false);
        expect(settings.minimizeToTray, true);
        expect(settings.showNotifications, true);
      });
    });

    test('should save and retrieve settings', () async {
      // Arrange
      const newSettings = AppSettings(
        scanIntervalSeconds: 15,
        debounceSeconds: 20,
        fallbackBehavior: FallbackBehavior.justChatting,
        autoStartWithWindows: true,
        minimizeToTray: false,
        showNotifications: false,
        notifyOnMissingCategory: true,
        startMinimized: false,
        autoStartMonitoring: true,
        updateChannel: UpdateChannel.stable,
      );

      // Act - Save
      final saveResult = await updateSettingsUseCase(newSettings);

      // Assert - Save succeeded
      expect(saveResult.isRight(), true);

      // Act - Retrieve
      final getResult = await getSettingsUseCase();

      // Assert - Retrieved settings match saved settings
      expect(getResult.isRight(), true);
      getResult.fold((failure) => fail('Should not return failure'), (
        settings,
      ) {
        expect(settings.scanIntervalSeconds, 15);
        expect(settings.debounceSeconds, 20);
        expect(settings.fallbackBehavior, FallbackBehavior.justChatting);
        expect(settings.autoStartWithWindows, true);
        expect(settings.minimizeToTray, false);
        expect(settings.showNotifications, false);
      });
    });

    test('should persist settings across instances', () async {
      // Arrange
      const settings1 = AppSettings(
        scanIntervalSeconds: 30,
        debounceSeconds: 25,
        fallbackBehavior: FallbackBehavior.custom,
        customFallbackCategoryId: '12345',
        customFallbackCategoryName: 'Test Category',
        autoStartWithWindows: true,
        minimizeToTray: true,
        showNotifications: true,
        notifyOnMissingCategory: true,
        startMinimized: false,
        autoStartMonitoring: true,
        updateChannel: UpdateChannel.stable,
      );

      // Act - Save with first instance
      await updateSettingsUseCase(settings1);

      // Create new instances (simulating app restart)
      final newDataSource = SettingsLocalDataSource(prefs, logger);
      final newRepository = SettingsRepositoryImpl(newDataSource, logger);
      final newGetSettingsUseCase = GetSettingsUseCase(newRepository);

      // Act - Retrieve with new instance
      final result = await newGetSettingsUseCase();

      // Assert - Settings persisted
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (settings) {
        expect(settings.scanIntervalSeconds, 30);
        expect(settings.debounceSeconds, 25);
        expect(settings.fallbackBehavior, FallbackBehavior.custom);
        expect(settings.customFallbackCategoryId, '12345');
        expect(settings.customFallbackCategoryName, 'Test Category');
      });

      // Cleanup
      newDataSource.dispose();
    });

    test('should validate settings before saving', () async {
      // Arrange - Invalid scan interval
      const invalidSettings = AppSettings(
        scanIntervalSeconds: 0,
        debounceSeconds: 10,
        fallbackBehavior: FallbackBehavior.doNothing,
        autoStartWithWindows: false,
        minimizeToTray: true,
        showNotifications: true,
        notifyOnMissingCategory: true,
        startMinimized: false,
        autoStartMonitoring: true,
        updateChannel: UpdateChannel.stable,
      );

      // Act
      final result = await updateSettingsUseCase(invalidSettings);

      // Assert - Validation failure
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure.message, contains('Scan interval'));
      }, (_) => fail('Should return validation failure'));
    });

    test('should emit settings updates through watch stream', () async {
      // Arrange
      final settingsStream = watchSettingsUseCase();
      final emittedSettings = <AppSettings>[];

      final subscription = settingsStream.listen((settings) {
        emittedSettings.add(settings);
      });

      // Wait for initial emission
      await Future.delayed(const Duration(milliseconds: 100));

      // Act - Update settings
      const newSettings = AppSettings(
        scanIntervalSeconds: 20,
        debounceSeconds: 15,
        fallbackBehavior: FallbackBehavior.justChatting,
        autoStartWithWindows: true,
        minimizeToTray: false,
        showNotifications: true,
        notifyOnMissingCategory: true,
        startMinimized: false,
        autoStartMonitoring: true,
        updateChannel: UpdateChannel.stable,
      );
      await updateSettingsUseCase(newSettings);

      // Wait for update emission
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      expect(emittedSettings.length, greaterThanOrEqualTo(2));
      // Initial emission should be defaults
      expect(emittedSettings.first.scanIntervalSeconds, 5);
      // Updated emission should have new values
      expect(emittedSettings.last.scanIntervalSeconds, 20);
      expect(emittedSettings.last.debounceSeconds, 15);

      // Cleanup
      await subscription.cancel();
    });

    test('should handle multiple updates correctly', () async {
      // Arrange
      final updates = [
        AppSettings.defaults(),
        AppSettings.defaults().copyWith(scanIntervalSeconds: 10),
        AppSettings.defaults().copyWith(scanIntervalSeconds: 15),
        AppSettings.defaults().copyWith(scanIntervalSeconds: 20),
      ];

      // Act - Perform multiple updates
      for (final settings in updates) {
        final result = await updateSettingsUseCase(settings);
        expect(result.isRight(), true);
      }

      // Act - Retrieve final state
      final getResult = await getSettingsUseCase();

      // Assert - Final settings match last update
      expect(getResult.isRight(), true);
      getResult.fold((failure) => fail('Should not return failure'), (
        settings,
      ) {
        expect(settings.scanIntervalSeconds, 20);
      });
    });

    test(
      'should validate custom fallback behavior requires category',
      () async {
        // Arrange - Custom fallback without category ID
        const invalidSettings = AppSettings(
          scanIntervalSeconds: 5,
          debounceSeconds: 10,
          fallbackBehavior: FallbackBehavior.custom,
          customFallbackCategoryId: null,
          autoStartWithWindows: false,
          minimizeToTray: true,
          showNotifications: true,
          notifyOnMissingCategory: true,
          startMinimized: false,
          autoStartMonitoring: true,
          updateChannel: UpdateChannel.stable,
        );

        // Act
        final result = await updateSettingsUseCase(invalidSettings);

        // Assert - Validation failure
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure.message, contains('Custom fallback category'));
        }, (_) => fail('Should return validation failure'));
      },
    );

    test('should accept valid custom fallback with category', () async {
      // Arrange
      const validSettings = AppSettings(
        scanIntervalSeconds: 5,
        debounceSeconds: 10,
        fallbackBehavior: FallbackBehavior.custom,
        customFallbackCategoryId: 'category-123',
        customFallbackCategoryName: 'Custom Game',
        autoStartWithWindows: false,
        minimizeToTray: true,
        showNotifications: true,
        notifyOnMissingCategory: true,
        startMinimized: false,
        autoStartMonitoring: true,
        updateChannel: UpdateChannel.stable,
      );

      // Act
      final result = await updateSettingsUseCase(validSettings);

      // Assert - Success
      expect(result.isRight(), true);
    });

    test('should handle JSON serialization roundtrip correctly', () async {
      // Arrange
      const originalSettings = AppSettings(
        scanIntervalSeconds: 42,
        debounceSeconds: 33,
        fallbackBehavior: FallbackBehavior.custom,
        customFallbackCategoryId: 'test-id',
        customFallbackCategoryName: 'Test Name',
        autoStartWithWindows: true,
        minimizeToTray: false,
        showNotifications: true,
        notifyOnMissingCategory: true,
        startMinimized: false,
        autoStartMonitoring: true,
        updateChannel: UpdateChannel.stable,
      );

      // Act - Save (involves JSON serialization)
      await updateSettingsUseCase(originalSettings);

      // Clear in-memory cache by creating new instances
      final newDataSource = SettingsLocalDataSource(prefs, logger);
      final newRepository = SettingsRepositoryImpl(newDataSource, logger);
      final newGetSettingsUseCase = GetSettingsUseCase(newRepository);

      // Act - Retrieve (involves JSON deserialization)
      final result = await newGetSettingsUseCase();

      // Assert - All fields preserved
      expect(result.isRight(), true);
      result.fold((failure) => fail('Should not return failure'), (settings) {
        expect(
          settings.scanIntervalSeconds,
          originalSettings.scanIntervalSeconds,
        );
        expect(settings.debounceSeconds, originalSettings.debounceSeconds);
        expect(settings.fallbackBehavior, originalSettings.fallbackBehavior);
        expect(
          settings.customFallbackCategoryId,
          originalSettings.customFallbackCategoryId,
        );
        expect(
          settings.customFallbackCategoryName,
          originalSettings.customFallbackCategoryName,
        );
        expect(
          settings.autoStartWithWindows,
          originalSettings.autoStartWithWindows,
        );
        expect(settings.minimizeToTray, originalSettings.minimizeToTray);
        expect(settings.showNotifications, originalSettings.showNotifications);
      });

      // Cleanup
      newDataSource.dispose();
    });
  });
}
