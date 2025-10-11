import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tkit/core/errors/exceptions.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/core/utils/app_logger.dart';
import 'package:tkit/features/process_detection/data/datasources/process_detection_platform_datasource.dart';
import 'package:tkit/features/process_detection/data/models/process_info_model.dart';
import 'package:tkit/features/process_detection/data/repositories/process_detection_repository_impl.dart';

import 'process_detection_repository_impl_test.mocks.dart';

@GenerateMocks([ProcessDetectionPlatformDataSource, AppLogger])
void main() {
  late ProcessDetectionRepositoryImpl repository;
  late MockProcessDetectionPlatformDataSource mockDataSource;
  late MockAppLogger mockLogger;

  setUp(() {
    mockDataSource = MockProcessDetectionPlatformDataSource();
    mockLogger = MockAppLogger();
    repository = ProcessDetectionRepositoryImpl(mockDataSource, mockLogger);
  });

  group('ProcessDetectionRepositoryImpl', () {
    const tProcessInfoModel = ProcessInfoModel(
      processName: 'notepad.exe',
      pid: 12345,
      windowTitle: 'Untitled - Notepad',
      executablePath: 'C:\\Windows\\System32\\notepad.exe',
    );

    group('getFocusedProcess', () {
      test(
        'should return ProcessInfo when data source returns valid data',
        () async {
          // arrange
          when(
            mockDataSource.getFocusedProcess(),
          ).thenAnswer((_) async => tProcessInfoModel);

          // act
          final result = await repository.getFocusedProcess();

          // assert
          expect(result, const Right(tProcessInfoModel));
          verify(mockDataSource.getFocusedProcess());
          verifyNoMoreInteractions(mockDataSource);
        },
      );

      test('should return null when data source returns null', () async {
        // arrange
        when(mockDataSource.getFocusedProcess()).thenAnswer((_) async => null);

        // act
        final result = await repository.getFocusedProcess();

        // assert
        expect(result, const Right(null));
        verify(mockDataSource.getFocusedProcess());
      });

      test(
        'should return PlatformFailure when PlatformException is thrown',
        () async {
          // arrange
          when(mockDataSource.getFocusedProcess()).thenThrow(
            PlatformException(
              message: 'Platform error',
              code: 'PLATFORM_ERROR',
            ),
          );

          // act
          final result = await repository.getFocusedProcess();

          // assert
          expect(result.isLeft(), true);
          result.fold((failure) {
            expect(failure, isA<PlatformFailure>());
            expect(failure.message, 'Platform error');
            expect(failure.code, 'PLATFORM_ERROR');
          }, (_) => fail('Should return failure'));
          verify(mockDataSource.getFocusedProcess());
        },
      );

      test(
        'should return UnknownFailure when unexpected exception is thrown',
        () async {
          // arrange
          when(
            mockDataSource.getFocusedProcess(),
          ).thenThrow(Exception('Unexpected error'));

          // act
          final result = await repository.getFocusedProcess();

          // assert
          expect(result.isLeft(), true);
          result.fold((failure) {
            expect(failure, isA<UnknownFailure>());
            expect(failure.message, 'Failed to get focused process');
          }, (_) => fail('Should return failure'));
          verify(mockDataSource.getFocusedProcess());
        },
      );
    });

    group('watchProcessChanges', () {
      const tProcessInfo2 = ProcessInfoModel(
        processName: 'chrome.exe',
        pid: 67890,
        windowTitle: 'Google Chrome',
        executablePath:
            'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe',
      );

      test('should emit process changes with deduplication', () async {
        // arrange - use thenAnswer with sequential responses
        var callCount = 0;
        when(mockDataSource.getFocusedProcess()).thenAnswer((_) async {
          callCount++;
          if (callCount == 1) return tProcessInfoModel;
          if (callCount == 2) return tProcessInfoModel; // duplicate
          if (callCount == 3) return tProcessInfo2;
          return null;
        });

        // act
        final stream = repository.watchProcessChanges(
          const Duration(milliseconds: 100),
        );

        // assert
        // Note: distinct() filters out consecutive duplicates
        // The stream will emit: tProcessInfoModel, tProcessInfo2, null
        await expectLater(
          stream.take(3),
          emitsInOrder([tProcessInfoModel, tProcessInfo2, null]),
        );
      });

      test('should emit null when data source returns null', () async {
        // arrange
        when(mockDataSource.getFocusedProcess()).thenAnswer((_) async => null);

        // act
        final stream = repository.watchProcessChanges(
          const Duration(milliseconds: 50),
        );

        // assert
        await expectLater(stream.take(1), emits(null));
      });

      test('should handle PlatformException and emit null', () async {
        // arrange
        when(mockDataSource.getFocusedProcess()).thenThrow(
          PlatformException(message: 'Platform error', code: 'PLATFORM_ERROR'),
        );

        // act
        final stream = repository.watchProcessChanges(
          const Duration(milliseconds: 50),
        );

        // assert
        // When exception occurs, the stream should emit null
        await expectLater(stream.take(1), emits(null));
      });

      test('should not emit duplicate consecutive processes', () async {
        // arrange - return same process multiple times, then different
        var callCount = 0;
        when(mockDataSource.getFocusedProcess()).thenAnswer((_) async {
          callCount++;
          // Return same process 3 times, then different
          if (callCount <= 3) return tProcessInfoModel;
          return tProcessInfo2;
        });

        // act
        final stream = repository.watchProcessChanges(
          const Duration(milliseconds: 50),
        );

        // assert - should only emit tProcessInfoModel once, then tProcessInfo2
        // distinct() filters out consecutive duplicates
        await expectLater(
          stream.take(2),
          emitsInOrder([tProcessInfoModel, tProcessInfo2]),
        );
      });
    });

    group('isAvailable', () {
      test('should return true when data source is available', () async {
        // arrange
        when(mockDataSource.isAvailable()).thenAnswer((_) async => true);

        // act
        final result = await repository.isAvailable();

        // assert
        expect(result, const Right(true));
        verify(mockDataSource.isAvailable());
      });

      test('should return false when data source is not available', () async {
        // arrange
        when(mockDataSource.isAvailable()).thenAnswer((_) async => false);

        // act
        final result = await repository.isAvailable();

        // assert
        expect(result, const Right(false));
        verify(mockDataSource.isAvailable());
      });

      test('should return PlatformFailure when exception is thrown', () async {
        // arrange
        when(
          mockDataSource.isAvailable(),
        ).thenThrow(Exception('Platform error'));

        // act
        final result = await repository.isAvailable();

        // assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<PlatformFailure>());
          expect(failure.message, 'Failed to check platform availability');
        }, (_) => fail('Should return failure'));
        verify(mockDataSource.isAvailable());
      });
    });
  });
}
