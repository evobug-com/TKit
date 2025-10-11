import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/i_auto_switcher_repository.dart';

/// Use case to start the auto-switcher monitoring
///
/// Initiates the orchestration pipeline that:
/// - Monitors focused process changes
/// - Looks up category mappings
/// - Updates Twitch channel category automatically
class StartMonitoringUseCase {
  final IAutoSwitcherRepository repository;

  const StartMonitoringUseCase(this.repository);

  /// Execute the use case
  ///
  /// Returns void on success, Failure if cannot start monitoring
  Future<Either<Failure, void>> call() async {
    return await repository.startMonitoring();
  }
}
