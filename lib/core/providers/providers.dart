import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tkit/core/database/app_database.dart';
import 'package:tkit/core/platform/windows_platform_channel.dart';
import 'package:tkit/core/services/hotkey_service.dart';
import 'package:tkit/core/services/language_service.dart';
import 'package:tkit/core/services/notification_service.dart';
import 'package:tkit/core/services/system_tray_service.dart';
import 'package:tkit/core/services/updater/github_update_service.dart';
import 'package:tkit/core/utils/app_logger.dart';
import 'package:tkit/features/settings/presentation/providers/settings_providers.dart';

part 'providers.g.dart';

// =============================================================================
// CORE DEPENDENCIES
// =============================================================================

/// Provides the app logger instance
@Riverpod(keepAlive: true)
AppLogger appLogger(Ref ref) {
  return AppLogger();
}

/// Provides SharedPreferences instance
@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(Ref ref) async {
  return await SharedPreferences.getInstance();
}

/// Provides Auth Dio instance (no interceptors, for OAuth)
@Riverpod(keepAlive: true)
Dio authDio(Ref ref) {
  return Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    ),
  );
}

/// Provides API Dio instance (with auth interceptors)
@Riverpod(keepAlive: true)
Dio apiDio(Ref ref) {
  return Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    ),
  );
}

/// Provides FlutterSecureStorage instance
@Riverpod(keepAlive: true)
FlutterSecureStorage secureStorage(Ref ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
}

/// Provides AppDatabase instance
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final database = AppDatabase();
  ref.onDispose(() {
    database.close();
  });
  return database;
}

// =============================================================================
// CORE SERVICES
// =============================================================================

/// Provides WindowsPlatformChannel
@Riverpod(keepAlive: true)
WindowsPlatformChannel windowsPlatformChannel(Ref ref) {
  final logger = ref.watch(appLoggerProvider);
  return WindowsPlatformChannel(logger);
}

/// Provides LanguageService
@Riverpod(keepAlive: true)
Future<LanguageService> languageService(Ref ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  final logger = ref.watch(appLoggerProvider);
  return LanguageService(prefs, logger);
}

/// Provides SystemTrayService
@Riverpod(keepAlive: true)
SystemTrayService systemTrayService(Ref ref) {
  final logger = ref.watch(appLoggerProvider);
  final service = SystemTrayService(logger);
  ref.onDispose(() {
    service.dispose();
  });
  return service;
}

/// Provides GitHubUpdateService
@Riverpod(keepAlive: true)
GitHubUpdateService githubUpdateService(Ref ref) {
  final authDio = ref.watch(authDioProvider);
  final logger = ref.watch(appLoggerProvider);
  return GitHubUpdateService(authDio, logger);
}

/// Provides NotificationService
@Riverpod(keepAlive: true)
NotificationService notificationService(Ref ref) {
  final logger = ref.watch(appLoggerProvider);
  return NotificationService(logger);
}

/// Provides WindowService
@Riverpod(keepAlive: true)
WindowService windowService(Ref ref) {
  final logger = ref.watch(appLoggerProvider);
  final service = WindowService(logger);
  ref.onDispose(() {
    service.dispose();
  });
  return service;
}

/// Provides HotkeyService
@Riverpod(keepAlive: true)
Future<HotkeyService> hotkeyService(Ref ref) async {
  final getSettings = await ref.watch(getSettingsUseCaseProvider.future);
  final watchSettings = await ref.watch(watchSettingsUseCaseProvider.future);
  final logger = ref.watch(appLoggerProvider);
  final service = HotkeyService(getSettings, watchSettings, ref, logger);
  ref.onDispose(() {
    service.dispose();
  });
  return service;
}

// Convenience aliases for commonly used names
final databaseProvider = appDatabaseProvider;
final platformChannelProvider = windowsPlatformChannelProvider;
final updateServiceProvider = githubUpdateServiceProvider;
