import 'package:dartz/dartz.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/auto_switcher/domain/entities/orchestration_status.dart';
import 'package:tkit/features/auto_switcher/domain/entities/update_history.dart';

/// Repository interface for Auto Switcher orchestration
///
/// This repository coordinates the entire auto-switching pipeline:
/// 1. Process Detection → Category Mapping → Twitch API Update
/// 2. Manages debouncing logic
/// 3. Handles fallback behaviors
/// 4. Tracks update history
abstract class IAutoSwitcherRepository {
  /// Get a stream of orchestration status updates
  ///
  /// Emits status changes as the orchestration progresses through states:
  /// Idle → DetectingProcess → SearchingMapping → UpdatingCategory → WaitingDebounce
  Stream<OrchestrationStatus> getStatusStream();

  /// Start monitoring for process changes and auto-update categories
  ///
  /// This initiates the orchestration pipeline:
  /// - Watches for focused process changes
  /// - Applies debouncing from settings
  /// - Looks up category mappings
  /// - Updates Twitch channel category
  /// - Handles fallback behaviors when no mapping found
  ///
  /// Returns void on success, Failure if cannot start
  Future<Either<Failure, void>> startMonitoring();

  /// Stop monitoring and halt all auto-updates
  ///
  /// Cancels the orchestration pipeline and returns to idle state
  Future<Either<Failure, void>> stopMonitoring();

  /// Manually trigger a category update for the current process
  ///
  /// Performs a one-time update without starting continuous monitoring:
  /// - Detects current process
  /// - Finds category mapping
  /// - Updates Twitch category
  ///
  /// Returns void on success, Failure on error
  Future<Either<Failure, void>> manualUpdate();

  /// Get the current orchestration status
  ///
  /// Returns the latest status snapshot
  Future<Either<Failure, OrchestrationStatus>> getCurrentStatus();

  /// Get update history
  ///
  /// [limit] Maximum number of history entries to return (default: 100)
  /// Returns list of update history entries, most recent first
  Future<Either<Failure, List<UpdateHistory>>> getUpdateHistory({
    int limit = 100,
  });

  /// Clear all update history
  Future<Either<Failure, void>> clearUpdateHistory();

  /// Dispose of resources and cancel subscriptions
  Future<void> dispose();
}
