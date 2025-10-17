import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_manager/window_manager.dart';
import 'package:tkit/core/providers/providers.dart';
import 'package:tkit/core/config/app_config.dart';
import 'package:tkit/core/routing/app_router.dart';
import 'package:tkit/core/services/locale_provider.dart';
import 'package:tkit/features/auth/presentation/states/auth_state.dart';
import 'package:tkit/features/auth/presentation/providers/auth_providers.dart';
import 'package:tkit/features/auto_switcher/data/repositories/auto_switcher_repository_impl.dart';
import 'package:tkit/features/auto_switcher/presentation/providers/auto_switcher_providers.dart';
import 'package:tkit/features/category_mapping/domain/entities/category_mapping.dart';
import 'package:tkit/features/category_mapping/presentation/dialogs/unknown_game_dialog.dart';
import 'package:tkit/features/settings/domain/entities/update_channel.dart';
import 'package:tkit/features/settings/presentation/providers/settings_providers.dart';
import 'package:tkit/features/twitch_api/domain/entities/twitch_category.dart';
import 'package:tkit/presentation/main_window.dart';
import 'package:tkit/presentation/widgets/update_notification_widget.dart';
import 'package:tkit/shared/theme/app_theme.dart';
import 'package:tkit/l10n/app_localizations.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Create a ProviderContainer for initialization
  final container = ProviderContainer();

  try {
    // Load app version
    await AppConfig.getVersion();

    final logger = container.read(appLoggerProvider);
    logger.info('App version: ${AppConfig.appVersion}');

    // Initialize database and seed default mappings
    final database = container.read(databaseProvider);
    logger.info('Database initialized, checking schema...');

    try {
      await database.seedDefaultMappings();
      logger.info('Default mappings seeded successfully');
    } catch (e) {
      logger.warning('Failed to seed default mappings: $e');
    }

    // Check platform channel availability
    final platformChannel = container.read(platformChannelProvider);
    await platformChannel.isAvailable();

    // Configure window manager
    await windowManager.ensureInitialized();

    const windowOptions = WindowOptions(
      size: Size(AppConfig.defaultWindowWidth, AppConfig.defaultWindowHeight),
      minimumSize: Size(AppConfig.minWindowWidth, AppConfig.minWindowHeight),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
      title: AppConfig.appName,
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });

    // Load settings and configure window style
    final getSettingsUseCase = await container.read(
      getSettingsUseCaseProvider.future,
    );
    final initialSettings = await getSettingsUseCase();
    final windowService = container.read(windowServiceProvider);

    await initialSettings.fold(
      (failure) async {
        logger.warning('Could not load settings, using default window style');
        await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
      },
      (settings) async {
        if (settings.useFramelessWindow) {
          await windowManager.setAsFrameless();
          logger.info('Window set to frameless mode');
        } else {
          await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
          logger.info('Window set to normal mode with hidden title bar');
        }
        logger.info(
          'Initial minimize to tray setting: ${settings.minimizeToTray}',
        );
      },
    );

    // Initialize window service
    await windowService.initialize();

    // Watch for settings changes
    final watchSettingsUseCase = await container.read(
      watchSettingsUseCaseProvider.future,
    );
    watchSettingsUseCase().listen((settings) {
      // Settings changes are handled automatically by each component
      logger.debug(
        'Settings updated: minimize to tray = ${settings.minimizeToTray}',
      );
    });

    // Initialize system tray
    final systemTrayService = container.read(systemTrayServiceProvider);
    await systemTrayService.initialize(
      onShow: () async {
        await windowService.showWindow();
      },
      onExit: () async {
        logger.info('Exit requested from system tray');
        // Force exit bypasses close-to-tray behavior
        await windowService.forceExit();
      },
      showLabel: 'Show TKit',
      exitLabel: 'Exit',
      tooltip: 'TKit - Twitch Toolkit',
    );

    // Initialize notification service
    final notificationService = container.read(notificationServiceProvider);
    await notificationService.initialize();

    // Initialize hotkey service
    final hotkeyService = await container.read(hotkeyServiceProvider.future);
    await hotkeyService.initialize();

    // Configure and initialize update service
    final updateService = container.read(updateServiceProvider);
    updateService.setChannelProvider(() async {
      final settings = await getSettingsUseCase();
      return settings.fold(
        (failure) => UpdateChannel.stable,
        (settings) => settings.updateChannel,
      );
    });
    await updateService.initialize();

    // Check for updates on startup
    logger.info('Checking for app updates...');
    final updateChannel = await getSettingsUseCase().then(
      (result) => result.fold(
        (_) => UpdateChannel.stable,
        (settings) => settings.updateChannel,
      ),
    );
    unawaited(
      updateService.checkForUpdates(silent: true, channel: updateChannel),
    );

    logger.info('Initialization complete, launching app...');

    // Check if Sentry should be initialized based on settings and build mode
    // IMPORTANT: Sentry is disabled in debug mode to prevent debug crashes from polluting production data
    final shouldInitializeSentry = kReleaseMode && await getSettingsUseCase().then(
      (result) => result.fold(
        (_) => true, // Default to enabled if settings can't be loaded
        (settings) => settings.enableErrorTracking,
      ),
    );

    // Run app with Riverpod and conditionally initialize Sentry
    if (shouldInitializeSentry) {
      logger.info('Initializing Sentry error tracking...');
      try {
        // Get Sentry configuration from settings
        final sentryConfig = await getSettingsUseCase().then(
          (result) => result.fold(
            (_) => (
              errorTracking: true,
              performanceMonitoring: true,
              sessionReplay: false,
            ),
            (settings) => (
              errorTracking: settings.enableErrorTracking,
              performanceMonitoring: settings.enablePerformanceMonitoring,
              sessionReplay: settings.enableSessionReplay,
            ),
          ),
        );

        await SentryFlutter.init(
          (options) {
            options.dsn =
                'https://ac1a85025dfec5f5ff4e6852bcd19157@o4508065365950464.ingest.de.sentry.io/4510201319325776';

            // Release and environment tracking
            options.release = 'tkit@${AppConfig.appVersion}';
            options.environment = AppConfig.appVersion.contains('dev')
                ? 'development'
                : 'production';

            // Sample rates based on settings (10% for production, 0 to disable)
            options.tracesSampleRate = sentryConfig.performanceMonitoring
                ? 0.1
                : 0.0;
            options.profilesSampleRate = sentryConfig.performanceMonitoring
                ? 0.1
                : 0.0;

            // Note: Session replay configuration will be added when available in Sentry Flutter SDK
            // The setting is available in UI but not yet functional until SDK support is added
            // Track: https://github.com/getsentry/sentry-dart/issues

            // Filter sensitive data before sending
            options.beforeSend = (event, hint) {
              // You can filter or modify events here
              // For example, remove sensitive user data
              return event;
            };
          },
          appRunner: () => runApp(
            UncontrolledProviderScope(
              container: container,
              child: SentryWidget(child: const TKitApp()),
            ),
          ),
        );
      } catch (e, stackTrace) {
        // If Sentry fails to initialize, continue without it
        logger.error(
          'Sentry initialization failed, continuing without error tracking',
          e,
          stackTrace,
        );
        runApp(
          UncontrolledProviderScope(
            container: container,
            child: const TKitApp(),
          ),
        );
      }
    } else {
      if (!kReleaseMode) {
        logger.info('Sentry disabled in debug mode');
      } else {
        logger.info('Sentry disabled in settings, skipping initialization');
      }
      runApp(
        UncontrolledProviderScope(container: container, child: const TKitApp()),
      );
    }
  } catch (e, stackTrace) {
    final logger = container.read(appLoggerProvider);
    logger.fatal('Failed to initialize app', e, stackTrace);
    rethrow;
  }
}

