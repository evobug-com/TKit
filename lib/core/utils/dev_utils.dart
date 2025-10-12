import 'package:flutter/foundation.dart';

/// Development utilities
class DevUtils {
  DevUtils._();

  /// Check if running in development mode
  static bool get isDevelopment => kDebugMode;

  /// Check if running in release mode
  static bool get isRelease => kReleaseMode;

  /// Check if running in profile mode
  static bool get isProfile => kProfileMode;
}
