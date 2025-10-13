import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/core/services/notification_service.dart';
import 'package:tkit/core/utils/app_logger.dart';
import 'package:tkit/features/category_mapping/domain/usecases/find_mapping_usecase.dart';
import 'package:tkit/features/category_mapping/domain/usecases/save_mapping_usecase.dart';
import 'package:tkit/features/category_mapping/domain/usecases/update_last_used_usecase.dart';
import 'package:tkit/features/category_mapping/data/datasources/unknown_process_datasource.dart';
import 'package:tkit/features/process_detection/domain/usecases/get_focused_process_usecase.dart';
import 'package:tkit/features/process_detection/domain/usecases/watch_process_changes_usecase.dart';
import 'package:tkit/features/settings/domain/entities/app_settings.dart';
import 'package:tkit/features/settings/domain/entities/fallback_behavior.dart';
import 'package:tkit/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:tkit/features/settings/domain/usecases/watch_settings_usecase.dart';
import 'package:tkit/features/twitch_api/domain/usecases/update_channel_category_usecase.dart';
import 'package:tkit/features/auto_switcher/domain/entities/orchestration_status.dart';
import 'package:tkit/features/auto_switcher/domain/entities/unknown_game_callback.dart';
import 'package:tkit/features/auto_switcher/domain/entities/update_history.dart';
import 'package:tkit/features/auto_switcher/domain/repositories/i_auto_switcher_repository.dart';
import 'package:tkit/features/auto_switcher/data/datasources/update_history_local_datasource.dart';
import 'package:tkit/features/auto_switcher/data/models/update_history_model.dart';

/// Implementation of the Auto Switcher repository
///
/// Orchestrates the complete auto-switching pipeline:
/// - Process detection → Category mapping → Twitch API update
/// - Debouncing logic to prevent rapid updates
/// - Fallback behavior handling
/// - Update history tracking
/// - Unknown game handling via UI callback
class AutoSwitcherRepositoryImpl implements IAutoSwitcherRepository {
  final WatchProcessChangesUseCase _watchProcessChanges;
  final GetFocusedProcessUseCase _getFocusedProcess;
  final FindMappingUseCase _findMapping;
  final SaveMappingUseCase _saveMappingUseCase;
  final UpdateChannelCategoryUseCase _updateChannelCategory;
  final GetSettingsUseCase _getSettings;
  final WatchSettingsUseCase _watchSettings;
  final UpdateLastUsedUseCase _updateLastUsed;
  final UpdateHistoryLocalDataSource _historyDataSource;
  final UnknownProcessDataSource _unknownProcessDataSource;
  final NotificationService _notificationService;
  final AppLogger _logger = AppLogger();

  // Callback for handling unknown games (set by UI layer)
  UnknownGameCallback? unknownGameCallback;

  // State management
  late final StreamController<OrchestrationStatus> _statusController;
  OrchestrationStatus _currentStatus = OrchestrationStatus.idle();
  StreamSubscription<dynamic>? _monitoringSubscription;
  bool _isMonitoring = false;
  AppSettings? _currentSettings;
  String? _lastProcessedCategoryId;

  AutoSwitcherRepositoryImpl(
    this._watchProcessChanges,
    this._getFocusedProcess,
    this._findMapping,
    this._saveMappingUseCase,
    this._updateChannelCategory,
    this._getSettings,
    this._watchSettings,
    this._updateLastUsed,
    this._historyDataSource,
    this._unknownProcessDataSource,
    this._notificationService,
  ) {
    _statusController = StreamController<OrchestrationStatus>.broadcast();

    // Watch settings changes
    _watchSettings().listen((settings) {
      _currentSettings = settings;
      // If monitoring and settings changed, restart to apply new settings
      if (_isMonitoring) {
        _restartMonitoring();
      }
    });
  }

  @override
  Stream<OrchestrationStatus> getStatusStream() {
    return _statusController.stream;
  }

  @override
  Future<Either<Failure, void>> startMonitoring() async {
    if (_isMonitoring) {
      return const Right(null);
    }

    try {
      // Get current settings
      final settingsResult = await _getSettings();
      return settingsResult.fold((failure) => Left(failure), (settings) async {
        _currentSettings = settings;
        await _startMonitoringInternal();
        return const Right(null);
      });
    } catch (e) {
      return Left(
        UnknownFailure(
          message: 'Failed to start monitoring: $e',
          code: 'START_MONITORING_ERROR',
        ),
      );
    }
  }

