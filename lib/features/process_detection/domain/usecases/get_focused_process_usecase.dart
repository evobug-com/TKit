import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/process_info.dart';
import '../repositories/i_process_detection_repository.dart';

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
