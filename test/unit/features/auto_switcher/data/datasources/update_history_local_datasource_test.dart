import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tkit/core/database/app_database.dart';
import 'package:tkit/features/auto_switcher/data/datasources/update_history_local_datasource.dart';
import 'package:tkit/features/auto_switcher/data/models/update_history_model.dart';
import 'package:tkit/features/auto_switcher/domain/entities/update_history.dart'
    as domain;

void main() {
  late AppDatabase database;
  late UpdateHistoryLocalDataSource dataSource;

  setUp(() {
    database = AppDatabase.test(NativeDatabase.memory());
    dataSource = UpdateHistoryLocalDataSource(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('UpdateHistoryLocalDataSource', () {
    test('should save update history to database', () async {
      // Arrange
      final history = UpdateHistoryModel.fromDomain(
        domain.UpdateHistory.success(
          processName: 'test.exe',
          categoryId: '123',
          categoryName: 'Test Game',
        ),
      );

      // Act
      final id = await dataSource.saveUpdateHistory(history);

      // Assert
      expect(id, greaterThan(0));

      final saved = await dataSource.getUpdateHistory(limit: 1);
      expect(saved.length, 1);
      expect(saved.first.processName, 'test.exe');
      expect(saved.first.categoryId, '123');
      expect(saved.first.success, true);
    });

    test('should get update history ordered by most recent', () async {
      // Arrange
      final oldTime = DateTime.now().subtract(const Duration(seconds: 1));
      final newTime = DateTime.now();

      final history1 = UpdateHistoryModel(
        processName: 'game1.exe',
        categoryId: '1',
        categoryName: 'Game 1',
        success: true,
        updatedAt: oldTime,
      );
      final history2 = UpdateHistoryModel(
        processName: 'game2.exe',
        categoryId: '2',
        categoryName: 'Game 2',
        success: true,
        updatedAt: newTime,
      );

      await dataSource.saveUpdateHistory(history1);
      await dataSource.saveUpdateHistory(history2);

      // Act
      final result = await dataSource.getUpdateHistory(limit: 10);

      // Assert
      expect(result.length, 2);
      expect(result.first.processName, 'game2.exe'); // Most recent first
      expect(result.last.processName, 'game1.exe');
    });

    test('should get latest update history', () async {
      // Arrange
      final oldTime = DateTime.now().subtract(const Duration(seconds: 1));
      final newTime = DateTime.now();

      final history1 = UpdateHistoryModel(
        processName: 'old.exe',
        categoryId: '1',
        categoryName: 'Old',
        success: true,
        updatedAt: oldTime,
      );
      final history2 = UpdateHistoryModel(
        processName: 'new.exe',
        categoryId: '2',
        categoryName: 'New',
        success: true,
        updatedAt: newTime,
      );

      await dataSource.saveUpdateHistory(history1);
      await dataSource.saveUpdateHistory(history2);

      // Act
      final latest = await dataSource.getLatestUpdateHistory();

      // Assert
      expect(latest, isNotNull);
      expect(latest!.processName, 'new.exe');
    });

    test('should get success count', () async {
      // Arrange
      await dataSource.saveUpdateHistory(
        UpdateHistoryModel.fromDomain(
          domain.UpdateHistory.success(
            processName: 'game.exe',
            categoryId: '1',
            categoryName: 'Game',
          ),
        ),
      );
      await dataSource.saveUpdateHistory(
        UpdateHistoryModel.fromDomain(
          domain.UpdateHistory.failure(
            processName: 'game.exe',
            categoryId: '2',
            categoryName: 'Game',
            errorMessage: 'Error',
          ),
        ),
      );
      await dataSource.saveUpdateHistory(
        UpdateHistoryModel.fromDomain(
          domain.UpdateHistory.success(
            processName: 'game.exe',
            categoryId: '3',
            categoryName: 'Game',
          ),
        ),
      );

      // Act
      final count = await dataSource.getSuccessCount();

      // Assert
      expect(count, 2);
    });

    test('should get failure count', () async {
      // Arrange
      await dataSource.saveUpdateHistory(
        UpdateHistoryModel.fromDomain(
          domain.UpdateHistory.success(
            processName: 'game.exe',
            categoryId: '1',
            categoryName: 'Game',
          ),
        ),
      );
      await dataSource.saveUpdateHistory(
        UpdateHistoryModel.fromDomain(
          domain.UpdateHistory.failure(
            processName: 'game.exe',
            categoryId: '2',
            categoryName: 'Game',
            errorMessage: 'Error',
          ),
        ),
      );

      // Act
      final count = await dataSource.getFailureCount();

      // Assert
      expect(count, 1);
    });

    test('should clear all history', () async {
      // Arrange
      await dataSource.saveUpdateHistory(
        UpdateHistoryModel.fromDomain(
          domain.UpdateHistory.success(
            processName: 'game.exe',
            categoryId: '1',
            categoryName: 'Game',
          ),
        ),
      );

      // Act
      final deleted = await dataSource.clearAllHistory();

      // Assert
      expect(deleted, 1);
      final history = await dataSource.getUpdateHistory();
      expect(history, isEmpty);
    });
  });
}
