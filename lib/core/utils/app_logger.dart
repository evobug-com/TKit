import 'package:logger/logger.dart';
import 'package:talker/talker.dart';

/// Centralized logging utility for the application
/// Wraps both logger and talker for comprehensive logging
/// Registered via CoreModule
class AppLogger {
  static final AppLogger _instance = AppLogger._internal();
  factory AppLogger() => _instance;

  late final Logger _logger;
  late final Talker _talker;

  AppLogger._internal() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
    );

    _talker = Talker(
      logger: TalkerLogger(formatter: const ColoredLoggerFormatter()),
    );
  }

  /// Log debug message
  void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
    _talker.debug(message);
  }

  /// Log info message
  void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
    _talker.info(message);
  }

  /// Log warning message
  void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
    _talker.warning(message);
  }

  /// Log error message
  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
    _talker.error(message, error, stackTrace);
  }

  /// Log fatal/critical error
  void fatal(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
    _talker.critical(message, error, stackTrace);
  }

  /// Log verbose/trace message
  void trace(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.t(message, error: error, stackTrace: stackTrace);
    _talker.verbose(message);
  }

  /// Get talker instance for advanced usage (e.g., showing logs in UI)
  Talker get talker => _talker;

  /// Get logger instance for direct access
  Logger get logger => _logger;

  /// Close loggers and clean up resources
  void dispose() {
    _logger.close();
  }
}
