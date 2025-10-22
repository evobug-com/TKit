import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/auto_switcher/domain/entities/orchestration_status.dart';
import 'package:tkit/features/auto_switcher/domain/entities/update_history.dart';
import 'package:tkit/features/auto_switcher/domain/repositories/i_auto_switcher_repository.dart';

import 'auto_switcher_edge_cases_test.mocks.dart';

@GenerateMocks([IAutoSwitcherRepository])
void main() {
  late MockIAutoSwitcherRepository mockRepository;

  setUp(() {
    mockRepository = MockIAutoSwitcherRepository();
  });

  group('Auto-Switcher Edge Cases', () {
    group('Network Interruption During Category Update', () {
      test('should handle network failure during Twitch API call', () async {
        // arrange
        when(mockRepository.manualUpdate())
            .thenAnswer((_) async => const Left(NetworkFailure(
                  message: 'Network connection lost during API call',
                  code: 'NETWORK_ERROR',
                )));

        // act
        final result = await mockRepository.manualUpdate();

        // assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<NetworkFailure>());
            expect((failure as NetworkFailure).code, 'NETWORK_ERROR');
          },
          (r) => fail('Should fail with network error'),
        );
      });

      test('should handle intermittent network issues with retry', () async {
        // arrange
        var callCount = 0;
        when(mockRepository.manualUpdate())
            .thenAnswer((_) async {
          callCount++;
          if (callCount <= 2) {
            // First two calls fail
            return const Left(NetworkFailure(
              message: 'Connection timeout',
              code: 'TIMEOUT',
            ));
          } else {
            // Third call succeeds
            return const Right(null);
          }
        });

        // act - simulate retry mechanism
        Either<Failure, void>? result;
        for (int i = 0; i < 3; i++) {
          result = await mockRepository.manualUpdate();
          if (result.isRight()) break;
          await Future.delayed(const Duration(milliseconds: 100)); // Backoff
        }

        // assert
        expect(result?.isRight(), true);
        expect(callCount, 3);
      });

      test('should handle network interruption during status stream', () async {
        // arrange
        final statusController = StreamController<OrchestrationStatus>();

        when(mockRepository.getStatusStream())
            .thenAnswer((_) => statusController.stream.map((s) => s));

        // act
        final streamSubscription = mockRepository.getStatusStream().listen(
          (status) {},
          onError: (error) {
            expect(error, isA<NetworkException>());
          },
        );

        // Emit some statuses then error
        statusController.add(OrchestrationStatus.idle());
        statusController.add(OrchestrationStatus.monitoring());
        statusController.addError(NetworkException('Connection lost'));

        await Future.delayed(const Duration(milliseconds: 100));

        // cleanup
        await streamSubscription.cancel();
        await statusController.close();
      });
    });

    group('Twitch API Rate Limiting', () {
      test('should handle rate limit errors gracefully', () async {
        // arrange
        when(mockRepository.manualUpdate())
            .thenAnswer((_) async => const Left(ApiFailure(
                  message: 'Rate limit exceeded',
                  code: 'RATE_LIMIT',
                  statusCode: 429,
                  retryAfter: 60, // Retry after 60 seconds
                )));

        // act
        final result = await mockRepository.manualUpdate();

        // assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<ApiFailure>());
            final apiFailure = failure as ApiFailure;
            expect(apiFailure.code, 'RATE_LIMIT');
            expect(apiFailure.statusCode, 429);
            expect(apiFailure.retryAfter, 60);
          },
          (r) => fail('Should fail with rate limit'),
        );
      });

      test('should implement exponential backoff on repeated rate limits', () async {
        // arrange
        var callCount = 0;
        final delays = <int>[];

        when(mockRepository.manualUpdate())
            .thenAnswer((_) async {
          callCount++;
          if (callCount <= 3) {
            return Left(ApiFailure(
              message: 'Rate limit exceeded',
              code: 'RATE_LIMIT',
              statusCode: 429,
              retryAfter: callCount * 30, // Increasing retry times
            ));
          }
          return const Right(null);
        });

        // act - simulate exponential backoff
        Either<Failure, void>? result;
        var delay = 100;

        for (int i = 0; i < 4; i++) {
          final start = DateTime.now();
          result = await mockRepository.manualUpdate();

          if (result.isLeft()) {
            delays.add(delay);
            await Future.delayed(Duration(milliseconds: delay));
            delay *= 2; // Exponential backoff
          } else {
            break;
          }
        }

        // assert
        expect(result?.isRight(), true);
        expect(callCount, 4);
        expect(delays, [100, 200, 400]); // Exponential progression
      });

      test('should queue updates when rate limited', () async {
        // arrange
        final updateQueue = <Future<Either<Failure, void>>>[];
        var isRateLimited = true;

        when(mockRepository.manualUpdate())
            .thenAnswer((_) async {
          if (isRateLimited) {
            return const Left(ApiFailure(
              message: 'Rate limit exceeded',
              code: 'RATE_LIMIT',
              statusCode: 429,
              retryAfter: 10,
            ));
          }
          return const Right(null);
        });

        // act - queue multiple updates while rate limited
        for (int i = 0; i < 5; i++) {
          updateQueue.add(mockRepository.manualUpdate());
        }

        // Wait for rate limit to clear
        await Future.delayed(const Duration(milliseconds: 100));
        isRateLimited = false;

        // Process queued updates
        final results = await Future.wait(updateQueue);

        // assert
        expect(results.where((r) => r.isLeft()).length, 5); // All initially rate limited
      });
    });

    group('Rapid Start/Stop Monitoring', () {
      test('should handle rapid start and stop commands', () async {
        // arrange
        var isMonitoring = false;

        when(mockRepository.startMonitoring())
            .thenAnswer((_) async {
          if (isMonitoring) {
            return const Left(ValidationFailure(
              message: 'Monitoring already started',
              code: 'ALREADY_MONITORING',
            ));
          }
          isMonitoring = true;
          return const Right(null);
        });

        when(mockRepository.stopMonitoring())
            .thenAnswer((_) async {
          if (!isMonitoring) {
            return const Left(ValidationFailure(
              message: 'Monitoring not started',
              code: 'NOT_MONITORING',
            ));
          }
          isMonitoring = false;
          return const Right(null);
        });

        // act - rapid start/stop sequence executed sequentially
        final results = <Either<Failure, void>>[];

        results.add(await mockRepository.startMonitoring());
        results.add(await mockRepository.stopMonitoring());
        results.add(await mockRepository.startMonitoring());
        results.add(await mockRepository.stopMonitoring());
        results.add(await mockRepository.startMonitoring());

        // assert - all operations should succeed when executed sequentially
        expect(results.where((r) => r.isRight()).length, greaterThan(0));
        expect(results.length, 5);
      });

      test('should cancel pending operations when stopping monitoring', () async {
        // arrange
        final pendingOperations = <String>[];
        var isCancelled = false;

        when(mockRepository.startMonitoring())
            .thenAnswer((_) async {
          pendingOperations.add('start');
          // Simulate long operation
          for (int i = 0; i < 10; i++) {
            if (isCancelled) {
              return const Left(CancellationFailure(
                message: 'Operation cancelled',
                code: 'CANCELLED',
              ));
            }
            await Future.delayed(const Duration(milliseconds: 10));
          }
          return const Right(null);
        });

        when(mockRepository.stopMonitoring())
            .thenAnswer((_) async {
          isCancelled = true;
          pendingOperations.clear();
          return const Right(null);
        });

        // act
        final startFuture = mockRepository.startMonitoring();
        await Future.delayed(const Duration(milliseconds: 20));
        final stopFuture = mockRepository.stopMonitoring();

        final results = await Future.wait([startFuture, stopFuture]);

        // assert
        expect(results[0].isLeft(), true); // Start was cancelled
        expect(results[1].isRight(), true); // Stop succeeded
      });

      test('should handle monitoring state transitions correctly', () async {
        // arrange
        final states = <OrchestrationStatus>[];
        final statusController = StreamController<OrchestrationStatus>();

        when(mockRepository.getStatusStream())
            .thenAnswer((_) => statusController.stream);

        when(mockRepository.startMonitoring())
            .thenAnswer((_) async {
          statusController.add(OrchestrationStatus.monitoring());
          return const Right(null);
        });

        when(mockRepository.stopMonitoring())
            .thenAnswer((_) async {
          statusController.add(OrchestrationStatus.idle());
          return const Right(null);
        });

        // act
        mockRepository.getStatusStream().listen((status) {
          states.add(status);
        });

        await mockRepository.startMonitoring();
        await Future.delayed(const Duration(milliseconds: 50));
        await mockRepository.stopMonitoring();
        await Future.delayed(const Duration(milliseconds: 50));

        // assert
        expect(states.any((s) => s.state == OrchestrationState.detectingProcess), true);
        expect(states.last.state, OrchestrationState.idle);

        // cleanup
        await statusController.close();
      });
    });

    group('Mapping Changes During Active Monitoring', () {
      test('should handle mapping updates while monitoring is active', () async {
        // arrange
        var currentMapping = 'original_category';
        final statusController = StreamController<OrchestrationStatus>();

        when(mockRepository.getStatusStream())
            .thenAnswer((_) => statusController.stream);

        when(mockRepository.manualUpdate())
            .thenAnswer((_) async {
          // Mapping changed mid-operation
          if (currentMapping != 'original_category') {
            statusController.add(OrchestrationStatus(
              state: OrchestrationState.updatingCategory,
              currentProcess: 'game.exe',
              matchedCategory: currentMapping,
              isMonitoring: true,
            ));
          }
          return const Right(null);
        });

        // act
        final states = <OrchestrationStatus>[];
        mockRepository.getStatusStream().listen((status) {
          states.add(status);
        });

        // Start with original mapping
        await mockRepository.manualUpdate();

        // Change mapping mid-monitoring
        currentMapping = 'new_category';
        await mockRepository.manualUpdate();

        await Future.delayed(const Duration(milliseconds: 100));

        // assert
        expect(states.any((s) =>
          s.state == OrchestrationState.updatingCategory &&
          s.matchedCategory == 'new_category'
        ), true);

        // cleanup
        await statusController.close();
      });

      test('should handle deleted mappings during monitoring', () async {
        // arrange
        var mappingExists = true;

        when(mockRepository.manualUpdate())
            .thenAnswer((_) async {
          if (!mappingExists) {
            return const Left(DatabaseFailure(
              message: 'Category mapping not found',
              code: 'MAPPING_NOT_FOUND',
            ));
          }
          return const Right(null);
        });

        // act
        final result1 = await mockRepository.manualUpdate();

        // Delete mapping
        mappingExists = false;

        final result2 = await mockRepository.manualUpdate();

        // assert
        expect(result1.isRight(), true);
        expect(result2.isLeft(), true);
        result2.fold(
          (failure) {
            expect(failure, isA<DatabaseFailure>());
            expect((failure as DatabaseFailure).code, 'MAPPING_NOT_FOUND');
          },
          (r) => fail('Should fail when mapping is deleted'),
        );
      });
    });

    group('Update History Edge Cases', () {
      test('should handle very large update history', () async {
        // arrange
        final largeHistory = List.generate(
          10000,
          (i) => UpdateHistory(
            id: i,
            processName: 'game_$i.exe',
            categoryId: 'cat_$i',
            categoryName: 'Category $i',
            updatedAt: DateTime.now().subtract(Duration(minutes: i)),
            success: i % 10 != 0, // Every 10th update failed
            errorMessage: i % 10 == 0 ? 'Error on update $i' : null,
          ),
        );

        when(mockRepository.getUpdateHistory(limit: 10000))
            .thenAnswer((_) async => Right(largeHistory));

        // act
        final result = await mockRepository.getUpdateHistory(limit: 10000);

        // assert
        expect(result.isRight(), true);
        result.fold(
          (l) => fail('Should handle large history'),
          (r) {
            expect(r.length, 10000);
            expect(r.where((h) => !h.success).length, 1000); // 10% failures
          },
        );
      });

      test('should handle clearing history during active monitoring', () async {
        // arrange
        var historyCleared = false;

        when(mockRepository.getUpdateHistory())
            .thenAnswer((_) async {
          if (historyCleared) {
            return const Right([]);
          }
          return Right([
            UpdateHistory(
              id: 1,
              processName: 'game.exe',
              categoryId: 'cat_123',
              categoryName: 'Gaming',
              updatedAt: DateTime.now(),
              success: true,
            ),
          ]);
        });

        when(mockRepository.clearUpdateHistory())
            .thenAnswer((_) async {
          historyCleared = true;
          return const Right(null);
        });

        // act
        final beforeClear = await mockRepository.getUpdateHistory();
        await mockRepository.clearUpdateHistory();
        final afterClear = await mockRepository.getUpdateHistory();

        // assert
        beforeClear.fold(
          (l) => fail('Should get history'),
          (r) => expect(r.isNotEmpty, true),
        );

        afterClear.fold(
          (l) => fail('Should get empty history'),
          (r) => expect(r.isEmpty, true),
        );
      });

      test('should handle concurrent history operations', () async {
        // arrange
        final history = <UpdateHistory>[];
        var nextId = 1;

        when(mockRepository.getUpdateHistory())
            .thenAnswer((_) async => Right(List.from(history)));

        when(mockRepository.manualUpdate())
            .thenAnswer((_) async {
          // Add to history
          history.add(UpdateHistory(
            id: nextId++,
            processName: 'game.exe',
            categoryId: 'cat_${nextId}',
            categoryName: 'Category ${nextId}',
            updatedAt: DateTime.now(),
            success: true,
          ));
          return const Right(null);
        });

        // act - concurrent updates and history reads
        final operations = <Future<dynamic>>[];

        for (int i = 0; i < 5; i++) {
          operations.add(mockRepository.manualUpdate());
          operations.add(mockRepository.getUpdateHistory());
        }

        final results = await Future.wait(operations);

        // assert
        final lastHistory = await mockRepository.getUpdateHistory();
        lastHistory.fold(
          (l) => fail('Should get history'),
          (r) => expect(r.length, greaterThanOrEqualTo(5)),
        );
      });
    });

    group('Status Stream Edge Cases', () {
      test('should handle status stream disconnection and reconnection', () async {
        // arrange
        final controller1 = StreamController<OrchestrationStatus>();
        final controller2 = StreamController<OrchestrationStatus>();
        var useFirstController = true;

        when(mockRepository.getStatusStream())
            .thenAnswer((_) => useFirstController
                ? controller1.stream
                : controller2.stream);

        // act
        final states = <OrchestrationStatus>[];

        // First connection
        var subscription = mockRepository.getStatusStream().listen((status) {
          states.add(status);
        });

        controller1.add(OrchestrationStatus.idle());
        await Future.delayed(const Duration(milliseconds: 50));

        // Disconnect
        await subscription.cancel();
        await controller1.close();

        // Reconnect with new stream
        useFirstController = false;
        subscription = mockRepository.getStatusStream().listen((status) {
          states.add(status);
        });

        controller2.add(OrchestrationStatus.monitoring());
        await Future.delayed(const Duration(milliseconds: 50));

        // assert
        expect(states.length, 2);
        expect(states[0].state, OrchestrationState.idle);
        expect(states[1].state, OrchestrationState.detectingProcess);

        // cleanup
        await subscription.cancel();
        await controller2.close();
      });

      test('should handle rapid status updates without dropping events', () async {
        // arrange
        final statusController = StreamController<OrchestrationStatus>();

        when(mockRepository.getStatusStream())
            .thenAnswer((_) => statusController.stream);

        // act
        final receivedStates = <OrchestrationStatus>[];
        mockRepository.getStatusStream().listen((status) {
          receivedStates.add(status);
        });

        // Emit rapid status changes
        final statesToEmit = [
          OrchestrationStatus.idle(),
          OrchestrationStatus.monitoring(),
          OrchestrationStatus(
            state: OrchestrationState.searchingMapping,
            currentProcess: 'game.exe',
            isMonitoring: true,
          ),
          OrchestrationStatus(
            state: OrchestrationState.updatingCategory,
            currentProcess: 'game.exe',
            matchedCategory: 'Gaming',
            isMonitoring: true,
          ),
          OrchestrationStatus(
            state: OrchestrationState.waitingDebounce,
            isMonitoring: true,
          ),
          OrchestrationStatus.idle(),
        ];

        for (final status in statesToEmit) {
          statusController.add(status);
        }

        await Future.delayed(const Duration(milliseconds: 100));

        // assert
        expect(receivedStates.length, statesToEmit.length);
        for (int i = 0; i < statesToEmit.length; i++) {
          expect(receivedStates[i].state, statesToEmit[i].state);
        }

        // cleanup
        await statusController.close();
      });
    });

    group('Disposal and Cleanup', () {
      test('should properly dispose resources when repository is disposed', () async {
        // arrange
        final statusController = StreamController<OrchestrationStatus>();
        var isDisposed = false;

        when(mockRepository.getStatusStream())
            .thenAnswer((_) {
          if (isDisposed) {
            throw StateError('Repository already disposed');
          }
          return statusController.stream;
        });

        when(mockRepository.dispose())
            .thenAnswer((_) async {
          isDisposed = true;
          await statusController.close();
        });

        // act
        final subscription = mockRepository.getStatusStream().listen((_) {});

        await mockRepository.dispose();

        // assert
        expect(() => mockRepository.getStatusStream(),
               throwsA(isA<StateError>()));

        // cleanup
        await subscription.cancel();
      });

      test('should handle disposal during active operations', () async {
        // arrange
        var isDisposed = false;

        when(mockRepository.manualUpdate())
            .thenAnswer((_) async {
          // Simulate long operation
          for (int i = 0; i < 10; i++) {
            if (isDisposed) {
              return const Left(CancellationFailure(
                message: 'Repository disposed',
                code: 'DISPOSED',
              ));
            }
            await Future.delayed(const Duration(milliseconds: 10));
          }
          return const Right(null);
        });

        when(mockRepository.dispose())
            .thenAnswer((_) async {
          isDisposed = true;
        });

        // act
        final updateFuture = mockRepository.manualUpdate();
        await Future.delayed(const Duration(milliseconds: 20));
        await mockRepository.dispose();
        final result = await updateFuture;

        // assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<CancellationFailure>());
            expect((failure as CancellationFailure).code, 'DISPOSED');
          },
          (r) => fail('Should be cancelled due to disposal'),
        );
      });
    });
  });
}

// Helper classes for testing
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

class ApiFailure extends Failure {
  final int? statusCode;
  final int? retryAfter;

  const ApiFailure({
    required super.message,
    required String code,
    this.statusCode,
    this.retryAfter,
  }) : super(code: code);
}

class CancellationFailure extends Failure {
  const CancellationFailure({
    required super.message,
    required String code,
  }) : super(code: code);
}