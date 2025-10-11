import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/process_detection/domain/entities/process_info.dart';
import 'package:tkit/features/process_detection/domain/repositories/i_process_detection_repository.dart';
import 'package:tkit/features/process_detection/domain/usecases/get_focused_process_usecase.dart';

import 'get_focused_process_usecase_test.mocks.dart';

@GenerateMocks([IProcessDetectionRepository])
void main() {
  late GetFocusedProcessUseCase useCase;
  late MockIProcessDetectionRepository mockRepository;

  setUp(() {
    mockRepository = MockIProcessDetectionRepository();
    useCase = GetFocusedProcessUseCase(mockRepository);
  });

  group('GetFocusedProcessUseCase', () {
    const tProcessInfo = ProcessInfo(
      processName: 'notepad.exe',
      pid: 12345,
      windowTitle: 'Untitled - Notepad',
      executablePath: 'C:\\Windows\\System32\\notepad.exe',
    );

    test('should get focused process from the repository', () async {
      // arrange
      when(
        mockRepository.getFocusedProcess(),
      ).thenAnswer((_) async => const Right(tProcessInfo));

      // act
      final result = await useCase();

      // assert
      expect(result, const Right(tProcessInfo));
      verify(mockRepository.getFocusedProcess());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return null when no process is focused', () async {
      // arrange
      when(
        mockRepository.getFocusedProcess(),
      ).thenAnswer((_) async => const Right(null));

      // act
      final result = await useCase();

      // assert
      expect(result, const Right(null));
      verify(mockRepository.getFocusedProcess());
      verifyNoMoreInteractions(mockRepository);
    });

    test(
      'should return PlatformFailure when platform exception occurs',
      () async {
        // arrange
        const tFailure = PlatformFailure(
          message: 'Failed to detect process',
          code: 'PLATFORM_ERROR',
        );
        when(
          mockRepository.getFocusedProcess(),
        ).thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await useCase();

        // assert
        expect(result, const Left(tFailure));
        verify(mockRepository.getFocusedProcess());
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('should return UnknownFailure when unexpected error occurs', () async {
      // arrange
      const tFailure = UnknownFailure(message: 'Unexpected error');
      when(
        mockRepository.getFocusedProcess(),
      ).thenAnswer((_) async => const Left(tFailure));

      // act
      final result = await useCase();

      // assert
      expect(result, const Left(tFailure));
      verify(mockRepository.getFocusedProcess());
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
