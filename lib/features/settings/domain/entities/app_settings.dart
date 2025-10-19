import 'package:equatable/equatable.dart';
import 'package:tkit/features/settings/domain/entities/fallback_behavior.dart';
import 'package:tkit/features/settings/domain/entities/update_channel.dart';
import 'package:tkit/features/settings/domain/entities/window_controls_position.dart';

/// Sentinel value to indicate "use current value" vs "set to null"
class _Undefined {
  const _Undefined();
}

const _undefined = _Undefined();

/// Application settings entity
/// Pure domain entity with no external dependencies
class AppSettings extends Equatable {
  /// How often to scan for focused process (in seconds)
  /// Valid range: 1-300 seconds
  final int scanIntervalSeconds;

  /// Debounce time before updating category (in seconds)
  /// Valid range: 0-300 seconds
  final int debounceSeconds;

  /// Behavior when no category mapping is found
  final FallbackBehavior fallbackBehavior;

  /// Custom fallback category ID (only used if fallbackBehavior is custom)
  final String? customFallbackCategoryId;

  /// Custom fallback category name (for display)
  final String? customFallbackCategoryName;

  /// Auto-start application with Windows
  final bool autoStartWithWindows;

  /// Start application minimized to tray on launch
  final bool startMinimized;

  /// Minimize to system tray on close/minimize
  final bool minimizeToTray;

  /// Show notifications for category updates
  final bool showNotifications;

  /// Show notification when no category mapping is found
  final bool notifyOnMissingCategory;

  /// Automatically start monitoring when application starts
  final bool autoStartMonitoring;

  /// Hotkey for manual update (e.g., "ctrl+alt+f1")
  final String? manualUpdateHotkey;

  /// Update channel preference (stable, rc, beta, dev)
  final UpdateChannel updateChannel;

  /// Automatically check for updates on app launch
  final bool autoCheckForUpdates;

  /// Automatically install updates when downloaded (shows notification before install)
  final bool autoInstallUpdates;

  /// Window controls position (left, center, right)
  final WindowControlsPosition windowControlsPosition;

  /// Use frameless window (remove Windows title bar)
  final bool useFramelessWindow;

  /// Invert footer and header positions
  final bool invertFooterHeader;

  /// Auto-sync mappings on app start
  final bool autoSyncMappingsOnStart;

  /// How often to auto-sync mappings (in hours)
  /// Valid range: 1-168 hours (1 week)
  final int mappingsSyncIntervalHours;

  /// Enable error tracking with Sentry
  final bool enableErrorTracking;

  /// Enable performance monitoring with Sentry
  final bool enablePerformanceMonitoring;

  /// Enable session replay with Sentry
  final bool enableSessionReplay;

  const AppSettings({
    required this.scanIntervalSeconds,
    required this.debounceSeconds,
    required this.fallbackBehavior,
    this.customFallbackCategoryId,
    this.customFallbackCategoryName,
    required this.autoStartWithWindows,
    required this.startMinimized,
    required this.minimizeToTray,
    required this.showNotifications,
    required this.notifyOnMissingCategory,
    required this.autoStartMonitoring,
    this.manualUpdateHotkey,
    required this.updateChannel,
    required this.autoCheckForUpdates,
    required this.autoInstallUpdates,
    required this.windowControlsPosition,
    required this.useFramelessWindow,
    required this.invertFooterHeader,
    required this.autoSyncMappingsOnStart,
    required this.mappingsSyncIntervalHours,
    required this.enableErrorTracking,
    required this.enablePerformanceMonitoring,
    required this.enableSessionReplay,
  });

  /// Default settings for first-time users
  /// Automatically detects update channel from app version
  factory AppSettings.defaults({String? appVersion}) {
    return AppSettings(
      scanIntervalSeconds: 5,
      debounceSeconds: 10,
      fallbackBehavior: FallbackBehavior.doNothing,
      customFallbackCategoryId: null,
      customFallbackCategoryName: null,
      autoStartWithWindows: false,
      startMinimized: false,
      minimizeToTray: true,
      showNotifications: true,
      notifyOnMissingCategory: true,
      autoStartMonitoring: false,
      manualUpdateHotkey: 'alt+shift+f1',
      updateChannel: _detectChannelFromVersion(appVersion),
      autoCheckForUpdates: true, // Check for updates on launch by default
      autoInstallUpdates: false, // Require user confirmation by default
      windowControlsPosition: WindowControlsPosition.right,
      useFramelessWindow: false,
      invertFooterHeader: false,
      autoSyncMappingsOnStart: true,
      mappingsSyncIntervalHours: 6,
      enableErrorTracking: true,
      enablePerformanceMonitoring: true,
      enableSessionReplay: false, // Disabled by default due to privacy concerns
    );
  }

  /// Detect update channel from app version string
  /// - If version contains '-dev' or '-alpha' → Dev channel
  /// - If version contains '-beta' → Beta channel
  /// - If version contains '-rc' → RC channel
  /// - Otherwise → Stable channel
  static UpdateChannel _detectChannelFromVersion(String? version) {
    if (version == null || version.isEmpty) {
      return UpdateChannel.stable;
    }

    final lowerVersion = version.toLowerCase();

    if (lowerVersion.contains('-dev') || lowerVersion.contains('-alpha')) {
      return UpdateChannel.dev;
    } else if (lowerVersion.contains('-beta')) {
      return UpdateChannel.beta;
    } else if (lowerVersion.contains('-rc')) {
      return UpdateChannel.rc;
    }

    return UpdateChannel.stable;
  }

