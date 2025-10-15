import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tkit/core/database/app_database.dart';
import 'package:tkit/core/platform/windows_platform_channel.dart';
import 'package:tkit/core/utils/app_logger.dart';
import 'package:tkit/core/config/app_config.dart';
import 'package:tkit/core/routing/app_router.dart';
import 'package:tkit/core/services/system_tray_service.dart';
import 'package:tkit/core/services/hotkey_service.dart';
import 'package:tkit/core/services/language_service.dart';
import 'package:tkit/core/services/locale_provider.dart';
import 'package:tkit/core/services/notification_service.dart';
import 'package:tkit/core/services/updater/github_update_service.dart';
import 'package:tkit/features/auth/data/datasources/token_local_datasource.dart';
import 'package:tkit/features/auth/data/datasources/twitch_auth_remote_datasource.dart';
import 'package:tkit/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:tkit/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:tkit/features/auth/presentation/states/auth_state.dart';
import 'package:tkit/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:tkit/features/auth/domain/usecases/get_current_user_usecase.dart'
    as auth_get_user;
import 'package:tkit/features/auth/domain/usecases/logout_usecase.dart';
import 'package:tkit/features/auth/domain/usecases/refresh_token_usecase.dart';
import 'package:tkit/features/auth/presentation/providers/auth_provider.dart';
import 'package:tkit/features/auto_switcher/data/datasources/update_history_local_datasource.dart';
import 'package:tkit/features/auto_switcher/data/repositories/auto_switcher_repository_impl.dart';
import 'package:tkit/features/auto_switcher/domain/repositories/i_auto_switcher_repository.dart';
import 'package:tkit/features/auto_switcher/domain/usecases/get_orchestration_status_usecase.dart';
import 'package:tkit/features/auto_switcher/domain/usecases/get_update_history_usecase.dart';
import 'package:tkit/features/auto_switcher/domain/usecases/manual_update_usecase.dart';
import 'package:tkit/features/auto_switcher/domain/usecases/start_monitoring_usecase.dart';
import 'package:tkit/features/auto_switcher/domain/usecases/stop_monitoring_usecase.dart';
import 'package:tkit/features/auto_switcher/presentation/providers/auto_switcher_provider.dart';
import 'package:tkit/features/category_mapping/data/datasources/category_mapping_local_datasource.dart';
import 'package:tkit/features/category_mapping/data/datasources/unknown_process_datasource.dart';
import 'package:tkit/features/category_mapping/data/datasources/mapping_importer.dart';
import 'package:tkit/features/category_mapping/data/datasources/memory_cache.dart';
import 'package:tkit/features/category_mapping/data/repositories/category_mapping_repository_impl.dart';
import 'package:tkit/features/category_mapping/domain/entities/category_mapping.dart';
import 'package:tkit/features/category_mapping/domain/repositories/i_category_mapping_repository.dart';
import 'package:tkit/features/category_mapping/domain/usecases/delete_mapping_usecase.dart';
import 'package:tkit/features/category_mapping/domain/usecases/export_mappings_usecase.dart';
import 'package:tkit/features/category_mapping/domain/usecases/find_mapping_usecase.dart';
import 'package:tkit/features/category_mapping/domain/usecases/get_all_mappings_usecase.dart';
import 'package:tkit/features/category_mapping/domain/usecases/import_mappings_usecase.dart';
import 'package:tkit/features/category_mapping/domain/usecases/refresh_expired_mappings_usecase.dart';
import 'package:tkit/features/category_mapping/domain/usecases/refresh_expiring_soon_usecase.dart';
import 'package:tkit/features/category_mapping/domain/usecases/save_mapping_usecase.dart';
import 'package:tkit/features/category_mapping/domain/usecases/update_last_used_usecase.dart';
import 'package:tkit/features/category_mapping/presentation/providers/category_mapping_provider.dart';
import 'package:tkit/features/category_mapping/presentation/dialogs/unknown_game_dialog.dart';
import 'package:tkit/features/mapping_lists/data/datasources/mapping_list_local_datasource.dart';
import 'package:tkit/features/mapping_lists/data/datasources/mapping_list_sync_datasource.dart';
import 'package:tkit/features/mapping_lists/data/repositories/mapping_list_repository_impl.dart';
import 'package:tkit/features/mapping_lists/domain/repositories/i_mapping_list_repository.dart';
import 'package:tkit/features/mapping_lists/domain/usecases/get_all_lists_usecase.dart';
import 'package:tkit/features/mapping_lists/domain/usecases/sync_list_usecase.dart';
import 'package:tkit/features/mapping_lists/domain/usecases/import_list_from_url_usecase.dart';
import 'package:tkit/features/mapping_lists/domain/usecases/toggle_list_enabled_usecase.dart';
import 'package:tkit/features/mapping_lists/presentation/providers/mapping_list_provider.dart';
import 'package:tkit/features/mapping_submission/data/datasources/mapping_submission_datasource.dart';
import 'package:tkit/features/mapping_submission/domain/usecases/submit_mapping_usecase.dart';
import 'package:tkit/features/process_detection/data/datasources/process_detection_platform_datasource.dart';
import 'package:tkit/features/process_detection/data/repositories/process_detection_repository_impl.dart';
import 'package:tkit/features/process_detection/domain/repositories/i_process_detection_repository.dart';
import 'package:tkit/features/process_detection/domain/usecases/get_focused_process_usecase.dart';
import 'package:tkit/features/process_detection/domain/usecases/watch_process_changes_usecase.dart';
import 'package:tkit/features/process_detection/presentation/providers/process_detection_provider.dart';
import 'package:tkit/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:tkit/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:tkit/features/settings/domain/repositories/i_settings_repository.dart';
import 'package:tkit/features/settings/domain/entities/update_channel.dart';
import 'package:tkit/features/settings/domain/usecases/factory_reset_usecase.dart';
import 'package:tkit/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:tkit/features/settings/domain/usecases/update_settings_usecase.dart';
import 'package:tkit/features/settings/domain/usecases/watch_settings_usecase.dart';
import 'package:tkit/features/settings/presentation/providers/settings_provider.dart';
import 'package:tkit/features/settings/presentation/providers/window_controls_preview_provider.dart';
import 'package:tkit/features/settings/presentation/providers/unsaved_changes_notifier.dart';
import 'package:tkit/features/twitch_api/data/datasources/twitch_api_remote_datasource.dart';
import 'package:tkit/features/twitch_api/data/repositories/twitch_api_repository_impl.dart';
import 'package:tkit/features/twitch_api/domain/repositories/i_twitch_api_repository.dart';
import 'package:tkit/features/twitch_api/domain/usecases/get_category_by_id_usecase.dart';
import 'package:tkit/features/twitch_api/domain/usecases/get_current_user_usecase.dart'
    as twitch_get_user;
