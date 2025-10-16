import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tkit/core/providers/datasource_providers.dart';
import 'package:tkit/core/providers/providers.dart';
import 'package:tkit/core/providers/use_case_providers.dart';
import 'package:tkit/features/settings/presentation/providers/settings_providers.dart';
import 'package:tkit/features/category_mapping/presentation/providers/category_mapping_providers.dart';
import 'package:tkit/features/process_detection/presentation/providers/process_detection_providers.dart';
import 'package:tkit/features/auto_switcher/data/repositories/auto_switcher_repository_impl.dart';
import 'package:tkit/features/auto_switcher/domain/repositories/i_auto_switcher_repository.dart';
import 'package:tkit/features/auto_switcher/domain/usecases/get_orchestration_status_usecase.dart';
import 'package:tkit/features/auto_switcher/domain/usecases/get_update_history_usecase.dart';
import 'package:tkit/features/auto_switcher/domain/usecases/manual_update_usecase.dart';
import 'package:tkit/features/auto_switcher/domain/usecases/start_monitoring_usecase.dart';
import 'package:tkit/features/auto_switcher/domain/usecases/stop_monitoring_usecase.dart';
import 'package:tkit/features/auto_switcher/domain/entities/orchestration_status.dart';
import 'package:tkit/features/auto_switcher/presentation/states/auto_switcher_state.dart';

part 'auto_switcher_providers.g.dart';

// =============================================================================
// AUTO SWITCHER REPOSITORY
// =============================================================================

@Riverpod(keepAlive: true)
Future<IAutoSwitcherRepository> autoSwitcherRepository(Ref ref) async {
  final watchProcessChangesUseCase = ref.watch(
    watchProcessChangesUseCaseProvider,
  );
  final getFocusedProcessUseCase = ref.watch(getFocusedProcessUseCaseProvider);
  final findMappingUseCase = ref.watch(findMappingUseCaseProvider);
  final saveMappingUseCase = ref.watch(saveMappingUseCaseProvider);
  final updateChannelCategoryUseCase = ref.watch(
    updateChannelCategoryUseCaseProvider,
  );
  final getSettingsUseCase = await ref.watch(getSettingsUseCaseProvider.future);
  final watchSettingsUseCase = await ref.watch(
    watchSettingsUseCaseProvider.future,
  );
  final updateLastUsedUseCase = ref.watch(updateLastUsedUseCaseProvider);
  final updateHistoryLocalDataSource = ref.watch(
    updateHistoryLocalDataSourceProvider,
  );
  final unknownProcessDataSource = ref.watch(unknownProcessDataSourceProvider);
  final notificationService = ref.watch(notificationServiceProvider);

  final repo = AutoSwitcherRepositoryImpl(
    watchProcessChangesUseCase,
    getFocusedProcessUseCase,
    findMappingUseCase,
    saveMappingUseCase,
    updateChannelCategoryUseCase,
    getSettingsUseCase,
    watchSettingsUseCase,
    updateLastUsedUseCase,
    updateHistoryLocalDataSource,
    unknownProcessDataSource,
    notificationService,
  );

  ref.onDispose(() {
    repo.dispose();
  });

  return repo;
}

// =============================================================================
// AUTO SWITCHER USE CASES
// =============================================================================

@Riverpod(keepAlive: true)
Future<GetOrchestrationStatusUseCase> getOrchestrationStatusUseCase(
  Ref ref,
) async {
  final repository = await ref.watch(autoSwitcherRepositoryProvider.future);
  return GetOrchestrationStatusUseCase(repository);
}

@Riverpod(keepAlive: true)
Future<GetUpdateHistoryUseCase> getUpdateHistoryUseCase(Ref ref) async {
  final repository = await ref.watch(autoSwitcherRepositoryProvider.future);
  return GetUpdateHistoryUseCase(repository);
}

@Riverpod(keepAlive: true)
Future<ManualUpdateUseCase> manualUpdateUseCase(Ref ref) async {
  final repository = await ref.watch(autoSwitcherRepositoryProvider.future);
  return ManualUpdateUseCase(repository);
}

