import 'package:dartz/dartz.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/auto_switcher/domain/repositories/i_auto_switcher_repository.dart';

/// Use case to manually trigger a category update
///
/// Performs a one-time update for the currently focused process:
/// - Detects current process
/// - Finds category mapping
/// - Updates Twitch category
///
/// Does not start continuous monitoring
class ManualUpdateUseCase {
  final IAutoSwitcherRepository repository;

  const ManualUpdateUseCase(this.repository);

  /// Execute the use case
  ///
  /// Returns void on success, Failure on error
  Future<Either<Failure, void>> call() async {
    return await repository.manualUpdate();
  }
}