  Future<void> _startMonitoringInternal() async {
    _isMonitoring = true;
    _currentStatus = OrchestrationStatus.monitoring();
    _statusController.add(_currentStatus);

    final settings = _currentSettings!;
    final scanInterval = Duration(seconds: settings.scanIntervalSeconds);
    final debounceTime = Duration(seconds: settings.debounceSeconds);

    // Create the orchestration pipeline
    _monitoringSubscription = _watchProcessChanges(scanInterval)
        // Debounce to prevent rapid updates
        .transform(_createDebounceTransformer(debounceTime))
        // Filter out null/empty processes
        .where((process) => process != null && process.processName.isNotEmpty)
        // Process each detected process
        .asyncMap((process) async {
          _currentStatus = _currentStatus.copyWith(
            state: OrchestrationState.searchingMapping,
            currentProcess: process!.processName,
          );
          _statusController.add(_currentStatus);

          // Find category mapping
          final mappingResult = await _findMapping(
            processName: process.processName,
            executablePath: process.executablePath,
          );

          return mappingResult.fold(
            (failure) => null,
            (mapping) {
              if (mapping == null) return null;

              // Check if mapping is disabled - skip silently
              if (!mapping.isEnabled) {
                return {'process': process, 'mapping': null, 'disabled': true};
              }

              return {'process': process, 'mapping': mapping};
            },
          );
        })
        .listen(
          (data) async {
            if (data == null) {
              // No mapping found - handle via callback or fallback
              final processName = _currentStatus.currentProcess;
              if (processName != null && processName.isNotEmpty) {
                await _handleUnknownGame(
                  processName: processName,
                  executablePath: null, // Not available in stream context
                  windowTitle: null, // Not available in stream context
                );
              }
              return;
            }

            // Check if this was a disabled mapping - skip silently
            if (data['disabled'] == true) {
              _currentStatus = _currentStatus.copyWith(
                state: OrchestrationState.detectingProcess,
                currentProcess: null,
              );
              _statusController.add(_currentStatus);
              return;
            }

            // Cast the data to proper types
            final mapping = data['mapping'];
            final process = data['process'];

            // Type check and cast
            if (mapping is! Map<String, dynamic> && mapping == null) {
              return;
            }
            if (process is! Map<String, dynamic> && process == null) {
              return;
            }

            // Extract properties safely
            final categoryId = (mapping as dynamic).twitchCategoryId as String?;
            final categoryName =
                (mapping as dynamic).twitchCategoryName as String?;
            final processName = (process as dynamic).processName as String?;
            final mappingId = (mapping as dynamic).id as int?;

            if (categoryId != null &&
                categoryName != null &&
                processName != null) {
              await _performCategoryUpdate(
                categoryId: categoryId,
                categoryName: categoryName,
                processName: processName,
                mappingId: mappingId,
              );
            }
          },
          onError: (error) {
            _currentStatus = OrchestrationStatus.error(
              'Monitoring error: $error',
            );
            _statusController.add(_currentStatus);
          },
        );
  }

  // Helper method to create debounce transformer
  StreamTransformer<T, T> _createDebounceTransformer<T>(Duration duration) {
    Timer? debounceTimer;
    return StreamTransformer<T, T>.fromHandlers(
      handleData: (data, sink) {
        debounceTimer?.cancel();
        debounceTimer = Timer(duration, () {
          sink.add(data);
        });
      },
      handleDone: (sink) {
        debounceTimer?.cancel();
        sink.close();
      },
    );
  }

  Future<void> _restartMonitoring() async {
    await _stopMonitoringInternal();
    await _startMonitoringInternal();
  }

  @override
  Future<Either<Failure, void>> stopMonitoring() async {
    await _stopMonitoringInternal();
    return const Right(null);
  }

  Future<void> _stopMonitoringInternal() async {
    _isMonitoring = false;
    await _monitoringSubscription?.cancel();
    _monitoringSubscription = null;
    _currentStatus = OrchestrationStatus.idle();
    _statusController.add(_currentStatus);
  }

