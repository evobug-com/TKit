import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tkit/core/config/app_config.dart';
import 'package:tkit/core/platform/windows_platform_channel.dart';
import 'package:tkit/core/utils/app_logger.dart';
import 'package:tkit/core/errors/exceptions.dart' as app_exceptions;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late WindowsPlatformChannel platformChannel;
  late List<MethodCall> methodCalls;

  setUp(() {
    methodCalls = [];
    platformChannel = WindowsPlatformChannel(AppLogger());

    // Mock the method channel
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel(AppConfig.processDetectionChannel),
          (MethodCall methodCall) async {
            methodCalls.add(methodCall);

            switch (methodCall.method) {
              case 'getFocusedProcess':
                return '{"processName":"notepad.exe","pid":12345,"windowTitle":"Untitled - Notepad","executablePath":"C:\\\\Windows\\\\System32\\\\notepad.exe"}';
              case 'isAvailable':
                return true;
              default:
                return null;
            }
          },
        );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel(AppConfig.processDetectionChannel),
          null,
        );
  });

  group('WindowsPlatformChannel', () {
    group('getFocusedProcess', () {
      test('should return process info when process is focused', () async {
        final result = await platformChannel.getFocusedProcess();

        expect(result, isNotNull);
        expect(result!['processName'], 'notepad.exe');
        expect(result['pid'], 12345);
        expect(result['windowTitle'], 'Untitled - Notepad');
        expect(result['executablePath'], 'C:\\Windows\\System32\\notepad.exe');

        expect(methodCalls, hasLength(1));
        expect(methodCalls.first.method, 'getFocusedProcess');
      });

      test('should return null when no process is focused', () async {
        // Setup mock to return empty string
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
              const MethodChannel(AppConfig.processDetectionChannel),
              (MethodCall methodCall) async {
                return '';
              },
            );

        final result = await platformChannel.getFocusedProcess();

        expect(result, isNull);
      });

      test('should return null when platform returns null', () async {
        // Setup mock to return null
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
              const MethodChannel(AppConfig.processDetectionChannel),
              (MethodCall methodCall) async {
                return null;
              },
            );

        final result = await platformChannel.getFocusedProcess();

        expect(result, isNull);
      });

      test(
        'should throw PlatformException when platform method fails',
        () async {
          // Setup mock to throw PlatformException
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
              .setMockMethodCallHandler(
                const MethodChannel(AppConfig.processDetectionChannel),
                (MethodCall methodCall) async {
                  throw PlatformException(
                    code: 'UNAVAILABLE',
                    message: 'Platform not available',
                  );
                },
              );

          expect(
            () => platformChannel.getFocusedProcess(),
            throwsA(isA<app_exceptions.PlatformException>()),
          );
        },
      );

      test('should wrap unexpected errors in PlatformException', () async {
        // Setup mock to throw generic exception
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
              const MethodChannel(AppConfig.processDetectionChannel),
              (MethodCall methodCall) async {
                throw Exception('Unexpected error');
              },
            );

        expect(
          () => platformChannel.getFocusedProcess(),
          throwsA(isA<app_exceptions.PlatformException>()),
        );
      });

      test('should handle JSON with special characters', () async {
        // Setup mock to return JSON with special characters
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
              const MethodChannel(AppConfig.processDetectionChannel),
              (MethodCall methodCall) async {
                return '{"processName":"test.exe","pid":999,"windowTitle":"Test \\"Window\\" Title","executablePath":"C:\\\\Program Files\\\\test.exe"}';
              },
            );

        final result = await platformChannel.getFocusedProcess();

        expect(result, isNotNull);
        expect(result!['windowTitle'], 'Test "Window" Title');
        expect(result['executablePath'], 'C:\\Program Files\\test.exe');
      });

      test('should handle elevated processes gracefully', () async {
        // Elevated processes might return minimal info
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
              const MethodChannel(AppConfig.processDetectionChannel),
              (MethodCall methodCall) async {
                return '{"processName":"Unknown","pid":5678,"windowTitle":"Administrator Window","executablePath":""}';
              },
            );

        final result = await platformChannel.getFocusedProcess();

        expect(result, isNotNull);
        expect(result!['processName'], 'Unknown');
        expect(result['executablePath'], '');
      });

      test('should handle multiple rapid calls', () async {
        final results = await Future.wait([
          platformChannel.getFocusedProcess(),
          platformChannel.getFocusedProcess(),
          platformChannel.getFocusedProcess(),
        ]);

        expect(results, hasLength(3));
        for (final result in results) {
          expect(result, isNotNull);
          expect(result!['processName'], 'notepad.exe');
        }
      });
    });

    group('isAvailable', () {
      test('should return true when platform channel is available', () async {
        final result = await platformChannel.isAvailable();

        expect(result, true);
        expect(methodCalls.any((call) => call.method == 'isAvailable'), true);
      });

      test('should return false when platform channel throws', () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
              const MethodChannel(AppConfig.processDetectionChannel),
              (MethodCall methodCall) async {
                throw Exception('Not available');
              },
            );

        final result = await platformChannel.isAvailable();

        expect(result, false);
      });

      test('should return false when platform returns null', () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
              const MethodChannel(AppConfig.processDetectionChannel),
              (MethodCall methodCall) async {
                return null;
              },
            );

        final result = await platformChannel.isAvailable();

        expect(result, false);
      });
    });

    group('Integration', () {
      test(
        'should work in sequence: check availability then get process',
        () async {
          final isAvailable = await platformChannel.isAvailable();
          expect(isAvailable, true);

          final processInfo = await platformChannel.getFocusedProcess();
          expect(processInfo, isNotNull);
          expect(processInfo!['processName'], 'notepad.exe');
        },
      );
    });
  });
}
