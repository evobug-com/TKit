import 'package:dartz/dartz.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/process_detection/domain/entities/process_info.dart';
import 'package:tkit/features/process_detection/domain/repositories/i_process_detection_repository.dart';

/// Use case for getting the currently focused Windows process
class GetFocusedProcessUseCase {
  final IProcessDetectionRepository _repository;

  GetFocusedProcessUseCase(this._repository);

  /// Execute the use case
  /// Returns the currently focused process or null if none
  Future<Either<Failure, ProcessInfo?>> call() async {
    return await _repository.getFocusedProcess();
  }
}
