import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tkit/features/process_detection/domain/entities/process_info.dart';
import 'package:tkit/features/process_detection/domain/repositories/i_process_detection_repository.dart';
import 'package:tkit/features/process_detection/domain/usecases/watch_process_changes_usecase.dart';

import 'watch_process_changes_usecase_test.mocks.dart';

@GenerateMocks([IProcessDetectionRepository])
void main() {
  late WatchProcessChangesUseCase useCase;
  late MockIProcessDetectionRepository mockRepository;

  setUp(() {
    mockRepository = MockIProcessDetectionRepository();
    useCase = WatchProcessChangesUseCase(mockRepository);
  });

  group('WatchProcessChangesUseCase', () {
    const tProcessInfo1 = ProcessInfo(
      processName: 'notepad.exe',
      pid: 12345,
      windowTitle: 'Untitled - Notepad',
      executablePath: 'C:\\Windows\\System32\\notepad.exe',
    );

    const tProcessInfo2 = ProcessInfo(
      processName: 'chrome.exe',
      pid: 67890,
      windowTitle: 'Google Chrome',
      executablePath:
          'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe',
    );

    test('should return stream from the repository', () async {
      // arrange
      final tStream = Stream<ProcessInfo?>.fromIterable([
        tProcessInfo1,
        tProcessInfo2,
      ]);
      when(mockRepository.watchProcessChanges(any)).thenAnswer((_) => tStream);

      // act
      final result = useCase(const Duration(seconds: 5));

      // assert
      expect(result, tStream);
      verify(mockRepository.watchProcessChanges(const Duration(seconds: 5)));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should emit process changes from stream', () async {
      // arrange
      final tStream = Stream<ProcessInfo?>.fromIterable([
        tProcessInfo1,
        tProcessInfo2,
        null,
      ]);
      when(mockRepository.watchProcessChanges(any)).thenAnswer((_) => tStream);

      // act
      final result = useCase(const Duration(seconds: 3));

      // assert
      expect(result, emitsInOrder([tProcessInfo1, tProcessInfo2, null]));
      verify(mockRepository.watchProcessChanges(const Duration(seconds: 3)));
    });

    test('should pass correct scan interval to repository', () async {
      // arrange
      final tStream = Stream<ProcessInfo?>.fromIterable([]);
      when(mockRepository.watchProcessChanges(any)).thenAnswer((_) => tStream);

      // act
      const tScanInterval = Duration(seconds: 10);
      useCase(tScanInterval);

      // assert
      verify(mockRepository.watchProcessChanges(tScanInterval));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle empty stream', () async {
      // arrange
      final tStream = Stream<ProcessInfo?>.fromIterable([]);
      when(mockRepository.watchProcessChanges(any)).thenAnswer((_) => tStream);

      // act
      final result = useCase(const Duration(seconds: 5));

      // assert
      expect(result, emitsDone);
      verify(mockRepository.watchProcessChanges(const Duration(seconds: 5)));
    });
  });
}
