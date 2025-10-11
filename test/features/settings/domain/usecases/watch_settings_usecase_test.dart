import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tkit/features/settings/domain/entities/app_settings.dart';
import 'package:tkit/features/settings/domain/repositories/i_settings_repository.dart';
import 'package:tkit/features/settings/domain/usecases/watch_settings_usecase.dart';

@GenerateNiceMocks([MockSpec<ISettingsRepository>()])
import 'watch_settings_usecase_test.mocks.dart';

void main() {
  late WatchSettingsUseCase useCase;
  late MockISettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockISettingsRepository();
    useCase = WatchSettingsUseCase(mockRepository);
  });

  group('WatchSettingsUseCase', () {
    test('should return stream of settings from repository', () async {
      // Arrange
      final settings1 = AppSettings.defaults();
      final settings2 = settings1.copyWith(scanIntervalSeconds: 15);
      final settingsStream = Stream.fromIterable([settings1, settings2]);

      when(mockRepository.watchSettings()).thenAnswer((_) => settingsStream);

      // Act
      final result = useCase();

      // Assert
      expect(result, emitsInOrder([settings1, settings2]));
      verify(mockRepository.watchSettings()).called(1);
    });

    test('should return empty stream when repository returns empty', () async {
      // Arrange
      when(
        mockRepository.watchSettings(),
      ).thenAnswer((_) => const Stream.empty());

      // Act
      final result = useCase();

      // Assert
      expect(result, emitsDone);
      verify(mockRepository.watchSettings()).called(1);
    });
  });
}