class TKitApp extends ConsumerStatefulWidget {
  const TKitApp({super.key});

  @override
  ConsumerState<TKitApp> createState() => _TKitAppState();
}

class _TKitAppState extends ConsumerState<TKitApp> with WindowListener {
  late final AppRouter _appRouter;
  StreamSubscription<dynamic>? _authSubscription;
  var _initialized = false;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _appRouter = AppRouter();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Schedule initialization after build
    if (!_initialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initializeApp();
      });
    }
  }

  Future<void> _initializeApp() async {
    if (_initialized) {
      return;
    }
    _initialized = true;

    final logger = ref.read(appLoggerProvider);

    // Load saved language or detect system language
    logger.info('Loading saved language');
    final languageService = await ref.read(languageServiceProvider.future);
    final locale = languageService.getCurrentLocale();
    logger.info('Setting locale to: ${locale.languageCode}');
    ref.read(localeProvider.notifier).setLocale(locale);

    // Check auth status
    await ref.read(authProvider.notifier).checkAuthStatus();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Future<void> onWindowClose() async {
    // Get services before any async operations
    final logger = ref.read(appLoggerProvider);
    final windowService = ref.read(windowServiceProvider);

    // If force exit is set (from tray menu), bypass close-to-tray behavior
    if (!windowService.forceExitRequested) {
      // Check if we should minimize to tray instead of closing
      try {
        final getSettingsUseCase = await ref.read(
          getSettingsUseCaseProvider.future,
        );

        final settingsResult = await getSettingsUseCase();

        final shouldMinimizeToTray = settingsResult.fold((failure) {
          logger.warning(
            'Could not load settings, assuming close to tray disabled',
          );
          return false;
        }, (settings) => settings.minimizeToTray);

        if (shouldMinimizeToTray) {
          // Hide window instead of closing
          logger.info('Close to tray enabled - hiding window');
          await windowService.hideWindow();
          return; // Don't proceed with cleanup/destroy
        }
      } catch (e) {
        logger.error('Error checking minimize to tray setting', e);
        // Fall through to normal close behavior on error
      }
    } else {
      logger.info('Force exit requested - bypassing close to tray');
    }

    logger.info('Window close requested - starting fast shutdown');

    unawaited(
      _cleanupResources().catchError((Object e, StackTrace stackTrace) {
        logger.error('Cleanup error', e, stackTrace);
      }),
    );

    try {
      await windowManager.destroy().timeout(
        const Duration(milliseconds: 500),
        onTimeout: () {
          logger.warning('Window destroy timed out - force closing');
        },
      );
    } catch (e) {
      logger.error('Error destroying window', e);
    }
  }

  Future<void> _cleanupResources() async {
    final logger = ref.read(appLoggerProvider);
    logger.info('Starting cleanup...');
    final stopwatch = Stopwatch()..start();

    try {
      final autoSwitcherRepo = await ref.read(
        autoSwitcherRepositoryProvider.future,
      );
      final systemTrayService = ref.read(systemTrayServiceProvider);
      final database = ref.read(databaseProvider);

      await Future.wait([
        Future(() async {
          logger.info('Disposing auto switcher...');
          await autoSwitcherRepo.dispose();
        }),
        Future(() async {
          logger.info('Disposing system tray...');
          await systemTrayService.dispose();
        }),
      ], eagerError: false);

      logger.info('Closing database...');
      await database.close();

      stopwatch.stop();
      logger.info('Cleanup completed in ${stopwatch.elapsedMilliseconds}ms');
    } catch (e, stackTrace) {
      stopwatch.stop();
      logger.error(
        'Cleanup error after ${stopwatch.elapsedMilliseconds}ms',
        e,
        stackTrace,
      );
    }
  }

  Future<void> _handleAuthStateChange(AuthState state) async {
    if (state is Authenticated) {
      // Wire up notification click handler
      final notificationService = ref.read(notificationServiceProvider);
      notificationService.onMissingCategoryClick = ({
        required String processName,
        String? executablePath,
      }) async {
        await _showUnknownGameDialog(
          processName: processName,
          executablePath: executablePath,
          windowTitle: null,
        );
      };

      // Wire up unknown game dialog callback
      final autoSwitcherRepo = await ref.read(
        autoSwitcherRepositoryProvider.future,
      );
      // Cast to implementation to access unknownGameCallback
      if (autoSwitcherRepo is AutoSwitcherRepositoryImpl) {
        autoSwitcherRepo.unknownGameCallback = ({
          required String processName,
          String? executablePath,
          String? windowTitle,
        }) async {
          return await _showUnknownGameDialog(
            processName: processName,
            executablePath: executablePath,
            windowTitle: windowTitle,
          );
        };
      }
    }
  }

  Future<CategoryMapping?> _showUnknownGameDialog({
    required String processName,
    String? executablePath,
    String? windowTitle,
  }) async {
    final navigatorContext = _appRouter.navigatorKey.currentContext;
    if (navigatorContext == null) {
      return null;
    }

    final result = await showDialog<Map<String, dynamic>>(
      context: navigatorContext,
      barrierDismissible: false,
      builder: (context) => UnknownGameDialog(
        processName: processName,
        executablePath: executablePath,
        windowTitle: windowTitle,
      ),
    );

    if (result != null) {
      final category = result['category'] as TwitchCategory?;
      if (category != null) {
        final now = DateTime.now();
        final normalizedPath = result['normalizedInstallPath'] as String?;

        // Create and return a CategoryMapping with all required fields
        return CategoryMapping(
          processName: processName,
          executablePath: executablePath,
          normalizedInstallPaths: normalizedPath != null ? [normalizedPath] : [],
          twitchCategoryId: category.id,
          twitchCategoryName: category.name,
          createdAt: now,
          lastApiFetch: now,
          cacheExpiresAt: now.add(const Duration(hours: 24)),
          manualOverride: true, // User-created mappings are manual overrides
          listId: result['listId'] as String? ?? 'my-custom-mappings',
          isEnabled: result['isEnabled'] as bool? ?? true,
        );
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);

    // Listen to auth state changes (must be in build method)
    ref.listen<AuthState>(authProvider, (previous, next) {
      _handleAuthStateChange(next);
    });

    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      routerConfig: _appRouter.config(),
      builder: (context, child) {
        return UpdateNotificationWidget(
          navigatorKey: _appRouter.navigatorKey,
          child: MainWindow(
            router: _appRouter,
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