@Riverpod(keepAlive: true)
Future<StartMonitoringUseCase> startMonitoringUseCase(Ref ref) async {
  final repository = await ref.watch(autoSwitcherRepositoryProvider.future);
  return StartMonitoringUseCase(repository);
}

@Riverpod(keepAlive: true)
Future<StopMonitoringUseCase> stopMonitoringUseCase(Ref ref) async {
  final repository = await ref.watch(autoSwitcherRepositoryProvider.future);
  return StopMonitoringUseCase(repository);
}

// =============================================================================
// AUTO SWITCHER STATE NOTIFIER
// =============================================================================

@Riverpod(keepAlive: true)
class AutoSwitcher extends _$AutoSwitcher {
  StreamSubscription<OrchestrationStatus>? _statusSubscription;

  @override
  Future<AutoSwitcherState> build() async {
    // Initialize and subscribe to status stream
    final getStatus = await ref.read(
      getOrchestrationStatusUseCaseProvider.future,
    );

    await _statusSubscription?.cancel();
    _statusSubscription = getStatus.watchStatus().listen((status) {
      _handleStatusUpdate(status);
    });

    ref.onDispose(() {
      _statusSubscription?.cancel();
    });

    // Get initial status
    final result = await getStatus();
    return result.fold(
      (failure) => UpdateError(OrchestrationStatus.idle(), failure.message),
      (status) {
        if (status.isMonitoring) {
          return MonitoringActive(status);
        } else {
          return MonitoringInactive(status);
        }
      },
    );
  }

  /// Start monitoring for process changes
  Future<void> startMonitoring() async {
    final currentStatus = await _getCurrentStatus();
    state = AsyncData(AutoSwitcherLoading(currentStatus));

    final startMonitoring = await ref.read(
      startMonitoringUseCaseProvider.future,
    );
    final result = await startMonitoring();

    result.fold(
      (failure) {
        state = AsyncData(UpdateError(currentStatus, failure.message));
      },
      (_) {
        state = AsyncData(
          MonitoringActive(currentStatus.copyWith(isMonitoring: true)),
        );
      },
    );
  }

  /// Stop monitoring
  Future<void> stopMonitoring() async {
    final currentStatus = await _getCurrentStatus();
    state = AsyncData(AutoSwitcherLoading(currentStatus));

    final stopMonitoring = await ref.read(stopMonitoringUseCaseProvider.future);
    final result = await stopMonitoring();

    result.fold(
      (failure) {
        state = AsyncData(UpdateError(currentStatus, failure.message));
      },
      (_) {
        state = AsyncData(MonitoringInactive(OrchestrationStatus.idle()));
      },
    );
  }

  /// Manually trigger a category update
  Future<void> manualUpdate() async {
    final currentStatus = await _getCurrentStatus();
    state = AsyncData(Updating(currentStatus));

    final manualUpdate = await ref.read(manualUpdateUseCaseProvider.future);
    final result = await manualUpdate();

    await result.fold(
      (failure) async {
        state = AsyncData(UpdateError(currentStatus, failure.message));
      },
      (_) async {
        final updatedStatus = await _getCurrentStatus();
        state = AsyncData(
          UpdateSuccess(updatedStatus, message: 'Category updated'),
        );
      },
    );
  }

  /// Handle status updates from the stream
  void _handleStatusUpdate(OrchestrationStatus status) {
    // Update state based on orchestration status
    if (status.state == OrchestrationState.error) {
      state = AsyncData(
        UpdateError(status, status.errorMessage ?? 'Unknown error'),
      );
    } else if (status.state == OrchestrationState.updatingCategory) {
      state = AsyncData(Updating(status));
    } else if (status.isMonitoring) {
      state = AsyncData(MonitoringActive(status));
    } else {
      state = AsyncData(MonitoringInactive(status));
    }
  }

  /// Get current orchestration status
  Future<OrchestrationStatus> _getCurrentStatus() async {
    final getStatus = await ref.read(
      getOrchestrationStatusUseCaseProvider.future,
    );
    final result = await getStatus();
    return result.getOrElse(() => OrchestrationStatus.idle());
  }
}