import 'package:tkit/features/twitch_api/domain/entities/twitch_category.dart';
import 'package:tkit/features/twitch_api/domain/usecases/get_games_by_ids_usecase.dart';
import 'package:tkit/features/twitch_api/domain/usecases/get_games_by_names_usecase.dart';
import 'package:tkit/features/twitch_api/domain/usecases/get_top_games_usecase.dart';
import 'package:tkit/features/twitch_api/domain/usecases/search_categories_usecase.dart';
import 'package:tkit/features/twitch_api/domain/usecases/update_channel_category_usecase.dart';
import 'package:tkit/features/twitch_api/presentation/providers/twitch_api_provider.dart';
import 'package:tkit/presentation/main_window.dart';
import 'package:tkit/presentation/widgets/update_notification_widget.dart';
import 'package:tkit/shared/theme/app_theme.dart';
import 'package:tkit/l10n/app_localizations.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logger
  final logger = AppLogger();

  try {
    // =========================================================================
    // LOAD VERSION FROM PUBSPEC.YAML (SINGLE SOURCE OF TRUTH)
    // =========================================================================
    await AppConfig.getVersion();
    logger.info('App version: ${AppConfig.appVersion}');

    // -------------------------------------------------------------------------
    // 1. Core Dependencies (Singletons)
    // -------------------------------------------------------------------------
    final sharedPreferences = await SharedPreferences.getInstance();

    // Create separate Dio instances for different purposes
    // Auth Dio: No interceptors, used for OAuth token exchange
    final authDio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
      ),
    );

    // API Dio: Will have auth interceptors added by TwitchApiRemoteDataSource
    final apiDio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
      ),
    );

    final secureStorage = const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    );
    final database = AppDatabase();

    // -------------------------------------------------------------------------
    // 2. Core Services
    // -------------------------------------------------------------------------
    final platformChannel = WindowsPlatformChannel(logger);
    final languageService = LanguageService(sharedPreferences, logger);
    final localeProvider = LocaleProvider();
    final systemTrayService = SystemTrayService(logger);
    final windowService = WindowService(logger);
    final updateService = GitHubUpdateService(authDio, logger);
    final notificationService = NotificationService(logger);

    // -------------------------------------------------------------------------
    // 3. Data Sources
    // -------------------------------------------------------------------------
    // Auth datasources (use authDio without interceptors)
    final tokenLocalDataSource = TokenLocalDataSource(secureStorage);
    final twitchAuthRemoteDataSource = TwitchAuthRemoteDataSource(authDio);

    // Settings datasource
    final settingsLocalDataSource = SettingsLocalDataSource(
      sharedPreferences,
      logger,
    );

    // Category mapping datasources
    final categoryMappingLocalDataSource = CategoryMappingLocalDataSource(
      database,
    );
    final unknownProcessDataSource = UnknownProcessDataSource(database);
    final memoryCache = MemoryCache(
      maxSize: 100,
      defaultTtl: const Duration(minutes: 30),
    );

    // Mapping list datasources
    final mappingListLocalDataSource = MappingListLocalDataSource(database);
    final mappingListSyncDataSource = MappingListSyncDataSource(authDio);

    // Mapping submission datasource
    final mappingSubmissionDataSource = MappingSubmissionDataSource(authDio, logger);

    // Process detection datasource
    final processDetectionPlatformDataSource =
        ProcessDetectionPlatformDataSource(platformChannel, logger);

    // Update history datasource
    final updateHistoryLocalDataSource = UpdateHistoryLocalDataSource(database);

    // Twitch API datasource (use apiDio which will get auth interceptor)
    final twitchApiRemoteDataSource = TwitchApiRemoteDataSource(apiDio, logger);

    // -------------------------------------------------------------------------
    // 4. Repositories
    // -------------------------------------------------------------------------
    final authRepository = AuthRepositoryImpl(
      twitchAuthRemoteDataSource,
      tokenLocalDataSource,
    );

    final settingsRepository = SettingsRepositoryImpl(
      settingsLocalDataSource,
      logger,
    );

    final categoryMappingRepository = CategoryMappingRepositoryImpl(
      categoryMappingLocalDataSource,
      memoryCache,
    );

    // Mapping list repository
    final mappingListRepository = MappingListRepositoryImpl(
      mappingListLocalDataSource,
      mappingListSyncDataSource,
      database,
      logger,
    );

    final processDetectionRepository = ProcessDetectionRepositoryImpl(
      processDetectionPlatformDataSource,
      logger,
    );

    final twitchApiRepository = TwitchApiRepositoryImpl(
      twitchApiRemoteDataSource,
      logger,
    );

    // Configure token provider for Twitch API with automatic refresh
    // This checks token expiration and refreshes automatically
    String? cachedAccessToken;
    DateTime? tokenExpiresAt;
    bool isRefreshing = false;

    twitchApiRepository.setTokenProvider(() {
      // Check if token is expired or expiring soon (within 5 minutes)
      if (tokenExpiresAt != null) {
        final now = DateTime.now();
        final fiveMinutesFromNow = now.add(const Duration(minutes: 5));

        if (fiveMinutesFromNow.isAfter(tokenExpiresAt!)) {
          // Token is expired or expiring soon - refresh it
          if (!isRefreshing) {
            isRefreshing = true;
            logger.info('Token expiring soon, attempting automatic refresh');

            // Trigger refresh asynchronously (don't block the provider)
            authRepository.refreshToken().then((result) {
              result.fold(
                (failure) {
                  logger.error('Automatic token refresh failed: ${failure.message}');
                  isRefreshing = false;
                },
                (newToken) {
                  cachedAccessToken = newToken.accessToken;
                  tokenExpiresAt = newToken.expiresAt;
                  isRefreshing = false;
                  logger.info('Token automatically refreshed successfully');
                },
              );
            });
          }
        }
      }

      return cachedAccessToken;
    });

    // Load initial token if available
    tokenLocalDataSource.getToken().then((token) {
      if (token != null) {
        cachedAccessToken = token.accessToken;
        tokenExpiresAt = token.expiresAt;
        logger.debug('Initial access token loaded for Twitch API (expires: $tokenExpiresAt)');
      }
    });

    // Configure refresh token callback for 401 error handling
    // This forces a synchronous token refresh when API calls fail with 401
    twitchApiRepository.setRefreshTokenCallback(() async {
      logger.info('Force token refresh requested (401 error interceptor)');

      final result = await authRepository.refreshToken();

      return result.fold(
        (failure) {
          logger.error('Force token refresh failed: ${failure.message}');
          cachedAccessToken = null;
          tokenExpiresAt = null;
          isRefreshing = false;
          return null;
        },
        (newToken) {
          cachedAccessToken = newToken.accessToken;
          tokenExpiresAt = newToken.expiresAt;
          isRefreshing = false;
          logger.info('Force token refresh successful');
          return newToken.accessToken;
        },
      );
    });

    // Mapping importer (requires twitch API repository)
    final mappingImporter = MappingImporter(
      localDataSource: categoryMappingLocalDataSource,
      twitchApiRepository: twitchApiRepository,
      logger: logger,
      dio: apiDio,
    );

    // -------------------------------------------------------------------------
    // 5. Use Cases
    // -------------------------------------------------------------------------
    // Auth use cases
    final checkAuthStatusUseCase = CheckAuthStatusUseCase(authRepository);
    final getCurrentUserUseCase = auth_get_user.GetCurrentUserUseCase(
      authRepository,
    );
    final logoutUseCase = LogoutUseCase(authRepository);
    final refreshTokenUseCase = RefreshTokenUseCase(authRepository);

    // Settings use cases
    final getSettingsUseCase = GetSettingsUseCase(settingsRepository);
    final updateSettingsUseCase = UpdateSettingsUseCase(settingsRepository);
    final watchSettingsUseCase = WatchSettingsUseCase(settingsRepository);
    final factoryResetUseCase = FactoryResetUseCase(
      settingsRepository,
      database,
      secureStorage,
      sharedPreferences,
    );

    // Category mapping use cases
    final getAllMappingsUseCase = GetAllMappingsUseCase(
      categoryMappingRepository,
    );
    final findMappingUseCase = FindMappingUseCase(categoryMappingRepository);
    final saveMappingUseCase = SaveMappingUseCase(categoryMappingRepository);
    final deleteMappingUseCase = DeleteMappingUseCase(
      categoryMappingRepository,
    );
    final updateLastUsedUseCase = UpdateLastUsedUseCase(
      categoryMappingRepository,
    );
    final exportMappingsUseCase = ExportMappingsUseCase(
      categoryMappingRepository,
    );
    final importMappingsUseCase = ImportMappingsUseCase(
      categoryMappingRepository,
    );
    final refreshExpiredMappingsUseCase = RefreshExpiredMappingsUseCase(
      categoryMappingLocalDataSource,
      twitchApiRepository,
    );
    final refreshExpiringSoonUseCase = RefreshExpiringSoonUseCase(
      categoryMappingLocalDataSource,
      twitchApiRepository,
    );

    // Mapping list use cases
    final getAllListsUseCase = GetAllListsUseCase(mappingListRepository);
    final syncListUseCase = SyncListUseCase(mappingListRepository);
    final importListFromUrlUseCase = ImportListFromUrlUseCase(mappingListRepository);
    final toggleListEnabledUseCase = ToggleListEnabledUseCase(mappingListRepository);

    // Mapping submission use case
    final submitMappingUseCase = SubmitMappingUseCase(mappingSubmissionDataSource);

    // Process detection use cases
    final getFocusedProcessUseCase = GetFocusedProcessUseCase(
      processDetectionRepository,
    );
    final watchProcessChangesUseCase = WatchProcessChangesUseCase(
      processDetectionRepository,
    );

    // Twitch API use cases
    final getCategoryByIdUseCase = GetCategoryByIdUseCase(twitchApiRepository);
    final getTwitchCurrentUserUseCase = twitch_get_user.GetCurrentUserUseCase(
      twitchApiRepository,
    );
    final searchCategoriesUseCase = SearchCategoriesUseCase(
      twitchApiRepository,
    );
    final updateChannelCategoryUseCase = UpdateChannelCategoryUseCase(
      twitchApiRepository,
    );
    final getGamesByIdsUseCase = GetGamesByIdsUseCase(twitchApiRepository);
    final getGamesByNamesUseCase = GetGamesByNamesUseCase(twitchApiRepository);
    final getTopGamesUseCase = GetTopGamesUseCase(twitchApiRepository);

    // Auto switcher repository (depends on multiple use cases)
    final autoSwitcherRepository = AutoSwitcherRepositoryImpl(
      watchProcessChangesUseCase,
      getFocusedProcessUseCase,
      findMappingUseCase,
      saveMappingUseCase,
      updateChannelCategoryUseCase,
      getSettingsUseCase,
      watchSettingsUseCase,
      updateLastUsedUseCase,
      updateHistoryLocalDataSource,
      unknownProcessDataSource,
      notificationService,
    );

    // Auto switcher use cases
    final getOrchestrationStatusUseCase = GetOrchestrationStatusUseCase(
      autoSwitcherRepository,
    );
    final getUpdateHistoryUseCase = GetUpdateHistoryUseCase(
      autoSwitcherRepository,
    );
    final manualUpdateUseCase = ManualUpdateUseCase(autoSwitcherRepository);
    final startMonitoringUseCase = StartMonitoringUseCase(
      autoSwitcherRepository,
    );
    final stopMonitoringUseCase = StopMonitoringUseCase(autoSwitcherRepository);

    // -------------------------------------------------------------------------
    // 6. Providers
    // -------------------------------------------------------------------------
    final authProvider = AuthProvider(
      logoutUseCase,
      checkAuthStatusUseCase,
      refreshTokenUseCase,
      getCurrentUserUseCase,
      tokenLocalDataSource,
      authRepository,
    );

    final settingsProvider = SettingsProvider(
      getSettingsUseCase,
      updateSettingsUseCase,
      watchSettingsUseCase,
      logger,
    );

    final windowControlsPreviewProvider = WindowControlsPreviewProvider();
    final unsavedChangesNotifier = UnsavedChangesNotifier();

    final categoryMappingProvider = CategoryMappingProvider(
      getAllMappingsUseCase: getAllMappingsUseCase,
      findMappingUseCase: findMappingUseCase,
      saveMappingUseCase: saveMappingUseCase,
      deleteMappingUseCase: deleteMappingUseCase,
    );

    final mappingListProvider = MappingListProvider(
      getAllListsUseCase: getAllListsUseCase,
      syncListUseCase: syncListUseCase,
      importListFromUrlUseCase: importListFromUrlUseCase,
      toggleListEnabledUseCase: toggleListEnabledUseCase,
    );

    final processDetectionProvider = ProcessDetectionProvider(
      getFocusedProcessUseCase,
      watchProcessChangesUseCase,
      logger,
    );

    final twitchApiProvider = TwitchApiProvider(
      searchCategoriesUseCase,
      logger,
    );

    final autoSwitcherProvider = AutoSwitcherProvider(
      startMonitoringUseCase,
      stopMonitoringUseCase,
      manualUpdateUseCase,
      getOrchestrationStatusUseCase,
      getUpdateHistoryUseCase,
    );

    // HotkeyService depends on autoSwitcherProvider, so create it after
    final hotkeyService = HotkeyService(
      getSettingsUseCase,
      watchSettingsUseCase,
      autoSwitcherProvider,
      logger,
    );

    // -------------------------------------------------------------------------
    // 7. Initialize Services
    // -------------------------------------------------------------------------
    // Initialize database
    logger.info('Database initialized, checking schema...');

    // Seed default mappings (e.g., tkit.exe as ignored)
    try {
      await database.seedDefaultMappings();
      logger.info('Default mappings seeded successfully');
    } catch (e) {
      logger.warning('Failed to seed default mappings: $e');
    }

    // Initialize platform channel
    await platformChannel.isAvailable();

    // Configure window with custom chrome
    await windowManager.ensureInitialized();

    const windowOptions = WindowOptions(
      size: Size(AppConfig.defaultWindowWidth, AppConfig.defaultWindowHeight),
      minimumSize: Size(AppConfig.minWindowWidth, AppConfig.minWindowHeight),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden, // Remove default title bar
      title: AppConfig.appName,
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });

    // Load settings to determine window style
    final initialSettings = await getSettingsUseCase();
    await initialSettings.fold(
      (failure) async {
        logger.warning('Could not load settings, using default window style');
        // Default to hidden title bar (non-frameless)
        await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
      },
      (settings) async {
        // Apply window style based on settings
        if (settings.useFramelessWindow) {
          await windowManager.setAsFrameless();
          logger.info('Window set to frameless mode');
        } else {
          await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
          logger.info('Window set to normal mode with hidden title bar');
        }

        // Also set minimize to tray setting
        windowService.setMinimizeToTray(settings.minimizeToTray);
        logger.info('Initial minimize to tray setting: ${settings.minimizeToTray}');
      },
    );

    // Initialize window service
    await windowService.initialize();

    // Watch for settings changes and update window service
    watchSettingsUseCase().listen((settings) {
      windowService.setMinimizeToTray(settings.minimizeToTray);
    });

    // Initialize system tray
    await systemTrayService.initialize(
      onShow: () async {
        await windowService.showWindow();
      },
      onExit: () async {
        logger.info('Exit requested from system tray');
        // Use close() instead of destroy() to trigger cleanup via WindowListener
        await windowManager.close();
      },
      showLabel: 'Show TKit',
      exitLabel: 'Exit',
      tooltip: 'TKit - Twitch Toolkit',
    );

    // Initialize hotkey service
    await hotkeyService.initialize();

    // Initialize notification service
    await notificationService.initialize();

    // Configure update service with settings channel provider
    updateService.setChannelProvider(() async {
      final settings = await getSettingsUseCase();
      return settings.fold(
        (failure) => UpdateChannel.stable, // Default to stable on error
        (settings) => settings.updateChannel,
      );
    });

    // Initialize update service
    await updateService.initialize();

    // Check for updates immediately on startup
    logger.info('Checking for app updates...');
    final updateChannel = await getSettingsUseCase().then(
      (result) => result.fold(
        (_) => UpdateChannel.stable,
        (settings) => settings.updateChannel,
      ),
    );
    updateService.checkForUpdates(silent: true, channel: updateChannel);

    // Sync mapping lists on startup based on settings
    final shouldSyncOnStart = await getSettingsUseCase().then(
      (result) => result.fold(
        (_) => true, // Default to true on error
        (settings) => settings.autoSyncMappingsOnStart,
      ),
    );

    if (shouldSyncOnStart) {
      logger.info('Auto-sync enabled, syncing enabled mapping lists...');

      // Get all enabled lists that need syncing
      final listsResult = await mappingListRepository.getAllLists();
      await listsResult.fold(
        (failure) {
          logger.warning('Failed to get mapping lists: ${failure.message}');
        },
        (lists) async {
          final enabledLists = lists.where((list) => list.isEnabled && list.shouldSync).toList();

          if (enabledLists.isEmpty) {
            logger.info('No enabled lists to sync');
            return;
          }

          logger.info('Syncing ${enabledLists.length} enabled list(s)...');

          for (final list in enabledLists) {
            final syncResult = await syncListUseCase(list.id);
            syncResult.fold(
              (failure) {
                logger.warning('Failed to sync list "${list.name}": ${failure.message}');
              },
              (_) {
                logger.info('Successfully synced list: ${list.name}');
              },
            );
          }
        },
      );
    } else {
      logger.info('Auto-sync disabled in settings, skipping mapping list sync');
    }

    // -------------------------------------------------------------------------
    // 8. Run App with MultiProvider
    // -------------------------------------------------------------------------
    runApp(
      MultiProvider(
        providers: [
          // Core services
          Provider<AppLogger>.value(value: logger),
          Provider<AppDatabase>.value(value: database),
          Provider<FlutterSecureStorage>.value(value: secureStorage),
          Provider<SharedPreferences>.value(value: sharedPreferences),
          Provider<WindowsPlatformChannel>.value(value: platformChannel),
          Provider<LanguageService>.value(value: languageService),
          ChangeNotifierProvider<LocaleProvider>.value(value: localeProvider),
          Provider<SystemTrayService>.value(value: systemTrayService),
          Provider<WindowService>.value(value: windowService),
          Provider<GitHubUpdateService>.value(value: updateService),
          Provider<HotkeyService>.value(value: hotkeyService),
          Provider<NotificationService>.value(value: notificationService),

          // Data sources
          Provider<TokenLocalDataSource>.value(value: tokenLocalDataSource),
          Provider<CategoryMappingLocalDataSource>.value(
            value: categoryMappingLocalDataSource,
          ),
          Provider<UnknownProcessDataSource>.value(
            value: unknownProcessDataSource,
          ),
          Provider<MemoryCache>.value(value: memoryCache),
          Provider<MappingImporter>.value(value: mappingImporter),

          // Repositories
          Provider<IAuthRepository>.value(value: authRepository),
          Provider<ISettingsRepository>.value(value: settingsRepository),
          Provider<ICategoryMappingRepository>.value(
            value: categoryMappingRepository,
          ),
          Provider<IMappingListRepository>.value(
            value: mappingListRepository,
          ),
          Provider<IProcessDetectionRepository>.value(
            value: processDetectionRepository,
          ),
          Provider<ITwitchApiRepository>.value(value: twitchApiRepository),
          Provider<IAutoSwitcherRepository>.value(
            value: autoSwitcherRepository,
          ),

          // Use cases
          Provider<CheckAuthStatusUseCase>.value(value: checkAuthStatusUseCase),
          Provider<auth_get_user.GetCurrentUserUseCase>.value(
            value: getCurrentUserUseCase,
          ),
          Provider<LogoutUseCase>.value(value: logoutUseCase),
          Provider<RefreshTokenUseCase>.value(value: refreshTokenUseCase),
          Provider<GetSettingsUseCase>.value(value: getSettingsUseCase),
          Provider<UpdateSettingsUseCase>.value(value: updateSettingsUseCase),
          Provider<WatchSettingsUseCase>.value(value: watchSettingsUseCase),
          Provider<FactoryResetUseCase>.value(value: factoryResetUseCase),
          Provider<GetAllMappingsUseCase>.value(value: getAllMappingsUseCase),
          Provider<FindMappingUseCase>.value(value: findMappingUseCase),
          Provider<SaveMappingUseCase>.value(value: saveMappingUseCase),
          Provider<DeleteMappingUseCase>.value(value: deleteMappingUseCase),
          Provider<UpdateLastUsedUseCase>.value(value: updateLastUsedUseCase),
          Provider<ExportMappingsUseCase>.value(value: exportMappingsUseCase),
          Provider<ImportMappingsUseCase>.value(value: importMappingsUseCase),
          Provider<RefreshExpiredMappingsUseCase>.value(
            value: refreshExpiredMappingsUseCase,
          ),
          Provider<RefreshExpiringSoonUseCase>.value(
            value: refreshExpiringSoonUseCase,
          ),
          Provider<GetAllListsUseCase>.value(value: getAllListsUseCase),
          Provider<SyncListUseCase>.value(value: syncListUseCase),
          Provider<ImportListFromUrlUseCase>.value(value: importListFromUrlUseCase),
          Provider<ToggleListEnabledUseCase>.value(value: toggleListEnabledUseCase),
          Provider<SubmitMappingUseCase>.value(value: submitMappingUseCase),
          Provider<GetFocusedProcessUseCase>.value(
            value: getFocusedProcessUseCase,
          ),
          Provider<WatchProcessChangesUseCase>.value(
            value: watchProcessChangesUseCase,
          ),
          Provider<GetCategoryByIdUseCase>.value(value: getCategoryByIdUseCase),
          Provider<twitch_get_user.GetCurrentUserUseCase>.value(
            value: getTwitchCurrentUserUseCase,
          ),
          Provider<SearchCategoriesUseCase>.value(
            value: searchCategoriesUseCase,
          ),
          Provider<UpdateChannelCategoryUseCase>.value(
            value: updateChannelCategoryUseCase,
          ),
          Provider<GetGamesByIdsUseCase>.value(value: getGamesByIdsUseCase),
          Provider<GetGamesByNamesUseCase>.value(value: getGamesByNamesUseCase),
          Provider<GetTopGamesUseCase>.value(value: getTopGamesUseCase),
          Provider<GetOrchestrationStatusUseCase>.value(
            value: getOrchestrationStatusUseCase,
          ),
          Provider<GetUpdateHistoryUseCase>.value(
            value: getUpdateHistoryUseCase,
          ),
          Provider<ManualUpdateUseCase>.value(value: manualUpdateUseCase),
          Provider<StartMonitoringUseCase>.value(value: startMonitoringUseCase),
          Provider<StopMonitoringUseCase>.value(value: stopMonitoringUseCase),

          // Providers (ChangeNotifier)
          ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
          ChangeNotifierProvider<SettingsProvider>.value(
            value: settingsProvider,
          ),
          ChangeNotifierProvider<WindowControlsPreviewProvider>.value(
            value: windowControlsPreviewProvider,
          ),
          ChangeNotifierProvider<UnsavedChangesNotifier>.value(
            value: unsavedChangesNotifier,
          ),
          ChangeNotifierProvider<CategoryMappingProvider>.value(
            value: categoryMappingProvider,
          ),
          ChangeNotifierProvider<MappingListProvider>.value(
            value: mappingListProvider,
          ),
          ChangeNotifierProvider<ProcessDetectionProvider>.value(
            value: processDetectionProvider,
          ),
          ChangeNotifierProvider<TwitchApiProvider>.value(
            value: twitchApiProvider,
          ),
          ChangeNotifierProvider<AutoSwitcherProvider>.value(
            value: autoSwitcherProvider,
          ),
        ],
        child: const TKitApp(),
      ),
    );
  } catch (e, stackTrace) {
    logger.fatal('Failed to initialize app', e, stackTrace);
    rethrow;
  }
}

