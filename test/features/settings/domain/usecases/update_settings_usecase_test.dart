import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/settings/domain/entities/app_settings.dart';
import 'package:tkit/features/settings/domain/entities/fallback_behavior.dart';
import 'package:tkit/features/settings/domain/repositories/i_settings_repository.dart';
import 'package:tkit/features/settings/domain/usecases/update_settings_usecase.dart';

@GenerateNiceMocks([MockSpec<ISettingsRepository>()])
import 'update_settings_usecase_test.mocks.dart';

void main() {
  late UpdateSettingsUseCase useCase;
  late MockISettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockISettingsRepository();
    useCase = UpdateSettingsUseCase(mockRepository);
  });

  group('UpdateSettingsUseCase', () {
    test('should update settings when valid', () async {
      // Arrange
      final settings = AppSettings.defaults();
      when(
        mockRepository.updateSettings(any),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(settings);

      // Assert
      expect(result, const Right(null));
      verify(mockRepository.updateSettings(settings)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ValidationFailure for invalid scan interval', () async {
      // Arrange
      final settings = AppSettings.defaults().copyWith(scanIntervalSeconds: 0);

      // Act
      final result = await useCase(settings);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ValidationFailure>()),
        (_) => fail('Should have failed'),
      );
      verifyNever(mockRepository.updateSettings(any));
    });

    test('should return ValidationFailure for invalid debounce', () async {
      // Arrange
      final settings = AppSettings.defaults().copyWith(debounceSeconds: -1);

      // Act
      final result = await useCase(settings);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ValidationFailure>()),
        (_) => fail('Should have failed'),
      );
      verifyNever(mockRepository.updateSettings(any));
    });

    test(
      'should return ValidationFailure for custom fallback without category',
      () async {
        // Arrange
        final settings = AppSettings.defaults().copyWith(
          fallbackBehavior: FallbackBehavior.custom,
        );

        // Act
        final result = await useCase(settings);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<ValidationFailure>()),
          (_) => fail('Should have failed'),
        );
        verifyNever(mockRepository.updateSettings(any));
      },
    );

    test('should update when custom fallback has category', () async {
      // Arrange
      final settings = AppSettings.defaults().copyWith(
        fallbackBehavior: FallbackBehavior.custom,
        customFallbackCategoryId: '12345',
      );
      when(
        mockRepository.updateSettings(any),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(settings);

      // Assert
      expect(result, const Right(null));
      verify(mockRepository.updateSettings(settings)).called(1);
    });

    test('should return failure when repository fails', () async {
      // Arrange
      final settings = AppSettings.defaults();
      const failure = CacheFailure(message: 'Failed to save settings');
      when(
        mockRepository.updateSettings(any),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(settings);

      // Assert
      expect(result, const Left(failure));
      verify(mockRepository.updateSettings(settings)).called(1);
    });
  });
}
