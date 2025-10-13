import 'package:dartz/dartz.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/process_detection/domain/entities/process_info.dart';

/// Repository interface for process detection operations
abstract class IProcessDetectionRepository {
  /// Get the currently focused Windows process
  /// Returns null if no window is focused or process cannot be detected
  Future<Either<Failure, ProcessInfo?>> getFocusedProcess();

  /// Watch for process changes with configurable scan interval
  /// Emits new ProcessInfo whenever the focused window changes
  /// Deduplicates consecutive identical processes
  Stream<ProcessInfo?> watchProcessChanges(Duration scanInterval);

  /// Check if process detection is available on this platform
  Future<Either<Failure, bool>> isAvailable();
}
