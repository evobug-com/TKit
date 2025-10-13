import 'package:dartz/dartz.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/auto_switcher/domain/entities/update_history.dart';
import 'package:tkit/features/auto_switcher/domain/repositories/i_auto_switcher_repository.dart';

/// Use case to retrieve update history
///
/// Gets historical records of category update attempts
class GetUpdateHistoryUseCase {
  final IAutoSwitcherRepository repository;

  const GetUpdateHistoryUseCase(this.repository);

  /// Execute the use case
  ///
  /// [limit] Maximum number of history entries to return (default: 100)
  /// Returns list of update history entries, most recent first
  Future<Either<Failure, List<UpdateHistory>>> call({int limit = 100}) async {
    return await repository.getUpdateHistory(limit: limit);
  }

  /// Clear all update history
  Future<Either<Failure, void>> clearHistory() async {
    return await repository.clearUpdateHistory();
  }
}
