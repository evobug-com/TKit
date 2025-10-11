import '../entities/process_info.dart';
import '../repositories/i_process_detection_repository.dart';

/// Use case for watching process changes over time
class WatchProcessChangesUseCase {
  final IProcessDetectionRepository _repository;

  WatchProcessChangesUseCase(this._repository);

  /// Execute the use case
  /// Returns a stream that emits ProcessInfo whenever the focused window changes
  ///
  /// [scanInterval] - How frequently to check for process changes
  Stream<ProcessInfo?> call(Duration scanInterval) {
    return _repository.watchProcessChanges(scanInterval);
  }
}
