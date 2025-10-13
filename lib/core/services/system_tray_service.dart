import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';
import '../utils/app_logger.dart';

/// Service for managing system tray integration
class SystemTrayService with TrayListener {
  final AppLogger _logger;
  bool _isInitialized = false;

  VoidCallback? _onShow;
  VoidCallback? _onExit;

  SystemTrayService(this._logger);

  /// Initialize system tray with icon and menu
  Future<void> initialize({
    required VoidCallback onShow,
    required VoidCallback onExit,
    required String showLabel,
    required String exitLabel,
    required String tooltip,
  }) async {
    if (_isInitialized) {
      _logger.warning('System tray already initialized');
      return;
    }

    try {
      _logger.info('Initializing system tray...');

      // Store callbacks
      _onShow = onShow;
      _onExit = onExit;

      // Add listener
      trayManager.addListener(this);

      // Set tray icon
      await trayManager.setIcon(
        Platform.isWindows
            ? 'Assets/Icon512x512.ico'
            : 'Assets/Icon512x512.png',
      );

      // Build context menu
      final menu = Menu(
        items: [
          MenuItem(
            label: showLabel,
            onClick: (_) => onShow(),
          ),
          MenuItem.separator(),
          MenuItem(
            label: exitLabel,
            onClick: (_) => onExit(),
          ),
        ],
      );

      // Set context menu
      await trayManager.setContextMenu(menu);

      // Set tooltip
      await trayManager.setToolTip(tooltip);

      _isInitialized = true;
      _logger.info('System tray initialized successfully');
    } catch (e, stackTrace) {
      _logger.error('Failed to initialize system tray', e, stackTrace);
      // Don't rethrow - tray is not critical for app functionality
    }
  }

  @override
  void onTrayIconMouseDown() {
    _onShow?.call();
  }

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  /// Update tray icon tooltip
  Future<void> updateTooltip(String tooltip) async {
    if (!_isInitialized) return;

    try {
      await trayManager.setToolTip(tooltip);
    } catch (e, stackTrace) {
      _logger.error('Failed to update tray tooltip', e, stackTrace);
    }
  }

  /// Dispose system tray resources
  Future<void> dispose() async {
    if (!_isInitialized) return;

    try {
      trayManager.removeListener(this);
      await trayManager.destroy();
      _isInitialized = false;
      _logger.info('System tray disposed');
    } catch (e, stackTrace) {
      _logger.error('Failed to dispose system tray', e, stackTrace);
    }
  }
}

/// Window manager service with minimize to tray support
class WindowService with WindowListener {
  final AppLogger _logger;
  bool _minimizeToTray = true;

  WindowService(this._logger);

  /// Initialize window service
  Future<void> initialize() async {
    windowManager.addListener(this);
    // Prevent window from closing immediately - trigger onWindowClose instead
    await windowManager.setPreventClose(true);
    _logger.info('Window service initialized');
  }

  /// Set minimize to tray preference
  void setMinimizeToTray(bool enabled) {
    _minimizeToTray = enabled;
    _logger.info('Minimize to tray: $enabled');
  }

  /// Show the main window
  Future<void> showWindow() async {
    try {
      await windowManager.show();
      await windowManager.focus();
      _logger.debug('Window shown');
    } catch (e, stackTrace) {
      _logger.error('Failed to show window', e, stackTrace);
    }
  }

  /// Hide the main window
  Future<void> hideWindow() async {
    try {
      await windowManager.hide();
      _logger.debug('Window hidden');
    } catch (e, stackTrace) {
      _logger.error('Failed to hide window', e, stackTrace);
    }
  }

  /// Toggle window visibility
  Future<void> toggleWindow() async {
    try {
      final isVisible = await windowManager.isVisible();
      if (isVisible) {
        await hideWindow();
      } else {
        await showWindow();
      }
    } catch (e, stackTrace) {
      _logger.error('Failed to toggle window', e, stackTrace);
    }
  }

  @override
  void onWindowClose() {
    // If minimize to tray is enabled, just hide the window
    if (_minimizeToTray) {
      hideWindow();
    } else {
      // Otherwise, actually close the app
      windowManager.destroy();
    }
  }

  @override
  void onWindowMinimize() {
    // Normal minimize behavior - just minimize to taskbar
    // Don't hide to tray on minimize
  }

  /// Dispose window service
  Future<void> dispose() async {
    windowManager.removeListener(this);
    _logger.info('Window service disposed');
  }
}
