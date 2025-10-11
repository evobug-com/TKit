import 'package:get_it/get_it.dart';
import '../database/app_database.dart';
import '../platform/windows_platform_channel.dart';
import '../utils/app_logger.dart';

/// Global GetIt instance for dependency injection
final getIt = GetIt.instance;

/// Configure all dependencies for the application
///
/// This function registers core dependencies as lazy singletons:
/// - [AppDatabase]: Database instance
/// - [WindowsPlatformChannel]: Platform channel for Windows-specific features
/// - [AppLogger]: Application logger
///
/// Call this function at app startup before accessing any dependencies.
Future<void> configureDependencies() async {
  // Reset existing registrations to ensure clean state
  await resetDependencies();

  // -------------------------------------------------------------------------
  // Core Dependencies (Lazy Singletons)
  // -------------------------------------------------------------------------

  // Register AppDatabase as lazy singleton
  // Lazy singleton means instance is created only when first accessed
  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());

  // Register WindowsPlatformChannel as lazy singleton
  // Requires AppLogger dependency
  getIt.registerLazySingleton<WindowsPlatformChannel>(
    () => WindowsPlatformChannel(getIt<AppLogger>()),
  );

  // Register AppLogger as lazy singleton
  // AppLogger is already a singleton itself, but we register it for consistency
  getIt.registerLazySingleton<AppLogger>(() => AppLogger());
}

/// Reset all registered dependencies
///
/// Clears all registrations from the GetIt instance.
/// Useful for testing or when you need to reconfigure dependencies.
Future<void> resetDependencies() async {
  await getIt.reset();
}
