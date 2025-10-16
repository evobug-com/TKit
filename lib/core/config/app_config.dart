import 'package:package_info_plus/package_info_plus.dart';

/// Application configuration constants
class AppConfig {
  // App Information
  static const appName = 'TKit';
  static const appDescription =
      'Twitch Toolkit - Stream category auto-switcher';

  // Version info - cached from package_info_plus
  static String? _cachedVersion;

  /// Get app version from pubspec.yaml (single source of truth)
  static Future<String> getVersion() async {
    if (_cachedVersion != null) {
      return _cachedVersion!;
    }

    final packageInfo = await PackageInfo.fromPlatform();
    _cachedVersion = packageInfo.version;
    return _cachedVersion!;
  }

  /// Get cached version synchronously (must call getVersion() first)
  /// Returns '0.0.0' if not yet initialized
  static String get appVersion => _cachedVersion ?? '0.0.0';

  // Database
  static const databaseName = 'tkit.db';
  static const databaseVersion = 1;

  // API Configuration
  static const twitchClientId = 'cvl099faue5hszx1so8y21844l7avb';
  static const String? twitchClientSecret =
      null; // Set if using confidential client
  static const twitchAuthUrl = 'https://id.twitch.tv/oauth2/authorize';
  static const twitchTokenUrl = 'https://id.twitch.tv/oauth2/token';
  static const twitchApiBaseUrl = 'https://api.twitch.tv/helix';
  static const twitchRedirectUri = 'http://localhost:3000/callback';

  // OAuth Scopes
  static const twitchScopes = <String>[
    'user:read:email',
    'channel:manage:broadcast',
  ];

  // Default Settings
  static const defaultScanIntervalSeconds = 5;
  static const defaultDebounceSeconds = 10;
  static const minScanInterval = 1;
  static const maxScanInterval = 300;
  static const minDebounceInterval = 0;
  static const maxDebounceInterval = 300;

  // Platform Channels
  static const processDetectionChannel =
      'com.evobug.tkit/process_detection';

  // Logging
  static const enableLogging = true;
  static const enableVerboseLogging = false;

  // Window Configuration
  static const double defaultWindowWidth = 1200;
  static const double defaultWindowHeight = 800;
  static const double minWindowWidth = 800;
  static const double minWindowHeight = 600;

  // System Tray
  static const trayTooltip = 'TKit - Twitch Toolkit';
  static const trayIconPath = 'assets/icons/tray_icon.ico';

  // GitHub Repository for Updates
  static const githubOwner = 'evobug-com';
  static const githubRepo = 'TKit';

  // Community Mappings API
  static const communityApiUrl =
      'https://tkit-community-api.siocom.workers.dev';
  static const useCommunityApi = true;
}
