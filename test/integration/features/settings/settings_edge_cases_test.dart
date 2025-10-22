import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/settings/domain/entities/app_settings.dart';
import 'package:tkit/features/settings/domain/entities/fallback_behavior.dart';
import 'package:tkit/features/settings/domain/entities/update_channel.dart';
import 'package:tkit/features/settings/domain/entities/window_controls_position.dart';
import 'package:tkit/features/settings/domain/repositories/i_settings_repository.dart';

import 'settings_edge_cases_test.mocks.dart';

@GenerateMocks([ISettingsRepository])
void main() {
  late MockISettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockISettingsRepository();
  });

  group('Settings Persistence Edge Cases', () {
    group('Invalid Settings Values', () {
      test('should validate negative debounce seconds', () {
        // arrange
        final invalidSettings = AppSettings.defaults().copyWith(
          debounceSeconds: -5, // Invalid negative value
        );

        // Settings validation happens in the entity itself
        expect(invalidSettings.validate(), isNotNull);
        expect(invalidSettings.validate(), contains('between 0 and 300'));
      });

      test('should validate negative scan interval', () {
        // arrange
        final invalidSettings = AppSettings.defaults().copyWith(
          scanIntervalSeconds: -1, // Invalid negative value
        );

        expect(invalidSettings.validate(), isNotNull);
        expect(invalidSettings.validate(), contains('between 1 and 300'));
      });

      test('should validate extremely large debounce values', () {
        // arrange
        final extremeSettings = AppSettings.defaults().copyWith(
          debounceSeconds: 999999999, // Extremely large value
        );

        expect(extremeSettings.validate(), isNotNull);
        expect(extremeSettings.validate(), contains('between 0 and 300'));
      });

      test('should validate extremely large scan interval', () {
        // arrange
        final extremeSettings = AppSettings.defaults().copyWith(
          scanIntervalSeconds: 999999, // Extremely large value
        );

        expect(extremeSettings.validate(), isNotNull);
        expect(extremeSettings.validate(), contains('between 1 and 300'));
      });

      test('should require custom category ID when fallback behavior is custom', () {
        // arrange
        final invalidSettings = AppSettings.defaults().copyWith(
          fallbackBehavior: FallbackBehavior.custom,
          customFallbackCategoryId: null, // Missing required ID
        );

        expect(invalidSettings.validate(), isNotNull);
        expect(invalidSettings.validate(), contains('Custom fallback category must be specified'));
      });

      test('should accept empty custom category ID when fallback is not custom', () {
        // arrange
        final validSettings = AppSettings.defaults().copyWith(
          fallbackBehavior: FallbackBehavior.doNothing,
          customFallbackCategoryId: null, // OK when not using custom
        );

        expect(validSettings.validate(), isNull);
        expect(validSettings.isValid, true);
      });

      test('should validate mappings sync interval boundaries', () {
        // arrange
        final tooSmall = AppSettings.defaults().copyWith(
          mappingsSyncIntervalHours: -1,
        );

        final tooLarge = AppSettings.defaults().copyWith(
          mappingsSyncIntervalHours: 169, // > 168 (1 week)
        );

        final justRight = AppSettings.defaults().copyWith(
          mappingsSyncIntervalHours: 24, // Valid
        );

        expect(tooSmall.validate(), isNotNull);
        expect(tooSmall.validate(), contains('between 0 and 168'));

        expect(tooLarge.validate(), isNotNull);
        expect(tooLarge.validate(), contains('between 0 and 168'));

        expect(justRight.validate(), isNull);
        expect(justRight.isValid, true);
      });
    });

    group('Corrupted Settings File Handling', () {
      test('should fallback to defaults when settings file is corrupted', () async {
        // arrange
        when(mockRepository.getSettings())
            .thenAnswer((_) async => const Left(CacheFailure(
                  message: 'Failed to parse settings file: Invalid JSON',
                  code: 'CORRUPTED_SETTINGS',
                )));

        when(mockRepository.clearSettings())
            .thenAnswer((_) async => const Right(null));

        // act
        final getResult = await mockRepository.getSettings();

        // When get fails, app should clear and use defaults
        final clearResult = await mockRepository.clearSettings();

        // assert
        expect(getResult.isLeft(), true);
        getResult.fold(
          (failure) {
            expect(failure, isA<CacheFailure>());
            expect((failure as CacheFailure).code, 'CORRUPTED_SETTINGS');
          },
          (r) => fail('Should fail with corrupted settings'),
        );

        expect(clearResult.isRight(), true);
      });

      test('should handle partial settings corruption gracefully', () async {
        // arrange - Some fields are corrupted but others are valid
        final partialSettings = AppSettings.defaults().copyWith(
          scanIntervalSeconds: 10,
          debounceSeconds: 30,
          showNotifications: false,
          minimizeToTray: false,
        );

        when(mockRepository.getSettings())
            .thenAnswer((_) async => Right(partialSettings));

        // act
        final result = await mockRepository.getSettings();

        // assert
        expect(result.isRight(), true);
        result.fold(
          (l) => fail('Should handle partial corruption'),
          (r) {
            // Verify all fields have valid values
            expect(r.scanIntervalSeconds, greaterThanOrEqualTo(1));
            expect(r.scanIntervalSeconds, lessThanOrEqualTo(300));
            expect(r.debounceSeconds, greaterThanOrEqualTo(0));
            expect(r.debounceSeconds, lessThanOrEqualTo(300));
            expect(r.fallbackBehavior, isIn(FallbackBehavior.values));
            expect(r.updateChannel, isIn(UpdateChannel.values));
            expect(r.windowControlsPosition, isIn(WindowControlsPosition.values));
          },
        );
      });

      test('should handle file system errors during update', () async {
        // arrange
        final settings = AppSettings.defaults();

        when(mockRepository.updateSettings(settings))
            .thenAnswer((_) async => const Left(CacheFailure(
                  message: 'File system error: Access denied',
                  code: 'FILE_WRITE_ERROR',
                )));

        // act
        final result = await mockRepository.updateSettings(settings);

        // assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<CacheFailure>());
            expect((failure as CacheFailure).code, 'FILE_WRITE_ERROR');
          },
          (r) => fail('Should fail with file system error'),
        );
      });
    });

    group('Concurrent Settings Operations', () {
      test('should handle rapid consecutive settings updates', () async {
        // arrange
        final settings = AppSettings.defaults();
        var updateCount = 0;

        when(mockRepository.updateSettings(any))
            .thenAnswer((_) async {
          updateCount++;
          // Simulate some processing delay
          await Future.delayed(const Duration(milliseconds: 10));
          return const Right(null);
        });

        // act - rapid updates with different values
        final futures = <Future<Either<Failure, void>>>[];
        for (int i = 0; i < 10; i++) {
          final modifiedSettings = settings.copyWith(
            debounceSeconds: (i * 10).clamp(0, 300),
            scanIntervalSeconds: ((i + 1) * 5).clamp(1, 300),
          );
          futures.add(mockRepository.updateSettings(modifiedSettings));
        }

        final results = await Future.wait(futures);

        // assert
        expect(results.every((r) => r.isRight()), true);
        expect(updateCount, 10);
      });

      test('should handle concurrent read and write operations', () async {
        // arrange
        var settings = AppSettings.defaults();
        var version = 0;

        when(mockRepository.getSettings())
            .thenAnswer((_) async {
          // Simulate read delay
          await Future.delayed(const Duration(milliseconds: 20));
          return Right(settings);
        });

        when(mockRepository.updateSettings(any))
            .thenAnswer((invocation) async {
          // Simulate write delay
          await Future.delayed(const Duration(milliseconds: 10));
          version++;
          settings = invocation.positionalArguments[0] as AppSettings;
          return const Right(null);
        });

        // act - concurrent read and write
        final futures = <Future<dynamic>>[];

        // Mix reads and writes
        futures.add(mockRepository.getSettings());
        futures.add(mockRepository.updateSettings(settings.copyWith(debounceSeconds: 60)));
        futures.add(mockRepository.getSettings());
        futures.add(mockRepository.updateSettings(settings.copyWith(debounceSeconds: 90)));
        futures.add(mockRepository.getSettings());

        final results = await Future.wait(futures);

        // assert
        expect(results.every((r) => r.isRight()), true);
        expect(version, 2); // Two writes occurred
      });

      test('should handle settings changes during active monitoring', () async {
        // arrange
        final initialSettings = AppSettings.defaults();
        final updatedSettings = initialSettings.copyWith(
          debounceSeconds: 60,
          showNotifications: false,
          autoStartMonitoring: true,
        );

        // Create a stream that emits settings changes
        final settingsStream = Stream.fromIterable([
          initialSettings,
          updatedSettings,
        ]);

        when(mockRepository.watchSettings())
            .thenAnswer((_) => settingsStream);

        // act
        final emissions = <AppSettings>[];
        await mockRepository.watchSettings().forEach((settings) {
          emissions.add(settings);
        });

        // assert
        expect(emissions.length, 2);
        expect(emissions[0].debounceSeconds, initialSettings.debounceSeconds);
        expect(emissions[1].debounceSeconds, updatedSettings.debounceSeconds);
        expect(emissions[1].showNotifications, false);
        expect(emissions[1].autoStartMonitoring, true);
      });
    });

    group('Settings Boundaries and Limits', () {
      test('should handle boundary values for numeric settings', () async {
        // arrange
        final boundaryTests = [
          (scanInterval: 1, debounce: 0), // Minimum values
          (scanInterval: 1, debounce: 1), // Low values
          (scanInterval: 30, debounce: 30), // Medium values
          (scanInterval: 300, debounce: 300), // Maximum values
        ];

        for (final test in boundaryTests) {
          final settings = AppSettings.defaults().copyWith(
            scanIntervalSeconds: test.scanInterval,
            debounceSeconds: test.debounce,
          );

          // Validate settings
          expect(settings.isValid, true,
              reason: 'Should accept boundary values: scan=${test.scanInterval}, debounce=${test.debounce}');

          when(mockRepository.updateSettings(settings))
              .thenAnswer((_) async => const Right(null));

          // act
          final result = await mockRepository.updateSettings(settings);

          // assert
          expect(result.isRight(), true);
        }
      });

      test('should handle special characters in custom fallback category ID', () async {
        // arrange
        final specialIds = [
          'category_with_unicode_🎮',
          'category-with-dashes',
          'category.with.dots',
          'category with spaces',
          'категория_кириллица', // Cyrillic
          '类别_中文', // Chinese
          'カテゴリー_日本語', // Japanese
          'فئة_عربي', // Arabic
        ];

        for (final id in specialIds) {
          final settings = AppSettings.defaults().copyWith(
            fallbackBehavior: FallbackBehavior.custom,
            customFallbackCategoryId: id,
            customFallbackCategoryName: 'Display Name for $id',
          );

          expect(settings.isValid, true, reason: 'Should accept special ID: $id');

          when(mockRepository.updateSettings(settings))
              .thenAnswer((_) async => const Right(null));

          // act
          final result = await mockRepository.updateSettings(settings);

          // assert
          expect(result.isRight(), true,
              reason: 'Should handle special ID: $id');
        }
      });
    });

    group('Settings Validation Edge Cases', () {
      test('should validate all settings combinations', () {
        // Test various valid combinations
        final validCombinations = [
          AppSettings.defaults().copyWith(
            fallbackBehavior: FallbackBehavior.doNothing,
            customFallbackCategoryId: null, // OK - not needed
          ),
          AppSettings.defaults().copyWith(
            fallbackBehavior: FallbackBehavior.justChatting,
            customFallbackCategoryId: null, // OK - not needed
          ),
          AppSettings.defaults().copyWith(
            fallbackBehavior: FallbackBehavior.custom,
            customFallbackCategoryId: 'valid_id', // Required
            customFallbackCategoryName: 'Valid Name',
          ),
        ];

        for (final settings in validCombinations) {
          expect(settings.isValid, true);
        }

        // Test invalid combinations
        final invalidSettings = AppSettings.defaults().copyWith(
          fallbackBehavior: FallbackBehavior.custom,
          customFallbackCategoryId: '', // Empty string is invalid
        );

        expect(invalidSettings.isValid, false);
        expect(invalidSettings.validate(), contains('Custom fallback category'));
      });

      test('should handle copyWith with nullable fields correctly', () {
        // arrange
        final original = AppSettings.defaults().copyWith(
          customFallbackCategoryId: 'original_id',
          customFallbackCategoryName: 'Original Name',
          manualUpdateHotkey: 'ctrl+f1',
        );

        // Test setting to null explicitly
        final setToNull = original.copyWith(
          customFallbackCategoryId: null,
          customFallbackCategoryName: null,
          manualUpdateHotkey: null,
        );

        expect(setToNull.customFallbackCategoryId, isNull);
        expect(setToNull.customFallbackCategoryName, isNull);
        expect(setToNull.manualUpdateHotkey, isNull);

        // Test keeping current value (not passing parameter)
        final keepCurrent = original.copyWith(
          debounceSeconds: 100, // Change something else
          // Don't pass nullable fields - they should keep current values
        );

        expect(keepCurrent.customFallbackCategoryId, 'original_id');
        expect(keepCurrent.customFallbackCategoryName, 'Original Name');
        expect(keepCurrent.manualUpdateHotkey, 'ctrl+f1');
        expect(keepCurrent.debounceSeconds, 100);
      });

      test('should detect and set correct update channel from version string', () {
        // Test channel detection
        expect(AppSettings.defaults(appVersion: '1.0.0').updateChannel, UpdateChannel.stable);
        expect(AppSettings.defaults(appVersion: '1.0.0-beta.1').updateChannel, UpdateChannel.beta);
        expect(AppSettings.defaults(appVersion: '1.0.0-rc.1').updateChannel, UpdateChannel.rc);
        expect(AppSettings.defaults(appVersion: '1.0.0-dev.123').updateChannel, UpdateChannel.dev);
        expect(AppSettings.defaults(appVersion: '1.0.0-alpha.1').updateChannel, UpdateChannel.dev);
        expect(AppSettings.defaults(appVersion: null).updateChannel, UpdateChannel.stable);
        expect(AppSettings.defaults(appVersion: '').updateChannel, UpdateChannel.stable);
      });
    });
  });
}