  @override
  Future<Either<Failure, void>> manualUpdate() async {
    try {
      _currentStatus = _currentStatus.copyWith(
        state: OrchestrationState.detectingProcess,
      );
      _statusController.add(_currentStatus);

      // Get current focused process
      final processResult = await _getFocusedProcess();
      return processResult.fold((failure) => Left(failure), (process) async {
        if (process == null || process.processName.isEmpty) {
          return const Left(
            ValidationFailure(
              message: 'No active process detected',
              code: 'NO_PROCESS',
            ),
          );
        }

        _currentStatus = _currentStatus.copyWith(
          state: OrchestrationState.searchingMapping,
          currentProcess: process.processName,
        );
        _statusController.add(_currentStatus);

        // Find mapping
        final mappingResult = await _findMapping(
          processName: process.processName,
          executablePath: process.executablePath,
        );

        return mappingResult.fold((failure) => Left(failure), (mapping) async {
          if (mapping == null) {
            // No mapping found - handle via callback or fallback
            return await _handleUnknownGame(
              processName: process.processName,
              executablePath: process.executablePath,
              windowTitle: null, // Not available in this context
            );
          }

          // Check if mapping is disabled - skip silently
          if (!mapping.isEnabled) {
            _logger.debug('[AutoSwitcher] Mapping found but disabled for: ${process.processName}');
            _currentStatus = _currentStatus.copyWith(
              state: OrchestrationState.idle,
              currentProcess: null,
            );
            _statusController.add(_currentStatus);
            return const Right(null);
          }

          // Perform update
          return await _performCategoryUpdate(
            categoryId: mapping.twitchCategoryId,
            categoryName: mapping.twitchCategoryName,
            processName: process.processName,
            mappingId: mapping.id,
          );
        });
      });
    } catch (e) {
      return Left(
        UnknownFailure(
          message: 'Manual update failed: $e',
          code: 'MANUAL_UPDATE_ERROR',
        ),
      );
    }
  }

  Future<Either<Failure, void>> _performCategoryUpdate({
    required String categoryId,
    required String categoryName,
    required String processName,
    int? mappingId,
  }) async {
    // Skip if same category as last update (prevent duplicate updates)
    if (_lastProcessedCategoryId == categoryId) {
      return const Right(null);
    }

    _currentStatus = _currentStatus.copyWith(
      state: OrchestrationState.updatingCategory,
      matchedCategory: categoryName,
      categoryId: categoryId,
    );
    _statusController.add(_currentStatus);

    // Update Twitch channel category
    final updateResult = await _updateChannelCategory(categoryId);

    final now = DateTime.now();
    return updateResult.fold(
      (failure) async {
        // Record failure
        await _recordHistory(
          UpdateHistory.failure(
            processName: processName,
            categoryId: categoryId,
            categoryName: categoryName,
            errorMessage: failure.message,
          ),
        );

        _currentStatus = _currentStatus.copyWith(
          state: OrchestrationState.error,
          lastUpdateTime: now,
          lastUpdateSuccess: false,
          errorMessage: failure.message,
        );
        _statusController.add(_currentStatus);

        return Left(failure);
      },
      (_) async {
        // Record success
        await _recordHistory(
          UpdateHistory.success(
            processName: processName,
            categoryId: categoryId,
            categoryName: categoryName,
          ),
        );

        // Update last used timestamp for mapping
        if (mappingId != null) {
          await _updateLastUsed(mappingId);
        }

        _lastProcessedCategoryId = categoryId;

        _currentStatus = _currentStatus.copyWith(
          state: _isMonitoring
              ? OrchestrationState.detectingProcess
              : OrchestrationState.idle,
          lastUpdateTime: now,
          lastUpdateSuccess: true,
          errorMessage: null,
        );
        _statusController.add(_currentStatus);

        return const Right(null);
      },
    );
  }

