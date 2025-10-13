import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:tkit/core/config/app_config.dart';
import 'package:tkit/core/utils/app_logger.dart';
import 'package:tkit/core/errors/exceptions.dart' as app_exceptions;

/// Platform channel for Windows-specific operations
/// Communicates with Windows runner (C++) for process detection
class WindowsPlatformChannel {
  final MethodChannel _channel;
  final AppLogger _logger;

  WindowsPlatformChannel(this._logger)
    : _channel = const MethodChannel(AppConfig.processDetectionChannel) {
    _logger.info('WindowsPlatformChannel initialized');
  }

  /// Get the currently focused Windows process
  /// Returns a map with process information or null if no process is focused
  ///
  /// Returns:
  /// {
  ///   "processName": "notepad.exe",
  ///   "pid": 12345,
  ///   "windowTitle": "Untitled - Notepad",
  ///   "executablePath": "C:\\Windows\\System32\\notepad.exe"
  /// }
  Future<Map<String, dynamic>?> getFocusedProcess() async {
    try {
      _logger.trace('Requesting focused process from platform');

      final result = await _channel.invokeMethod<String>('getFocusedProcess');

      if (result == null || result.isEmpty) {
        _logger.trace('No focused process returned from platform');
        return null;
      }

      final processData = json.decode(result) as Map<String, dynamic>;
      _logger.debug('Focused process: ${processData['processName']}');

      return processData;
    } on PlatformException catch (e, stackTrace) {
      _logger.error(
        'Platform exception while getting focused process',
        e,
        stackTrace,
      );
      throw app_exceptions.PlatformException(
        message: 'Failed to get focused process: ${e.message}',
        code: e.code,
        originalError: e,
      );
    } catch (e, stackTrace) {
      _logger.error(
        'Unexpected error while getting focused process',
        e,
        stackTrace,
      );
      throw app_exceptions.PlatformException(
        message: 'Unexpected error getting focused process',
        originalError: e,
      );
    }
  }

  /// Check if the platform channel is available (i.e., running on Windows)
  Future<bool> isAvailable() async {
    try {
      final result = await _channel.invokeMethod<bool>('isAvailable');
      return result ?? false;
    } catch (e) {
      _logger.warning('Platform channel not available', e);
      return false;
    }
  }
}