  /// Create a copy with updated values
  /// For nullable fields, pass the value directly to set it (including null)
  /// or omit the parameter to keep the current value
  AppSettings copyWith({
    int? scanIntervalSeconds,
    int? debounceSeconds,
    FallbackBehavior? fallbackBehavior,
    Object? customFallbackCategoryId = _undefined,
    Object? customFallbackCategoryName = _undefined,
    bool? autoStartWithWindows,
    bool? startMinimized,
    bool? minimizeToTray,
    bool? showNotifications,
    bool? notifyOnMissingCategory,
    bool? autoStartMonitoring,
    Object? manualUpdateHotkey = _undefined,
    UpdateChannel? updateChannel,
    bool? autoCheckForUpdates,
    bool? autoInstallUpdates,
    WindowControlsPosition? windowControlsPosition,
    bool? useFramelessWindow,
    bool? invertFooterHeader,
    bool? autoSyncMappingsOnStart,
    int? mappingsSyncIntervalHours,
    bool? enableErrorTracking,
    bool? enablePerformanceMonitoring,
    bool? enableSessionReplay,
  }) {
    return AppSettings(
      scanIntervalSeconds: scanIntervalSeconds ?? this.scanIntervalSeconds,
      debounceSeconds: debounceSeconds ?? this.debounceSeconds,
      fallbackBehavior: fallbackBehavior ?? this.fallbackBehavior,
      customFallbackCategoryId: customFallbackCategoryId == _undefined
          ? this.customFallbackCategoryId
          : customFallbackCategoryId as String?,
      customFallbackCategoryName: customFallbackCategoryName == _undefined
          ? this.customFallbackCategoryName
          : customFallbackCategoryName as String?,
      autoStartWithWindows: autoStartWithWindows ?? this.autoStartWithWindows,
      startMinimized: startMinimized ?? this.startMinimized,
      minimizeToTray: minimizeToTray ?? this.minimizeToTray,
      showNotifications: showNotifications ?? this.showNotifications,
      notifyOnMissingCategory:
          notifyOnMissingCategory ?? this.notifyOnMissingCategory,
      autoStartMonitoring: autoStartMonitoring ?? this.autoStartMonitoring,
      manualUpdateHotkey: manualUpdateHotkey == _undefined
          ? this.manualUpdateHotkey
          : manualUpdateHotkey as String?,
      updateChannel: updateChannel ?? this.updateChannel,
      autoCheckForUpdates: autoCheckForUpdates ?? this.autoCheckForUpdates,
      autoInstallUpdates: autoInstallUpdates ?? this.autoInstallUpdates,
      windowControlsPosition:
          windowControlsPosition ?? this.windowControlsPosition,
      useFramelessWindow: useFramelessWindow ?? this.useFramelessWindow,
      invertFooterHeader: invertFooterHeader ?? this.invertFooterHeader,
      autoSyncMappingsOnStart:
          autoSyncMappingsOnStart ?? this.autoSyncMappingsOnStart,
      mappingsSyncIntervalHours:
          mappingsSyncIntervalHours ?? this.mappingsSyncIntervalHours,
      enableErrorTracking: enableErrorTracking ?? this.enableErrorTracking,
      enablePerformanceMonitoring:
          enablePerformanceMonitoring ?? this.enablePerformanceMonitoring,
      enableSessionReplay: enableSessionReplay ?? this.enableSessionReplay,
    );
  }

  /// Validate settings values
  /// Returns null if valid, error message if invalid
  String? validate() {
    if (scanIntervalSeconds < 1 || scanIntervalSeconds > 300) {
      return 'Scan interval must be between 1 and 300 seconds';
    }
    if (debounceSeconds < 0 || debounceSeconds > 300) {
      return 'Debounce must be between 0 and 300 seconds';
    }
    if (fallbackBehavior == FallbackBehavior.custom &&
        (customFallbackCategoryId == null ||
            customFallbackCategoryId!.isEmpty)) {
      return 'Custom fallback category must be specified';
    }
    if (mappingsSyncIntervalHours < 0 || mappingsSyncIntervalHours > 168) {
      return 'Mappings sync interval must be between 0 and 168 hours';
    }
    return null;
  }

  /// Check if settings are valid
  bool get isValid => validate() == null;

  @override
  List<Object?> get props => [
    scanIntervalSeconds,
    debounceSeconds,
    fallbackBehavior,
    customFallbackCategoryId,
    customFallbackCategoryName,
    autoStartWithWindows,
    startMinimized,
    minimizeToTray,
    showNotifications,
    notifyOnMissingCategory,
    autoStartMonitoring,
    manualUpdateHotkey,
    updateChannel,
    autoCheckForUpdates,
    autoInstallUpdates,
    windowControlsPosition,
    useFramelessWindow,
    invertFooterHeader,
    autoSyncMappingsOnStart,
    mappingsSyncIntervalHours,
    enableErrorTracking,
    enablePerformanceMonitoring,
    enableSessionReplay,
  ];
}
