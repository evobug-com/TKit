import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/process_detection/domain/entities/process_info.dart';
import 'package:tkit/features/process_detection/domain/repositories/i_process_detection_repository.dart';
import 'package:tkit/features/process_detection/domain/usecases/get_focused_process_usecase.dart';
import 'package:tkit/features/process_detection/domain/usecases/watch_process_changes_usecase.dart';

import 'process_detection_edge_cases_test.mocks.dart';

@GenerateMocks([IProcessDetectionRepository])
void main() {
  late MockIProcessDetectionRepository mockRepository;
  late GetFocusedProcessUseCase getFocusedProcessUseCase;
  late WatchProcessChangesUseCase watchProcessChangesUseCase;

  setUp(() {
    mockRepository = MockIProcessDetectionRepository();
    getFocusedProcessUseCase = GetFocusedProcessUseCase(mockRepository);
    watchProcessChangesUseCase = WatchProcessChangesUseCase(mockRepository);
  });

  group('Process Detection Edge Cases', () {
    group('Special Characters in Process Names', () {
      test('should handle process names with spaces and hyphens', () async {
        // arrange
        const processWithSpecialChars = ProcessInfo(
          processName: 'Visual Studio Code - Insiders.exe',
          pid: 12345,
          windowTitle: 'main.dart - TKit',
          executablePath: 'C:\\Program Files\\Microsoft VS Code Insiders\\Code - Insiders.exe',
        );

        when(mockRepository.getFocusedProcess())
            .thenAnswer((_) async => const Right(processWithSpecialChars));

        // act
        final result = await getFocusedProcessUseCase();

        // assert
        expect(result.isRight(), true);
        result.fold(
          (l) => fail('Should return process'),
          (r) {
            expect(r?.processName, contains('Code - Insiders'));
            expect(r?.normalizedName, 'visualstudiocodeinsiders');
          },
        );
      });

      test('should handle process names with brackets and parentheses', () async {
        // arrange
        const processWithBrackets = ProcessInfo(
          processName: 'Game [Beta] (v1.2.3).exe',
          pid: 54321,
          windowTitle: 'Game Window [Debug Mode]',
          executablePath: 'D:\\Games\\Game [Beta]\\game.exe',
        );

        when(mockRepository.getFocusedProcess())
            .thenAnswer((_) async => const Right(processWithBrackets));

        // act
        final result = await getFocusedProcessUseCase();

        // assert
        expect(result.isRight(), true);
        result.fold(
          (l) => fail('Should return process'),
          (r) {
            expect(r?.processName, contains('[Beta]'));
            expect(r?.processName, contains('(v1.2.3)'));
          },
        );
      });

      test('should handle process names with special symbols (!@#\$%^&*)', () async {
        // arrange
        const processWithSymbols = ProcessInfo(
          processName: 'app@2.0!.exe',
          pid: 99999,
          windowTitle: 'App #1 - !Important',
          executablePath: 'C:\\Special\\app@2.0!.exe',
        );

        when(mockRepository.getFocusedProcess())
            .thenAnswer((_) async => const Right(processWithSymbols));

        // act
        final result = await getFocusedProcessUseCase();

        // assert
        expect(result.isRight(), true);
        result.fold(
          (l) => fail('Should return process'),
          (r) {
            expect(r?.processName, contains('@'));
            expect(r?.processName, contains('!'));
          },
        );
      });
    });

    group('Unicode and International Characters', () {
      test('should handle process names with Japanese characters', () async {
        // arrange
        const processWithJapanese = ProcessInfo(
          processName: 'ゲーム.exe',
          pid: 11111,
          windowTitle: '日本語のウィンドウ',
          executablePath: 'C:\\Games\\日本\\ゲーム.exe',
        );

        when(mockRepository.getFocusedProcess())
            .thenAnswer((_) async => const Right(processWithJapanese));

        // act
        final result = await getFocusedProcessUseCase();

        // assert
        expect(result.isRight(), true);
        result.fold(
          (l) => fail('Should return process'),
          (r) {
            expect(r?.processName, 'ゲーム.exe');
            expect(r?.windowTitle, contains('日本語'));
          },
        );
      });

      test('should handle process names with emojis', () async {
        // arrange
        const processWithEmojis = ProcessInfo(
          processName: 'app_🚀_launcher.exe',
          pid: 22222,
          windowTitle: '🎮 Game Launcher 🎯',
          executablePath: 'C:\\Apps\\app_🚀_launcher.exe',
        );

        when(mockRepository.getFocusedProcess())
            .thenAnswer((_) async => const Right(processWithEmojis));

        // act
        final result = await getFocusedProcessUseCase();

        // assert
        expect(result.isRight(), true);
        result.fold(
          (l) => fail('Should return process'),
          (r) {
            expect(r?.processName, contains('🚀'));
            expect(r?.windowTitle, contains('🎮'));
          },
        );
      });

      test('should handle process names with mixed scripts (Cyrillic, Arabic, etc)', () async {
        // arrange
        const processWithMixedScripts = ProcessInfo(
          processName: 'игра_العبة_game.exe',
          pid: 33333,
          windowTitle: 'Мультиязычное окно',
          executablePath: 'C:\\International\\игра_العبة_game.exe',
        );

        when(mockRepository.getFocusedProcess())
            .thenAnswer((_) async => const Right(processWithMixedScripts));

        // act
        final result = await getFocusedProcessUseCase();

        // assert
        expect(result.isRight(), true);
        result.fold(
          (l) => fail('Should return process'),
          (r) {
            expect(r?.processName, contains('игра'));
            expect(r?.processName, contains('العبة'));
          },
        );
      });
    });

    group('Extreme Length Process Names', () {
      test('should handle very long process names (255+ characters)', () async {
        // arrange
        final longName = 'A' * 255 + '.exe';
        final processWithLongName = ProcessInfo(
          processName: longName,
          pid: 44444,
          windowTitle: 'Long Window Title ' + ('X' * 500),
          executablePath: 'C:\\VeryLong\\' + longName,
        );

        when(mockRepository.getFocusedProcess())
            .thenAnswer((_) async => Right(processWithLongName));

        // act
        final result = await getFocusedProcessUseCase();

        // assert
        expect(result.isRight(), true);
        result.fold(
          (l) => fail('Should return process'),
          (r) {
            expect(r?.processName.length, greaterThan(255));
          },
        );
      });

      test('should handle empty process names gracefully', () async {
        // arrange
        const emptyProcess = ProcessInfo(
          processName: '',
          pid: 0, // PID must be 0 for isEmpty to be true
          windowTitle: 'Window with no process name',
          executablePath: null,
        );

        when(mockRepository.getFocusedProcess())
            .thenAnswer((_) async => const Right(emptyProcess));

        // act
        final result = await getFocusedProcessUseCase();

        // assert
        expect(result.isRight(), true);
        result.fold(
          (l) => fail('Should return process'),
          (r) {
            expect(r?.isEmpty, true);
            expect(r?.normalizedName, '');
          },
        );
      });

      test('should handle null executable paths', () async {
        // arrange
        const processWithNullPath = ProcessInfo(
          processName: 'system_process.exe',
          pid: 4, // System process PID
          windowTitle: 'System',
          executablePath: null,
        );

        when(mockRepository.getFocusedProcess())
            .thenAnswer((_) async => const Right(processWithNullPath));

        // act
        final result = await getFocusedProcessUseCase();

        // assert
        expect(result.isRight(), true);
        result.fold(
          (l) => fail('Should return process'),
          (r) {
            expect(r?.executablePath, isNull);
            expect(r?.processName, 'system_process.exe');
          },
        );
      });
    });

    group('Rapid Window Switching', () {
      test('should handle rapid process changes without crashes', () async {
        // arrange
        final processes = [
          const ProcessInfo(
            processName: 'chrome.exe',
            pid: 1001,
            windowTitle: 'Google Chrome',
            executablePath: 'C:\\Program Files\\Google\\Chrome\\chrome.exe',
          ),
          const ProcessInfo(
            processName: 'firefox.exe',
            pid: 1002,
            windowTitle: 'Mozilla Firefox',
            executablePath: 'C:\\Program Files\\Mozilla Firefox\\firefox.exe',
          ),
          const ProcessInfo(
            processName: 'code.exe',
            pid: 1003,
            windowTitle: 'Visual Studio Code',
            executablePath: 'C:\\Program Files\\Microsoft VS Code\\code.exe',
          ),
        ];

        // Simulate rapid switching
        final stream = Stream.periodic(
          const Duration(milliseconds: 10),
          (i) => processes[i % processes.length],
        ).take(30); // 30 rapid changes

        final scanInterval = const Duration(milliseconds: 10);
        when(mockRepository.watchProcessChanges(scanInterval))
            .thenAnswer((_) => stream);

        // act
        final result = watchProcessChangesUseCase(scanInterval);
        final collectedProcesses = <ProcessInfo?>[];

        // assert - should handle all rapid changes without errors
        await expectLater(
          result,
          emitsInOrder([
            for (int i = 0; i < 30; i++)
              processes[i % processes.length],
          ]),
        );
      });

      test('should debounce rapid identical process notifications', () async {
        // arrange
        const sameProcess = ProcessInfo(
          processName: 'stable.exe',
          pid: 9999,
          windowTitle: 'Stable Window',
          executablePath: 'C:\\stable.exe',
        );

        // Emit same process multiple times rapidly
        final stream = Stream.fromIterable(
          List.generate(10, (_) => sameProcess),
        );

        final scanInterval = const Duration(milliseconds: 10);
        when(mockRepository.watchProcessChanges(scanInterval))
            .thenAnswer((_) => stream);

        // act
        final result = watchProcessChangesUseCase(scanInterval);

        // assert - should emit distinct values
        await expectLater(
          result.distinct(),
          emits(sameProcess),
        );
      });
    });

    group('Process Name Normalization Edge Cases', () {
      test('should normalize process names with multiple extensions', () async {
        // arrange
        const processWithMultipleExts = ProcessInfo(
          processName: 'app.x86_64.exe',
          pid: 7777,
          windowTitle: 'App Window',
          executablePath: 'C:\\app.x86_64.exe',
        );

        when(mockRepository.getFocusedProcess())
            .thenAnswer((_) async => const Right(processWithMultipleExts));

        // act
        final result = await getFocusedProcessUseCase();

        // assert
        expect(result.isRight(), true);
        result.fold(
          (l) => fail('Should return process'),
          (r) {
            // Should only remove .exe, not other dots
            expect(r?.normalizedName, 'app.x86_64');
          },
        );
      });

      test('should handle case variations in .exe extension', () async {
        // arrange
        final testCases = [
          'app.EXE',
          'app.Exe',
          'app.eXe',
          'app.ExE',
        ];

        for (final name in testCases) {
          final process = ProcessInfo(
            processName: name,
            pid: 8888,
            windowTitle: 'Test',
            executablePath: 'C:\\$name',
          );

          when(mockRepository.getFocusedProcess())
              .thenAnswer((_) async => Right(process));

          // act
          final result = await getFocusedProcessUseCase();

          // assert
          expect(result.isRight(), true);
          result.fold(
            (l) => fail('Should return process'),
            (r) {
              // Normalization is case-insensitive
              expect(r?.normalizedName, 'app');
            },
          );
        }
      });
    });
  });
}