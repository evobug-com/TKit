import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tkit/core/errors/exceptions.dart';
import 'package:tkit/core/platform/windows_platform_channel.dart';
import 'package:tkit/core/utils/app_logger.dart';
import 'package:tkit/features/process_detection/data/datasources/process_detection_platform_datasource.dart';

import 'process_detection_platform_datasource_test.mocks.dart';

@GenerateMocks([WindowsPlatformChannel, AppLogger])
void main() {
  late ProcessDetectionPlatformDataSource dataSource;
  late MockWindowsPlatformChannel mockPlatformChannel;
  late MockAppLogger mockLogger;

  setUp(() {
    mockPlatformChannel = MockWindowsPlatformChannel();
    mockLogger = MockAppLogger();
    dataSource = ProcessDetectionPlatformDataSource(
      mockPlatformChannel,
      mockLogger,
    );
  });

  group('ProcessDetectionPlatformDataSource', () {
    final tProcessData = {
      'processName': 'notepad.exe',
      'pid': 12345,
      'windowTitle': 'Untitled - Notepad',
      'executablePath': 'C:\\Windows\\System32\\notepad.exe',
    };

    group('getFocusedProcess', () {
      test(
        'should return ProcessInfoModel when platform returns valid data',
        () async {
          // arrange
          when(
            mockPlatformChannel.getFocusedProcess(),
          ).thenAnswer((_) async => tProcessData);

          // act
          final result = await dataSource.getFocusedProcess();

          // assert
          expect(result, isNotNull);
          expect(result!.processName, 'notepad.exe');
          expect(result.pid, 12345);
          expect(result.windowTitle, 'Untitled - Notepad');
          expect(result.executablePath, 'C:\\Windows\\System32\\notepad.exe');
          verify(mockPlatformChannel.getFocusedProcess());
        },
      );

      test('should return null when platform returns null', () async {
        // arrange
        when(
          mockPlatformChannel.getFocusedProcess(),
        ).thenAnswer((_) async => null);

        // act
        final result = await dataSource.getFocusedProcess();

        // assert
        expect(result, isNull);
        verify(mockPlatformChannel.getFocusedProcess());
      });

      test(
        'should throw PlatformException when platform channel throws PlatformException',
        () async {
          // arrange
          when(mockPlatformChannel.getFocusedProcess()).thenThrow(
            PlatformException(
              message: 'Platform error',
              code: 'PLATFORM_ERROR',
            ),
          );

          // act & assert
          expect(
            () => dataSource.getFocusedProcess(),
            throwsA(isA<PlatformException>()),
          );
          verify(mockPlatformChannel.getFocusedProcess());
        },
      );

      test(
        'should throw PlatformException when unexpected error occurs',
        () async {
          // arrange
          when(
            mockPlatformChannel.getFocusedProcess(),
          ).thenThrow(Exception('Unexpected error'));

          // act & assert
          expect(
            () => dataSource.getFocusedProcess(),
            throwsA(isA<PlatformException>()),
          );
          verify(mockPlatformChannel.getFocusedProcess());
        },
      );

      test('should handle process with null executable path', () async {
        // arrange
        final processDataWithoutPath = {
          'processName': 'notepad.exe',
          'pid': 12345,
          'windowTitle': 'Untitled - Notepad',
          'executablePath': null,
        };
        when(
          mockPlatformChannel.getFocusedProcess(),
        ).thenAnswer((_) async => processDataWithoutPath);

        // act
        final result = await dataSource.getFocusedProcess();

        // assert
        expect(result, isNotNull);
        expect(result!.processName, 'notepad.exe');
        expect(result.executablePath, isNull);
        verify(mockPlatformChannel.getFocusedProcess());
      });
    });

    group('isAvailable', () {
      test('should return true when platform is available', () async {
        // arrange
        when(mockPlatformChannel.isAvailable()).thenAnswer((_) async => true);

        // act
        final result = await dataSource.isAvailable();

        // assert
        expect(result, true);
        verify(mockPlatformChannel.isAvailable());
      });

      test('should return false when platform is not available', () async {
        // arrange
        when(mockPlatformChannel.isAvailable()).thenAnswer((_) async => false);

        // act
        final result = await dataSource.isAvailable();

        // assert
        expect(result, false);
        verify(mockPlatformChannel.isAvailable());
      });

      test(
        'should return false when platform check throws exception',
        () async {
          // arrange
          when(
            mockPlatformChannel.isAvailable(),
          ).thenThrow(Exception('Platform error'));

          // act
          final result = await dataSource.isAvailable();

          // assert
          expect(result, false);
          verify(mockPlatformChannel.isAvailable());
        },
      );
    });
  });
}
