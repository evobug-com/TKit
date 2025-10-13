import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:tkit/features/auto_switcher/presentation/providers/auto_switcher_provider.dart';
import 'package:tkit/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:tkit/features/settings/domain/usecases/watch_settings_usecase.dart';
import 'package:tkit/core/utils/app_logger.dart';

/// Service for managing application hotkeys
/// Registers and handles keyboard shortcuts for various actions
class HotkeyService {
  final GetSettingsUseCase _getSettings;
  final WatchSettingsUseCase _watchSettings;
  final AutoSwitcherProvider _autoSwitcherProvider;
  final AppLogger _logger;

  StreamSubscription? _settingsSubscription;
  HotKey? _currentManualUpdateHotkey;

  HotkeyService(
    this._getSettings,
    this._watchSettings,
    this._autoSwitcherProvider,
    this._logger,
  );

  /// Initialize the hotkey service
  /// Starts listening for settings changes and registers initial hotkeys
  Future<void> initialize() async {
    try {
      _logger.info('Initializing hotkey service');

      // Only initialize on supported platforms
      if (!kIsWeb && (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux ||
          defaultTargetPlatform == TargetPlatform.macOS)) {
        await hotKeyManager.unregisterAll();
      }

      // Load initial settings and register hotkey
      final initialSettings = await _getSettings();
      initialSettings.fold(
        (failure) {
          _logger.warning('Failed to load initial settings for hotkeys: ${failure.message}');
        },
        (settings) {
          final hotkeyString = settings.manualUpdateHotkey;
          if (hotkeyString != null && hotkeyString.isNotEmpty) {
            _registerManualUpdateHotkey(hotkeyString);
          }
        },
      );

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
        onError: (error) {
          _logger.error('Failed to watch settings for hotkeys', error);
        },
      );

      _logger.info('Hotkey service initialized successfully');
    } catch (e, stackTrace) {
      _logger.error('Failed to initialize hotkey service', e, stackTrace);
    }
  }

  /// Register the manual update hotkey
  Future<void> _registerManualUpdateHotkey(String hotkeyString) async {
    try {
      // Skip if not on a supported platform
      if (kIsWeb || (defaultTargetPlatform != TargetPlatform.windows &&
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

      // Register the hotkey
      await hotKeyManager.register(
        hotKey,
        keyDownHandler: (hotKey) {
          _logger.info('Manual update hotkey pressed');
          _autoSwitcherProvider.manualUpdate();
        },
      );

      _currentManualUpdateHotkey = hotKey;
      _logger.info('Registered manual update hotkey: $hotkeyString');
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
        await hotKeyManager.unregister(_currentManualUpdateHotkey!);
        _logger.info('Unregistered manual update hotkey');
        _currentManualUpdateHotkey = null;
      } catch (e, stackTrace) {
        _logger.error('Failed to unregister manual update hotkey', e, stackTrace);
      }
    }
  }

  /// Parse a hotkey string into a HotKey object
  /// Format: "ctrl+alt+f1", "ctrl+shift+s", etc.
  HotKey? _parseHotKeyString(String hotkeyString) {
    try {
      final parts = hotkeyString.toLowerCase().split('+');
      if (parts.isEmpty) return null;

      PhysicalKeyboardKey? physicalKey;
      final modifiers = <HotKeyModifier>[];

      for (final part in parts) {
        final trimmed = part.trim();
        switch (trimmed) {
          case 'ctrl':
          case 'control':
            modifiers.add(HotKeyModifier.control);
            break;
          case 'alt':
            modifiers.add(HotKeyModifier.alt);
            break;
          case 'shift':
            modifiers.add(HotKeyModifier.shift);
            break;
          case 'meta':
          case 'win':
          case 'cmd':
            modifiers.add(HotKeyModifier.meta);
            break;
          default:
            // Parse physical key
            physicalKey = _parsePhysicalKey(trimmed);
            break;
        }
      }

      if (physicalKey == null) return null;

      return HotKey(
        key: physicalKey,
        modifiers: modifiers,
      );
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
          case 1: return PhysicalKeyboardKey.f1;
          case 2: return PhysicalKeyboardKey.f2;
          case 3: return PhysicalKeyboardKey.f3;
          case 4: return PhysicalKeyboardKey.f4;
          case 5: return PhysicalKeyboardKey.f5;
          case 6: return PhysicalKeyboardKey.f6;
          case 7: return PhysicalKeyboardKey.f7;
          case 8: return PhysicalKeyboardKey.f8;
          case 9: return PhysicalKeyboardKey.f9;
          case 10: return PhysicalKeyboardKey.f10;
          case 11: return PhysicalKeyboardKey.f11;
          case 12: return PhysicalKeyboardKey.f12;
        }
      }
    }

    // Letter keys
    if (key.length == 1) {
      final char = key.toUpperCase();
      if (char.codeUnitAt(0) >= 'A'.codeUnitAt(0) &&
          char.codeUnitAt(0) <= 'Z'.codeUnitAt(0)) {
        switch (char) {
          case 'A': return PhysicalKeyboardKey.keyA;
          case 'B': return PhysicalKeyboardKey.keyB;
          case 'C': return PhysicalKeyboardKey.keyC;
          case 'D': return PhysicalKeyboardKey.keyD;
          case 'E': return PhysicalKeyboardKey.keyE;
          case 'F': return PhysicalKeyboardKey.keyF;
          case 'G': return PhysicalKeyboardKey.keyG;
          case 'H': return PhysicalKeyboardKey.keyH;
          case 'I': return PhysicalKeyboardKey.keyI;
          case 'J': return PhysicalKeyboardKey.keyJ;
          case 'K': return PhysicalKeyboardKey.keyK;
          case 'L': return PhysicalKeyboardKey.keyL;
          case 'M': return PhysicalKeyboardKey.keyM;
          case 'N': return PhysicalKeyboardKey.keyN;
          case 'O': return PhysicalKeyboardKey.keyO;
          case 'P': return PhysicalKeyboardKey.keyP;
          case 'Q': return PhysicalKeyboardKey.keyQ;
          case 'R': return PhysicalKeyboardKey.keyR;
          case 'S': return PhysicalKeyboardKey.keyS;
          case 'T': return PhysicalKeyboardKey.keyT;
          case 'U': return PhysicalKeyboardKey.keyU;
          case 'V': return PhysicalKeyboardKey.keyV;
          case 'W': return PhysicalKeyboardKey.keyW;
          case 'X': return PhysicalKeyboardKey.keyX;
          case 'Y': return PhysicalKeyboardKey.keyY;
          case 'Z': return PhysicalKeyboardKey.keyZ;
        }
      }
    }

    // Special keys
    switch (key) {
      case 'space': return PhysicalKeyboardKey.space;
      case 'enter': return PhysicalKeyboardKey.enter;
      case 'tab': return PhysicalKeyboardKey.tab;
      case 'backspace': return PhysicalKeyboardKey.backspace;
      case 'delete': return PhysicalKeyboardKey.delete;
      case 'escape': return PhysicalKeyboardKey.escape;
      case 'home': return PhysicalKeyboardKey.home;
      case 'end': return PhysicalKeyboardKey.end;
      case 'pageup': return PhysicalKeyboardKey.pageUp;
      case 'pagedown': return PhysicalKeyboardKey.pageDown;
      case 'up': return PhysicalKeyboardKey.arrowUp;
      case 'down': return PhysicalKeyboardKey.arrowDown;
      case 'left': return PhysicalKeyboardKey.arrowLeft;
      case 'right': return PhysicalKeyboardKey.arrowRight;
    }

    return null;
  }

  /// Dispose resources
  void dispose() {
    _settingsSubscription?.cancel();
    _unregisterManualUpdateHotkey();
  }
}
