import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/database/app_database.dart';
import 'core/platform/windows_platform_channel.dart';
import 'core/utils/app_logger.dart';
import 'core/config/app_config.dart';
import 'core/routing/app_router.dart';
import 'core/services/system_tray_service.dart';
import 'core/services/hotkey_service.dart';
import 'core/services/language_service.dart';
import 'core/services/locale_provider.dart';
import 'core/services/maintenance_scheduler.dart';
import 'core/services/notification_service.dart';
import 'core/services/updater/github_update_service.dart';
import 'features/auth/data/datasources/token_local_datasource.dart';
import 'features/auth/data/datasources/twitch_auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/i_auth_repository.dart';
import 'features/auth/presentation/states/auth_state.dart';
import 'features/auth/domain/usecases/authenticate_usecase.dart';
import 'features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'features/auth/domain/usecases/get_current_user_usecase.dart'
    as auth_get_user;
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/domain/usecases/refresh_token_usecase.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auto_switcher/data/datasources/update_history_local_datasource.dart';
import 'features/auto_switcher/data/repositories/auto_switcher_repository_impl.dart';
import 'features/auto_switcher/domain/repositories/i_auto_switcher_repository.dart';
import 'features/auto_switcher/domain/usecases/get_orchestration_status_usecase.dart';
import 'features/auto_switcher/domain/usecases/get_update_history_usecase.dart';
import 'features/auto_switcher/domain/usecases/manual_update_usecase.dart';
import 'features/auto_switcher/domain/usecases/start_monitoring_usecase.dart';
import 'features/auto_switcher/domain/usecases/stop_monitoring_usecase.dart';
import 'features/auto_switcher/presentation/providers/auto_switcher_provider.dart';
import 'features/category_mapping/data/datasources/category_mapping_local_datasource.dart';
import 'features/category_mapping/data/datasources/unknown_process_datasource.dart';
import 'features/category_mapping/data/datasources/mapping_importer.dart';
import 'features/category_mapping/data/datasources/memory_cache.dart';
import 'features/category_mapping/data/repositories/category_mapping_repository_impl.dart';
import 'features/category_mapping/domain/entities/category_mapping.dart';
import 'features/category_mapping/domain/repositories/i_category_mapping_repository.dart';
import 'features/category_mapping/domain/usecases/delete_mapping_usecase.dart';
import 'features/category_mapping/domain/usecases/export_mappings_usecase.dart';
import 'features/category_mapping/domain/usecases/find_mapping_usecase.dart';
import 'features/category_mapping/domain/usecases/get_all_mappings_usecase.dart';
import 'features/category_mapping/domain/usecases/import_mappings_usecase.dart';
import 'features/category_mapping/domain/usecases/refresh_expired_mappings_usecase.dart';
import 'features/category_mapping/domain/usecases/refresh_expiring_soon_usecase.dart';
import 'features/category_mapping/domain/usecases/save_mapping_usecase.dart';
import 'features/category_mapping/domain/usecases/update_last_used_usecase.dart';
import 'features/category_mapping/presentation/providers/category_mapping_provider.dart';
import 'features/category_mapping/presentation/dialogs/unknown_game_dialog.dart';
import 'features/community_mappings/data/datasources/community_sync_datasource.dart';
import 'features/community_mappings/data/datasources/mapping_submission_datasource.dart';
import 'features/community_mappings/data/repositories/community_mappings_repository_impl.dart';
import 'features/community_mappings/domain/repositories/i_community_mappings_repository.dart';
import 'features/community_mappings/domain/usecases/sync_community_mappings_usecase.dart';
import 'features/community_mappings/domain/usecases/submit_mapping_usecase.dart';
import 'features/process_detection/data/datasources/process_detection_platform_datasource.dart';
import 'features/process_detection/data/repositories/process_detection_repository_impl.dart';
import 'features/process_detection/domain/repositories/i_process_detection_repository.dart';
import 'features/process_detection/domain/usecases/get_focused_process_usecase.dart';
import 'features/process_detection/domain/usecases/watch_process_changes_usecase.dart';
import 'features/process_detection/presentation/providers/process_detection_provider.dart';
import 'features/settings/data/datasources/settings_local_datasource.dart';
import 'features/settings/data/repositories/settings_repository_impl.dart';
import 'features/settings/domain/repositories/i_settings_repository.dart';
import 'features/settings/domain/entities/update_channel.dart';
import 'features/settings/domain/usecases/factory_reset_usecase.dart';
import 'features/settings/domain/usecases/get_settings_usecase.dart';
import 'features/settings/domain/usecases/update_settings_usecase.dart';
import 'features/settings/domain/usecases/watch_settings_usecase.dart';
import 'features/settings/presentation/providers/settings_provider.dart';
import 'features/settings/presentation/providers/window_controls_preview_provider.dart';
import 'features/settings/presentation/providers/unsaved_changes_notifier.dart';
import 'features/twitch_api/data/datasources/twitch_api_remote_datasource.dart';
import 'features/twitch_api/data/repositories/twitch_api_repository_impl.dart';
import 'features/twitch_api/domain/repositories/i_twitch_api_repository.dart';
import 'features/twitch_api/domain/usecases/get_category_by_id_usecase.dart';
import 'features/twitch_api/domain/usecases/get_current_user_usecase.dart'
    as twitch_get_user;
