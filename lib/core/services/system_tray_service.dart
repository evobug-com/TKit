import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';
import 'package:tkit/core/utils/app_logger.dart';

/// Service for managing system tray integration
class SystemTrayService with TrayListener {
  final AppLogger _logger;
  var _isInitialized = false;

  VoidCallback? _onShow;

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

      // Store callback
      _onShow = onShow;

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
  var _forceExitRequested = false;

  WindowService(this._logger);

  /// Initialize window service
  Future<void> initialize() async {
    windowManager.addListener(this);
    // Prevent window from closing immediately - trigger onWindowClose instead
    await windowManager.setPreventClose(true);
  }

  /// Check if force exit has been requested (bypasses close-to-tray)
  bool get forceExitRequested => _forceExitRequested;

  /// Request a forced exit that bypasses close-to-tray behavior
  Future<void> forceExit() async {
    _logger.info('Force exit requested - bypassing close-to-tray');
    _forceExitRequested = true;
    await windowManager.close();
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
  Future<void> onWindowClose() async {
    // Window close is now handled in _TKitAppState.onWindowClose()
    // This ensures proper cleanup and respects the minimizeToTray setting
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
