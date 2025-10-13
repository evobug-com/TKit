import 'package:dartz/dartz.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/auto_switcher/domain/repositories/i_auto_switcher_repository.dart';

/// Use case to stop the auto-switcher monitoring
///
/// Halts the orchestration pipeline and returns the system to idle state
class StopMonitoringUseCase {
  final IAutoSwitcherRepository repository;

  const StopMonitoringUseCase(this.repository);

  /// Execute the use case
  ///
  /// Returns void on success, Failure on error
  Future<Either<Failure, void>> call() async {
    return await repository.stopMonitoring();
  }
}
