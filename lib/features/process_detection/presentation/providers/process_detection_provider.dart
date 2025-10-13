import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:tkit/core/utils/app_logger.dart';
import 'package:tkit/features/process_detection/domain/usecases/get_focused_process_usecase.dart';
import 'package:tkit/features/process_detection/domain/usecases/watch_process_changes_usecase.dart';
import 'package:tkit/features/process_detection/presentation/states/process_detection_state.dart';

/// Provider for managing process detection state
class ProcessDetectionProvider extends ChangeNotifier {
  final GetFocusedProcessUseCase _getFocusedProcessUseCase;
  final WatchProcessChangesUseCase _watchProcessChangesUseCase;
  final AppLogger _logger;

  StreamSubscription? _processStreamSubscription;
  ProcessDetectionState _state = const ProcessDetectionInitial();

  ProcessDetectionProvider(
    this._getFocusedProcessUseCase,
    this._watchProcessChangesUseCase,
    this._logger,
  );

  ProcessDetectionState get state => _state;

  void _updateState(ProcessDetectionState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> start(Duration scanInterval) async {
    _logger.info(
      'Starting process detection with interval: ${scanInterval.inSeconds}s',
    );

    // Cancel any existing subscription
    await _processStreamSubscription?.cancel();

    _updateState(ProcessDetectionRunning(scanInterval));

    // Start watching for process changes
    _processStreamSubscription = _watchProcessChangesUseCase(scanInterval)
        .listen(
          (processInfo) {
            detectProcess();
          },
          onError: (error) {
            _logger.error('Error in process detection stream', error);
            stop();
          },
        );

    // Immediately detect current process
    final result = await _getFocusedProcessUseCase();
    result.fold(
      (failure) {
        _logger.warning('Failed to get initial process: ${failure.message}');
        _updateState(ProcessDetectionError(failure.message));
      },
      (processInfo) {
        _updateState(ProcessDetected(processInfo, DateTime.now()));
      },
    );
  }

  Future<void> stop() async {
    _logger.info('Stopping process detection');

    await _processStreamSubscription?.cancel();
    _processStreamSubscription = null;

    _updateState(const ProcessDetectionStopped());
  }

  Future<void> detectProcess() async {
    final result = await _getFocusedProcessUseCase();

    result.fold(
      (failure) {
        _logger.warning('Process detection failed: ${failure.message}');
        _updateState(ProcessDetectionError(failure.message));
      },
      (processInfo) {
        _updateState(ProcessDetected(processInfo, DateTime.now()));
      },
    );
  }

  @override
  void dispose() {
    _processStreamSubscription?.cancel();
    super.dispose();
  }
}
