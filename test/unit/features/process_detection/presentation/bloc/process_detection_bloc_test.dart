import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/core/utils/app_logger.dart';
import 'package:tkit/features/process_detection/domain/entities/process_info.dart';
import 'package:tkit/features/process_detection/domain/usecases/get_focused_process_usecase.dart';
import 'package:tkit/features/process_detection/domain/usecases/watch_process_changes_usecase.dart';
import 'package:tkit/features/process_detection/presentation/providers/process_detection_provider.dart';
import 'package:tkit/features/process_detection/presentation/states/process_detection_state.dart';

import 'process_detection_bloc_test.mocks.dart';

@GenerateMocks([
  GetFocusedProcessUseCase,
  WatchProcessChangesUseCase,
  AppLogger,
])
void main() {
  late ProcessDetectionProvider provider;
  late MockGetFocusedProcessUseCase mockGetFocusedProcessUseCase;
  late MockWatchProcessChangesUseCase mockWatchProcessChangesUseCase;
  late MockAppLogger mockLogger;

  setUp(() {
    mockGetFocusedProcessUseCase = MockGetFocusedProcessUseCase();
    mockWatchProcessChangesUseCase = MockWatchProcessChangesUseCase();
    mockLogger = MockAppLogger();
    provider = ProcessDetectionProvider(
      mockGetFocusedProcessUseCase,
      mockWatchProcessChangesUseCase,
      mockLogger,
    );
  });

  tearDown(() {
    provider.dispose();
  });

  group('ProcessDetectionProvider', () {
    const tProcessInfo = ProcessInfo(
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

    const tScanInterval = Duration(seconds: 5);

    test('initial state should be ProcessDetectionInitial', () {
      expect(provider.state, const ProcessDetectionInitial());
    });

    group('start', () {
      test('should emit ProcessDetectionRunning and ProcessDetected when process is detected',
          () async {
        // Arrange
        when(
          mockGetFocusedProcessUseCase(),
        ).thenAnswer((_) async => const Right(tProcessInfo));
        when(mockWatchProcessChangesUseCase(any)).thenAnswer(
          (_) => Stream<ProcessInfo?>.fromIterable([tProcessInfo]),
        );

        final states = <ProcessDetectionState>[];
        provider.addListener(() {
          states.add(provider.state);
        });

        // Act
        await provider.start(tScanInterval);
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(states.length, greaterThanOrEqualTo(2));
        expect(states[0], const ProcessDetectionRunning(tScanInterval));
        expect(states[1], isA<ProcessDetected>());
        expect((states[1] as ProcessDetected).processInfo, tProcessInfo);

        verify(mockGetFocusedProcessUseCase());
        verify(mockWatchProcessChangesUseCase(tScanInterval));
      });

      test('should emit ProcessDetectionRunning and ProcessDetectionError when detection fails',
          () async {
        // Arrange
        when(mockGetFocusedProcessUseCase()).thenAnswer(
          (_) async => const Left(PlatformFailure(message: 'Platform error')),
        );
        when(
          mockWatchProcessChangesUseCase(any),
        ).thenAnswer((_) => Stream<ProcessInfo?>.fromIterable([]));

        final states = <ProcessDetectionState>[];
        provider.addListener(() {
          states.add(provider.state);
        });

        // Act
        await provider.start(tScanInterval);

        // Assert
        expect(states.length, 2);
        expect(states[0], const ProcessDetectionRunning(tScanInterval));
        expect(states[1], const ProcessDetectionError('Platform error'));

        verify(mockGetFocusedProcessUseCase());
        verify(mockWatchProcessChangesUseCase(tScanInterval));
      });

      test('should emit ProcessDetected with null when no process is focused',
          () async {
        // Arrange
        when(
          mockGetFocusedProcessUseCase(),
        ).thenAnswer((_) async => const Right(null));
        when(
          mockWatchProcessChangesUseCase(any),
        ).thenAnswer((_) => Stream<ProcessInfo?>.fromIterable([]));

        final states = <ProcessDetectionState>[];
        provider.addListener(() {
          states.add(provider.state);
        });

        // Act
        await provider.start(tScanInterval);

        // Assert
        expect(states.length, 2);
        expect(states[0], const ProcessDetectionRunning(tScanInterval));
        expect(states[1], isA<ProcessDetected>());
        expect((states[1] as ProcessDetected).processInfo, null);

        verify(mockGetFocusedProcessUseCase());
        verify(mockWatchProcessChangesUseCase(tScanInterval));
      });
    });

    group('stop', () {
      test('should emit ProcessDetectionStopped when stop is requested',
          () async {
        // Arrange
        final states = <ProcessDetectionState>[];
        provider.addListener(() {
          states.add(provider.state);
        });

        // Act
        await provider.stop();

        // Assert
        expect(states.length, 1);
        expect(states[0], const ProcessDetectionStopped());
      });

      test('should cancel stream subscription when stopped', () async {
        // Arrange
        when(
          mockGetFocusedProcessUseCase(),
        ).thenAnswer((_) async => const Right(tProcessInfo));
        when(mockWatchProcessChangesUseCase(any)).thenAnswer(
          (_) => Stream<ProcessInfo?>.fromIterable([
            tProcessInfo,
            tProcessInfo2,
          ]),
        );

        final states = <ProcessDetectionState>[];
        provider.addListener(() {
          states.add(provider.state);
        });

        // Act
        await provider.start(tScanInterval);
        await provider.stop();

        // Assert
        expect(states.last, const ProcessDetectionStopped());
      });
    });

    group('detectProcess', () {
      test('should emit ProcessDetected when manual detection is requested',
          () async {
        // Arrange
        when(
          mockGetFocusedProcessUseCase(),
        ).thenAnswer((_) async => const Right(tProcessInfo));

        final states = <ProcessDetectionState>[];
        provider.addListener(() {
          states.add(provider.state);
        });

        // Act
        await provider.detectProcess();

        // Assert
        expect(states.length, 1);
        expect(states[0], isA<ProcessDetected>());
        expect((states[0] as ProcessDetected).processInfo, tProcessInfo);

        verify(mockGetFocusedProcessUseCase());
      });

      test('should emit ProcessDetectionError when manual detection fails',
          () async {
        // Arrange
        when(mockGetFocusedProcessUseCase()).thenAnswer(
          (_) async =>
              const Left(PlatformFailure(message: 'Detection failed')),
        );

        final states = <ProcessDetectionState>[];
        provider.addListener(() {
          states.add(provider.state);
        });

        // Act
        await provider.detectProcess();

        // Assert
        expect(states.length, 1);
        expect(states[0], const ProcessDetectionError('Detection failed'));

        verify(mockGetFocusedProcessUseCase());
      });

      test('should emit ProcessDetected with null when no process found',
          () async {
        // Arrange
        when(
          mockGetFocusedProcessUseCase(),
        ).thenAnswer((_) async => const Right(null));

        final states = <ProcessDetectionState>[];
        provider.addListener(() {
          states.add(provider.state);
        });

        // Act
        await provider.detectProcess();

        // Assert
        expect(states.length, 1);
        expect(states[0], isA<ProcessDetected>());
        expect((states[0] as ProcessDetected).processInfo, null);

        verify(mockGetFocusedProcessUseCase());
      });
    });

    group('Error handling', () {
      test('should handle UnknownFailure', () async {
        // Arrange
        when(mockGetFocusedProcessUseCase()).thenAnswer(
          (_) async => const Left(UnknownFailure(message: 'Unknown error')),
        );

        final states = <ProcessDetectionState>[];
        provider.addListener(() {
          states.add(provider.state);
        });

        // Act
        await provider.detectProcess();

        // Assert
        expect(states.length, 1);
        expect(states[0], const ProcessDetectionError('Unknown error'));
      });

      test('should handle CacheFailure', () async {
        // Arrange
        when(mockGetFocusedProcessUseCase()).thenAnswer(
          (_) async => const Left(CacheFailure(message: 'Cache error')),
        );

        final states = <ProcessDetectionState>[];
        provider.addListener(() {
          states.add(provider.state);
        });

        // Act
        await provider.detectProcess();

        // Assert
        expect(states.length, 1);
        expect(states[0], const ProcessDetectionError('Cache error'));
      });
    });
  });
}
