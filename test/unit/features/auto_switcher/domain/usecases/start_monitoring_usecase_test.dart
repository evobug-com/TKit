import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/auto_switcher/domain/repositories/i_auto_switcher_repository.dart';
import 'package:tkit/features/auto_switcher/domain/usecases/start_monitoring_usecase.dart';

import 'start_monitoring_usecase_test.mocks.dart';

@GenerateMocks([IAutoSwitcherRepository])
void main() {
  late StartMonitoringUseCase useCase;
  late MockIAutoSwitcherRepository mockRepository;

  setUp(() {
    mockRepository = MockIAutoSwitcherRepository();
    useCase = StartMonitoringUseCase(mockRepository);
  });

  group('StartMonitoringUseCase', () {
    test('should call repository startMonitoring', () async {
      // Arrange
      when(
        mockRepository.startMonitoring(),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Right(null));
      verify(mockRepository.startMonitoring()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when repository fails', () async {
      // Arrange
      final failure = const ServerFailure(
        message: 'Failed to start',
        code: 'START_ERROR',
      );
      when(
        mockRepository.startMonitoring(),
      ).thenAnswer((_) async => Left(failure));

      // Act
      final result = await useCase();

      // Assert
      expect(result, Left(failure));
      verify(mockRepository.startMonitoring()).called(1);
    });
  });
}
