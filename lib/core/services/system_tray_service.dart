import 'dart:async';
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

      // Set tray icon with retry logic for transient failures
      var retryCount = 0;
      const maxRetries = 3;
      Exception? lastError;

      while (retryCount < maxRetries) {
        try {
          await trayManager.setIcon(
            Platform.isWindows
                ? 'Assets/Icon512x512.ico'
                : 'Assets/Icon512x512.png',
          ).timeout(
            const Duration(seconds: 5),
            onTimeout: () => throw TimeoutException(
              'Tray icon setup timed out',
            ),
          );
          break; // Success, exit retry loop
        } catch (e) {
          lastError = e is Exception ? e : Exception(e.toString());
          retryCount++;
          if (retryCount < maxRetries) {
            _logger.warning(
              'Failed to set tray icon (attempt $retryCount/$maxRetries), retrying...',
            );
            await Future<void>.delayed(Duration(milliseconds: 500 * retryCount));
          }
        }
      }

      if (retryCount == maxRetries && lastError != null) {
        throw lastError;
      }

      // Build context menu
      final menu = Menu(
        items: [
          MenuItem(label: showLabel, onClick: (_) => onShow()),
          MenuItem.separator(),
          MenuItem(label: exitLabel, onClick: (_) => onExit()),
        ],
      );

      // Set context menu
      await trayManager.setContextMenu(menu).timeout(
        const Duration(seconds: 3),
        onTimeout: () => throw TimeoutException('Context menu setup timed out'),
      );

      // Set tooltip
      await trayManager.setToolTip(tooltip).timeout(
        const Duration(seconds: 3),
        onTimeout: () => throw TimeoutException('Tooltip setup timed out'),
      );

      _isInitialized = true;
      _logger.info('System tray initialized successfully');
    } on TimeoutException catch (e, stackTrace) {
      _logger.error(
        'Timeout during system tray initialization: ${e.message}',
        e,
        stackTrace,
      );
      // Don't rethrow - tray is not critical for app functionality
    } on FileSystemException catch (e, stackTrace) {
      _logger.error(
        'File system error during tray initialization (icon not found?): ${e.message}',
        e,
        stackTrace,
      );
    } catch (e, stackTrace) {
      _logger.error(
        'Unexpected error during system tray initialization',
        e,
        stackTrace,
      );
      // Don't rethrow - tray is not critical for app functionality
    }
  }

  @override
  void onTrayIconMouseDown() {
    try {
      _onShow?.call();
    } catch (e, stackTrace) {
      _logger.error('Error handling tray icon click', e, stackTrace);
    }
  }

  @override
  void onTrayIconRightMouseDown() {
    try {
      trayManager.popUpContextMenu();
    } catch (e, stackTrace) {
      _logger.error('Error showing tray context menu', e, stackTrace);
    }
  }

  /// Update tray icon tooltip
  Future<void> updateTooltip(String tooltip) async {
    if (!_isInitialized) {
      _logger.debug('System tray not initialized, skipping tooltip update');
      return;
    }

    try {
      await trayManager.setToolTip(tooltip).timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          _logger.warning('Timeout updating tray tooltip');
        },
      );
    } on TimeoutException catch (e, stackTrace) {
      _logger.error(
        'Timeout updating tray tooltip: ${e.message}',
        e,
        stackTrace,
      );
    } catch (e, stackTrace) {
      _logger.error('Failed to update tray tooltip', e, stackTrace);
    }
  }

  /// Dispose system tray resources
  Future<void> dispose() async {
    if (!_isInitialized) {
      return;
    }

    try {
      trayManager.removeListener(this);
      await trayManager.destroy().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          _logger.warning('Timeout disposing system tray');
        },
      );
      _logger.info('System tray disposed');
    } on TimeoutException catch (e, stackTrace) {
      _logger.error(
        'Timeout during system tray disposal: ${e.message}',
        e,
        stackTrace,
      );
    } catch (e, stackTrace) {
      _logger.error('Failed to dispose system tray', e, stackTrace);
    } finally {
      // Always mark as not initialized, even if disposal failed
      _isInitialized = false;
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
    try {
      windowManager.addListener(this);
      // Prevent window from closing immediately - trigger onWindowClose instead
      await windowManager.setPreventClose(true).timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          _logger.warning('Timeout setting prevent close for window');
        },
      );
      _logger.info('Window service initialized');
    } on TimeoutException catch (e, stackTrace) {
      _logger.error(
        'Timeout during window service initialization',
        e,
        stackTrace,
      );
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to initialize window service',
        e,
        stackTrace,
      );
      // Rethrow as window service is critical
      rethrow;
    }
  }

  /// Check if force exit has been requested (bypasses close-to-tray)
  bool get forceExitRequested => _forceExitRequested;

  /// Request a forced exit that bypasses close-to-tray behavior
  Future<void> forceExit() async {
    try {
      _logger.info('Force exit requested - bypassing close-to-tray');
      _forceExitRequested = true;
      await windowManager.close().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          _logger.warning('Timeout during force exit, window may not close');
        },
      );
    } on TimeoutException catch (e, stackTrace) {
      _logger.error('Timeout during force exit', e, stackTrace);
      // Still try to exit even if window close times out
      _forceExitRequested = true;
    } catch (e, stackTrace) {
      _logger.error('Error during force exit', e, stackTrace);
      // Still mark as requested even if close fails
      _forceExitRequested = true;
      rethrow;
    }
  }

  /// Show the main window
  Future<void> showWindow() async {
    try {
      await windowManager.show().timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          _logger.warning('Timeout showing window');
        },
      );
      await windowManager.focus().timeout(
        const Duration(seconds: 2),
        onTimeout: () {
          _logger.warning('Timeout focusing window');
        },
      );
      _logger.debug('Window shown and focused');
    } on TimeoutException catch (e, stackTrace) {
      _logger.error('Timeout while showing window', e, stackTrace);
    } catch (e, stackTrace) {
      _logger.error('Failed to show window', e, stackTrace);
    }
  }

  /// Hide the main window
  Future<void> hideWindow() async {
    try {
      await windowManager.hide().timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          _logger.warning('Timeout hiding window');
        },
      );
      _logger.debug('Window hidden');
    } on TimeoutException catch (e, stackTrace) {
      _logger.error('Timeout while hiding window', e, stackTrace);
    } catch (e, stackTrace) {
      _logger.error('Failed to hide window', e, stackTrace);
    }
  }

  /// Toggle window visibility
  Future<void> toggleWindow() async {
    try {
      final isVisible = await windowManager.isVisible().timeout(
        const Duration(seconds: 2),
        onTimeout: () {
          _logger.warning('Timeout checking window visibility, assuming hidden');
          return false;
        },
      );
      if (isVisible) {
        await hideWindow();
      } else {
        await showWindow();
      }
    } on TimeoutException catch (e, stackTrace) {
      _logger.error('Timeout while toggling window', e, stackTrace);
      // Fallback: try to show the window
      await showWindow();
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
    try {
      windowManager.removeListener(this);
      _logger.info('Window service disposed');
    } catch (e, stackTrace) {
      _logger.error('Error disposing window service', e, stackTrace);
    }
  }
}
