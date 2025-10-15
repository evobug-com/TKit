import 'package:flutter_test/flutter_test.dart';
import 'package:tkit/features/settings/domain/entities/app_settings.dart';
import 'package:tkit/features/settings/domain/entities/fallback_behavior.dart';
import 'package:tkit/features/settings/domain/entities/update_channel.dart';
import 'package:tkit/features/settings/domain/entities/window_controls_position.dart';

void main() {
  group('AppSettings', () {
    test('should create default settings', () {
      // Act
      final settings = AppSettings.defaults();

      // Assert
      expect(settings.scanIntervalSeconds, 5);
      expect(settings.debounceSeconds, 10);
      expect(settings.fallbackBehavior, FallbackBehavior.doNothing);
      expect(settings.customFallbackCategoryId, null);
      expect(settings.autoStartWithWindows, false);
      expect(settings.minimizeToTray, true);
      expect(settings.showNotifications, true);
    });

    test('should create settings with all parameters', () {
      // Act
      const settings = AppSettings(
        scanIntervalSeconds: 10,
        debounceSeconds: 20,
        fallbackBehavior: FallbackBehavior.justChatting,
        autoStartWithWindows: true,
        minimizeToTray: false,
        showNotifications: false,
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

      // Assert
      expect(settings.scanIntervalSeconds, 10);
      expect(settings.debounceSeconds, 20);
      expect(settings.fallbackBehavior, FallbackBehavior.justChatting);
      expect(settings.autoStartWithWindows, true);
      expect(settings.minimizeToTray, false);
      expect(settings.showNotifications, false);
    });

    test('should copy settings with updated values', () {
      // Arrange
      final settings = AppSettings.defaults();

      // Act
      final updated = settings.copyWith(
        scanIntervalSeconds: 15,
        fallbackBehavior: FallbackBehavior.custom,
        customFallbackCategoryId: '12345',
      );

      // Assert
      expect(updated.scanIntervalSeconds, 15);
      expect(updated.debounceSeconds, settings.debounceSeconds);
      expect(updated.fallbackBehavior, FallbackBehavior.custom);
      expect(updated.customFallbackCategoryId, '12345');
    });

    group('validate', () {
      test('should return null for valid settings', () {
        // Arrange
        final settings = AppSettings.defaults();

        // Act
        final result = settings.validate();

        // Assert
        expect(result, null);
      });

      test('should return error for scanIntervalSeconds < 1', () {
        // Arrange
        final settings = AppSettings.defaults().copyWith(
          scanIntervalSeconds: 0,
        );

        // Act
        final result = settings.validate();

        // Assert
        expect(result, contains('Scan interval must be between 1 and 300'));
      });

      test('should return error for scanIntervalSeconds > 300', () {
        // Arrange
        final settings = AppSettings.defaults().copyWith(
          scanIntervalSeconds: 301,
        );

        // Act
        final result = settings.validate();

        // Assert
        expect(result, contains('Scan interval must be between 1 and 300'));
      });

      test('should return error for debounceSeconds < 0', () {
        // Arrange
        final settings = AppSettings.defaults().copyWith(debounceSeconds: -1);

        // Act
        final result = settings.validate();

        // Assert
        expect(result, contains('Debounce must be between 0 and 300'));
      });

      test('should return error for debounceSeconds > 300', () {
        // Arrange
        final settings = AppSettings.defaults().copyWith(debounceSeconds: 301);

        // Act
        final result = settings.validate();

        // Assert
        expect(result, contains('Debounce must be between 0 and 300'));
      });

      test('should return error for custom fallback without category ID', () {
        // Arrange
        final settings = AppSettings.defaults().copyWith(
          fallbackBehavior: FallbackBehavior.custom,
        );

        // Act
        final result = settings.validate();

        // Assert
        expect(result, contains('Custom fallback category must be specified'));
      });

      test(
        'should return error for custom fallback with empty category ID',
        () {
          // Arrange
          final settings = AppSettings.defaults().copyWith(
            fallbackBehavior: FallbackBehavior.custom,
            customFallbackCategoryId: '',
          );

          // Act
          final result = settings.validate();

          // Assert
          expect(
            result,
            contains('Custom fallback category must be specified'),
          );
        },
      );

      test('should return null for valid custom fallback', () {
        // Arrange
        final settings = AppSettings.defaults().copyWith(
          fallbackBehavior: FallbackBehavior.custom,
          customFallbackCategoryId: '12345',
        );

        // Act
        final result = settings.validate();

        // Assert
        expect(result, null);
      });
    });

    test('isValid should return true for valid settings', () {
      // Arrange
      final settings = AppSettings.defaults();

      // Act & Assert
      expect(settings.isValid, true);
    });

    test('isValid should return false for invalid settings', () {
      // Arrange
      final settings = AppSettings.defaults().copyWith(scanIntervalSeconds: 0);

      // Act & Assert
      expect(settings.isValid, false);
    });

    test('should support equality comparison', () {
      // Arrange
      final settings1 = AppSettings.defaults();
      final settings2 = AppSettings.defaults();
      final settings3 = AppSettings.defaults().copyWith(
        scanIntervalSeconds: 15,
      );

      // Act & Assert
      expect(settings1, equals(settings2));
      expect(settings1, isNot(equals(settings3)));
    });
  });
}
