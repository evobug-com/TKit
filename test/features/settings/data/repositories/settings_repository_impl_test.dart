import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tkit/core/errors/exceptions.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/core/utils/app_logger.dart';
import 'package:tkit/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:tkit/features/settings/data/models/app_settings_model.dart';
import 'package:tkit/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:tkit/features/settings/domain/entities/app_settings.dart';
import 'package:tkit/features/settings/domain/entities/fallback_behavior.dart';

@GenerateNiceMocks([MockSpec<SettingsLocalDataSource>(), MockSpec<AppLogger>()])
import 'settings_repository_impl_test.mocks.dart';

void main() {
  late SettingsRepositoryImpl repository;
  late MockSettingsLocalDataSource mockDataSource;
  late MockAppLogger mockLogger;

  setUp(() {
    mockDataSource = MockSettingsLocalDataSource();
    mockLogger = MockAppLogger();
    repository = SettingsRepositoryImpl(mockDataSource, mockLogger);
  });

  group('getSettings', () {
    test('should return settings from data source', () async {
      // Arrange
      final settingsModel = AppSettingsModel.defaults();
      when(mockDataSource.getSettings()).thenAnswer((_) async => settingsModel);

      // Act
      final result = await repository.getSettings();

      // Assert
      expect(result.isRight(), true);
      result.fold((_) => fail('Should be Right'), (settings) {
        expect(settings, isA<AppSettings>());
        expect(settings.scanIntervalSeconds, 5);
        expect(settings.debounceSeconds, 10);
      });
      verify(mockDataSource.getSettings()).called(1);
    });

    test(
      'should return CacheFailure when data source throws CacheException',
      () async {
        // Arrange
        when(
          mockDataSource.getSettings(),
        ).thenThrow(const CacheException(message: 'Failed to load'));

        // Act
        final result = await repository.getSettings();

        // Assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<CacheFailure>());
          expect(failure.message, 'Failed to load');
        }, (_) => fail('Should be Left'));
      },
    );

    test(
      'should return UnknownFailure when data source throws unexpected error',
      () async {
        // Arrange
        when(mockDataSource.getSettings()).thenThrow(Exception('Unexpected'));

        // Act
        final result = await repository.getSettings();

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<UnknownFailure>()),
          (_) => fail('Should be Left'),
        );
      },
    );
  });

  group('updateSettings', () {
    test('should update settings when valid', () async {
      // Arrange
      final settings = AppSettings.defaults();
      when(mockDataSource.saveSettings(any)).thenAnswer((_) async => {});

      // Act
      final result = await repository.updateSettings(settings);

      // Assert
      expect(result.isRight(), true);
      verify(mockDataSource.saveSettings(any)).called(1);
    });

    test('should return ValidationFailure for invalid settings', () async {
      // Arrange
      final settings = AppSettings.defaults().copyWith(scanIntervalSeconds: 0);

      // Act
      final result = await repository.updateSettings(settings);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, contains('Scan interval'));
      }, (_) => fail('Should be Left'));
      verifyNever(mockDataSource.saveSettings(any));
    });

    test(
      'should return ValidationFailure for custom fallback without category',
      () async {
        // Arrange
        final settings = AppSettings.defaults().copyWith(
          fallbackBehavior: FallbackBehavior.custom,
        );

        // Act
        final result = await repository.updateSettings(settings);

        // Assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, contains('Custom fallback category'));
        }, (_) => fail('Should be Left'));
        verifyNever(mockDataSource.saveSettings(any));
      },
    );

    test(
      'should return CacheFailure when data source throws CacheException',
      () async {
        // Arrange
        final settings = AppSettings.defaults();
        when(
          mockDataSource.saveSettings(any),
        ).thenThrow(const CacheException(message: 'Failed to save'));

        // Act
        final result = await repository.updateSettings(settings);

        // Assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<CacheFailure>());
          expect(failure.message, 'Failed to save');
        }, (_) => fail('Should be Left'));
      },
    );

    test(
      'should return UnknownFailure when data source throws unexpected error',
      () async {
        // Arrange
        final settings = AppSettings.defaults();
        when(
          mockDataSource.saveSettings(any),
        ).thenThrow(Exception('Unexpected'));

        // Act
        final result = await repository.updateSettings(settings);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<UnknownFailure>()),
          (_) => fail('Should be Left'),
        );
      },
    );
  });

  group('watchSettings', () {
    test('should return stream from data source', () async {
      // Arrange
      final settings1 = AppSettingsModel.defaults();
      final settings2 = AppSettingsModel.fromEntity(
        settings1.toEntity().copyWith(scanIntervalSeconds: 20),
      );
      final stream = Stream.fromIterable([settings1, settings2]);

      when(mockDataSource.watchSettings()).thenAnswer((_) => stream);

      // Act
      final result = repository.watchSettings();

      // Assert
      await expectLater(
        result,
        emitsInOrder([
          predicate<AppSettings>((s) => s.scanIntervalSeconds == 5),
          predicate<AppSettings>((s) => s.scanIntervalSeconds == 20),
        ]),
      );
      verify(mockDataSource.watchSettings()).called(1);
    });

    test('should return default settings stream on error', () async {
      // Arrange
      when(mockDataSource.watchSettings()).thenThrow(Exception('Error'));

      // Act
      final result = repository.watchSettings();

      // Assert
      await expectLater(
        result.first,
        completion(
          predicate<AppSettings>(
            (s) => s.scanIntervalSeconds == 5 && s.debounceSeconds == 10,
          ),
        ),
      );
    });
  });
}