  Future<Either<Failure, void>> _applyFallback(
    FallbackBehavior behavior,
    String? customCategoryId,
    String processName,
  ) async {
    switch (behavior) {
      case FallbackBehavior.doNothing:
        // Do nothing - keep current category
        _currentStatus = _currentStatus.copyWith(
          state: _isMonitoring
              ? OrchestrationState.detectingProcess
              : OrchestrationState.idle,
          matchedCategory: null,
        );
        _statusController.add(_currentStatus);
        return const Right(null);

      case FallbackBehavior.justChatting:
        // Switch to "Just Chatting" (category ID: 509658)
        return await _performCategoryUpdate(
          categoryId: '509658',
          categoryName: 'Just Chatting',
          processName: processName,
        );

      case FallbackBehavior.custom:
        if (customCategoryId == null || customCategoryId.isEmpty) {
          return const Left(
            ValidationFailure(
              message: 'Custom fallback category not configured',
              code: 'MISSING_CUSTOM_FALLBACK',
            ),
          );
        }
        return await _performCategoryUpdate(
          categoryId: customCategoryId,
          categoryName:
              _currentSettings?.customFallbackCategoryName ?? 'Custom Category',
          processName: processName,
        );
    }
  }

  /// Handle unknown game - try callback first, then fallback
  Future<Either<Failure, void>> _handleUnknownGame({
    required String processName,
    String? executablePath,
    String? windowTitle,
  }) async {
    // Log the unknown process
    try {
      await _unknownProcessDataSource.logUnknownProcess(
        processName,
        windowTitle,
      );
    } catch (e) {
      // Don't fail if logging fails
      _logger.error('[AutoSwitcher] Failed to log unknown process', e);
    }

    _logger.info('[AutoSwitcher] Handling unknown game: $processName');
    _logger.debug('[AutoSwitcher] Callback available: ${unknownGameCallback != null}');

    // Try to invoke callback if available (UI will show dialog)
    if (unknownGameCallback != null) {
      try {
        _logger.info('[AutoSwitcher] Invoking unknown game callback for: $processName');
        final mapping = await unknownGameCallback!(
          processName: processName,
          executablePath: executablePath,
          windowTitle: windowTitle,
        );

        if (mapping != null) {
          _logger.info('[AutoSwitcher] User selected category: ${mapping.twitchCategoryName}');
          // User selected a category - save and use it
          await _saveMappingUseCase(mapping);

          // Mark as resolved
          await _unknownProcessDataSource.markAsResolved(processName);

          // Perform the category update
          return await _performCategoryUpdate(
            categoryId: mapping.twitchCategoryId,
            categoryName: mapping.twitchCategoryName,
            processName: processName,
            mappingId: mapping.id,
          );
        }
        // User cancelled - apply fallback
        _logger.info('[AutoSwitcher] User cancelled dialog, applying fallback');
      } catch (e) {
        // Callback failed - fall through to notification/fallback
        _logger.error('[AutoSwitcher] Callback failed', e);
      }
    } else {
      _logger.info('[AutoSwitcher] No callback registered, using notification fallback');
    }

    // Show notification if enabled and callback not available/failed
    final settings = _currentSettings ?? AppSettings.defaults();
    if (settings.notifyOnMissingCategory) {
      await _notificationService.showMissingCategoryNotification(
        processName: processName,
        executablePath: executablePath,
      );
    }

    // Apply fallback behavior
    return await _applyFallback(
      settings.fallbackBehavior,
      settings.customFallbackCategoryId,
      processName,
    );
  }

  Future<void> _recordHistory(UpdateHistory history) async {
    try {
      await _historyDataSource.saveUpdateHistory(
        UpdateHistoryModel.fromDomain(history),
      );
    } catch (e) {
      // Log error but don't fail the operation
      // History recording is not critical
    }
  }

  @override
  Future<Either<Failure, OrchestrationStatus>> getCurrentStatus() async {
    try {
      return Right(_currentStatus);
    } catch (e) {
      return Left(
        UnknownFailure(
          message: 'Failed to get status: $e',
          code: 'GET_STATUS_ERROR',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<UpdateHistory>>> getUpdateHistory({
    int limit = 100,
  }) async {
    try {
      final models = await _historyDataSource.getUpdateHistory(limit: limit);
      return Right(models.map((m) => m.toDomain()).toList());
    } catch (e) {
      return Left(
        CacheFailure(
          message: 'Failed to get update history: $e',
          code: 'HISTORY_ERROR',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> clearUpdateHistory() async {
    try {
      await _historyDataSource.clearAllHistory();
      return const Right(null);
    } catch (e) {
      return Left(
        CacheFailure(
          message: 'Failed to clear history: $e',
          code: 'CLEAR_HISTORY_ERROR',
        ),
      );
    }
  }

  @override
  Future<void> dispose() async {
    await _stopMonitoringInternal();
    await _statusController.close();
  }
}
