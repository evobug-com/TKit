import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tkit/features/auto_switcher/presentation/providers/auto_switcher_providers.dart';
import 'package:tkit/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:tkit/features/settings/domain/usecases/watch_settings_usecase.dart';
import 'package:tkit/core/utils/app_logger.dart';

/// Service for managing application hotkeys
/// Registers and handles keyboard shortcuts for various actions
class HotkeyService {
  final GetSettingsUseCase _getSettings;
  final WatchSettingsUseCase _watchSettings;
  final Ref _ref;
  final AppLogger _logger;

  StreamSubscription<dynamic>? _settingsSubscription;
  HotKey? _currentManualUpdateHotkey;

  HotkeyService(
    this._getSettings,
    this._watchSettings,
    this._ref,
    this._logger,
  );

  /// Initialize the hotkey service
  /// Starts listening for settings changes and registers initial hotkeys
  Future<void> initialize() async {
    try {
      _logger.info('Initializing hotkey service');

      // Only initialize on supported platforms
      if (!kIsWeb &&
          (defaultTargetPlatform == TargetPlatform.windows ||
              defaultTargetPlatform == TargetPlatform.linux ||
              defaultTargetPlatform == TargetPlatform.macOS)) {
        try {
          await hotKeyManager.unregisterAll().timeout(
            const Duration(seconds: 5),
            onTimeout: () {
              _logger.warning('Timeout unregistering all hotkeys');
            },
          );
        } on PlatformException catch (e) {
          _logger.warning(
            'Platform error unregistering hotkeys: ${e.message}',
          );
          // Continue initialization even if unregister fails
        } on TimeoutException catch (e) {
          _logger.warning('Timeout unregistering hotkeys: ${e.message}');
        }
      } else {
        _logger.info('Hotkeys not supported on this platform, skipping');
        return;
      }

      // Load initial settings and register hotkey with timeout
      try {
        final initialSettings = await _getSettings().timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            _logger.warning('Timeout loading initial settings for hotkeys');
            throw TimeoutException('Settings load timeout');
          },
        );
        initialSettings.fold(
          (failure) {
            _logger.warning(
              'Failed to load initial settings for hotkeys: ${failure.message}',
            );
          },
          (settings) {
            final hotkeyString = settings.manualUpdateHotkey;
            if (hotkeyString != null && hotkeyString.isNotEmpty) {
              _registerManualUpdateHotkey(hotkeyString);
            }
          },
        );
      } on TimeoutException catch (e, stackTrace) {
        _logger.error(
          'Timeout loading initial settings for hotkeys',
          e,
          stackTrace,
        );
        // Continue without initial hotkey
      }

      // Watch settings for changes
      final settingsStream = _watchSettings();
      _settingsSubscription = settingsStream.listen(
        (settings) {
          final hotkeyString = settings.manualUpdateHotkey;
          if (hotkeyString != null && hotkeyString.isNotEmpty) {
            _registerManualUpdateHotkey(hotkeyString);
          } else {
            _unregisterManualUpdateHotkey();
          }
        },
        onError: (Object error, StackTrace stackTrace) {
          _logger.error(
            'Error in settings stream for hotkeys',
            error,
            stackTrace,
          );
        },
        cancelOnError: false, // Keep listening even if there's an error
      );

