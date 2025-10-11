import 'package:flutter_test/flutter_test.dart';
import 'package:tkit/core/errors/failure.dart';

void main() {
  group('Failure', () {
    group('ServerFailure', () {
      test('should create ServerFailure with message', () {
        const failure = ServerFailure(message: 'Server error');

        expect(failure.message, 'Server error');
        expect(failure.code, isNull);
        expect(failure.originalError, isNull);
      });

      test('should create ServerFailure with all parameters', () {
        const failure = ServerFailure(
          message: 'Server error',
          code: '500',
          originalError: 'Original error',
        );

        expect(failure.message, 'Server error');
        expect(failure.code, '500');
        expect(failure.originalError, 'Original error');
      });

      test('should have correct toString representation', () {
        const failure = ServerFailure(message: 'Server error', code: '500');

        expect(failure.toString(), 'Failure: Server error (Code: 500)');
      });

      test('should support equality comparison', () {
        const failure1 = ServerFailure(message: 'Server error', code: '500');
        const failure2 = ServerFailure(message: 'Server error', code: '500');
        const failure3 = ServerFailure(message: 'Different error');

        expect(failure1, equals(failure2));
        expect(failure1, isNot(equals(failure3)));
      });
    });

    group('CacheFailure', () {
      test('should create CacheFailure with message', () {
        const failure = CacheFailure(message: 'Cache error');

        expect(failure.message, 'Cache error');
        expect(failure.code, isNull);
      });

      test('should support equality comparison', () {
        const failure1 = CacheFailure(message: 'Cache error');
        const failure2 = CacheFailure(message: 'Cache error');

        expect(failure1, equals(failure2));
      });
    });

    group('PlatformFailure', () {
      test('should create PlatformFailure with message', () {
        const failure = PlatformFailure(message: 'Platform error');

        expect(failure.message, 'Platform error');
      });

      test('should store original error', () {
        final originalError = Exception('Platform exception');
        final failure = PlatformFailure(
          message: 'Platform error',
          originalError: originalError,
        );

        expect(failure.originalError, equals(originalError));
      });
    });

    group('DatabaseFailure', () {
      test('should create DatabaseFailure with message', () {
        const failure = DatabaseFailure(message: 'Database error');

        expect(failure.message, 'Database error');
      });
    });

    group('AuthFailure', () {
      test('should create AuthFailure with message and code', () {
        const failure = AuthFailure(
          message: 'Authentication failed',
          code: 'INVALID_TOKEN',
        );

        expect(failure.message, 'Authentication failed');
        expect(failure.code, 'INVALID_TOKEN');
      });
    });

    group('NetworkFailure', () {
      test('should create NetworkFailure with message', () {
        const failure = NetworkFailure(message: 'Network error');

        expect(failure.message, 'Network error');
      });
    });

    group('ValidationFailure', () {
      test('should create ValidationFailure with message', () {
        const failure = ValidationFailure(message: 'Validation error');

        expect(failure.message, 'Validation error');
      });
    });

    group('UnknownFailure', () {
      test('should create UnknownFailure with message', () {
        const failure = UnknownFailure(message: 'Unknown error');

        expect(failure.message, 'Unknown error');
      });
    });

    group('Equality', () {
      test(
        'different failure types should not be equal even with same message',
        () {
          const serverFailure = ServerFailure(message: 'Error');
          const cacheFailure = CacheFailure(message: 'Error');

          expect(serverFailure, isNot(equals(cacheFailure)));
        },
      );

      test('same failure type with different messages should not be equal', () {
        const failure1 = ServerFailure(message: 'Error 1');
        const failure2 = ServerFailure(message: 'Error 2');

        expect(failure1, isNot(equals(failure2)));
      });
    });
  });
}
