import 'package:flutter_test/flutter_test.dart';
import 'package:tkit/core/utils/app_logger.dart';

void main() {
  group('AppLogger', () {
    late AppLogger logger;

    setUp(() {
      logger = AppLogger();
    });

    test('should be a singleton', () {
      final logger1 = AppLogger();
      final logger2 = AppLogger();

      expect(identical(logger1, logger2), true);
    });

    test('should provide talker instance', () {
      expect(logger.talker, isNotNull);
    });

    group('Logging methods', () {
      test('debug should not throw', () {
        expect(() => logger.debug('Debug message'), returnsNormally);
        expect(
          () => logger.debug('Debug with error', Exception('test')),
          returnsNormally,
        );
        expect(
          () => logger.debug('Debug with stack', null, StackTrace.current),
          returnsNormally,
        );
      });

      test('info should not throw', () {
        expect(() => logger.info('Info message'), returnsNormally);
        expect(
          () => logger.info('Info with error', Exception('test')),
          returnsNormally,
        );
      });

      test('warning should not throw', () {
        expect(() => logger.warning('Warning message'), returnsNormally);
        expect(
          () => logger.warning('Warning with error', Exception('test')),
          returnsNormally,
        );
      });

      test('error should not throw', () {
        expect(() => logger.error('Error message'), returnsNormally);
        expect(
          () => logger.error('Error with exception', Exception('test')),
          returnsNormally,
        );
      });

      test('fatal should not throw', () {
        expect(() => logger.fatal('Fatal message'), returnsNormally);
        expect(
          () => logger.fatal(
            'Fatal error',
            Exception('test'),
            StackTrace.current,
          ),
          returnsNormally,
        );
      });

      test('trace should not throw', () {
        expect(() => logger.trace('Trace message'), returnsNormally);
      });
    });

    group('Multiple calls', () {
      test('should handle rapid successive calls', () {
        expect(() {
          for (int i = 0; i < 100; i++) {
            logger.info('Message $i');
          }
        }, returnsNormally);
      });

      test('should handle all log levels in sequence', () {
        expect(() {
          logger.trace('Trace level');
          logger.debug('Debug level');
          logger.info('Info level');
          logger.warning('Warning level');
          logger.error('Error level');
          logger.fatal('Fatal level');
        }, returnsNormally);
      });
    });

    group('Error handling', () {
      test('should handle null error gracefully', () {
        expect(() => logger.error('Error', null), returnsNormally);
      });

      test('should handle null stackTrace gracefully', () {
        expect(
          () => logger.error('Error', Exception('test'), null),
          returnsNormally,
        );
      });

      test('should handle complex error objects', () {
        final complexError = {
          'type': 'NetworkError',
          'message': 'Connection failed',
          'details': {'code': 500, 'retry': true},
        };

        expect(
          () => logger.error('Complex error', complexError),
          returnsNormally,
        );
      });
    });

    group('Message formatting', () {
      test('should handle multiline messages', () {
        expect(() => logger.info('Line 1\nLine 2\nLine 3'), returnsNormally);
      });

      test('should handle special characters in messages', () {
        expect(
          () => logger.info('Special: \t\n\r "quotes" \'apostrophes\''),
          returnsNormally,
        );
      });

      test('should handle very long messages', () {
        final longMessage = 'A' * 10000;
        expect(() => logger.info(longMessage), returnsNormally);
      });

      test('should handle empty messages', () {
        expect(() => logger.info(''), returnsNormally);
      });
    });

    group('Performance', () {
      test('logging should be fast', () {
        final stopwatch = Stopwatch()..start();

        for (int i = 0; i < 1000; i++) {
          logger.trace('Performance test $i');
        }

        stopwatch.stop();

        // Should complete in reasonable time (less than 5 seconds for 1000 calls)
        expect(stopwatch.elapsedMilliseconds, lessThan(5000));
      });
    });

    group('Direct talker access', () {
      test('should expose talker for direct access', () {
        final talker = logger.talker;

        expect(() => talker.info('Direct talker call'), returnsNormally);
        expect(() => talker.error('Direct error call'), returnsNormally);
      });
    });
  });
}
