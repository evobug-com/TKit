import 'dart:async';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/process_info.dart';
import '../../domain/repositories/i_process_detection_repository.dart';
import '../datasources/process_detection_platform_datasource.dart';

/// Implementation of IProcessDetectionRepository
class ProcessDetectionRepositoryImpl implements IProcessDetectionRepository {
  final ProcessDetectionPlatformDataSource _dataSource;
  final AppLogger _logger;

  ProcessDetectionRepositoryImpl(this._dataSource, this._logger);

  @override
  Future<Either<Failure, ProcessInfo?>> getFocusedProcess() async {
    try {
      final processModel = await _dataSource.getFocusedProcess();
      return Right(processModel);
    } on PlatformException catch (e, stackTrace) {
      _logger.error(
        'Platform exception getting focused process',
        e,
        stackTrace,
      );
      return Left(
        PlatformFailure(message: e.message, code: e.code, originalError: e),
      );
    } catch (e, stackTrace) {
      _logger.error('Unexpected error getting focused process', e, stackTrace);
      return Left(
        UnknownFailure(
          message: 'Failed to get focused process',
          originalError: e,
        ),
      );
    }
  }

  @override
  Stream<ProcessInfo?> watchProcessChanges(Duration scanInterval) {
    _logger.info(
      'Starting process detection stream with interval: ${scanInterval.inSeconds}s',
    );

    // Create a periodic stream that polls for process changes
    return Stream.periodic(scanInterval)
        .asyncMap((_) async {
          final result = await getFocusedProcess();
          return result.fold((failure) {
            _logger.warning('Failed to detect process: ${failure.message}');
            return null;
          }, (process) => process);
        })
        // Deduplicate: only emit when process changes
        .distinct((previous, next) {
          // Compare by process name and window title
          if (previous == null && next == null) return true;
          if (previous == null || next == null) return false;
          return previous.processName == next.processName &&
              previous.windowTitle == next.windowTitle;
        })
        // Log process changes
        .map((process) {
          if (process != null && !process.isEmpty) {
            _logger.info(
              'Process changed: ${process.processName} - ${process.windowTitle}',
            );
          }
          return process;
        });
  }

  @override
  Future<Either<Failure, bool>> isAvailable() async {
    try {
      final available = await _dataSource.isAvailable();
      return Right(available);
    } catch (e, stackTrace) {
      _logger.error(
        'Error checking process detection availability',
        e,
        stackTrace,
      );
      return Left(
        PlatformFailure(
          message: 'Failed to check platform availability',
          originalError: e,
        ),
      );
    }
  }
}
