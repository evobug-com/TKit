import 'package:dartz/dartz.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/auto_switcher/domain/entities/orchestration_status.dart';
import 'package:tkit/features/auto_switcher/domain/repositories/i_auto_switcher_repository.dart';

/// Use case to get the current orchestration status
///
/// Returns a snapshot of the current state of the auto-switcher
class GetOrchestrationStatusUseCase {
  final IAutoSwitcherRepository repository;

  const GetOrchestrationStatusUseCase(this.repository);

  /// Execute the use case
  ///
  /// Returns OrchestrationStatus on success, Failure on error
  Future<Either<Failure, OrchestrationStatus>> call() async {
    return await repository.getCurrentStatus();
  }

  /// Get a stream of status updates
  ///
  /// Returns a stream that emits status changes in real-time
  Stream<OrchestrationStatus> watchStatus() {
    return repository.getStatusStream();
  }
}
