import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tkit/core/database/app_database.dart';
import 'package:tkit/core/platform/windows_platform_channel.dart';
import 'package:tkit/core/utils/app_logger.dart';
import 'package:tkit/core/di/injection_container.dart';
import 'package:tkit/core/config/app_config.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Infrastructure Integration Tests', () {
    late AppDatabase database;
    late WindowsPlatformChannel platformChannel;
    late AppLogger logger;

    setUp(() async {
      // Setup in-memory database for testing
      database = AppDatabase.test(NativeDatabase.memory());

      // Setup logger
      logger = AppLogger();

      // Setup platform channel
      platformChannel = WindowsPlatformChannel(logger);

      // Mock platform channel
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel(AppConfig.processDetectionChannel),
            (MethodCall methodCall) async {
              switch (methodCall.method) {
                case 'getFocusedProcess':
                  return '{"processName":"League of Legends.exe","pid":12345,"windowTitle":"League of Legends","executablePath":"C:\\\\Games\\\\League of Legends.exe"}';
                case 'isAvailable':
                  return true;
                default:
                  return null;
              }
            },
          );
    });

    tearDown(() async {
      await database.close();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel(AppConfig.processDetectionChannel),
            null,
          );
    });

    test('Full workflow: detect process -> find mapping -> log result', () async {
      // 1. Seed database with mappings
      logger.info('Seeding database with initial mappings...');
      await database.seedInitialMappings();

      final mappings = await database.select(database.categoryMappings).get();
      logger.info('Database seeded with ${mappings.length} mappings');

      expect(mappings.length, greaterThan(0));

      // 2. Detect focused process via platform channel
      logger.info('Detecting focused process...');
      final processInfo = await platformChannel.getFocusedProcess();

      expect(processInfo, isNotNull);
      logger.info('Detected process: ${processInfo!['processName']}');

      final processName = processInfo['processName'] as String;
      expect(processName, 'League of Legends.exe');

      // 3. Find matching category mapping in database
      logger.info('Searching for category mapping...');
      final mapping = await (database.select(
        database.categoryMappings,
      )..where((tbl) => tbl.processName.equals(processName))).getSingleOrNull();

      expect(mapping, isNotNull);
      logger.info(
        'Found mapping: ${mapping!.processName} -> ${mapping.twitchCategoryName}',
      );

      expect(mapping.processName, 'League of Legends.exe');
      expect(mapping.twitchCategoryId, '21779');
      expect(mapping.twitchCategoryName, 'League of Legends');

      // 4. Log successful update to history
      logger.info('Recording update history...');
      await database
          .into(database.updateHistory)
          .insert(
            UpdateHistoryCompanion.insert(
              processName: processName,
              categoryId: mapping.twitchCategoryId,
              categoryName: mapping.twitchCategoryName,
              success: true,
            ),
          );

      final history = await database.select(database.updateHistory).get();
      expect(history, hasLength(1));
      expect(history.first.success, true);

      logger.info('Integration test completed successfully');
    });

    test('Workflow with unknown process -> no mapping found', () async {
      // Setup mock to return unknown process
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel(AppConfig.processDetectionChannel),
            (MethodCall methodCall) async {
              if (methodCall.method == 'getFocusedProcess') {
                return '{"processName":"unknown.exe","pid":99999,"windowTitle":"Unknown App","executablePath":"C:\\\\unknown.exe"}';
              }
              return null;
            },
          );

      // 1. Seed database
      await database.seedInitialMappings();

      // 2. Detect process
      final processInfo = await platformChannel.getFocusedProcess();
      expect(processInfo, isNotNull);

      final processName = processInfo!['processName'] as String;
      expect(processName, 'unknown.exe');

      // 3. Try to find mapping (should fail)
      final mapping = await (database.select(
        database.categoryMappings,
      )..where((tbl) => tbl.processName.equals(processName))).getSingleOrNull();

      expect(mapping, isNull);
      logger.warning('No mapping found for $processName');

      // 4. Log failed update
      await database
          .into(database.updateHistory)
          .insert(
            UpdateHistoryCompanion.insert(
              processName: processName,
              categoryId: '',
              categoryName: '',
              success: false,
              errorMessage: const Value('No mapping found'),
            ),
          );

      final history = await database.select(database.updateHistory).get();
      expect(history, hasLength(1));
      expect(history.first.success, false);
      expect(history.first.errorMessage, 'No mapping found');
    });

    test('Database migration and seeding workflow', () async {
      // 1. Fresh database should be empty
      var mappings = await database.select(database.categoryMappings).get();
      expect(mappings, isEmpty);

      // 2. Seed initial mappings
      await database.seedInitialMappings();

      mappings = await database.select(database.categoryMappings).get();
      expect(mappings.length, greaterThanOrEqualTo(30));

      // 3. Verify indexes work (fast query)
      final stopwatch = Stopwatch()..start();

      final leagueMapping =
          await (database.select(database.categoryMappings)..where(
                (tbl) => tbl.processName.equals('League of Legends.exe'),
              ))
              .getSingle();

      stopwatch.stop();

      expect(leagueMapping.twitchCategoryId, '21779');
      expect(stopwatch.elapsedMilliseconds, lessThan(100)); // Fast query

      // 4. Update last used timestamp
      await (database.update(database.categoryMappings)
            ..where((tbl) => tbl.id.equals(leagueMapping.id)))
          .write(CategoryMappingsCompanion(lastUsedAt: Value(DateTime.now())));

      final updatedMapping = await (database.select(
        database.categoryMappings,
      )..where((tbl) => tbl.id.equals(leagueMapping.id))).getSingle();

      expect(updatedMapping.lastUsedAt, isNotNull);
    });

    test('Platform channel error handling workflow', () async {
      // Setup mock to throw error
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel(AppConfig.processDetectionChannel),
            (MethodCall methodCall) async {
              throw PlatformException(
                code: 'ACCESS_DENIED',
                message: 'Cannot access elevated process',
              );
            },
          );

      // Try to detect process
      try {
        await platformChannel.getFocusedProcess();
        fail('Should have thrown exception');
      } catch (e) {
        logger.error('Platform error caught as expected', e);
        expect(e, isNotNull);

        // Log error to history
        await database
            .into(database.updateHistory)
            .insert(
              UpdateHistoryCompanion.insert(
                processName: 'Unknown',
                categoryId: '',
                categoryName: '',
                success: false,
                errorMessage: Value(e.toString()),
              ),
            );

        final history = await database.select(database.updateHistory).get();
        expect(history, hasLength(1));
        expect(history.first.success, false);
      }
    });

    test('Concurrent database operations', () async {
      await database.seedInitialMappings();

      // Perform multiple concurrent database operations
      final futures = <Future>[];

      // Read operations
      for (int i = 0; i < 10; i++) {
        futures.add(database.select(database.categoryMappings).get());
      }

      // Write operations
      for (int i = 0; i < 10; i++) {
        futures.add(
          database
              .into(database.updateHistory)
              .insert(
                UpdateHistoryCompanion.insert(
                  processName: 'concurrent_$i.exe',
                  categoryId: '$i',
                  categoryName: 'Concurrent $i',
                  success: true,
                ),
              ),
        );
      }

      // All operations should complete without errors
      await Future.wait(futures);

      final history = await database.select(database.updateHistory).get();
      expect(history, hasLength(10));
    });

    test('Full dependency injection integration', () async {
      // Reset and configure DI
      await resetDependencies();
      await configureDependencies();

      // Resolve dependencies
      expect(() => getIt<AppDatabase>(), returnsNormally);
      expect(() => getIt<WindowsPlatformChannel>(), returnsNormally);
      expect(() => getIt<AppLogger>(), returnsNormally);

      final dbFromDI = getIt<AppDatabase>();
      final platformFromDI = getIt<WindowsPlatformChannel>();
      final loggerFromDI = getIt<AppLogger>();

      expect(dbFromDI, isNotNull);
      expect(platformFromDI, isNotNull);
      expect(loggerFromDI, isNotNull);

      // Verify singletons
      expect(identical(getIt<AppDatabase>(), dbFromDI), true);
      expect(identical(getIt<WindowsPlatformChannel>(), platformFromDI), true);
      expect(identical(getIt<AppLogger>(), loggerFromDI), true);

      await resetDependencies();
    });

    test('Performance: rapid process detection and database queries', () async {
      await database.seedInitialMappings();

      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < 100; i++) {
        // Detect process
        final processInfo = await platformChannel.getFocusedProcess();

        // Query database
        if (processInfo != null) {
          final processName = processInfo['processName'] as String;
          await (database.select(database.categoryMappings)
                ..where((tbl) => tbl.processName.equals(processName)))
              .getSingleOrNull();
        }
      }

      stopwatch.stop();

      logger.info(
        'Completed 100 iterations in ${stopwatch.elapsedMilliseconds}ms',
      );

      // Should be reasonably fast (less than 5 seconds for 100 iterations)
      expect(stopwatch.elapsedMilliseconds, lessThan(5000));
    });
  });
}
