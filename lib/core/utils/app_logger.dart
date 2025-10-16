import 'package:talker/talker.dart';

/// Centralized logging utility for the application
/// Provides structured logging with in-app viewer support (F2 to view logs)
class AppLogger {
  static final _instance = AppLogger._internal();
  factory AppLogger() => _instance;

  late final Talker _talker;

  AppLogger._internal() {
    _talker = Talker(
      logger: TalkerLogger(
        formatter: const ColoredLoggerFormatter(),
        settings: TalkerLoggerSettings(enableColors: true),
      ),
    );
  }

  /// Log debug message
  void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    if (error != null || stackTrace != null) {
      _talker.debug(message);
      if (error != null) {
        _talker.error(error, stackTrace);
      }
    } else {
      _talker.debug(message);
    }
  }

  /// Log info message
  void info(String message, [dynamic error, StackTrace? stackTrace]) {
    if (error != null || stackTrace != null) {
      _talker.info(message);
      if (error != null) {
        _talker.error(error, stackTrace);
      }
    } else {
      _talker.info(message);
    }
  }

  /// Log warning message
  void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    if (error != null || stackTrace != null) {
      _talker.warning(message);
      if (error != null) {
        _talker.error(error, stackTrace);
      }
    } else {
      _talker.warning(message);
    }
  }

  /// Log error message
  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _talker.error(message, error, stackTrace);
  }

  /// Log fatal/critical error
  void fatal(String message, [dynamic error, StackTrace? stackTrace]) {
    _talker.critical(message, error, stackTrace);
  }

  /// Log verbose/trace message
  void trace(String message, [dynamic error, StackTrace? stackTrace]) {
    if (error != null || stackTrace != null) {
      _talker.verbose(message);
      if (error != null) {
        _talker.error(error, stackTrace);
      }
    } else {
      _talker.verbose(message);
    }
  }

  /// Get talker instance for direct access (e.g., TalkerScreen)
  Talker get talker => _talker;

  /// Close loggers and clean up resources
  void dispose() {
    // Talker doesn't need explicit disposal
  }
}