import 'features/twitch_api/domain/entities/twitch_category.dart';
import 'features/twitch_api/domain/usecases/get_games_by_ids_usecase.dart';
import 'features/twitch_api/domain/usecases/get_games_by_names_usecase.dart';
import 'features/twitch_api/domain/usecases/get_top_games_usecase.dart';
import 'features/twitch_api/domain/usecases/search_categories_usecase.dart';
import 'features/twitch_api/domain/usecases/update_channel_category_usecase.dart';
import 'features/twitch_api/presentation/providers/twitch_api_provider.dart';
import 'presentation/main_window.dart';
import 'presentation/widgets/update_notification_widget.dart';
import 'shared/theme/app_theme.dart';
import 'l10n/app_localizations.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logger
  final logger = AppLogger();
  logger.info('TKit starting...');

  try {
    // =========================================================================
    // LOAD VERSION FROM PUBSPEC.YAML (SINGLE SOURCE OF TRUTH)
    // =========================================================================
    await AppConfig.getVersion();
    logger.info('App version: ${AppConfig.appVersion}');

    // =========================================================================
    // MANUAL DEPENDENCY INJECTION SETUP
    // =========================================================================
    logger.info('Configuring dependencies...');

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
    final maintenanceScheduler = MaintenanceScheduler(logger);
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

    // Community mappings datasources
    final communitySyncDataSource = CommunitySyncDataSource(
      dio: authDio,
      logger: logger,
    );
    final mappingSubmissionDataSource = MappingSubmissionDataSource(
      dio: authDio,
      logger: logger,
    );

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

    // Community mappings repository
    final communityMappingsRepository = CommunityMappingsRepositoryImpl(
      syncDataSource: communitySyncDataSource,
      submissionDataSource: mappingSubmissionDataSource,
      database: database,
      logger: logger,
    );

    final categoryMappingRepository = CategoryMappingRepositoryImpl(
      categoryMappingLocalDataSource,
      memoryCache,
      communityMappingsRepository: communityMappingsRepository,
    );

    final processDetectionRepository = ProcessDetectionRepositoryImpl(
      processDetectionPlatformDataSource,
      logger,
    );

    final twitchApiRepository = TwitchApiRepositoryImpl(
      twitchApiRemoteDataSource,
      logger,
    );

    // Configure token provider for Twitch API
    // This caches the token in memory and provides it to the API datasource
    String? cachedAccessToken;
    twitchApiRepository.setTokenProvider(() {
      return cachedAccessToken;
    });

    // Load initial token if available
    tokenLocalDataSource.getToken().then((token) {
      if (token != null) {
        cachedAccessToken = token.accessToken;
        logger.debug('Initial access token loaded for Twitch API');
      }
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
    final authenticateUseCase = AuthenticateUseCase(authRepository);
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

    // Community mappings use cases
    final syncCommunityMappingsUseCase = SyncCommunityMappingsUseCase(
      communityMappingsRepository,
    );
    final submitMappingUseCase = SubmitMappingUseCase(
      communityMappingsRepository,
    );

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
      authenticateUseCase,
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

    logger.info('Dependencies configured successfully');

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
    final isAvailable = await platformChannel.isAvailable();
    logger.info('Platform channel available: $isAvailable');

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

    logger.info('Window initialized successfully');

    // Initialize window service
    await windowService.initialize();

    // Watch for settings changes and update window service
    watchSettingsUseCase().listen((settings) {
      windowService.setMinimizeToTray(settings.minimizeToTray);
      logger.debug('Updated minimize to tray setting: ${settings.minimizeToTray}');
    });

    // Initialize system tray (navigation will be set up after router is created)
    await systemTrayService.initialize(
      onShow: () async {
        await windowService.showWindow();
        // Navigation handled in TKitApp
      },
      onAutoSwitcher: () async {
        await windowService.showWindow();
        // Navigation handled in TKitApp
      },
      onCategoryMappings: () async {
        await windowService.showWindow();
        // Navigation handled in TKitApp
      },
      onSettings: () async {
        await windowService.showWindow();
        // Navigation handled in TKitApp
      },
      onExit: () async {
        logger.info('Exit requested from system tray');
        await windowManager.destroy();
      },
      showLabel: 'Show TKit',
      autoSwitcherLabel: 'Auto Switcher',
      categoryMappingsLabel: 'Category Mappings',
      settingsLabel: 'Settings',
      exitLabel: 'Exit',
      tooltip: 'TKit - Twitch Toolkit',
    );

    logger.info('System tray initialized successfully');

    // Initialize hotkey service
    await hotkeyService.initialize();
    logger.info('Hotkey service initialized successfully');

    // Initialize notification service
    await notificationService.initialize();
    logger.info('Notification service initialized successfully');

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

    // Initialize maintenance scheduler with use cases
    logger.info('Starting maintenance scheduler...');
    await _initializeMaintenanceScheduler(
      maintenanceScheduler,
      refreshExpiredMappingsUseCase,
      refreshExpiringSoonUseCase,
      mappingImporter,
      logger,
    );

    // Sync community mappings on startup (doesn't require authentication)
    logger.info('Syncing community mappings from GitHub...');
    final syncResult = await syncCommunityMappingsUseCase(forceSync: true);
    syncResult.fold(
      (failure) {
        logger.warning('Community mappings sync failed: ${failure.message}');
      },
      (count) {
        logger.info('Synced $count community mappings from GitHub');
      },
    );

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
          Provider<MaintenanceScheduler>.value(value: maintenanceScheduler),

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
          Provider<ICommunityMappingsRepository>.value(
            value: communityMappingsRepository,
          ),
          Provider<ICategoryMappingRepository>.value(
            value: categoryMappingRepository,
          ),
          Provider<IProcessDetectionRepository>.value(
            value: processDetectionRepository,
          ),
          Provider<ITwitchApiRepository>.value(value: twitchApiRepository),
          Provider<IAutoSwitcherRepository>.value(
            value: autoSwitcherRepository,
          ),

          // Use cases
          Provider<AuthenticateUseCase>.value(value: authenticateUseCase),
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
          Provider<SyncCommunityMappingsUseCase>.value(
            value: syncCommunityMappingsUseCase,
          ),
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

/// Initialize maintenance scheduler with actual use cases
Future<void> _initializeMaintenanceScheduler(
  MaintenanceScheduler scheduler,
  RefreshExpiredMappingsUseCase refreshExpired,
  RefreshExpiringSoonUseCase refreshExpiringSoon,
  MappingImporter importer,
  AppLogger logger,
) async {
  // Wire up the scheduler with actual implementations
  // For now, we'll start the scheduler - actual job wiring can be done
  // when scheduler is enhanced to accept callbacks
  await scheduler.start();
  logger.info('Maintenance scheduler started');

  // TODO: Future enhancement - wire up actual use case calls
  // The scheduler currently has placeholder methods that need to be
  // enhanced to accept callbacks for:
  // - Daily cleanup: call refreshExpired()
  // - Proactive refresh: call refreshExpiringSoon()
  // - Weekly sync: call importer.importFromGr3gorywolf() and importFromNerothos()
}

class TKitApp extends StatefulWidget {
  const TKitApp({super.key});

  @override
  State<TKitApp> createState() => _TKitAppState();
}

class _TKitAppState extends State<TKitApp> {
  late final AppRouter _appRouter;
  late final LanguageService _languageService;
  late final LocaleProvider _localeProvider;
  late final AppLogger _logger;

  @override
  void initState() {
    super.initState();

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
      authProvider.addListener(() {
        _handleAuthStateChange(authProvider.state);
      });
    });
  }

  /// Handle auth state changes
  void _handleAuthStateChange(AuthState state) {
    if (state is Authenticated) {
      // Update cached access token for Twitch API
      _updateApiAccessToken();

      // Initialize community mappings sync
      _initializeCommunitySync();

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

  /// Initialize community mappings sync
  Future<void> _initializeCommunitySync() async {
    try {
      final syncUseCase = Provider.of<SyncCommunityMappingsUseCase>(
        context,
        listen: false,
      );
      final logger = Provider.of<AppLogger>(context, listen: false);

      logger.info('Syncing community mappings from GitHub...');
      final result = await syncUseCase(forceSync: true);

      result.fold(
        (failure) {
          logger.warning('Community mappings sync failed: ${failure.message}');
        },
        (count) {
          logger.info('Synced $count community mappings from GitHub');
        },
      );
    } catch (e) {
      _logger.error('Failed to sync community mappings', e);
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
      final submitMappingUseCase = Provider.of<SubmitMappingUseCase>(
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

            logger.info('User selected category: ${category.name} (ID: ${category.id}) for process: $processName');

            // Submit to community if requested
            if (contributeToCommunity) {
              try {
                final submitResult = await submitMappingUseCase(
                  processName: processName,
                  twitchCategoryId: category.id,
                  twitchCategoryName: category.name,
                  windowTitle: null,
                );

                submitResult.fold(
                  (failure) => logger.error('Failed to submit mapping: ${failure.message}'),
                  (submissionResult) {
                    final message = submissionResult['message'] as String? ?? 'Submitted successfully';
                    logger.info(message);
                  },
                );
              } catch (e) {
                logger.error('Failed to submit mapping to community', e);
              }
            }

            // Save locally if requested
            if (saveLocally) {
              try {
                final mapping = CategoryMapping(
                  processName: processName,
                  executablePath: executablePath,
                  twitchCategoryId: category.id,
                  twitchCategoryName: category.name,
                  createdAt: DateTime.now(),
                  lastApiFetch: DateTime.now(),
                  cacheExpiresAt: DateTime.now().add(const Duration(hours: 24)),
                  manualOverride: true,
                  isEnabled: isEnabled,
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
      final submitMappingUseCase = Provider.of<SubmitMappingUseCase>(
        context,
        listen: false,
      );
      final categoryMappingProvider = Provider.of<CategoryMappingProvider>(
        context,
        listen: false,
      );
      final logger = Provider.of<AppLogger>(context, listen: false);
      final windowService = Provider.of<WindowService>(context, listen: false);

      // Helper function to show the unknown game dialog
      Future<CategoryMapping?> _showUnknownGameDialog({
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

        logger.info(
          'User selected category: ${category.name} (ID: ${category.id}) '
          'for process: $processName',
        );

        // Submit to community if requested
        if (contributeToCommunity) {
          try {
            final result = await submitMappingUseCase(
              processName: processName,
              twitchCategoryId: category.id,
              twitchCategoryName: category.name,
              windowTitle: windowTitle,
            );

            result.fold(
              (failure) {
                logger.error('Failed to submit mapping: ${failure.message}');
                // Error is already logged, user sees it in the app logs
              },
              (submissionResult) {
                final isVerification =
                    submissionResult['isVerification'] as bool? ?? false;
                final message =
                    submissionResult['message'] as String? ??
                    'Submitted successfully';
                final issueUrl = submissionResult['issueUrl'] as String?;

                logger.info(
                  isVerification
                      ? 'Verified existing mapping: $processName'
                      : 'Submitted new mapping: $processName',
                );

                if (issueUrl != null) {
                  logger.debug('GitHub PR: $issueUrl');
                }
              },
            );
          } catch (e) {
            logger.error('Failed to submit mapping to community', e);
            // Don't fail the whole operation
          }
        }

        // Create the mapping to be saved locally
        CategoryMapping? mappingToReturn;
        if (saveLocally) {
          mappingToReturn = CategoryMapping(
            processName: processName,
            executablePath: executablePath,
            twitchCategoryId: category.id,
            twitchCategoryName: category.name,
            createdAt: DateTime.now(),
            lastApiFetch: DateTime.now(),
            cacheExpiresAt: DateTime.now().add(const Duration(hours: 24)),
            manualOverride: true,
            isEnabled: isEnabled,
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
            return await _showUnknownGameDialog(
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
