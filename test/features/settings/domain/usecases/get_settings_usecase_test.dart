import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/settings/domain/entities/app_settings.dart';
import 'package:tkit/features/settings/domain/repositories/i_settings_repository.dart';
import 'package:tkit/features/settings/domain/usecases/get_settings_usecase.dart';

@GenerateNiceMocks([MockSpec<ISettingsRepository>()])
import 'get_settings_usecase_test.mocks.dart';

void main() {
  late GetSettingsUseCase useCase;
  late MockISettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockISettingsRepository();
    useCase = GetSettingsUseCase(mockRepository);
  });

  group('GetSettingsUseCase', () {
    test('should get settings from repository', () async {
      // Arrange
      final settings = AppSettings.defaults();
      when(
        mockRepository.getSettings(),
      ).thenAnswer((_) async => Right(settings));

      // Act
      final result = await useCase();

      // Assert
      expect(result, Right(settings));
      verify(mockRepository.getSettings()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when repository fails', () async {
      // Arrange
      const failure = CacheFailure(message: 'Failed to load settings');
      when(
        mockRepository.getSettings(),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Left(failure));
      verify(mockRepository.getSettings()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