      _logger.info('Hotkey service initialized successfully');
    } on PlatformException catch (e, stackTrace) {
      _logger.error(
        'Platform error initializing hotkey service: ${e.message}',
        e,
        stackTrace,
      );
      // Don't rethrow - hotkeys are not critical for app functionality
    } catch (e, stackTrace) {
      _logger.error(
        'Unexpected error initializing hotkey service',
        e,
        stackTrace,
      );
      // Don't rethrow - hotkeys are not critical for app functionality
    }
  }

  /// Register the manual update hotkey
  Future<void> _registerManualUpdateHotkey(String hotkeyString) async {
    try {
      // Skip if not on a supported platform
      if (kIsWeb ||
          (defaultTargetPlatform != TargetPlatform.windows &&
              defaultTargetPlatform != TargetPlatform.linux &&
              defaultTargetPlatform != TargetPlatform.macOS)) {
        _logger.debug('Hotkeys not supported on this platform');
        return;
      }

      // Unregister existing hotkey if any
      await _unregisterManualUpdateHotkey();

      // Parse hotkey string (e.g., "ctrl+alt+f1")
      final hotKey = _parseHotKeyString(hotkeyString);
      if (hotKey == null) {
        _logger.warning('Invalid hotkey format: $hotkeyString');
        return;
      }

      // Register the hotkey with timeout and retry logic
      var retryCount = 0;
      const maxRetries = 2;
      Exception? lastError;

      while (retryCount <= maxRetries) {
        try {
          await hotKeyManager.register(
            hotKey,
            keyDownHandler: (hotKey) {
              try {
                _logger.info('Manual update hotkey pressed');
                _ref.read(autoSwitcherProvider.notifier).manualUpdate();
              } catch (e, stackTrace) {
                _logger.error(
                  'Error handling manual update hotkey press',
                  e,
                  stackTrace,
                );
              }
            },
          ).timeout(
            const Duration(seconds: 5),
            onTimeout: () {
              throw TimeoutException('Hotkey registration timed out');
            },
          );

          _currentManualUpdateHotkey = hotKey;
          _logger.info('Registered manual update hotkey: $hotkeyString');
          return; // Success
        } on PlatformException catch (e) {
          lastError = e;
          if (e.code == 'HOT_KEY_ALREADY_REGISTERED') {
            _logger.error(
              'Hotkey "$hotkeyString" is already registered by another application',
              e,
            );
            return; // Don't retry for this specific error
          }
          retryCount++;
        } on TimeoutException catch (e) {
          lastError = e;
          retryCount++;
        } catch (e) {
          lastError = e is Exception ? e : Exception(e.toString());
          retryCount++;
        }

        if (retryCount <= maxRetries) {
          _logger.warning(
            'Failed to register hotkey (attempt $retryCount/$maxRetries), retrying...',
          );
          await Future<void>.delayed(Duration(milliseconds: 200 * retryCount));
        }
      }

      if (lastError != null) {
        throw lastError;
      }
    } on PlatformException catch (e, stackTrace) {
      _logger.error(
        'Platform error registering hotkey "$hotkeyString": ${e.message}',
        e,
        stackTrace,
      );
    } on TimeoutException catch (e, stackTrace) {
      _logger.error(
        'Timeout registering hotkey "$hotkeyString"',
        e,
        stackTrace,
      );
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to register manual update hotkey: $hotkeyString',
        e,
        stackTrace,
      );
    }
  }

  /// Unregister the manual update hotkey
  Future<void> _unregisterManualUpdateHotkey() async {
    if (_currentManualUpdateHotkey != null) {
      try {
        await hotKeyManager.unregister(_currentManualUpdateHotkey!).timeout(
          const Duration(seconds: 3),
          onTimeout: () {
            _logger.warning('Timeout unregistering manual update hotkey');
          },
        );
        _logger.info('Unregistered manual update hotkey');
      } on PlatformException catch (e, stackTrace) {
        _logger.error(
          'Platform error unregistering hotkey: ${e.message}',
          e,
          stackTrace,
        );
      } on TimeoutException catch (e, stackTrace) {
        _logger.error(
          'Timeout unregistering manual update hotkey',
          e,
          stackTrace,
        );
      } catch (e, stackTrace) {
        _logger.error(
          'Failed to unregister manual update hotkey',
          e,
          stackTrace,
        );
      } finally {
        // Always clear the reference, even if unregister fails
        _currentManualUpdateHotkey = null;
      }
    }
  }

  /// Parse a hotkey string into a HotKey object
  /// Format: "ctrl+alt+f1", "ctrl+shift+s", etc.
  HotKey? _parseHotKeyString(String hotkeyString) {
    try {
      final parts = hotkeyString.toLowerCase().split('+');
      if (parts.isEmpty) {
        return null;
      }

      PhysicalKeyboardKey? physicalKey;
      final modifiers = <HotKeyModifier>[];

      for (final part in parts) {
        final trimmed = part.trim();
        switch (trimmed) {
          case 'ctrl':
          case 'control':
            modifiers.add(HotKeyModifier.control);
          case 'alt':
            modifiers.add(HotKeyModifier.alt);
          case 'shift':
            modifiers.add(HotKeyModifier.shift);
          case 'meta':
          case 'win':
          case 'cmd':
            modifiers.add(HotKeyModifier.meta);
          default:
            // Parse physical key
            physicalKey = _parsePhysicalKey(trimmed);
        }
      }

      if (physicalKey == null) {
        return null;
      }

      return HotKey(key: physicalKey, modifiers: modifiers);
    } catch (e) {
      _logger.warning('Failed to parse hotkey string: $hotkeyString', e);
      return null;
    }
  }

  /// Parse a physical key from a string
  PhysicalKeyboardKey? _parsePhysicalKey(String key) {
    // Function keys
    if (key.startsWith('f') && key.length > 1) {
      final num = int.tryParse(key.substring(1));
      if (num != null && num >= 1 && num <= 12) {
        switch (num) {
          case 1:
            return PhysicalKeyboardKey.f1;
          case 2:
            return PhysicalKeyboardKey.f2;
          case 3:
            return PhysicalKeyboardKey.f3;
          case 4:
            return PhysicalKeyboardKey.f4;
          case 5:
            return PhysicalKeyboardKey.f5;
          case 6:
            return PhysicalKeyboardKey.f6;
          case 7:
            return PhysicalKeyboardKey.f7;
          case 8:
            return PhysicalKeyboardKey.f8;
          case 9:
            return PhysicalKeyboardKey.f9;
          case 10:
            return PhysicalKeyboardKey.f10;
          case 11:
            return PhysicalKeyboardKey.f11;
          case 12:
            return PhysicalKeyboardKey.f12;
        }
      }
    }

    // Letter keys
    if (key.length == 1) {
      final char = key.toUpperCase();
      if (char.codeUnitAt(0) >= 'A'.codeUnitAt(0) &&
          char.codeUnitAt(0) <= 'Z'.codeUnitAt(0)) {
        switch (char) {
          case 'A':
            return PhysicalKeyboardKey.keyA;
          case 'B':
            return PhysicalKeyboardKey.keyB;
          case 'C':
            return PhysicalKeyboardKey.keyC;
          case 'D':
            return PhysicalKeyboardKey.keyD;
          case 'E':
            return PhysicalKeyboardKey.keyE;
          case 'F':
            return PhysicalKeyboardKey.keyF;
          case 'G':
            return PhysicalKeyboardKey.keyG;
          case 'H':
            return PhysicalKeyboardKey.keyH;
          case 'I':
            return PhysicalKeyboardKey.keyI;
          case 'J':
            return PhysicalKeyboardKey.keyJ;
          case 'K':
            return PhysicalKeyboardKey.keyK;
          case 'L':
            return PhysicalKeyboardKey.keyL;
          case 'M':
            return PhysicalKeyboardKey.keyM;
          case 'N':
            return PhysicalKeyboardKey.keyN;
          case 'O':
            return PhysicalKeyboardKey.keyO;
          case 'P':
            return PhysicalKeyboardKey.keyP;
          case 'Q':
            return PhysicalKeyboardKey.keyQ;
          case 'R':
            return PhysicalKeyboardKey.keyR;
          case 'S':
            return PhysicalKeyboardKey.keyS;
          case 'T':
            return PhysicalKeyboardKey.keyT;
          case 'U':
            return PhysicalKeyboardKey.keyU;
          case 'V':
            return PhysicalKeyboardKey.keyV;
          case 'W':
            return PhysicalKeyboardKey.keyW;
          case 'X':
            return PhysicalKeyboardKey.keyX;
          case 'Y':
            return PhysicalKeyboardKey.keyY;
          case 'Z':
            return PhysicalKeyboardKey.keyZ;
        }
      }
    }

    // Special keys
    switch (key) {
      case 'space':
        return PhysicalKeyboardKey.space;
      case 'enter':
        return PhysicalKeyboardKey.enter;
      case 'tab':
        return PhysicalKeyboardKey.tab;
      case 'backspace':
        return PhysicalKeyboardKey.backspace;
      case 'delete':
        return PhysicalKeyboardKey.delete;
      case 'escape':
        return PhysicalKeyboardKey.escape;
      case 'home':
        return PhysicalKeyboardKey.home;
      case 'end':
        return PhysicalKeyboardKey.end;
      case 'pageup':
        return PhysicalKeyboardKey.pageUp;
      case 'pagedown':
        return PhysicalKeyboardKey.pageDown;
      case 'up':
        return PhysicalKeyboardKey.arrowUp;
      case 'down':
        return PhysicalKeyboardKey.arrowDown;
      case 'left':
        return PhysicalKeyboardKey.arrowLeft;
      case 'right':
        return PhysicalKeyboardKey.arrowRight;
    }

    return null;
  }

  /// Dispose resources
  Future<void> dispose() async {
    try {
      await _settingsSubscription?.cancel();
      await _unregisterManualUpdateHotkey();
      _logger.info('Hotkey service disposed');
    } catch (e, stackTrace) {
      _logger.error('Error disposing hotkey service', e, stackTrace);
    }
  }
}
