import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../domain/entities/orchestration_status.dart';
import '../../domain/usecases/get_orchestration_status_usecase.dart';
import '../../domain/usecases/get_update_history_usecase.dart';
import '../../domain/usecases/manual_update_usecase.dart';
import '../../domain/usecases/start_monitoring_usecase.dart';
import '../../domain/usecases/stop_monitoring_usecase.dart';
import '../states/auto_switcher_state.dart';

/// Provider error message keys for localization
class AutoSwitcherProviderKeys {
  static const errorPrefix = 'autoSwitcherProviderErrorPrefix';
  static const startMonitoring = 'autoSwitcherProviderStartMonitoring';
  static const stopMonitoring = 'autoSwitcherProviderStopMonitoring';
  static const manualUpdate = 'autoSwitcherProviderManualUpdate';
  static const loadHistory = 'autoSwitcherProviderLoadHistory';
  static const clearHistory = 'autoSwitcherProviderClearHistory';
  static const successCategoryUpdated = 'autoSwitcherProviderSuccessCategoryUpdated';
  static const successHistoryCleared = 'autoSwitcherProviderSuccessHistoryCleared';
  static const errorUnknown = 'autoSwitcherProviderErrorUnknown';
}

/// Provider for managing Auto Switcher state and orchestration
///
/// Coordinates all auto-switcher operations:
/// - Starting/stopping monitoring
/// - Manual category updates
/// - Status tracking
/// - Update history management
class AutoSwitcherProvider extends ChangeNotifier {
  final StartMonitoringUseCase _startMonitoring;
  final StopMonitoringUseCase _stopMonitoring;
  final ManualUpdateUseCase _manualUpdate;
  final GetOrchestrationStatusUseCase _getStatus;
  final GetUpdateHistoryUseCase _getHistory;

  StreamSubscription<OrchestrationStatus>? _statusSubscription;
  AutoSwitcherState _state = const AutoSwitcherInitial();

  AutoSwitcherState get state => _state;

  AutoSwitcherProvider(
    this._startMonitoring,
    this._stopMonitoring,
    this._manualUpdate,
    this._getStatus,
    this._getHistory,
  );

  void _updateState(AutoSwitcherState newState) {
    _state = newState;
    notifyListeners();
  }

  /// Initialize the provider and subscribe to status stream
  Future<void> initialize() async {
    // Subscribe to status stream
    await _statusSubscription?.cancel();
    _statusSubscription = _getStatus.watchStatus().listen((status) {
      _handleStatusUpdate(status);
    });

    // Get initial status
    final result = await _getStatus();
    result.fold(
      (failure) => _updateState(
        UpdateError(OrchestrationStatus.idle(), failure.message),
      ),
      (status) {
        if (status.isMonitoring) {
          _updateState(MonitoringActive(status));
        } else {
          _updateState(MonitoringInactive(status));
        }
      },
    );
  }

  /// Start monitoring for process changes
  Future<void> startMonitoring() async {
    final currentStatus = await _getCurrentStatus();
    _updateState(AutoSwitcherLoading(currentStatus));

    final result = await _startMonitoring();

    result.fold(
      (failure) => _updateState(
        UpdateError(
          currentStatus,
          failure.message,
        ),
      ),
      (_) {
        // Status will be updated via status stream
        // Emit a temporary active state
        _updateState(MonitoringActive(currentStatus.copyWith(isMonitoring: true)));
      },
    );
  }

  /// Stop monitoring
  Future<void> stopMonitoring() async {
    final currentStatus = await _getCurrentStatus();
    _updateState(AutoSwitcherLoading(currentStatus));

    final result = await _stopMonitoring();

    result.fold(
      (failure) => _updateState(
        UpdateError(
          currentStatus,
          failure.message,
        ),
      ),
      (_) {
        // Status will be updated via status stream
        _updateState(MonitoringInactive(OrchestrationStatus.idle()));
      },
    );
  }

  /// Manually trigger a category update
  Future<void> manualUpdate() async {
    final currentStatus = await _getCurrentStatus();
    _updateState(Updating(currentStatus));

    final result = await _manualUpdate();

    await result.fold(
      (failure) async {
        _updateState(
          UpdateError(currentStatus, failure.message),
        );
      },
      (_) async {
        final updatedStatus = await _getCurrentStatus();
        _updateState(
          UpdateSuccess(
            updatedStatus,
            message: AutoSwitcherProviderKeys.successCategoryUpdated,
          ),
        );
      },
    );
  }

  /// Handle status updates from the stream
  void _handleStatusUpdate(OrchestrationStatus status) {
    // Update state based on orchestration status
    if (status.state == OrchestrationState.error) {
      _updateState(UpdateError(status, status.errorMessage ?? AutoSwitcherProviderKeys.errorUnknown));
    } else if (status.state == OrchestrationState.updatingCategory) {
      _updateState(Updating(status));
    } else if (status.isMonitoring) {
      _updateState(MonitoringActive(status));
    } else {
      _updateState(MonitoringInactive(status));
    }
  }

  /// Load update history
  Future<void> loadHistory({int limit = 100}) async {
    final currentStatus = await _getCurrentStatus();

    final result = await _getHistory(limit: limit);

    result.fold(
      (failure) => _updateState(
        UpdateError(
          currentStatus,
          failure.message,
        ),
      ),
      (history) => _updateState(HistoryLoaded(currentStatus, history)),
    );
  }

  /// Clear update history
  Future<void> clearHistory() async {
    final currentStatus = await _getCurrentStatus();

    final result = await _getHistory.clearHistory();

    result.fold(
      (failure) => _updateState(
        UpdateError(
          currentStatus,
          failure.message,
        ),
      ),
      (_) => _updateState(
        UpdateSuccess(currentStatus, message: AutoSwitcherProviderKeys.successHistoryCleared),
      ),
    );
  }

  /// Get current orchestration status
  Future<OrchestrationStatus> _getCurrentStatus() async {
    final result = await _getStatus();
    return result.getOrElse(() => OrchestrationStatus.idle());
  }

  @override
  void dispose() {
    _statusSubscription?.cancel();
    super.dispose();
  }
}