class TKitApp extends StatefulWidget {
  const TKitApp({super.key});

  @override
  State<TKitApp> createState() => _TKitAppState();
}

class _TKitAppState extends State<TKitApp> with WindowListener {
  late final AppRouter _appRouter;
  late final LanguageService _languageService;
  late final LocaleProvider _localeProvider;
  late final AppLogger _logger;

  // Track stream subscriptions for cleanup
  StreamSubscription? _settingsWatchSubscription;
  VoidCallback? _authProviderListener;

  @override
  void initState() {
    super.initState();

    // Register window listener for cleanup
    windowManager.addListener(this);

    // Get dependencies from Provider
    _languageService = Provider.of<LanguageService>(context, listen: false);
    _localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    _logger = Provider.of<AppLogger>(context, listen: false);

    // Check if language setup is completed
    final isSetupCompleted = _languageService.isLanguageSetupCompleted();

    // Create router with appropriate initial route
    _appRouter = AppRouter();

    if (!isSetupCompleted) {
      _logger.info('Language setup not completed, showing welcome screen');
      // Navigate to welcome screen after build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _appRouter.push(
          WelcomeRoute(
            onLocaleChange: (locale) {
              _localeProvider.setLocale(locale);
            },
          ),
        );
      });
    } else {
      _logger.info('Language setup completed, loading saved locale');
      // Schedule locale change after build to avoid setState during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _localeProvider.setLocale(_languageService.getCurrentLocale());
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check auth status after dependencies are available
    // Schedule for after build to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Set up notification click handler immediately (doesn't require auth)
      _setupNotificationClickHandler();

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.checkAuthStatus();

      // Listen to auth state changes
      _authProviderListener = () {
        _handleAuthStateChange(authProvider.state);
      };
      authProvider.addListener(_authProviderListener!);
    });
  }

  @override
  void dispose() {
    // Cancel stream subscriptions
    _settingsWatchSubscription?.cancel();

    // Remove auth provider listener
    if (_authProviderListener != null) {
      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        authProvider.removeListener(_authProviderListener!);
      } catch (e) {
        // Context might be unavailable
      }
    }

    // Unregister window listener
    windowManager.removeListener(this);
    super.dispose();
  }

  /// Called when the window is about to close
  @override
  Future<void> onWindowClose() async {
    _logger.info('Window close requested - starting fast shutdown');

    // Start cleanup but don't wait - let it run in background
    // This allows immediate window close while cleanup finishes
    _cleanupResources().catchError((e, stackTrace) {
      _logger.error('Cleanup error', e, stackTrace);
    });

    // Close window with 500ms timeout to prevent hanging
    try {
      await windowManager.destroy().timeout(
        const Duration(milliseconds: 500),
        onTimeout: () {
          _logger.warning('Window destroy timed out - force closing');
        },
      );
    } catch (e) {
      _logger.error('Error destroying window', e);
    }
  }

  /// Cleanup all app resources before exit
  Future<void> _cleanupResources() async {
    _logger.info('Starting cleanup - this should be fast...');
    final stopwatch = Stopwatch()..start();

    try {
      // Get all services that need cleanup
      final autoSwitcherRepo = Provider.of<IAutoSwitcherRepository>(context, listen: false);
      final hotkeyService = Provider.of<HotkeyService>(context, listen: false);
      final systemTrayService = Provider.of<SystemTrayService>(context, listen: false);
      final database = Provider.of<AppDatabase>(context, listen: false);

      // Stop services in parallel for speed
      await Future.wait([
        // Dispose auto switcher (cancels stream subscriptions)
        Future(() async {
          _logger.info('Disposing auto switcher...');
          await autoSwitcherRepo.dispose();
        }),

        // Dispose hotkey service (cancels stream subscription, unregisters hotkeys)
        Future(() async {
          _logger.info('Disposing hotkey service...');
          hotkeyService.dispose();
        }),

        // Dispose system tray
        Future(() async {
          _logger.info('Disposing system tray...');
          await systemTrayService.dispose();
        }),
      ], eagerError: false);

      // Close database last (might have pending writes)
      _logger.info('Closing database...');
      await database.close();

      stopwatch.stop();
      _logger.info('Cleanup completed in ${stopwatch.elapsedMilliseconds}ms');
    } catch (e, stackTrace) {
      stopwatch.stop();
      _logger.error('Cleanup error after ${stopwatch.elapsedMilliseconds}ms', e, stackTrace);
    }
  }

  /// Handle auth state changes
  void _handleAuthStateChange(AuthState state) {
    if (state is Authenticated) {
      // Update cached access token for Twitch API
      _updateApiAccessToken();

      // Initialize periodic sync scheduler
      _initializePeriodicListSync();

      // Wire up unknown game dialog callback
      _setupUnknownGameCallback();
    }
  }

  /// Update the API access token from secure storage
  Future<void> _updateApiAccessToken() async {
    try {
      final tokenDataSource = Provider.of<TokenLocalDataSource>(
        context,
        listen: false,
      );
      final twitchApiRepo =
          Provider.of<ITwitchApiRepository>(context, listen: false)
              as TwitchApiRepositoryImpl;
      final logger = Provider.of<AppLogger>(context, listen: false);

      final token = await tokenDataSource.getToken();
      if (token != null) {
        // Update the token provider with the new token
        twitchApiRepo.setTokenProvider(() => token.accessToken);
        logger.debug('Access token updated for Twitch API');
      }
    } catch (e) {
      _logger.error('Failed to update API access token', e);
    }
  }

  /// Initialize periodic mapping list sync based on settings
  void _initializePeriodicListSync() {
    try {
      final mappingListRepository = Provider.of<IMappingListRepository>(
        context,
        listen: false,
      );
      final syncListUseCase = Provider.of<SyncListUseCase>(
        context,
        listen: false,
      );
      final getSettingsUseCase = Provider.of<GetSettingsUseCase>(
        context,
        listen: false,
      );
      final watchSettingsUseCase = Provider.of<WatchSettingsUseCase>(
        context,
        listen: false,
      );
      final logger = Provider.of<AppLogger>(context, listen: false);

      Timer? syncTimer;

      // Function to schedule next sync
      void scheduleSyncTimer(int intervalHours) {
        // Cancel existing timer
        syncTimer?.cancel();

        if (intervalHours <= 0) {
          logger.info('Periodic mapping list sync disabled (interval: 0)');
          return;
        }

        final duration = Duration(hours: intervalHours);
        logger.info('Scheduling mapping list sync every ${intervalHours}h');

        syncTimer = Timer.periodic(duration, (_) async {
          logger.info('Periodic sync triggered for mapping lists');

          // Get all enabled lists
          final listsResult = await mappingListRepository.getAllLists();
          await listsResult.fold(
            (failure) {
              logger.warning('Failed to get mapping lists for periodic sync: ${failure.message}');
            },
            (lists) async {
              final enabledLists = lists.where((list) => list.isEnabled && list.shouldSync).toList();

              if (enabledLists.isEmpty) {
                logger.debug('No enabled lists need syncing');
                return;
              }

              logger.info('Syncing ${enabledLists.length} enabled list(s)...');

              for (final list in enabledLists) {
                final syncResult = await syncListUseCase(list.id);
                syncResult.fold(
                  (failure) {
                    logger.warning('Periodic sync failed for "${list.name}": ${failure.message}');
                  },
                  (_) {
                    logger.info('Periodic sync completed for: ${list.name}');
                  },
                );
              }
            },
          );
        });
      }

      // Watch settings for changes to sync interval
      watchSettingsUseCase().listen((settings) {
        scheduleSyncTimer(settings.mappingsSyncIntervalHours);
      });

      // Initialize with current settings
      getSettingsUseCase().then((result) {
        result.fold(
          (failure) => logger.warning('Could not get settings for sync scheduler'),
          (settings) => scheduleSyncTimer(settings.mappingsSyncIntervalHours),
        );
      });

      logger.info('Periodic mapping list sync initialized');
    } catch (e) {
      _logger.error('Failed to initialize periodic sync', e);
    }
  }

  /// Setup notification click handler (doesn't require auth)
  void _setupNotificationClickHandler() {
    try {
      final notificationService = Provider.of<NotificationService>(
        context,
        listen: false,
      );
      final saveMappingUseCase = Provider.of<SaveMappingUseCase>(
        context,
        listen: false,
      );
      final categoryMappingProvider = Provider.of<CategoryMappingProvider>(
        context,
        listen: false,
      );
      final logger = Provider.of<AppLogger>(context, listen: false);
      final windowService = Provider.of<WindowService>(context, listen: false);

      // Set the notification click handler
      notificationService.onMissingCategoryClick =
          ({required String processName, String? executablePath}) async {
            logger.info('Notification clicked for: $processName');

            // Bring window to foreground first
            try {
              await windowService.showWindow();
              logger.debug('Window brought to foreground from notification');
              // Small delay to ensure window is ready
              await Future.delayed(const Duration(milliseconds: 100));
            } catch (e) {
              logger.warning('Failed to bring window to foreground: $e');
            }

            // Show dialog directly when notification is clicked
            final result = await showDialog<Map<String, dynamic>>(
              context: _appRouter.navigatorKey.currentContext!,
              barrierDismissible: false,
              builder: (context) => UnknownGameDialog(
                processName: processName,
                executablePath: executablePath,
                windowTitle: null,
              ),
            );

            if (result == null) return;

            // Extract data from result
            final category = result['category'] as TwitchCategory;
            final saveLocally = result['saveLocally'] as bool? ?? false;
            final contributeToCommunity = result['contributeToCommunity'] as bool? ?? false;
            final isEnabled = result['isEnabled'] as bool? ?? true;
            final normalizedPath = result['normalizedInstallPath'] as String?;
            final listId = result['listId'] as String?;

            logger.info('User selected category: ${category.name} (ID: ${category.id}) for process: $processName');

            // Submit to community if requested
            if (contributeToCommunity) {
              // TODO: Implement submission to mapping list's submission hook URL
              logger.info('Community contribution requested - submission feature to be implemented with mapping list hooks');
            }

            // Save locally if requested
            if (saveLocally) {
              try {
                // Remove .exe extension for cross-platform compatibility
                final sanitizedProcessName = processName.replaceAll(RegExp(r'\.exe$', caseSensitive: false), '');

                final mapping = CategoryMapping(
                  processName: sanitizedProcessName,
                  executablePath: executablePath,
                  normalizedInstallPaths: normalizedPath != null ? [normalizedPath] : [],
                  twitchCategoryId: category.id,
                  twitchCategoryName: category.name,
                  createdAt: DateTime.now(),
                  lastApiFetch: DateTime.now(),
                  cacheExpiresAt: DateTime.now().add(const Duration(hours: 24)),
                  manualOverride: true,
                  isEnabled: isEnabled,
                  pendingSubmission: contributeToCommunity,
                  listId: listId ?? 'my-custom-mappings',
                );

                final saveResult = await saveMappingUseCase(mapping);
                saveResult.fold(
                  (failure) => logger.error('Failed to save mapping: ${failure.message}'),
                  (_) {
                    logger.info('Mapping saved successfully: $processName -> ${category.name}');
                    // Refresh the mappings list immediately
                    categoryMappingProvider.loadMappings();
                  },
                );
              } catch (e) {
                logger.error('Failed to save mapping locally', e);
              }
            }
          };

      logger.info('Notification click handler configured');
    } catch (e) {
      _logger.error('Failed to setup notification click handler', e);
    }
  }

  /// Setup unknown game dialog callback
  void _setupUnknownGameCallback() {
    try {
      final autoSwitcherRepo =
          Provider.of<IAutoSwitcherRepository>(context, listen: false)
              as AutoSwitcherRepositoryImpl;
      final categoryMappingProvider = Provider.of<CategoryMappingProvider>(
        context,
        listen: false,
      );
      final submitMappingUseCase = Provider.of<SubmitMappingUseCase>(
        context,
        listen: false,
      );
      final logger = Provider.of<AppLogger>(context, listen: false);
      final windowService = Provider.of<WindowService>(context, listen: false);

      // Helper function to show the unknown game dialog
      Future<CategoryMapping?> showUnknownGameDialog({
        required String processName,
        String? executablePath,
        String? windowTitle,
      }) async {
        logger.info('Showing unknown game dialog for: $processName');

        // Bring window to foreground first
        try {
          await windowService.showWindow();
          logger.debug('Window brought to foreground');
          // Small delay to ensure window is ready
          await Future.delayed(const Duration(milliseconds: 100));
        } catch (e) {
          logger.warning('Failed to bring window to foreground: $e');
        }

        // Show dialog to user
        final result = await showDialog<Map<String, dynamic>>(
          context: _appRouter.navigatorKey.currentContext!,
          barrierDismissible: false,
          builder: (context) => UnknownGameDialog(
            processName: processName,
            executablePath: executablePath,
            windowTitle: windowTitle,
          ),
        );

        if (result == null) {
          // User cancelled
          logger.info('User cancelled unknown game dialog');
          return null;
        }

        // Extract TwitchCategory object
        final category = result['category'] as TwitchCategory;
        final saveLocally = result['saveLocally'] as bool;
        final contributeToCommunity = result['contributeToCommunity'] as bool;
        final isEnabled = result['isEnabled'] as bool? ?? true;
        final normalizedPath = result['normalizedInstallPath'] as String?;
        final listId = result['listId'] as String?;

        logger.info(
          'User selected category: ${category.name} (ID: ${category.id}) '
          'for process: $processName',
        );

        // Submit to community if requested
        if (contributeToCommunity) {
          try {
            // Normalize process name: remove .exe extension for cross-platform compatibility
            final normalizedProcessName = processName.toLowerCase().replaceAll('.exe', '');

            // Use the submission URL from the user's selected list
            final submissionUrl = result['submissionUrl'] as String?;

            if (submissionUrl != null) {
              logger.debug('Using submission URL from user-selected list: $submissionUrl');
              final result = await submitMappingUseCase(
                submissionUrl: submissionUrl,
                processName: normalizedProcessName,
                twitchCategoryId: category.id,
                twitchCategoryName: category.name,
                windowTitle: windowTitle,
                normalizedInstallPath: normalizedPath,
              );

              result.fold(
                (failure) {
                  logger.error('Failed to submit mapping: ${failure.message}');
                },
                (submissionResult) {
                  final isVerification = submissionResult['isVerification'] as bool? ?? false;
                  final issueUrl = submissionResult['issueUrl'] as String?;

                  logger.info(
                    isVerification
                        ? 'Verified existing mapping: $processName'
                        : 'Submitted new mapping: $processName',
                  );

                  if (issueUrl != null) {
                    logger.debug('Submission URL: $issueUrl');
                  }
                },
              );
            } else {
              logger.warning('No submission URL available in enabled mapping lists');
            }
          } catch (e) {
            logger.error('Failed to submit mapping to community', e);
            // Don't fail the whole operation
          }
        }

        // Create the mapping to be saved locally
        CategoryMapping? mappingToReturn;
        if (saveLocally) {
          // Remove .exe extension for cross-platform compatibility
          final sanitizedProcessName = processName.replaceAll(RegExp(r'\.exe$', caseSensitive: false), '');

          mappingToReturn = CategoryMapping(
            processName: sanitizedProcessName,
            executablePath: executablePath,
            normalizedInstallPaths: normalizedPath != null ? [normalizedPath] : [],
            twitchCategoryId: category.id,
            twitchCategoryName: category.name,
            createdAt: DateTime.now(),
            lastApiFetch: DateTime.now(),
            cacheExpiresAt: DateTime.now().add(const Duration(hours: 24)),
            manualOverride: true,
            isEnabled: isEnabled,
            pendingSubmission: contributeToCommunity,
            listId: listId ?? 'my-custom-mappings',
          );
        }

        // Refresh the mappings list in the UI after a short delay
        // This ensures the UI updates immediately after the mapping is saved
        if (saveLocally) {
          // Small delay to ensure database write completes
          Future.delayed(const Duration(milliseconds: 500), () {
            categoryMappingProvider.loadMappings();
            logger.debug('Mappings list refreshed after save');
          });
        }

        return mappingToReturn;
      }

      // Set the callback for unknown games (automatic detection)
      autoSwitcherRepo.unknownGameCallback =
          ({
            required String processName,
            String? executablePath,
            String? windowTitle,
          }) async {
            return await showUnknownGameDialog(
              processName: processName,
              executablePath: executablePath,
              windowTitle: windowTitle,
            );
          };

      logger.info('Unknown game dialog callbacks configured');
    } catch (e) {
      _logger.error('Failed to setup unknown game callback', e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, _) {
        return MaterialApp.router(
          title: AppConfig.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          // Localization support
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: localeProvider.locale,
          routerConfig: _appRouter.config(),
          builder: (context, child) {
            // Wrap all routes with MainWindow and UpdateNotificationWidget
            return UpdateNotificationWidget(
              navigatorKey: _appRouter.navigatorKey,
              child: MainWindow(
                router: _appRouter,
                child: child ?? const SizedBox.shrink(),
              ),
            );
          },
        );
      },
    );
  }
}
