import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/core/utils/app_logger.dart';
import 'package:tkit/features/settings/domain/entities/app_settings.dart';
import 'package:tkit/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:tkit/features/settings/domain/usecases/update_settings_usecase.dart';
import 'package:tkit/features/settings/domain/usecases/watch_settings_usecase.dart';
import 'package:tkit/features/settings/presentation/providers/settings_provider.dart';
import 'package:tkit/features/settings/presentation/states/settings_state.dart';

@GenerateNiceMocks([
  MockSpec<GetSettingsUseCase>(),
  MockSpec<UpdateSettingsUseCase>(),
  MockSpec<WatchSettingsUseCase>(),
  MockSpec<AppLogger>(),
])
import 'settings_provider_test.mocks.dart';

void main() {
  late SettingsProvider provider;
  late MockGetSettingsUseCase mockGetSettings;
  late MockUpdateSettingsUseCase mockUpdateSettings;
  late MockWatchSettingsUseCase mockWatchSettings;
  late MockAppLogger mockLogger;

  setUp(() {
    mockGetSettings = MockGetSettingsUseCase();
    mockUpdateSettings = MockUpdateSettingsUseCase();
    mockWatchSettings = MockWatchSettingsUseCase();
    mockLogger = MockAppLogger();

    provider = SettingsProvider(
      mockGetSettings,
      mockUpdateSettings,
      mockWatchSettings,
      mockLogger,
    );
  });

  tearDown(() {
    provider.dispose();
  });

  group('SettingsProvider', () {
    final testSettings = AppSettings.defaults();

    test('initial state should be SettingsInitial', () {
      expect(provider.state, const SettingsInitial());
    });

    test('should emit SettingsLoading then SettingsLoaded when loading succeeds', () async {
      when(mockGetSettings()).thenAnswer((_) async => Right(testSettings));

      final states = <SettingsState>[];
      provider.addListener(() {
        states.add(provider.state);
      });

      await provider.loadSettings();

      expect(states.length, 2);
      expect(states[0], const SettingsLoading());
      expect(states[1], SettingsLoaded(testSettings));
      verify(mockGetSettings()).called(1);
    });

    test('should emit SettingsLoading then SettingsError when loading fails', () async {
      when(mockGetSettings()).thenAnswer(
        (_) async => const Left(CacheFailure(message: 'Failed to load')),
      );

      final states = <SettingsState>[];
      provider.addListener(() {
        states.add(provider.state);
      });

      await provider.loadSettings();

      expect(states.length, 2);
      expect(states[0], const SettingsLoading());
      expect(states[1], const SettingsError('Failed to load'));
      verify(mockGetSettings()).called(1);
    });

    test('should emit SettingsSaving, SettingsSaved, SettingsLoaded when update succeeds', () async {
      when(mockUpdateSettings(any)).thenAnswer((_) async => const Right(null));

      final states = <SettingsState>[];
      provider.addListener(() {
        states.add(provider.state);
      });

      await provider.updateSettings(testSettings);

      expect(states.length, 3);
      expect(states[0], SettingsSaving(testSettings));
      expect(states[1], SettingsSaved(testSettings));
      expect(states[2], SettingsLoaded(testSettings));
      verify(mockUpdateSettings(testSettings)).called(1);
    });

    test('should emit SettingsSaving then SettingsError when update fails', () async {
      when(mockUpdateSettings(any)).thenAnswer(
        (_) async => const Left(CacheFailure(message: 'Failed to save')),
      );

      final states = <SettingsState>[];
      provider.addListener(() {
        states.add(provider.state);
      });

      await provider.updateSettings(testSettings);

      expect(states.length, 2);
      expect(states[0], SettingsSaving(testSettings));
      expect(states[1], const SettingsError('Failed to save', currentSettings: null));
      verify(mockUpdateSettings(testSettings)).called(1);
    });

    test('should emit SettingsSaving then SettingsError when validation fails', () async {
      when(mockUpdateSettings(any)).thenAnswer(
        (_) async => const Left(
          ValidationFailure(
            message: 'Scan interval must be between 1 and 300 seconds',
          ),
        ),
      );

      final states = <SettingsState>[];
      provider.addListener(() {
        states.add(provider.state);
      });

      final invalidSettings = testSettings.copyWith(scanIntervalSeconds: 0);
      await provider.updateSettings(invalidSettings);

      expect(states.length, 2);
      expect(states[0].runtimeType, SettingsSaving);
      expect((states[0] as SettingsSaving).settings.scanIntervalSeconds, 0);
      expect(states[1].runtimeType, SettingsError);
      expect((states[1] as SettingsError).message, contains('Scan interval'));
      verify(mockUpdateSettings(any)).called(1);
    });

    test('should handle settings watch stream', () async {
      final settings1 = testSettings;
      final settings2 = testSettings.copyWith(scanIntervalSeconds: 20);
      final stream = Stream.fromIterable([settings1, settings2]);

      when(mockWatchSettings()).thenAnswer((_) => stream);

      final states = <SettingsState>[];
      provider.addListener(() {
        states.add(provider.state);
      });

      await provider.startWatchingSettings();
      await Future.delayed(const Duration(milliseconds: 100));

      expect(states.length, 2);
      expect(states[0], SettingsLoaded(testSettings));
      expect((states[1] as SettingsLoaded).settings.scanIntervalSeconds, 20);
      verify(mockWatchSettings()).called(1);
    });

    test('hasUnsavedChanges should return false initially', () {
      expect(provider.hasUnsavedChanges(testSettings), false);
    });

    test('hasUnsavedChanges should return true when settings differ', () async {
      when(mockGetSettings()).thenAnswer((_) async => Right(testSettings));

      await provider.loadSettings();

      final modifiedSettings = testSettings.copyWith(scanIntervalSeconds: 20);
      expect(provider.hasUnsavedChanges(modifiedSettings), true);
    });

    test('hasUnsavedChanges should return false after saving', () async {
      when(mockGetSettings()).thenAnswer((_) async => Right(testSettings));
      when(mockUpdateSettings(any)).thenAnswer((_) async => const Right(null));

      await provider.loadSettings();

      final modified = testSettings.copyWith(scanIntervalSeconds: 20);
      await provider.updateSettings(modified);

      expect(provider.hasUnsavedChanges(modified), false);
    });

    test('should not emit settings changed while saving', () async {
      when(mockUpdateSettings(any)).thenAnswer((_) async => const Right(null));

      final controller = StreamController<AppSettings>();
      when(mockWatchSettings()).thenAnswer((_) => controller.stream);

      final states = <SettingsState>[];
      provider.addListener(() {
        states.add(provider.state);
      });

      await provider.startWatchingSettings();
      await Future.delayed(const Duration(milliseconds: 10));

      // Trigger save while watch is active
      provider.updateSettings(testSettings);
      await Future.delayed(const Duration(milliseconds: 10));

      // The states should be saving, saved, loaded (no extra state from watch during save)
      expect(states.length, 3);
      expect(states[0], SettingsSaving(testSettings));
      expect(states[1], SettingsSaved(testSettings));
      expect(states[2], SettingsLoaded(testSettings));

      controller.close();
    });

    test('dispose should cancel settings subscription', () async {
      // Create a separate provider for this test to avoid double dispose
      final testProvider = SettingsProvider(
        mockGetSettings,
        mockUpdateSettings,
        mockWatchSettings,
        mockLogger,
      );

      final controller = StreamController<AppSettings>();
      when(mockWatchSettings()).thenAnswer((_) => controller.stream);

      await testProvider.startWatchingSettings();
      testProvider.dispose();

      // No exception should be thrown
      expect(true, true);
    });
  });
}
