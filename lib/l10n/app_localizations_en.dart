// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'TKit';

  @override
  String get welcomeTitle => 'Welcome to TKit';

  @override
  String get selectLanguage => 'Select Your Language';

  @override
  String get languageLabel => 'Language';

  @override
  String get continueButton => 'CONTINUE';

  @override
  String get confirm => 'Confirm';

  @override
  String get hello => 'Hello';

  @override
  String get languageNativeName => 'English';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageCzech => 'Čeština';

  @override
  String get languagePolish => 'Polski';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languagePortuguese => 'Português';

  @override
  String get languageJapanese => '日本語';

  @override
  String get languageKorean => '한국어';

  @override
  String get languageChinese => '中文';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageDescription =>
      'Choose your preferred language for the application';

  @override
  String get languageChangeNotice =>
      'Language changed. The application will update immediately.';

  @override
  String get authSuccessAuthenticatedAs => 'Successfully authenticated as';

  @override
  String get systemTrayShowTkit => 'Show TKit';

  @override
  String get authConnectToTwitch => 'Connect to Twitch';

  @override
  String get systemTrayAutoSwitcher => 'Auto Switcher';

  @override
  String get authLoading => 'Loading...';

  @override
  String get systemTrayCategoryMappings => 'Category Mappings';

  @override
  String get authRefreshingToken => 'Refreshing token...';

  @override
  String get systemTraySettings => 'Settings';

  @override
  String get authSuccessfullyAuthenticated => 'Successfully Authenticated';

  @override
  String get systemTrayExit => 'Exit';

  @override
  String get authLoggedInAs => 'Logged in as';

  @override
  String get systemTrayTooltip => 'TKit - Twitch Toolkit';

  @override
  String get authErrorAuthenticationFailed => 'Authentication Failed';

  @override
  String get authErrorErrorCode => 'Error code:';

  @override
  String get authTryAgain => 'Try Again';

  @override
  String get authAuthorizationSteps => 'Authorization Steps';

  @override
  String get authStep1 => 'Click \"Connect to Twitch\" button below';

  @override
  String get authStep2 =>
      'Your browser will open the Twitch authorization page';

  @override
  String get authStep3 => 'Review and authorize TKit to manage your channel';

  @override
  String get authStep4 => 'Return to this window after authorization';

  @override
  String get authConnectToTwitchButton => 'CONNECT TO TWITCH';

  @override
  String get authRequiresAccessMessage =>
      'TKit requires access to update your Twitch channel category.';

  @override
  String get authDeviceCodeTitle => 'Connect to Twitch';

  @override
  String get authDeviceCodeInstructions =>
      'To connect your Twitch account, follow these simple steps:';

  @override
  String get authDeviceCodeStep1 => 'Go to';

  @override
  String get authDeviceCodeStep2 => 'Enter this code:';

  @override
  String get authDeviceCodeStep3 =>
      'Authorize TKit to manage your channel category';

  @override
  String get authDeviceCodeCodeLabel => 'Your Code';

  @override
  String get authDeviceCodeCopyCode => 'Copy Code';

  @override
  String get authDeviceCodeCopied => 'Copied!';

  @override
  String get authDeviceCodeOpenBrowser => 'Open twitch.tv/activate';

  @override
  String get authDeviceCodeWaiting => 'Waiting for authorization...';

  @override
  String authDeviceCodeExpiresIn(String minutes, String seconds) {
    return 'Code expires in $minutes:$seconds';
  }

  @override
  String get authDeviceCodeExpired => 'Code expired. Please try again.';

  @override
  String get authDeviceCodeCancel => 'Cancel';

  @override
  String get authDeviceCodeSuccess => 'Successfully connected!';

  @override
  String get authDeviceCodeError => 'Connection failed. Please try again.';

  @override
  String get authDeviceCodeHelp =>
      'Having trouble? Make sure you\'re logged in to Twitch in your browser.';

  @override
  String get autoSwitcherPageTitle => 'AUTO SWITCHER';

  @override
  String get authStatusAuthenticated => 'Authenticated';

  @override
  String get autoSwitcherPageDescription =>
      'Automatically updates stream category based on focused application';

  @override
  String get authStatusConnecting => 'Connecting...';

  @override
  String get autoSwitcherStatusHeader => 'STATUS';

  @override
  String get authStatusError => 'Error';

  @override
  String get autoSwitcherStatusCurrentProcess => 'CURRENT PROCESS';

  @override
  String get authStatusNotConnected => 'Not connected';

  @override
  String get autoSwitcherStatusNone => 'None';

  @override
  String get autoSwitcherStatusMatchedCategory => 'MATCHED CATEGORY';

  @override
  String get mainWindowNavAutoSwitcher => 'Auto Switcher';

  @override
  String get autoSwitcherStatusLastUpdate => 'LAST UPDATE';

  @override
  String get mainWindowNavMappings => 'Mappings';

  @override
  String get autoSwitcherStatusNever => 'Never';

  @override
  String get mainWindowNavSettings => 'Settings';

  @override
  String get mainWindowStatusConnected => 'Connected';

  @override
  String get autoSwitcherStatusUpdateStatus => 'UPDATE STATUS';

  @override
  String get mainWindowStatusDisconnected => 'Disconnected';

  @override
  String get autoSwitcherStatusNoUpdatesYet => 'No updates yet';

  @override
  String get mainWindowWindowControlMinimize => 'Minimize';

  @override
  String get autoSwitcherStatusSuccess => 'SUCCESS';

  @override
  String get authLoadingStartingAuthentication => 'Starting authentication...';

  @override
  String get mainWindowWindowControlMaximize => 'Maximize';

  @override
  String get autoSwitcherStatusFailed => 'FAILED';

  @override
  String get authLoadingLoggingOut => 'Logging out...';

  @override
  String get settingsSavedSuccessfully => 'Settings saved successfully';

  @override
  String get autoSwitcherStatusSystemState => 'SYSTEM STATE';

  @override
  String get mainWindowWindowControlClose => 'Close';

  @override
  String get authLoadingCheckingStatus => 'Checking authentication status...';

  @override
  String get settingsRetry => 'Retry';

  @override
  String get settingsPageTitle => 'SETTINGS';

  @override
  String get settingsPageDescription =>
      'Configure application behavior and preferences';

  @override
  String get settingsTabGeneral => 'General';

  @override
  String get settingsTabAutoSwitcher => 'Auto Switcher';

  @override
  String get settingsTabKeyboard => 'Keyboard';

  @override
  String get settingsTabTwitch => 'Twitch';

  @override
  String get settingsTabAdvanced => 'Advanced';

  @override
  String get autoSwitcherStatusNotInitialized => 'NOT INITIALIZED';

  @override
  String get mainWindowFooterReady => 'Ready';

  @override
  String get authErrorTokenRefreshFailed => 'Token refresh failed:';

  @override
  String get settingsAutoSwitcher => 'Auto Switcher';

  @override
  String get autoSwitcherStatusIdle => 'IDLE';

  @override
  String get updateDialogTitle => 'Update Available';

  @override
  String get settingsMonitoring => 'Monitoring';

  @override
  String get autoSwitcherStatusDetectingProcess => 'DETECTING PROCESS';

  @override
  String get categoryMappingTitle => 'CATEGORY MAPPINGS';

  @override
  String get updateDialogWhatsNew => 'What\'s New:';

  @override
  String get settingsScanIntervalLabel => 'Scan Interval';

  @override
  String get autoSwitcherStatusSearchingMapping => 'SEARCHING MAPPING';

  @override
  String get categoryMappingSubtitle =>
      'Manage process-to-category mappings for automatic switching';

  @override
  String get updateDialogDownloadComplete =>
      'Download complete! Ready to install.';

  @override
  String get settingsScanIntervalDescription =>
      'How often to check which application has focus';

  @override
  String get autoSwitcherStatusUpdatingCategory => 'UPDATING CATEGORY';

  @override
  String get categoryMappingAddMappingButton => 'ADD MAPPING';

  @override
  String get updateDialogDownloadFailed => 'Download failed:';

  @override
  String get settingsDebounceTimeLabel => 'Debounce Time';

  @override
  String get autoSwitcherStatusWaitingDebounce => 'WAITING (DEBOUNCE)';

  @override
  String get categoryMappingErrorDialogTitle => 'Error';

  @override
  String get updateDialogRemindLater => 'Remind Me Later';

  @override
  String get updateDialogIgnore => 'Ignore This Version';

  @override
  String get settingsDebounceTimeDescription =>
      'Wait time before switching category after app change (prevents rapid switching)';

  @override
  String get autoSwitcherStatusError => 'ERROR';

  @override
  String get categoryMappingStatsTotalMappings => 'Total Mappings';

  @override
  String get updateDialogDownloadUpdate => 'Download Update';

  @override
  String get settingsAutoStartMonitoringLabel =>
      'Start monitoring automatically';

  @override
  String get autoSwitcherControlsHeader => 'CONTROLS';

  @override
  String get categoryMappingStatsUserDefined => 'User Defined';

  @override
  String get updateDialogCancel => 'Cancel';

  @override
  String get settingsAutoStartMonitoringSubtitle =>
      'Begin monitoring for active application when TKit starts';

  @override
  String get autoSwitcherControlsStopMonitoring => 'STOP MONITORING';

  @override
  String get categoryMappingStatsPresets => 'Presets';

  @override
  String get updateDialogLater => 'Later';

  @override
  String get settingsFallbackBehavior => 'Fallback Behavior';

  @override
  String get autoSwitcherControlsStartMonitoring => 'START MONITORING';

  @override
  String get categoryMappingErrorLoading => 'Error loading mappings';

  @override
  String get updateDialogInstallRestart => 'Install & Restart';

  @override
  String get settingsFallbackBehaviorLabel => 'When no mapping is found';

  @override
  String get autoSwitcherControlsManualUpdate => 'MANUAL UPDATE';

  @override
  String get categoryMappingRetryButton => 'RETRY';

  @override
  String get updateDialogToday => 'today';

  @override
  String get settingsFallbackBehaviorDescription =>
      'Choose what happens when the focused app has no category mapping';

  @override
  String get categoryMappingDeleteDialogTitle => 'Delete Mapping';

  @override
  String get autoSwitcherControlsMonitoringStatus => 'MONITORING STATUS';

  @override
  String get updateDialogYesterday => 'yesterday';

  @override
  String get settingsCustomCategory => 'Custom Category';

  @override
  String get categoryMappingDeleteDialogMessage =>
      'Are you sure you want to delete this mapping?';

  @override
  String get autoSwitcherControlsActive => 'ACTIVE';

  @override
  String updateDialogDaysAgo(int days) {
    return '$days days ago';
  }

  @override
  String get settingsCustomCategoryHint => 'Search for a category...';

  @override
  String get categoryMappingDeleteDialogConfirm => 'DELETE';

  @override
  String get autoSwitcherControlsInactive => 'INACTIVE';

  @override
  String updateDialogVersion(String version) {
    return 'Version $version';
  }

  @override
  String get categoryMappingDeleteDialogCancel => 'CANCEL';

  @override
  String get settingsCategorySearchUnavailable =>
      'Category search will be available when Twitch API module is complete';

  @override
  String get autoSwitcherControlsActiveDescription =>
      'Automatically updating category based on focused process';

  @override
  String updateDialogPublished(String date) {
    return 'Published $date';
  }

  @override
  String get updateDialogVersionLabel => 'VERSION';

  @override
  String get updateDialogSize => 'Size';

  @override
  String get updateDialogPublishedLabel => 'Published';

  @override
  String get updateDialogDownloading => 'Downloading';

  @override
  String get updateDialogReadyToInstall => 'Ready to Install';

  @override
  String get updateDialogClickInstallRestart => 'Click Install & Restart';

  @override
  String get updateDialogDownloadFailedTitle => 'Download Failed';

  @override
  String get updateDialogNeverShowTooltip => 'Never show this version again';

  @override
  String get updateDialogIgnoreButton => 'Ignore';

  @override
  String get updateDialogRemindTooltip => 'Remind me next time';

  @override
  String get updateDialogPostpone => 'Postpone';

  @override
  String get categoryMappingAddDialogEditTitle => 'EDIT MAPPING';

  @override
  String get settingsApplication => 'Application';

  @override
  String get autoSwitcherControlsInactiveDescription =>
      'Start monitoring to enable automatic category updates';

  @override
  String get welcomeStepLanguage => 'Language';

  @override
  String get categoryMappingAddDialogAddTitle => 'ADD NEW MAPPING';

  @override
  String get categoryMappingAddDialogClose => 'Close';

  @override
  String get categoryMappingAddDialogProcessName => 'PROCESS NAME';

  @override
  String get categoryMappingAddDialogExecutablePath =>
      'EXECUTABLE PATH (OPTIONAL)';

  @override
  String get categoryMappingAddDialogCategoryId => 'TWITCH CATEGORY ID';

  @override
  String get categoryMappingAddDialogCategoryName => 'TWITCH CATEGORY NAME';

  @override
  String get categoryMappingAddDialogCancel => 'CANCEL';

  @override
  String get categoryMappingAddDialogUpdate => 'UPDATE';

  @override
  String get categoryMappingAddDialogAdd => 'ADD';

  @override
  String get settingsAutoStartWindowsLabel => 'Auto-start with Windows';

  @override
  String get categoryMappingAddDialogCloseTooltip => 'Close';

  @override
  String get welcomeStepTwitch => 'Twitch';

  @override
  String get welcomeStepBehavior => 'Behavior';

  @override
  String get welcomeBehaviorStepTitle => 'STEP 3: APPLICATION BEHAVIOR';

  @override
  String get welcomeBehaviorTitle => 'Application Behavior';

  @override
  String get welcomeBehaviorDescription =>
      'Configure how TKit behaves on startup and when minimized.';

  @override
  String get welcomeBehaviorOptionalInfo =>
      'These settings can be changed anytime in Settings.';

  @override
  String get settingsWindowControlsPositionLabel => 'Window Controls Position';

  @override
  String get settingsWindowControlsPositionDescription =>
      'Choose where window controls (minimize, maximize, close) appear';

  @override
  String get windowControlsPositionLeft => 'Left';

  @override
  String get windowControlsPositionCenter => 'Center';

  @override
  String get windowControlsPositionRight => 'Right';

  @override
  String get settingsAutoStartWindowsSubtitle =>
      'Launch TKit automatically when Windows starts';

  @override
  String get categoryMappingAddDialogProcessNameLabel => 'PROCESS NAME';

  @override
  String get welcomeLanguageStepTitle => 'STEP 1: SELECT YOUR LANGUAGE';

  @override
  String get settingsStartMinimizedLabel => 'Start minimized';

  @override
  String get categoryMappingAddDialogProcessNameHint =>
      'e.g., League of Legends.exe';

  @override
  String get welcomeLanguageChangeLater =>
      'You can change this later in Settings.';

  @override
  String get settingsStartMinimizedSubtitle =>
      'Launch TKit minimized to system tray';

  @override
  String get categoryMappingAddDialogProcessNameRequired =>
      'Process name is required';

  @override
  String get welcomeTwitchStepTitle => 'STEP 2: CONNECT TO TWITCH';

  @override
  String get settingsMinimizeToTrayLabel => 'Close to system tray';

  @override
  String get categoryMappingAddDialogExecutablePathLabel =>
      'EXECUTABLE PATH (OPTIONAL)';

  @override
  String get welcomeTwitchConnectionTitle => 'Twitch Connection';

  @override
  String get settingsMinimizeToTraySubtitle =>
      'Keep TKit running in the background when closing window (minimize goes to taskbar)';

  @override
  String get categoryMappingAddDialogExecutablePathHint =>
      'e.g., C:\\Games\\LeagueOfLegends\\Game\\League of Legends.exe';

  @override
  String welcomeTwitchConnectedAs(String username) {
    return 'Connected as $username';
  }

  @override
  String get settingsShowNotificationsLabel => 'Show notifications';

  @override
  String get categoryMappingAddDialogCategoryIdLabel => 'TWITCH CATEGORY ID';

  @override
  String get welcomeTwitchDescription =>
      'Connect your Twitch account to enable automatic category switching based on active application.';

  @override
  String get settingsShowNotificationsSubtitle =>
      'Display notifications when category is updated';

  @override
  String get settingsNotifyMissingCategoryLabel => 'Notify on missing category';

  @override
  String get settingsNotifyMissingCategorySubtitle =>
      'Show notification when no mapping is found for a game or app';

  @override
  String get categoryMappingAddDialogCategoryIdHint => 'e.g., 21779';

  @override
  String get welcomeTwitchOptionalInfo =>
      'This step is optional. You can skip and set it up later in Settings.';

  @override
  String get settingsKeyboardShortcuts => 'Keyboard Shortcuts';

  @override
  String get categoryMappingAddDialogCategoryIdRequired =>
      'Category ID is required';

  @override
  String get welcomeTwitchAuthorizeButton => 'AUTHORIZE WITH TWITCH';

  @override
  String get settingsManualUpdateHotkeyLabel => 'Manual Update Hotkey';

  @override
  String get categoryMappingAddDialogCategoryNameLabel =>
      'TWITCH CATEGORY NAME';

  @override
  String get welcomeButtonNext => 'NEXT';

  @override
  String get settingsManualUpdateHotkeyDescription =>
      'Trigger a manual category update';

  @override
  String get categoryMappingAddDialogCategoryNameHint =>
      'e.g., League of Legends';

  @override
  String get welcomeButtonBack => 'BACK';

  @override
  String get settingsUnsavedChanges => 'You have unsaved changes';

  @override
  String get categoryMappingAddDialogCategoryNameRequired =>
      'Category name is required';

  @override
  String get settingsDiscard => 'Discard';

  @override
  String get categoryMappingAddDialogTip =>
      'Tip: Use the Twitch category search to find the correct ID and name';

  @override
  String get settingsSave => 'Save';

  @override
  String get categoryMappingAddDialogCancelButton => 'CANCEL';

  @override
  String get settingsTwitchConnection => 'Twitch Connection';

  @override
  String get categoryMappingAddDialogUpdateButton => 'UPDATE';

  @override
  String get settingsTwitchStatusConnected => 'Connected';

  @override
  String get categoryMappingAddDialogAddButton => 'ADD';

  @override
  String get settingsTwitchStatusNotConnected => 'Not Connected';

  @override
  String get categoryMappingListEmpty => 'No category mappings yet';

  @override
  String get categoryMappingListEmptyTitle => 'No category mappings yet';

  @override
  String get settingsTwitchLoggedInAs => 'Logged in as:';

  @override
  String get categoryMappingListEmptySubtitle =>
      'Add your first mapping to get started';

  @override
  String get settingsTwitchDisconnect => 'Disconnect';

  @override
  String get categoryMappingListColumnProcessName => 'PROCESS NAME';

  @override
  String get settingsTwitchConnectDescription =>
      'Connect your Twitch account to enable automatic category switching.';

  @override
  String get categoryMappingListColumnCategory => 'CATEGORY';

  @override
  String get settingsTwitchConnect => 'Connect to Twitch';

  @override
  String get categoryMappingListColumnLastUsed => 'LAST USED';

  @override
  String get hotkeyInputCancel => 'Cancel';

  @override
  String get categoryMappingListColumnType => 'TYPE';

  @override
  String get hotkeyInputChange => 'Change';

  @override
  String get categoryMappingListColumnActions => 'ACTIONS';

  @override
  String get hotkeyInputClearHotkey => 'Clear hotkey';

  @override
  String get categoryMappingListIdPrefix => 'ID: ';

  @override
  String categoryMappingListCategoryId(String categoryId) {
    return 'ID: $categoryId';
  }

  @override
  String get categoryMappingListNever => 'Never';

  @override
  String get categoryMappingListJustNow => 'Just now';

  @override
  String categoryMappingListMinutesAgo(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'minutes',
      one: 'minute',
    );
    return '$minutes $_temp0 ago';
  }

  @override
  String categoryMappingListHoursAgo(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: 'hours',
      one: 'hour',
    );
    return '$hours $_temp0 ago';
  }

  @override
  String categoryMappingListDaysAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'days',
      one: 'day',
    );
    return '$days $_temp0 ago';
  }

  @override
  String get hotkeyInputSetHotkey => 'Set Hotkey';

  @override
  String get categoryMappingListNeverUsed => 'Never';

  @override
  String get categoryMappingListTypeUser => 'USER';

  @override
  String get categoryMappingListTypePreset => 'PRESET';

  @override
  String get categoryMappingListEditTooltip => 'Edit mapping';

  @override
  String get categoryMappingListDeleteTooltip => 'Delete mapping';

  @override
  String get categoryMappingListTimeJustNow => 'Just now';

  @override
  String get categoryMappingProviderSuccessAdded =>
      'Mapping added successfully';

  @override
  String get categoryMappingProviderSuccessUpdated =>
      'Mapping updated successfully';

  @override
  String get categoryMappingProviderSuccessDeleted =>
      'Mapping deleted successfully';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonOk => 'OK';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get autoSwitcherProviderErrorPrefix => 'Failed to';

  @override
  String get autoSwitcherProviderStartMonitoring => 'start monitoring';

  @override
  String get autoSwitcherProviderStopMonitoring => 'stop monitoring';

  @override
  String get autoSwitcherProviderManualUpdate => 'perform manual update';

  @override
  String get autoSwitcherProviderLoadHistory => 'load history';

  @override
  String get autoSwitcherProviderClearHistory => 'clear history';

  @override
  String get autoSwitcherProviderSuccessCategoryUpdated =>
      'Category updated successfully';

  @override
  String get autoSwitcherProviderSuccessHistoryCleared =>
      'History cleared successfully';

  @override
  String get autoSwitcherProviderErrorUnknown => 'Unknown error';

  @override
  String get settingsFactoryReset => 'Factory Reset';

  @override
  String get settingsFactoryResetDescription =>
      'Reset all settings and data to factory defaults';

  @override
  String get settingsFactoryResetButton => 'Reset to Factory Defaults';

  @override
  String get settingsFactoryResetDialogTitle => 'Factory Reset';

  @override
  String get settingsFactoryResetDialogMessage =>
      'This will:\n• Disconnect your Twitch account\n• Reset all settings to defaults\n• Clear all category mappings\n• Delete update history\n\nYour language preference will be preserved.\n\nAre you sure you want to continue?';

  @override
  String get settingsFactoryResetDialogConfirm => 'RESET';

  @override
  String get settingsFactoryResetSuccess =>
      'Application reset to factory defaults successfully. Please restart the application.';

  @override
  String get settingsUpdates => 'Updates';

  @override
  String get settingsUpdateChannelLabel => 'Update Channel';

  @override
  String get settingsUpdateChannelDescription =>
      'Choose which types of updates you want to receive';

  @override
  String settingsUpdateChannelChanged(String channel) {
    return 'Update channel changed to $channel. Checking for updates...';
  }

  @override
  String get settingsAutoCheckForUpdatesLabel => 'Auto-check for updates';

  @override
  String get settingsAutoCheckForUpdatesSubtitle =>
      'Automatically check for new updates when the application starts';

  @override
  String get settingsAutoInstallUpdatesLabel => 'Auto-install updates';

  @override
  String get settingsAutoInstallUpdatesSubtitle =>
      'Automatically download and install updates when available (shows update dialog, then installs)';

  @override
  String get updateChannelStable => 'Stable';

  @override
  String get updateChannelStableDesc =>
      'Recommended for most users. Only stable releases.';

  @override
  String get updateChannelRc => 'Release Candidate';

  @override
  String get updateChannelRcDesc =>
      'Stable features with final testing before stable release.';

  @override
  String get updateChannelBeta => 'Beta';

  @override
  String get updateChannelBetaDesc =>
      'New features that are mostly stable. May have bugs.';

  @override
  String get updateChannelDev => 'Development';

  @override
  String get updateChannelDevDesc =>
      'Bleeding edge features. Expect bugs and instability.';

  @override
  String get fallbackBehaviorDoNothing => 'Do Nothing';

  @override
  String get fallbackBehaviorJustChatting => 'Just Chatting';

  @override
  String get fallbackBehaviorCustom => 'Custom Category';

  @override
  String get unknownGameDialogTitle => 'Game Not Mapped';

  @override
  String get unknownGameDialogStepCategory => 'Category';

  @override
  String get unknownGameDialogStepDestination => 'Destination';

  @override
  String get unknownGameDialogStepConfirm => 'Confirm';

  @override
  String get unknownGameDialogConfirmHeader => 'Review & Confirm';

  @override
  String get unknownGameDialogConfirmDescription =>
      'Please review your selections before saving';

  @override
  String get unknownGameDialogConfirmCategory => 'TWITCH CATEGORY';

  @override
  String get unknownGameDialogConfirmDestination => 'DESTINATION LIST';

  @override
  String get unknownGameDialogBack => 'Back';

  @override
  String get unknownGameDialogNext => 'Next';

  @override
  String unknownGameDialogSubtitle(String processName) {
    return 'Select a Twitch category for \"$processName\"';
  }

  @override
  String get unknownGameDialogClose => 'Close';

  @override
  String get unknownGameDialogSearchLabel => 'SEARCH TWITCH CATEGORIES';

  @override
  String get unknownGameDialogSearchHint => 'Type game name...';

  @override
  String get unknownGameDialogCategoryHeader => 'Select Twitch Category';

  @override
  String get unknownGameDialogCategoryDescription =>
      'Search and select the Twitch category for this game';

  @override
  String get unknownGameDialogListHeader => 'Choose Destination';

  @override
  String get unknownGameDialogListDescription =>
      'Select where to save this mapping';

  @override
  String get unknownGameDialogNoWritableLists => 'No writable lists available';

  @override
  String get unknownGameDialogNoWritableListsHint =>
      'Create a local list in Category Mappings to save custom mappings';

  @override
  String get unknownGameDialogLocalListsHeader => 'LOCAL MAPPINGS';

  @override
  String get unknownGameDialogSubmissionListsHeader => 'COMMUNITY SUBMISSION';

  @override
  String get unknownGameDialogWorkflowHeader => 'How Submission Works';

  @override
  String get unknownGameDialogWorkflowCompactNote =>
      'Saves locally first, then submitted for community approval';

  @override
  String get unknownGameDialogWorkflowLearnMore => 'Learn More';

  @override
  String get unknownGameDialogWorkflowStep1Title => 'Saved Locally (Immediate)';

  @override
  String get unknownGameDialogWorkflowStep1Description =>
      'Mapping is added to your local list and works immediately';

  @override
  String get unknownGameDialogWorkflowStep2Title => 'Submitted for Review';

  @override
  String get unknownGameDialogWorkflowStep2Description =>
      'Your mapping is submitted to the community for approval';

  @override
  String get unknownGameDialogWorkflowStep3Title => 'Merged to Official';

  @override
  String get unknownGameDialogWorkflowStep3Description =>
      'Once approved, it appears in official mappings and is removed from your local list';

  @override
  String get unknownGameDialogSearchError => 'Search Error';

  @override
  String get unknownGameDialogSearchPrompt =>
      'Search for a Twitch category above';

  @override
  String get unknownGameDialogNoResults => 'No categories found';

  @override
  String get unknownGameDialogIgnore => 'Ignore';

  @override
  String get unknownGameDialogSkip => 'Skip';

  @override
  String get unknownGameDialogSave => 'Save';

  @override
  String get unknownGameDialogThankYouTitle => 'Thank You!';

  @override
  String get unknownGameDialogThankYouMessage =>
      'Your contribution helps the community grow!';

  @override
  String get versionStatusUpToDate => 'Up to date';

  @override
  String get versionStatusUpdateAvailable => 'Update available';

  @override
  String versionStatusCheckFailed(String error) {
    return 'Update check failed: $error';
  }

  @override
  String get versionStatusNotInitialized => 'Update service not initialized';

  @override
  String get versionStatusPlatformNotSupported =>
      'Updates not supported on this platform';

  @override
  String get notificationMissingCategoryTitle => 'Category Mapping Not Found';

  @override
  String notificationMissingCategoryBody(String processName) {
    return 'No Twitch category found for: $processName';
  }

  @override
  String get notificationActionAssignCategory => 'Assign Category';

  @override
  String get notificationCategoryUpdatedTitle => 'Category Updated';

  @override
  String notificationCategoryUpdatedBody(
    String categoryName,
    String processName,
  ) {
    return 'Switched to \"$categoryName\" for $processName';
  }

  @override
  String get mappingListColumnSource => 'Source';

  @override
  String get mappingListColumnEnabled => 'Enabled';

  @override
  String get mappingListTooltipIgnored => 'This category is ignored';

  @override
  String mappingListTooltipTwitchId(String twitchCategoryId) {
    return 'Twitch ID: $twitchCategoryId';
  }

  @override
  String get mappingListCategoryIgnored => 'Ignored';

  @override
  String get mappingListSourceUnknown => 'Unknown';

  @override
  String mappingListSelected(int count) {
    return '$count selected';
  }

  @override
  String mappingListSelectedVisible(int count, int visible) {
    return '$count selected ($visible visible)';
  }

  @override
  String get mappingListButtonInvert => 'Invert';

  @override
  String get mappingListButtonClear => 'Clear';

  @override
  String mappingListButtonUndo(String action) {
    return 'Undo $action';
  }

  @override
  String get mappingListButtonExport => 'Export';

  @override
  String get mappingListButtonEnable => 'Enable';

  @override
  String get mappingListButtonDisable => 'Disable';

  @override
  String get mappingListButtonDelete => 'Delete';

  @override
  String get mappingListTooltipCannotDelete =>
      'Cannot delete mappings from read-only lists';

  @override
  String get mappingListTooltipDelete => 'Delete selected mappings';

  @override
  String get mappingListSearchHint => 'Search by process name or category...';

  @override
  String get mappingListTooltipClearSearch => 'Clear search';

  @override
  String get listManagementEmptyState => 'No lists found';

  @override
  String get listManagementTitle => 'Manage Lists';

  @override
  String get listManagementSyncNow => 'Sync now';

  @override
  String get listManagementBadgeLocal => 'LOCAL';

  @override
  String get listManagementBadgeOfficial => 'OFFICIAL';

  @override
  String get listManagementBadgeRemote => 'REMOTE';

  @override
  String get listManagementBadgeReadOnly => 'READ-ONLY';

  @override
  String get listManagementButtonImport => 'Import List';

  @override
  String get listManagementButtonSyncAll => 'Sync All';

  @override
  String get listManagementButtonClose => 'Close';

  @override
  String get listManagementImportTitle => 'Import List';

  @override
  String get listManagementImportUrl => 'List URL';

  @override
  String get listManagementImportUrlPlaceholder =>
      'https://example.com/mappings.json';

  @override
  String get listManagementImportName => 'List Name (optional)';

  @override
  String get listManagementImportNameHelper =>
      'If not provided, will use name from JSON file';

  @override
  String get listManagementImportNamePlaceholder => 'My Custom List';

  @override
  String get listManagementImportDescription => 'Description (optional)';

  @override
  String get listManagementImportDescriptionHelper =>
      'If not provided, will use description from JSON file';

  @override
  String get listManagementImportDescriptionPlaceholder =>
      'A collection of game mappings';

  @override
  String get listManagementButtonCancel => 'Cancel';

  @override
  String get listManagementButtonImportConfirm => 'Import';

  @override
  String get listManagementDefaultName => 'Imported List';

  @override
  String get listManagementImportSuccess => 'List imported successfully';

  @override
  String get listManagementSyncNever => 'never';

  @override
  String get listManagementSyncJustNow => 'just now';

  @override
  String listManagementSyncMinutesAgo(int minutes) {
    return '${minutes}m ago';
  }

  @override
  String listManagementSyncHoursAgo(int hours) {
    return '${hours}h ago';
  }

  @override
  String listManagementSyncDaysAgo(int days) {
    return '${days}d ago';
  }

  @override
  String listManagementSyncDaysHoursAgo(int days, int hours) {
    return '${days}d ${hours}h ago';
  }

  @override
  String listManagementMappingsCount(int count) {
    return '$count mappings';
  }

  @override
  String get listManagementSyncFailed => 'Sync failed:';

  @override
  String get listManagementLastSynced => 'Last synced:';

  @override
  String get unknownGameIgnoreProcess => 'Ignore Process';

  @override
  String unknownGameCategoryId(String id) {
    return 'ID: $id';
  }

  @override
  String get unknownGameSubmissionTitle => 'Submission Required';

  @override
  String get unknownGameSubmissionInfo =>
      'This mapping will be saved locally and submitted to the list owner for approval. Once approved and synced, your local copy will be automatically replaced.';

  @override
  String get unknownGameSectionLists => 'LISTS';

  @override
  String unknownGameListMappingCount(int count) {
    return '$count mappings';
  }

  @override
  String get unknownGameBadgeStaged => 'STAGED';

  @override
  String get unknownGameIgnoredProcess => 'IGNORED PROCESS';

  @override
  String unknownGameSelectedCategoryId(String id) {
    return 'ID: $id';
  }

  @override
  String get unknownGameWorkflowTitle => 'Submission Workflow';

  @override
  String get unknownGameWorkflowTitleAlt => 'What Happens Next';

  @override
  String get unknownGameWorkflowStepLocal =>
      'Saved locally to My Custom Mappings';

  @override
  String get unknownGameWorkflowStepLocalDesc =>
      'Stored on your device first, so the mapping works immediately';

  @override
  String unknownGameWorkflowStepSubmit(String listName) {
    return 'Submitted to $listName';
  }

  @override
  String get unknownGameWorkflowStepSubmitDesc =>
      'Automatically sent to the list owner for review and approval';

  @override
  String get unknownGameWorkflowStepReplace =>
      'Local copy replaced when approved';

  @override
  String unknownGameWorkflowStepReplaceDesc(String listName) {
    return 'Once accepted and synced, your local copy is removed and replaced with the official version from $listName';
  }

  @override
  String unknownGameSavedTo(String listName) {
    return 'Saved to $listName';
  }

  @override
  String get unknownGameIgnoredInfo =>
      'This process will be ignored and won\'t trigger notifications';

  @override
  String get unknownGameLocalSaveInfo =>
      'Your mapping is saved locally and will work immediately';

  @override
  String get unknownGamePrivacyInfo =>
      'This mapping is private and only stored on your device';

  @override
  String autoSwitcherError(String error) {
    return 'Error: $error';
  }

  @override
  String get autoSwitcherStatusActive => 'Auto-switching active';

  @override
  String get autoSwitcherStatusInactive => 'Not monitoring';

  @override
  String get autoSwitcherLabelActiveApp => 'Active app';

  @override
  String get autoSwitcherLabelCategory => 'Category';

  @override
  String get autoSwitcherValueNone => 'None';

  @override
  String get autoSwitcherDescriptionActive =>
      'Your category automatically changes when you switch apps.';

  @override
  String get autoSwitcherButtonTurnOff => 'Turn Off';

  @override
  String get autoSwitcherInstructionPress => 'Press';

  @override
  String get autoSwitcherInstructionManual =>
      'to update manually to focused process';

  @override
  String get autoSwitcherHeadingEnable => 'Enable automatic switching';

  @override
  String get autoSwitcherDescriptionInactive =>
      'Categories will change automatically when you switch between apps.';

  @override
  String get autoSwitcherButtonTurnOn => 'Turn On';

  @override
  String get autoSwitcherInstructionOr => 'Or press';

  @override
  String get settingsTabMappings => 'Mappings';

  @override
  String get settingsTabTheme => 'Theme';

  @override
  String get settingsAutoSyncOnStart => 'Auto-sync mappings on app start';

  @override
  String get settingsAutoSyncOnStartDesc =>
      'Automatically sync mapping lists when the application starts';

  @override
  String get settingsAutoSyncInterval => 'Auto-sync interval';

  @override
  String get settingsAutoSyncIntervalDesc =>
      'How often to automatically sync mapping lists (0 = never)';

  @override
  String get settingsAutoSyncNever => 'Never';

  @override
  String get settingsTimingTitle => 'HOW THESE SETTINGS WORK TOGETHER';

  @override
  String settingsTimingStep1(int scanInterval) {
    return 'App checks for focused window every ${scanInterval}s';
  }

  @override
  String get settingsTimingStep2Instant =>
      'Category switches immediately when new app detected';

  @override
  String settingsTimingStep2Debounce(int debounce) {
    return 'Waits ${debounce}s after detecting new app (debounce)';
  }

  @override
  String settingsTimingStep3Instant(int scanInterval) {
    return 'Total switch time: ${scanInterval}s (instant after detection)';
  }

  @override
  String settingsTimingStep3Debounce(int scanInterval, int scanDebounce) {
    return 'Total switch time: ${scanInterval}s to ${scanDebounce}s';
  }

  @override
  String get settingsFramelessWindow => 'Use Frameless Window';

  @override
  String get settingsFramelessWindowDesc =>
      'Remove the Windows title bar for a modern, borderless look with rounded corners';

  @override
  String get settingsInvertLayout => 'Invert Footer/Header';

  @override
  String get settingsInvertLayoutDesc =>
      'Swap the positions of the header and footer sections';

  @override
  String get settingsTokenExpired => 'Expired';

  @override
  String settingsTokenExpiresDays(int days, int hours) {
    return 'Expires in ${days}d ${hours}h';
  }

  @override
  String settingsTokenExpiresHours(int hours, int minutes) {
    return 'Expires in ${hours}h ${minutes}m';
  }

  @override
  String settingsTokenExpiresMinutes(int minutes) {
    return 'Expires in ${minutes}m';
  }

  @override
  String get settingsResetDesc =>
      'Reset all settings and data to factory defaults';

  @override
  String get settingsButtonReset => 'Reset';

  @override
  String mappingEditorSummary(
    int count,
    String plural,
    int lists,
    String pluralLists,
  ) {
    return '$count process mapping$plural from $lists active list$pluralLists';
  }

  @override
  String mappingEditorBreakdown(int custom, int community) {
    return '$custom custom, $community from community lists';
  }

  @override
  String get mappingEditorButtonLists => 'Lists';

  @override
  String get mappingEditorButtonAdd => 'Add';

  @override
  String get mappingEditorDeleteTitle => 'Delete Multiple Mappings';

  @override
  String mappingEditorDeleteMessage(int count, String plural) {
    return 'Are you sure you want to delete $count mapping$plural? This action cannot be undone.';
  }

  @override
  String get mappingEditorExportTitle => 'Export Mappings';

  @override
  String get mappingEditorExportFilename => 'my-mappings.json';

  @override
  String mappingEditorExportSuccess(int count, String plural) {
    return 'Exported $count mapping$plural to';
  }

  @override
  String get mappingEditorExportFailed => 'Export Failed';

  @override
  String get addMappingPrivacySafe => 'Privacy-Safe Path';

  @override
  String get addMappingCustomLocation => 'Custom Location';

  @override
  String get addMappingOnlyFolder => 'Only game folder names stored';

  @override
  String get addMappingNotStored => 'Path not stored for privacy';

  @override
  String get colorPickerTitle => 'Pick Color';

  @override
  String get colorPickerHue => 'Hue';

  @override
  String get colorPickerSaturation => 'Saturation';

  @override
  String get colorPickerValue => 'Value';

  @override
  String get colorPickerButtonCancel => 'Cancel';

  @override
  String get colorPickerButtonSelect => 'Select';

  @override
  String get dropdownPlaceholder => 'Select an option';

  @override
  String get dropdownSearchHint => 'Search...';

  @override
  String get dropdownNoResults => 'No results found';

  @override
  String paginationPageInfo(int current, int total) {
    return 'Page $current of $total';
  }

  @override
  String get paginationGoTo => 'Go to:';

  @override
  String get datePickerPlaceholder => 'Select date';

  @override
  String get timePickerAM => 'AM';

  @override
  String get timePickerPM => 'PM';

  @override
  String get timePickerPlaceholder => 'Select time';

  @override
  String get fileUploadInstruction => 'Click to upload file';

  @override
  String fileUploadAllowed(String extensions) {
    return 'Allowed: $extensions';
  }

  @override
  String get menuButtonTooltip => 'More options';

  @override
  String get breadcrumbEllipsis => '...';

  @override
  String get breadcrumbTooltipShowPath => 'Show path';

  @override
  String get hotkeyModCtrl => 'Ctrl';

  @override
  String get hotkeyModAlt => 'Alt';

  @override
  String get hotkeyModShift => 'Shift';

  @override
  String get hotkeyModWin => 'Win';

  @override
  String get hotkeySpace => 'Space';

  @override
  String get hotkeyEnter => 'Enter';

  @override
  String get hotkeyTab => 'Tab';

  @override
  String get hotkeyBackspace => 'Bksp';

  @override
  String get hotkeyDelete => 'Del';

  @override
  String get hotkeyEscape => 'Esc';

  @override
  String get hotkeyHome => 'Home';

  @override
  String get hotkeyEnd => 'End';

  @override
  String get hotkeyPageUp => 'PgUp';

  @override
  String get hotkeyPageDown => 'PgDn';

  @override
  String get statusDashboardCurrentActivity => 'Current Activity';

  @override
  String get statusDashboardNotStarted => 'Not started';

  @override
  String get statusDashboardReady => 'Ready';

  @override
  String get statusDashboardCheckingApp => 'Checking active app';

  @override
  String get statusDashboardFindingCategory => 'Finding category';

  @override
  String get statusDashboardUpdating => 'Updating category';

  @override
  String get statusDashboardWaiting => 'Waiting for confirmation';

  @override
  String get statusDashboardError => 'Error occurred';

  @override
  String mappingListOfCount(int count, int total) {
    return '$count of $total';
  }

  @override
  String get mappingListActionDelete => 'Delete';

  @override
  String get mappingListActionEnable => 'Enable';

  @override
  String get mappingListActionDisable => 'Disable';

  @override
  String autoSwitcherTimeSecondsAgo(int seconds) {
    return '${seconds}s ago';
  }

  @override
  String autoSwitcherTimeMinutesAgo(int minutes) {
    return '${minutes}m ago';
  }

  @override
  String autoSwitcherTimeHoursAgo(int hours) {
    return '${hours}h ago';
  }

  @override
  String get settingsSentry => 'Error & Performance Tracking';

  @override
  String get settingsSentryDescription =>
      'Help improve TKit by sending anonymous crash reports and performance data';

  @override
  String get settingsEnableErrorTrackingLabel => 'Enable error tracking';

  @override
  String get settingsEnableErrorTrackingSubtitle =>
      'Send crash reports to help us fix bugs faster (requires app restart)';

  @override
  String get settingsEnablePerformanceMonitoringLabel =>
      'Enable performance monitoring';

  @override
  String get settingsEnablePerformanceMonitoringSubtitle =>
      'Track app performance to identify slowdowns (requires app restart)';

  @override
  String get settingsEnableSessionReplayLabel => 'Enable session replay';

  @override
  String get settingsEnableSessionReplaySubtitle =>
      'Record app interactions to help diagnose complex issues (requires app restart)';

  @override
  String get settingsSentryRestartRequired =>
      'Changes require app restart to take effect';

  @override
  String get welcomeSentryTitle => 'Privacy & Diagnostics';

  @override
  String get welcomeSentryDescription =>
      'Help us improve TKit by sending anonymous crash reports and performance data. You can change this anytime in Settings.';

  @override
  String get welcomeSentryEnableErrorTracking => 'Send error reports';

  @override
  String get welcomeSentryEnablePerformanceMonitoring =>
      'Send performance data';

  @override
  String get welcomeSentryEnableSessionReplay =>
      'Enable session replay (optional)';

  @override
  String get tutorialSkipButton => 'Skip Tutorial';

  @override
  String get tutorialRestartButton => 'Show Tutorial';

  @override
  String get tutorialAutoSwitcherTabTitle => 'Auto Switcher';

  @override
  String get tutorialAutoSwitcherTabDescription =>
      'This is your main control center. Click here to monitor and control automatic category switching based on your active application.';

  @override
  String get tutorialMappingsTabTitle => 'Mappings';

  @override
  String get tutorialMappingsTabDescription =>
      'Manage your game-to-category mappings here. Add custom mappings or use community presets to automatically switch your Twitch category.';

  @override
  String get tutorialSettingsTabTitle => 'Settings';

  @override
  String get tutorialSettingsTabDescription =>
      'Customize TKit\'s behavior, appearance, and configure your Twitch connection.';

  @override
  String get tutorialAutoSwitcherControlTitle =>
      'Automatic vs Manual Switching';

  @override
  String get tutorialAutoSwitcherControlDescription =>
      'Click the TURN ON button to enable automatic switching when you launch games. Want it to start automatically? Go to Settings and enable \'Start monitoring on app launch\'.\n\nAutomatic mode: Hands-free switching for all mapped games.\nManual mode: Use your hotkey for full control when you want to update.';

  @override
  String get tutorialAutoSwitcherPageTitle => 'How Auto Switcher Works';

  @override
  String get tutorialAutoSwitcherPageDescription =>
      'TKit monitors your active window. When you switch to a game, it automatically updates your Twitch category based on your mappings. Press \'Turn On\' to start monitoring.';

  @override
  String get tutorialMappingsPageTitle => 'Managing Mappings';

  @override
  String get tutorialMappingsPageDescription =>
      'Mappings connect applications to Twitch categories. Click \'Add Mapping\' to create custom ones, or manage community lists to import verified mappings from other users.';
}
