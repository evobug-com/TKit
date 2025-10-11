import '../../../../core/platform/windows_platform_channel.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/process_info_model.dart';

/// Data source for process detection using platform channels
class ProcessDetectionPlatformDataSource {
  final WindowsPlatformChannel _platformChannel;
  final AppLogger _logger;

  ProcessDetectionPlatformDataSource(this._platformChannel, this._logger);

  /// Get the currently focused process from the platform
  /// Returns null if no process is focused
  /// Throws PlatformException if detection fails
  Future<ProcessInfoModel?> getFocusedProcess() async {
    try {
      _logger.trace('Requesting focused process from platform channel');

      final processData = await _platformChannel.getFocusedProcess();

      if (processData == null) {
        _logger.trace('No focused process returned');
        return null;
      }

      final model = ProcessInfoModel.fromJson(processData);
      _logger.debug('Process detected: ${model.processName}');

      return model;
    } on PlatformException {
      rethrow;
    } catch (e, stackTrace) {
      _logger.error(
        'Unexpected error in process detection data source',
        e,
        stackTrace,
      );
      throw PlatformException(
        message: 'Failed to get focused process',
        originalError: e,
      );
    }
  }

  /// Check if process detection is available
  Future<bool> isAvailable() async {
    try {
      return await _platformChannel.isAvailable();
    } catch (e, stackTrace) {
      _logger.warning('Error checking platform availability', e, stackTrace);
      return false;
    }
  }
}
