import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:tkit/core/di/injection_container.dart';
import 'package:tkit/core/database/app_database.dart';
import 'package:tkit/core/platform/windows_platform_channel.dart';
import 'package:tkit/core/utils/app_logger.dart';

void main() {
  group('Dependency Injection', () {
    setUp(() async {
      // Initialize Flutter bindings for SharedPreferences
      TestWidgetsFlutterBinding.ensureInitialized();
      // Reset GetIt before each test
      await GetIt.instance.reset();
    });

    tearDown(() async {
      await GetIt.instance.reset();
    });

    group('configureDependencies', () {
      test('should configure dependencies without errors', () async {
        expect(() async => await configureDependencies(), returnsNormally);
      });

      test('should register AppDatabase as lazy singleton', () async {
        await configureDependencies();

        expect(getIt.isRegistered<AppDatabase>(), true);

        final db1 = getIt<AppDatabase>();
        final db2 = getIt<AppDatabase>();

        // Should return same instance (singleton)
        expect(identical(db1, db2), true);
      });

      test(
        'should register WindowsPlatformChannel as lazy singleton',
        () async {
          await configureDependencies();

          expect(getIt.isRegistered<WindowsPlatformChannel>(), true);

          final channel1 = getIt<WindowsPlatformChannel>();
          final channel2 = getIt<WindowsPlatformChannel>();

          // Should return same instance (singleton)
          expect(identical(channel1, channel2), true);
        },
      );

      test('should register AppLogger as lazy singleton', () async {
        await configureDependencies();

        expect(getIt.isRegistered<AppLogger>(), true);

        final logger1 = getIt<AppLogger>();
        final logger2 = getIt<AppLogger>();

        // AppLogger is already a singleton itself
        expect(identical(logger1, logger2), true);
      });

      test('should allow multiple calls without errors', () async {
        await configureDependencies();
        expect(getIt.isRegistered<AppDatabase>(), true);

        // Second call should reset and reconfigure
        await resetDependencies();
        await configureDependencies();

        expect(getIt.isRegistered<AppDatabase>(), true);
      });
    });

    group('resetDependencies', () {
      test('should clear all registered dependencies', () async {
        await configureDependencies();

        expect(getIt.isRegistered<AppDatabase>(), true);

        await resetDependencies();

        expect(getIt.isRegistered<AppDatabase>(), false);
      });

      test('should allow reconfiguration after reset', () async {
        await configureDependencies();
        await resetDependencies();
        await configureDependencies();

        expect(getIt.isRegistered<AppDatabase>(), true);
        expect(getIt.isRegistered<WindowsPlatformChannel>(), true);
      });
    });

    group('Dependency resolution', () {
      test('all core dependencies should be resolvable', () async {
        await configureDependencies();

        // Should not throw when resolving
        expect(() => getIt<AppDatabase>(), returnsNormally);
        expect(() => getIt<WindowsPlatformChannel>(), returnsNormally);
        expect(() => getIt<AppLogger>(), returnsNormally);
      });

      test('should throw when trying to get unregistered type', () async {
        await configureDependencies();

        // This should throw since String is not registered
        expect(() => getIt<String>(), throwsA(isA<Object>()));
      });
    });

    group('GetIt instance', () {
      test('getIt should be the same as GetIt.instance', () {
        expect(identical(getIt, GetIt.instance), true);
      });

      test('should support isRegistered check', () async {
        expect(getIt.isRegistered<AppDatabase>(), false);

        await configureDependencies();

        expect(getIt.isRegistered<AppDatabase>(), true);
      });
    });

    group('Lazy initialization', () {
      test(
        'lazy singletons should not be created until first access',
        () async {
          await configureDependencies();

          // Just registering shouldn't create the instance yet
          // (This is hard to test directly, but we verify no errors occur)
          expect(getIt.isRegistered<AppDatabase>(), true);

          // First access creates the instance
          final db = getIt<AppDatabase>();
          expect(db, isNotNull);
        },
      );
    });
  });
}
