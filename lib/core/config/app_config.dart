import 'package:package_info_plus/package_info_plus.dart';

/// Application configuration constants
class AppConfig {
  // App Information
  static const String appName = 'TKit';
  static const String appDescription =
      'Twitch Toolkit - Stream category auto-switcher';

  // Version info - cached from package_info_plus
  static String? _cachedVersion;

  /// Get app version from pubspec.yaml (single source of truth)
  static Future<String> getVersion() async {
    if (_cachedVersion != null) return _cachedVersion!;

    final packageInfo = await PackageInfo.fromPlatform();
    _cachedVersion = packageInfo.version;
    return _cachedVersion!;
  }

  /// Get cached version synchronously (must call getVersion() first)
  /// Returns '0.0.0' if not yet initialized
  static String get appVersion => _cachedVersion ?? '0.0.0';

  // Database
  static const String databaseName = 'tkit.db';
  static const int databaseVersion = 1;

  // API Configuration
  static const String twitchClientId = 'cvl099faue5hszx1so8y21844l7avb';
  static const String? twitchClientSecret =
      null; // Set if using confidential client
  static const String twitchAuthUrl = 'https://id.twitch.tv/oauth2/authorize';
  static const String twitchTokenUrl = 'https://id.twitch.tv/oauth2/token';
  static const String twitchApiBaseUrl = 'https://api.twitch.tv/helix';
  static const String twitchRedirectUri = 'http://localhost:3000/callback';

  // OAuth Scopes
  static const List<String> twitchScopes = [
    'user:read:email',
    'channel:manage:broadcast',
  ];

  // Default Settings
  static const int defaultScanIntervalSeconds = 5;
  static const int defaultDebounceSeconds = 10;
  static const int minScanInterval = 1;
  static const int maxScanInterval = 300;
  static const int minDebounceInterval = 0;
  static const int maxDebounceInterval = 300;

  // Platform Channels
  static const String processDetectionChannel =
      'com.evobug.tkit/process_detection';

  // Logging
  static const bool enableLogging = true;
  static const bool enableVerboseLogging = false;

  // Window Configuration
  static const double defaultWindowWidth = 1200;
  static const double defaultWindowHeight = 800;
  static const double minWindowWidth = 800;
  static const double minWindowHeight = 600;

  // System Tray
  static const String trayTooltip = 'TKit - Twitch Toolkit';
  static const String trayIconPath = 'assets/icons/tray_icon.ico';

  // GitHub Repository for Updates
  static const String githubOwner = 'evobug-com';
  static const String githubRepo = 'TKit';

  // Community Mappings API
  static const String communityApiUrl =
      'https://tkit-community-api.siocom.workers.dev';
  static const bool useCommunityApi = true;
}
