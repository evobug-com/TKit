import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_cs.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('cs'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ja'),
    Locale('ko'),
    Locale('pl'),
    Locale('pt'),
    Locale('zh'),
  ];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'TKit'**
  String get appTitle;

  /// Welcome screen title
  ///
  /// In en, this message translates to:
  /// **'Welcome to TKit'**
  String get welcomeTitle;

  /// Language selection instruction
  ///
  /// In en, this message translates to:
  /// **'Select Your Language'**
  String get selectLanguage;

  /// Language field label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// Continue button text
  ///
  /// In en, this message translates to:
  /// **'CONTINUE'**
  String get continueButton;

  /// Confirmation button text
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Hello greeting
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// Native name of this language
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageNativeName;

  /// English language name
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// Czech language name
  ///
  /// In en, this message translates to:
  /// **'Čeština'**
  String get languageCzech;

  /// Polish language name
  ///
  /// In en, this message translates to:
  /// **'Polski'**
  String get languagePolish;

  /// Spanish language name
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// French language name
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// German language name
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get languageGerman;

  /// Portuguese language name
  ///
  /// In en, this message translates to:
  /// **'Português'**
  String get languagePortuguese;

  /// Japanese language name
  ///
  /// In en, this message translates to:
  /// **'日本語'**
  String get languageJapanese;

  /// Korean language name
  ///
  /// In en, this message translates to:
  /// **'한국어'**
  String get languageKorean;

  /// Chinese language name
  ///
  /// In en, this message translates to:
  /// **'中文'**
  String get languageChinese;

  /// Language settings label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// Language settings description
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language for the application'**
  String get settingsLanguageDescription;

  /// Notice shown when language is changed
  ///
  /// In en, this message translates to:
  /// **'Language changed. The application will update immediately.'**
  String get languageChangeNotice;

  /// Success message for authentication
  ///
  /// In en, this message translates to:
  /// **'Successfully authenticated as'**
  String get authSuccessAuthenticatedAs;

  /// System tray menu option to show TKit window
  ///
  /// In en, this message translates to:
  /// **'Show TKit'**
  String get systemTrayShowTkit;

  /// Button to initiate Twitch connection
  ///
  /// In en, this message translates to:
  /// **'Connect to Twitch'**
  String get authConnectToTwitch;

  /// System tray menu option for auto switcher
  ///
  /// In en, this message translates to:
  /// **'Auto Switcher'**
  String get systemTrayAutoSwitcher;

  /// Loading state message
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get authLoading;

  /// System tray menu option for category mappings
  ///
  /// In en, this message translates to:
  /// **'Category Mappings'**
  String get systemTrayCategoryMappings;

  /// Token refresh in progress message
  ///
  /// In en, this message translates to:
  /// **'Refreshing token...'**
  String get authRefreshingToken;

  /// System tray menu option for settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get systemTraySettings;

  /// Successful authentication message
  ///
  /// In en, this message translates to:
  /// **'Successfully Authenticated'**
  String get authSuccessfullyAuthenticated;

  /// System tray menu option to exit application
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get systemTrayExit;

  /// Label showing current logged in user
  ///
  /// In en, this message translates to:
  /// **'Logged in as'**
  String get authLoggedInAs;

  /// System tray icon tooltip
  ///
  /// In en, this message translates to:
  /// **'TKit - Twitch Toolkit'**
  String get systemTrayTooltip;

  /// Authentication failure error message
  ///
  /// In en, this message translates to:
  /// **'Authentication Failed'**
  String get authErrorAuthenticationFailed;

  /// Label for error code display
  ///
  /// In en, this message translates to:
  /// **'Error code:'**
  String get authErrorErrorCode;

  /// Button to retry authentication
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get authTryAgain;

  /// Header for authorization steps
  ///
  /// In en, this message translates to:
  /// **'Authorization Steps'**
  String get authAuthorizationSteps;

  /// First authorization step instruction
  ///
  /// In en, this message translates to:
  /// **'Click \"Connect to Twitch\" button below'**
  String get authStep1;

  /// Second authorization step instruction
  ///
  /// In en, this message translates to:
  /// **'Your browser will open the Twitch authorization page'**
  String get authStep2;

  /// Third authorization step instruction
  ///
  /// In en, this message translates to:
  /// **'Review and authorize TKit to manage your channel'**
  String get authStep3;

  /// Fourth authorization step instruction
  ///
  /// In en, this message translates to:
  /// **'Return to this window after authorization'**
  String get authStep4;

  /// Connect to Twitch button text
  ///
  /// In en, this message translates to:
  /// **'CONNECT TO TWITCH'**
  String get authConnectToTwitchButton;

  /// Message explaining required access
  ///
  /// In en, this message translates to:
  /// **'TKit requires access to update your Twitch channel category.'**
  String get authRequiresAccessMessage;

  /// Device code authentication title
  ///
  /// In en, this message translates to:
  /// **'Connect to Twitch'**
  String get authDeviceCodeTitle;

  /// Device code flow instructions header
  ///
  /// In en, this message translates to:
  /// **'To connect your Twitch account, follow these simple steps:'**
  String get authDeviceCodeInstructions;

  /// Device code step 1 text
  ///
  /// In en, this message translates to:
  /// **'Go to'**
  String get authDeviceCodeStep1;

  /// Device code step 2 text
  ///
  /// In en, this message translates to:
  /// **'Enter this code:'**
  String get authDeviceCodeStep2;

  /// Device code step 3 text
  ///
  /// In en, this message translates to:
  /// **'Authorize TKit to manage your channel category'**
  String get authDeviceCodeStep3;

  /// Label for device code display
  ///
  /// In en, this message translates to:
  /// **'Your Code'**
  String get authDeviceCodeCodeLabel;

  /// Copy code button text
  ///
  /// In en, this message translates to:
  /// **'Copy Code'**
  String get authDeviceCodeCopyCode;

  /// Code copied confirmation
  ///
  /// In en, this message translates to:
  /// **'Copied!'**
  String get authDeviceCodeCopied;

  /// Open browser button text
  ///
  /// In en, this message translates to:
  /// **'Open twitch.tv/activate'**
  String get authDeviceCodeOpenBrowser;

  /// Waiting for user to authorize
  ///
  /// In en, this message translates to:
  /// **'Waiting for authorization...'**
  String get authDeviceCodeWaiting;

  /// Code expiration countdown
  ///
  /// In en, this message translates to:
  /// **'Code expires in {minutes}:{seconds}'**
  String authDeviceCodeExpiresIn(String minutes, String seconds);

  /// Code expired message
  ///
  /// In en, this message translates to:
  /// **'Code expired. Please try again.'**
  String get authDeviceCodeExpired;

  /// Cancel device code flow button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get authDeviceCodeCancel;

  /// Device code success message
  ///
  /// In en, this message translates to:
  /// **'Successfully connected!'**
  String get authDeviceCodeSuccess;

  /// Device code error message
  ///
  /// In en, this message translates to:
  /// **'Connection failed. Please try again.'**
  String get authDeviceCodeError;

  /// Help text for device code flow
  ///
  /// In en, this message translates to:
  /// **'Having trouble? Make sure you\'re logged in to Twitch in your browser.'**
  String get authDeviceCodeHelp;

  /// Auto switcher page title
  ///
  /// In en, this message translates to:
  /// **'AUTO SWITCHER'**
  String get autoSwitcherPageTitle;

  /// Authenticated status
  ///
  /// In en, this message translates to:
  /// **'Authenticated'**
  String get authStatusAuthenticated;

  /// Auto switcher page description
  ///
  /// In en, this message translates to:
  /// **'Automatically updates stream category based on focused application'**
  String get autoSwitcherPageDescription;

  /// Connecting status
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get authStatusConnecting;

  /// Status section header
  ///
  /// In en, this message translates to:
  /// **'STATUS'**
  String get autoSwitcherStatusHeader;

  /// Error status
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get authStatusError;

  /// Current process label
  ///
  /// In en, this message translates to:
  /// **'CURRENT PROCESS'**
  String get autoSwitcherStatusCurrentProcess;

  /// Not connected status
  ///
  /// In en, this message translates to:
  /// **'Not connected'**
  String get authStatusNotConnected;

  /// None value
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get autoSwitcherStatusNone;

  /// Matched category label
  ///
  /// In en, this message translates to:
  /// **'MATCHED CATEGORY'**
  String get autoSwitcherStatusMatchedCategory;

  /// Auto switcher navigation item
  ///
  /// In en, this message translates to:
  /// **'Auto Switcher'**
  String get mainWindowNavAutoSwitcher;

  /// Last update label
  ///
  /// In en, this message translates to:
  /// **'LAST UPDATE'**
  String get autoSwitcherStatusLastUpdate;

  /// Mappings navigation item
  ///
  /// In en, this message translates to:
  /// **'Mappings'**
  String get mainWindowNavMappings;

  /// Never value for last update
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get autoSwitcherStatusNever;

  /// Settings navigation item
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get mainWindowNavSettings;

  /// Connected status in main window
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get mainWindowStatusConnected;

  /// Update status label
  ///
  /// In en, this message translates to:
  /// **'UPDATE STATUS'**
  String get autoSwitcherStatusUpdateStatus;

  /// Disconnected status in main window
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get mainWindowStatusDisconnected;

  /// No updates yet message
  ///
  /// In en, this message translates to:
  /// **'No updates yet'**
  String get autoSwitcherStatusNoUpdatesYet;

  /// Minimize window button
  ///
  /// In en, this message translates to:
  /// **'Minimize'**
  String get mainWindowWindowControlMinimize;

  /// Success update status
  ///
  /// In en, this message translates to:
  /// **'SUCCESS'**
  String get autoSwitcherStatusSuccess;

  /// Starting authentication loading message
  ///
  /// In en, this message translates to:
  /// **'Starting authentication...'**
  String get authLoadingStartingAuthentication;

  /// Maximize window button
  ///
  /// In en, this message translates to:
  /// **'Maximize'**
  String get mainWindowWindowControlMaximize;

  /// Failed update status
  ///
  /// In en, this message translates to:
  /// **'FAILED'**
  String get autoSwitcherStatusFailed;

  /// Logging out loading message
  ///
  /// In en, this message translates to:
  /// **'Logging out...'**
  String get authLoadingLoggingOut;

  /// Settings saved success message
  ///
  /// In en, this message translates to:
  /// **'Settings saved successfully'**
  String get settingsSavedSuccessfully;

  /// System state label
  ///
  /// In en, this message translates to:
  /// **'SYSTEM STATE'**
  String get autoSwitcherStatusSystemState;

  /// Close window button
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get mainWindowWindowControlClose;

  /// Checking status loading message
  ///
  /// In en, this message translates to:
  /// **'Checking authentication status...'**
  String get authLoadingCheckingStatus;

  /// Retry button
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get settingsRetry;

  /// Settings page title
  ///
  /// In en, this message translates to:
  /// **'SETTINGS'**
  String get settingsPageTitle;

  /// Settings page description
  ///
  /// In en, this message translates to:
  /// **'Configure application behavior and preferences'**
  String get settingsPageDescription;

  /// General settings tab
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsTabGeneral;

  /// Auto Switcher settings tab
  ///
  /// In en, this message translates to:
  /// **'Auto Switcher'**
  String get settingsTabAutoSwitcher;

  /// Keyboard settings tab
  ///
  /// In en, this message translates to:
  /// **'Keyboard'**
  String get settingsTabKeyboard;

  /// Twitch settings tab
  ///
  /// In en, this message translates to:
  /// **'Twitch'**
  String get settingsTabTwitch;

  /// Advanced settings tab
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get settingsTabAdvanced;

  /// Not initialized system state
  ///
  /// In en, this message translates to:
  /// **'NOT INITIALIZED'**
  String get autoSwitcherStatusNotInitialized;

  /// Ready status in footer
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get mainWindowFooterReady;

  /// Token refresh failed error message
  ///
  /// In en, this message translates to:
  /// **'Token refresh failed:'**
  String get authErrorTokenRefreshFailed;

  /// Auto switcher settings section
  ///
  /// In en, this message translates to:
  /// **'Auto Switcher'**
  String get settingsAutoSwitcher;

  /// Idle system state
  ///
  /// In en, this message translates to:
  /// **'IDLE'**
  String get autoSwitcherStatusIdle;

  /// Update dialog title
  ///
  /// In en, this message translates to:
  /// **'Update Available'**
  String get updateDialogTitle;

  /// Monitoring settings section
  ///
  /// In en, this message translates to:
  /// **'Monitoring'**
  String get settingsMonitoring;

  /// Detecting process system state
  ///
  /// In en, this message translates to:
  /// **'DETECTING PROCESS'**
  String get autoSwitcherStatusDetectingProcess;

  /// Category mappings page title
  ///
  /// In en, this message translates to:
  /// **'CATEGORY MAPPINGS'**
  String get categoryMappingTitle;

  /// What's new label in update dialog
  ///
  /// In en, this message translates to:
  /// **'What\'s New:'**
  String get updateDialogWhatsNew;

  /// Scan interval setting label
  ///
  /// In en, this message translates to:
  /// **'Scan Interval'**
  String get settingsScanIntervalLabel;

  /// Searching mapping system state
  ///
  /// In en, this message translates to:
  /// **'SEARCHING MAPPING'**
  String get autoSwitcherStatusSearchingMapping;

  /// Category mappings page subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage process-to-category mappings for automatic switching'**
  String get categoryMappingSubtitle;

  /// Download complete message
  ///
  /// In en, this message translates to:
  /// **'Download complete! Ready to install.'**
  String get updateDialogDownloadComplete;

  /// Scan interval setting description
  ///
  /// In en, this message translates to:
  /// **'How often to check which application has focus'**
  String get settingsScanIntervalDescription;

  /// Updating category system state
  ///
  /// In en, this message translates to:
  /// **'UPDATING CATEGORY'**
  String get autoSwitcherStatusUpdatingCategory;

  /// Add mapping button
  ///
  /// In en, this message translates to:
  /// **'ADD MAPPING'**
  String get categoryMappingAddMappingButton;

  /// Download failed error message
  ///
  /// In en, this message translates to:
  /// **'Download failed:'**
  String get updateDialogDownloadFailed;

  /// Debounce time setting label
  ///
  /// In en, this message translates to:
  /// **'Debounce Time'**
  String get settingsDebounceTimeLabel;

  /// Waiting debounce system state
  ///
  /// In en, this message translates to:
  /// **'WAITING (DEBOUNCE)'**
  String get autoSwitcherStatusWaitingDebounce;

  /// Error dialog title
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get categoryMappingErrorDialogTitle;

  /// Remind later button
  ///
  /// In en, this message translates to:
  /// **'Remind Me Later'**
  String get updateDialogRemindLater;

  /// Debounce time setting description
  ///
  /// In en, this message translates to:
  /// **'Wait time before switching category after app change (prevents rapid switching)'**
  String get settingsDebounceTimeDescription;

  /// Error system state
  ///
  /// In en, this message translates to:
  /// **'ERROR'**
  String get autoSwitcherStatusError;

  /// Total mappings stat label
  ///
  /// In en, this message translates to:
  /// **'Total Mappings'**
  String get categoryMappingStatsTotalMappings;

  /// Download update button
  ///
  /// In en, this message translates to:
  /// **'Download Update'**
  String get updateDialogDownloadUpdate;

  /// Auto start monitoring setting label
  ///
  /// In en, this message translates to:
  /// **'Start monitoring automatically'**
  String get settingsAutoStartMonitoringLabel;

  /// Controls section header
  ///
  /// In en, this message translates to:
  /// **'CONTROLS'**
  String get autoSwitcherControlsHeader;

  /// User defined mappings stat label
  ///
  /// In en, this message translates to:
  /// **'User Defined'**
  String get categoryMappingStatsUserDefined;

  /// Cancel button in update dialog
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get updateDialogCancel;

  /// Auto start monitoring setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Begin monitoring for active application when TKit starts'**
  String get settingsAutoStartMonitoringSubtitle;

  /// Stop monitoring button
  ///
  /// In en, this message translates to:
  /// **'STOP MONITORING'**
  String get autoSwitcherControlsStopMonitoring;

  /// Presets stat label
  ///
  /// In en, this message translates to:
  /// **'Presets'**
  String get categoryMappingStatsPresets;

  /// Later button in update dialog
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get updateDialogLater;

  /// Fallback behavior settings section
  ///
  /// In en, this message translates to:
  /// **'Fallback Behavior'**
  String get settingsFallbackBehavior;

  /// Start monitoring button
  ///
  /// In en, this message translates to:
  /// **'START MONITORING'**
  String get autoSwitcherControlsStartMonitoring;

  /// Error loading mappings message
  ///
  /// In en, this message translates to:
  /// **'Error loading mappings'**
  String get categoryMappingErrorLoading;

  /// Install and restart button
  ///
  /// In en, this message translates to:
  /// **'Install & Restart'**
  String get updateDialogInstallRestart;

  /// Fallback behavior setting label
  ///
  /// In en, this message translates to:
  /// **'When no mapping is found'**
  String get settingsFallbackBehaviorLabel;

  /// Manual update button
  ///
  /// In en, this message translates to:
  /// **'MANUAL UPDATE'**
  String get autoSwitcherControlsManualUpdate;

  /// Retry button
  ///
  /// In en, this message translates to:
  /// **'RETRY'**
  String get categoryMappingRetryButton;

  /// Today text for date display
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get updateDialogToday;

  /// Fallback behavior setting description
  ///
  /// In en, this message translates to:
  /// **'Choose what happens when the focused app has no category mapping'**
  String get settingsFallbackBehaviorDescription;

  /// Delete mapping dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Mapping'**
  String get categoryMappingDeleteDialogTitle;

  /// Monitoring status label
  ///
  /// In en, this message translates to:
  /// **'MONITORING STATUS'**
  String get autoSwitcherControlsMonitoringStatus;

  /// Yesterday text for date display
  ///
  /// In en, this message translates to:
  /// **'yesterday'**
  String get updateDialogYesterday;

  /// Custom category settings section
  ///
  /// In en, this message translates to:
  /// **'Custom Category'**
  String get settingsCustomCategory;

  /// Delete mapping confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this mapping?'**
  String get categoryMappingDeleteDialogMessage;

  /// Active monitoring status
  ///
  /// In en, this message translates to:
  /// **'ACTIVE'**
  String get autoSwitcherControlsActive;

  /// Days ago text for date display
  ///
  /// In en, this message translates to:
  /// **'{days} days ago'**
  String updateDialogDaysAgo(int days);

  /// Custom category search hint
  ///
  /// In en, this message translates to:
  /// **'Search for a category...'**
  String get settingsCustomCategoryHint;

  /// Delete confirmation button
  ///
  /// In en, this message translates to:
  /// **'DELETE'**
  String get categoryMappingDeleteDialogConfirm;

  /// Inactive monitoring status
  ///
  /// In en, this message translates to:
  /// **'INACTIVE'**
  String get autoSwitcherControlsInactive;

  /// Version text for update dialog
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String updateDialogVersion(String version);

  /// Cancel delete button
  ///
  /// In en, this message translates to:
  /// **'CANCEL'**
  String get categoryMappingDeleteDialogCancel;

  /// Category search unavailable message
  ///
  /// In en, this message translates to:
  /// **'Category search will be available when Twitch API module is complete'**
  String get settingsCategorySearchUnavailable;

  /// Active monitoring description
  ///
  /// In en, this message translates to:
  /// **'Automatically updating category based on focused process'**
  String get autoSwitcherControlsActiveDescription;

  /// Published date text for update dialog
  ///
  /// In en, this message translates to:
  /// **'Published {date}'**
  String updateDialogPublished(String date);

  /// Edit mapping dialog title
  ///
  /// In en, this message translates to:
  /// **'EDIT MAPPING'**
  String get categoryMappingAddDialogEditTitle;

  /// Application settings section
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get settingsApplication;

  /// Inactive monitoring description
  ///
  /// In en, this message translates to:
  /// **'Start monitoring to enable automatic category updates'**
  String get autoSwitcherControlsInactiveDescription;

  /// Language setup step
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get welcomeStepLanguage;

  /// Add new mapping dialog title
  ///
  /// In en, this message translates to:
  /// **'ADD NEW MAPPING'**
  String get categoryMappingAddDialogAddTitle;

  /// Close button for add/edit mapping dialog
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get categoryMappingAddDialogClose;

  /// Process name field label
  ///
  /// In en, this message translates to:
  /// **'PROCESS NAME'**
  String get categoryMappingAddDialogProcessName;

  /// Executable path field label
  ///
  /// In en, this message translates to:
  /// **'EXECUTABLE PATH (OPTIONAL)'**
  String get categoryMappingAddDialogExecutablePath;

  /// Twitch category ID field label
  ///
  /// In en, this message translates to:
  /// **'TWITCH CATEGORY ID'**
  String get categoryMappingAddDialogCategoryId;

  /// Twitch category name field label
  ///
  /// In en, this message translates to:
  /// **'TWITCH CATEGORY NAME'**
  String get categoryMappingAddDialogCategoryName;

  /// Cancel button in add/edit mapping dialog
  ///
  /// In en, this message translates to:
  /// **'CANCEL'**
  String get categoryMappingAddDialogCancel;

  /// Update button in edit mapping dialog
  ///
  /// In en, this message translates to:
  /// **'UPDATE'**
  String get categoryMappingAddDialogUpdate;

  /// Add button in add mapping dialog
  ///
  /// In en, this message translates to:
  /// **'ADD'**
  String get categoryMappingAddDialogAdd;

  /// Auto-start with Windows setting label
  ///
  /// In en, this message translates to:
  /// **'Auto-start with Windows'**
  String get settingsAutoStartWindowsLabel;

  /// Close dialog tooltip
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get categoryMappingAddDialogCloseTooltip;

  /// Twitch setup step
  ///
  /// In en, this message translates to:
  /// **'Twitch'**
  String get welcomeStepTwitch;

  /// Behavior setup step
  ///
  /// In en, this message translates to:
  /// **'Behavior'**
  String get welcomeStepBehavior;

  /// Behavior step title
  ///
  /// In en, this message translates to:
  /// **'STEP 3: APPLICATION BEHAVIOR'**
  String get welcomeBehaviorStepTitle;

  /// Behavior section title
  ///
  /// In en, this message translates to:
  /// **'Application Behavior'**
  String get welcomeBehaviorTitle;

  /// Behavior section description
  ///
  /// In en, this message translates to:
  /// **'Configure how TKit behaves on startup and when minimized.'**
  String get welcomeBehaviorDescription;

  /// Behavior step optional info
  ///
  /// In en, this message translates to:
  /// **'These settings can be changed anytime in Settings.'**
  String get welcomeBehaviorOptionalInfo;

  /// Window controls position setting label
  ///
  /// In en, this message translates to:
  /// **'Window Controls Position'**
  String get settingsWindowControlsPositionLabel;

  /// Window controls position setting description
  ///
  /// In en, this message translates to:
  /// **'Choose where window controls (minimize, maximize, close) appear'**
  String get settingsWindowControlsPositionDescription;

  /// Left position for window controls
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get windowControlsPositionLeft;

  /// Center position for window controls
  ///
  /// In en, this message translates to:
  /// **'Center'**
  String get windowControlsPositionCenter;

  /// Right position for window controls
  ///
  /// In en, this message translates to:
  /// **'Right'**
  String get windowControlsPositionRight;

  /// Auto-start with Windows setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Launch TKit automatically when Windows starts'**
  String get settingsAutoStartWindowsSubtitle;

  /// Process name field label
  ///
  /// In en, this message translates to:
  /// **'PROCESS NAME'**
  String get categoryMappingAddDialogProcessNameLabel;

  /// Language step title
  ///
  /// In en, this message translates to:
  /// **'STEP 1: SELECT YOUR LANGUAGE'**
  String get welcomeLanguageStepTitle;

  /// Start minimized setting label
  ///
  /// In en, this message translates to:
  /// **'Start minimized'**
  String get settingsStartMinimizedLabel;

  /// Process name field hint
  ///
  /// In en, this message translates to:
  /// **'e.g., League of Legends.exe'**
  String get categoryMappingAddDialogProcessNameHint;

  /// Language change later message
  ///
  /// In en, this message translates to:
  /// **'You can change this later in Settings.'**
  String get welcomeLanguageChangeLater;

  /// Start minimized setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Launch TKit minimized to system tray'**
  String get settingsStartMinimizedSubtitle;

  /// Process name required validation message
  ///
  /// In en, this message translates to:
  /// **'Process name is required'**
  String get categoryMappingAddDialogProcessNameRequired;

  /// Twitch step title
  ///
  /// In en, this message translates to:
  /// **'STEP 2: CONNECT TO TWITCH'**
  String get welcomeTwitchStepTitle;

  /// Close to tray setting label
  ///
  /// In en, this message translates to:
  /// **'Close to system tray'**
  String get settingsMinimizeToTrayLabel;

  /// Executable path field label
  ///
  /// In en, this message translates to:
  /// **'EXECUTABLE PATH (OPTIONAL)'**
  String get categoryMappingAddDialogExecutablePathLabel;

  /// Twitch connection title
  ///
  /// In en, this message translates to:
  /// **'Twitch Connection'**
  String get welcomeTwitchConnectionTitle;

  /// Minimize to tray setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Keep TKit running in the background when closing window (minimize goes to taskbar)'**
  String get settingsMinimizeToTraySubtitle;

  /// Executable path field hint
  ///
  /// In en, this message translates to:
  /// **'e.g., C:\\Games\\LeagueOfLegends\\Game\\League of Legends.exe'**
  String get categoryMappingAddDialogExecutablePathHint;

  /// Connected as username message
  ///
  /// In en, this message translates to:
  /// **'Connected as {username}'**
  String welcomeTwitchConnectedAs(String username);

  /// Show notifications setting label
  ///
  /// In en, this message translates to:
  /// **'Show notifications'**
  String get settingsShowNotificationsLabel;

  /// Category ID field label
  ///
  /// In en, this message translates to:
  /// **'TWITCH CATEGORY ID'**
  String get categoryMappingAddDialogCategoryIdLabel;

  /// Twitch connection description
  ///
  /// In en, this message translates to:
  /// **'Connect your Twitch account to enable automatic category switching based on active application.'**
  String get welcomeTwitchDescription;

  /// Show notifications setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Display notifications when category is updated'**
  String get settingsShowNotificationsSubtitle;

  /// Notify on missing category setting label
  ///
  /// In en, this message translates to:
  /// **'Notify on missing category'**
  String get settingsNotifyMissingCategoryLabel;

  /// Notify on missing category setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Show notification when no mapping is found for a game or app'**
  String get settingsNotifyMissingCategorySubtitle;

  /// Category ID field hint
  ///
  /// In en, this message translates to:
  /// **'e.g., 21779'**
  String get categoryMappingAddDialogCategoryIdHint;

  /// Twitch step optional info
  ///
  /// In en, this message translates to:
  /// **'This step is optional. You can skip and set it up later in Settings.'**
  String get welcomeTwitchOptionalInfo;

  /// Keyboard shortcuts settings section
  ///
  /// In en, this message translates to:
  /// **'Keyboard Shortcuts'**
  String get settingsKeyboardShortcuts;

  /// Category ID required validation message
  ///
  /// In en, this message translates to:
  /// **'Category ID is required'**
  String get categoryMappingAddDialogCategoryIdRequired;

  /// Authorize with Twitch button
  ///
  /// In en, this message translates to:
  /// **'AUTHORIZE WITH TWITCH'**
  String get welcomeTwitchAuthorizeButton;

  /// Manual update hotkey setting label
  ///
  /// In en, this message translates to:
  /// **'Manual Update Hotkey'**
  String get settingsManualUpdateHotkeyLabel;

  /// Category name field label
  ///
  /// In en, this message translates to:
  /// **'TWITCH CATEGORY NAME'**
  String get categoryMappingAddDialogCategoryNameLabel;

  /// Next button
  ///
  /// In en, this message translates to:
  /// **'NEXT'**
  String get welcomeButtonNext;

  /// Manual update hotkey setting description
  ///
  /// In en, this message translates to:
  /// **'Trigger a manual category update'**
  String get settingsManualUpdateHotkeyDescription;

  /// Category name field hint
  ///
  /// In en, this message translates to:
  /// **'e.g., League of Legends'**
  String get categoryMappingAddDialogCategoryNameHint;

  /// Back button
  ///
  /// In en, this message translates to:
  /// **'BACK'**
  String get welcomeButtonBack;

  /// Unsaved changes warning
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes'**
  String get settingsUnsavedChanges;

  /// Category name required validation message
  ///
  /// In en, this message translates to:
  /// **'Category name is required'**
  String get categoryMappingAddDialogCategoryNameRequired;

  /// Discard changes button
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get settingsDiscard;

  /// Tip for finding category ID and name
  ///
  /// In en, this message translates to:
  /// **'Tip: Use the Twitch category search to find the correct ID and name'**
  String get categoryMappingAddDialogTip;

  /// Save settings button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get settingsSave;

  /// Cancel button in add/edit dialog
  ///
  /// In en, this message translates to:
  /// **'CANCEL'**
  String get categoryMappingAddDialogCancelButton;

  /// Twitch connection settings section
  ///
  /// In en, this message translates to:
  /// **'Twitch Connection'**
  String get settingsTwitchConnection;

  /// Update button in edit dialog
  ///
  /// In en, this message translates to:
  /// **'UPDATE'**
  String get categoryMappingAddDialogUpdateButton;

  /// Twitch connected status
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get settingsTwitchStatusConnected;

  /// Add button in add dialog
  ///
  /// In en, this message translates to:
  /// **'ADD'**
  String get categoryMappingAddDialogAddButton;

  /// Twitch not connected status
  ///
  /// In en, this message translates to:
  /// **'Not Connected'**
  String get settingsTwitchStatusNotConnected;

  /// Empty mappings list message
  ///
  /// In en, this message translates to:
  /// **'No category mappings yet'**
  String get categoryMappingListEmpty;

  /// Empty mappings list title
  ///
  /// In en, this message translates to:
  /// **'No category mappings yet'**
  String get categoryMappingListEmptyTitle;

  /// Logged in as label
  ///
  /// In en, this message translates to:
  /// **'Logged in as:'**
  String get settingsTwitchLoggedInAs;

  /// Empty mappings list subtitle
  ///
  /// In en, this message translates to:
  /// **'Add your first mapping to get started'**
  String get categoryMappingListEmptySubtitle;

  /// Disconnect from Twitch button
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get settingsTwitchDisconnect;

  /// Process name column header
  ///
  /// In en, this message translates to:
  /// **'PROCESS NAME'**
  String get categoryMappingListColumnProcessName;

  /// Twitch connect description
  ///
  /// In en, this message translates to:
  /// **'Connect your Twitch account to enable automatic category switching.'**
  String get settingsTwitchConnectDescription;

  /// Category column header
  ///
  /// In en, this message translates to:
  /// **'CATEGORY'**
  String get categoryMappingListColumnCategory;

  /// Connect to Twitch button
  ///
  /// In en, this message translates to:
  /// **'Connect to Twitch'**
  String get settingsTwitchConnect;

  /// Last used column header
  ///
  /// In en, this message translates to:
  /// **'LAST USED'**
  String get categoryMappingListColumnLastUsed;

  /// Cancel hotkey input button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get hotkeyInputCancel;

  /// Type column header
  ///
  /// In en, this message translates to:
  /// **'TYPE'**
  String get categoryMappingListColumnType;

  /// Change hotkey button
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get hotkeyInputChange;

  /// Actions column header
  ///
  /// In en, this message translates to:
  /// **'ACTIONS'**
  String get categoryMappingListColumnActions;

  /// Clear hotkey button
  ///
  /// In en, this message translates to:
  /// **'Clear hotkey'**
  String get hotkeyInputClearHotkey;

  /// ID prefix for category display
  ///
  /// In en, this message translates to:
  /// **'ID: '**
  String get categoryMappingListIdPrefix;

  /// Category ID display format
  ///
  /// In en, this message translates to:
  /// **'ID: {categoryId}'**
  String categoryMappingListCategoryId(String categoryId);

  /// Never used text for last used column
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get categoryMappingListNever;

  /// Just now time text for recent activity
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get categoryMappingListJustNow;

  /// Minutes ago time format
  ///
  /// In en, this message translates to:
  /// **'{minutes} {minutes, plural, =1{minute} other{minutes}} ago'**
  String categoryMappingListMinutesAgo(int minutes);

  /// Hours ago time format
  ///
  /// In en, this message translates to:
  /// **'{hours} {hours, plural, =1{hour} other{hours}} ago'**
  String categoryMappingListHoursAgo(int hours);

  /// Days ago time format
  ///
  /// In en, this message translates to:
  /// **'{days} {days, plural, =1{day} other{days}} ago'**
  String categoryMappingListDaysAgo(int days);

  /// Set hotkey button
  ///
  /// In en, this message translates to:
  /// **'Set Hotkey'**
  String get hotkeyInputSetHotkey;

  /// Never used text
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get categoryMappingListNeverUsed;

  /// User type label
  ///
  /// In en, this message translates to:
  /// **'USER'**
  String get categoryMappingListTypeUser;

  /// Preset type label
  ///
  /// In en, this message translates to:
  /// **'PRESET'**
  String get categoryMappingListTypePreset;

  /// Edit mapping tooltip
  ///
  /// In en, this message translates to:
  /// **'Edit mapping'**
  String get categoryMappingListEditTooltip;

  /// Delete mapping tooltip
  ///
  /// In en, this message translates to:
  /// **'Delete mapping'**
  String get categoryMappingListDeleteTooltip;

  /// Just now time text
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get categoryMappingListTimeJustNow;

  /// Mapping added success message
  ///
  /// In en, this message translates to:
  /// **'Mapping added successfully'**
  String get categoryMappingProviderSuccessAdded;

  /// Mapping updated success message
  ///
  /// In en, this message translates to:
  /// **'Mapping updated successfully'**
  String get categoryMappingProviderSuccessUpdated;

  /// Mapping deleted success message
  ///
  /// In en, this message translates to:
  /// **'Mapping deleted successfully'**
  String get categoryMappingProviderSuccessDeleted;

  /// Common cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// Common OK button
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// Common confirm button
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get commonConfirm;

  /// Error message prefix for auto switcher operations
  ///
  /// In en, this message translates to:
  /// **'Failed to'**
  String get autoSwitcherProviderErrorPrefix;

  /// Start monitoring operation text
  ///
  /// In en, this message translates to:
  /// **'start monitoring'**
  String get autoSwitcherProviderStartMonitoring;

  /// Stop monitoring operation text
  ///
  /// In en, this message translates to:
  /// **'stop monitoring'**
  String get autoSwitcherProviderStopMonitoring;

  /// Manual update operation text
  ///
  /// In en, this message translates to:
  /// **'perform manual update'**
  String get autoSwitcherProviderManualUpdate;

  /// Load history operation text
  ///
  /// In en, this message translates to:
  /// **'load history'**
  String get autoSwitcherProviderLoadHistory;

  /// Clear history operation text
  ///
  /// In en, this message translates to:
  /// **'clear history'**
  String get autoSwitcherProviderClearHistory;

  /// Success message for category update
  ///
  /// In en, this message translates to:
  /// **'Category updated successfully'**
  String get autoSwitcherProviderSuccessCategoryUpdated;

  /// Success message for clearing history
  ///
  /// In en, this message translates to:
  /// **'History cleared successfully'**
  String get autoSwitcherProviderSuccessHistoryCleared;

  /// Unknown error message
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get autoSwitcherProviderErrorUnknown;

  /// Factory reset settings section
  ///
  /// In en, this message translates to:
  /// **'Factory Reset'**
  String get settingsFactoryReset;

  /// Factory reset description
  ///
  /// In en, this message translates to:
  /// **'Reset all settings and data to factory defaults'**
  String get settingsFactoryResetDescription;

  /// Factory reset button text
  ///
  /// In en, this message translates to:
  /// **'Reset to Factory Defaults'**
  String get settingsFactoryResetButton;

  /// Factory reset dialog title
  ///
  /// In en, this message translates to:
  /// **'Factory Reset'**
  String get settingsFactoryResetDialogTitle;

  /// Factory reset confirmation message
  ///
  /// In en, this message translates to:
  /// **'This will:\n• Disconnect your Twitch account\n• Reset all settings to defaults\n• Clear all category mappings\n• Delete update history\n\nYour language preference will be preserved.\n\nAre you sure you want to continue?'**
  String get settingsFactoryResetDialogMessage;

  /// Factory reset confirm button
  ///
  /// In en, this message translates to:
  /// **'RESET'**
  String get settingsFactoryResetDialogConfirm;

  /// Factory reset success message
  ///
  /// In en, this message translates to:
  /// **'Application reset to factory defaults successfully. Please restart the application.'**
  String get settingsFactoryResetSuccess;

  /// Updates settings section
  ///
  /// In en, this message translates to:
  /// **'Updates'**
  String get settingsUpdates;

  /// Update channel setting label
  ///
  /// In en, this message translates to:
  /// **'Update Channel'**
  String get settingsUpdateChannelLabel;

  /// Update channel setting description
  ///
  /// In en, this message translates to:
  /// **'Choose which types of updates you want to receive'**
  String get settingsUpdateChannelDescription;

  /// Update channel changed confirmation message
  ///
  /// In en, this message translates to:
  /// **'Update channel changed to {channel}. Checking for updates...'**
  String settingsUpdateChannelChanged(String channel);

  /// Stable update channel name
  ///
  /// In en, this message translates to:
  /// **'Stable'**
  String get updateChannelStable;

  /// Stable update channel description
  ///
  /// In en, this message translates to:
  /// **'Recommended for most users. Only stable releases.'**
  String get updateChannelStableDesc;

  /// Release candidate update channel name
  ///
  /// In en, this message translates to:
  /// **'Release Candidate'**
  String get updateChannelRc;

  /// Release candidate update channel description
  ///
  /// In en, this message translates to:
  /// **'Stable features with final testing before stable release.'**
  String get updateChannelRcDesc;

  /// Beta update channel name
  ///
  /// In en, this message translates to:
  /// **'Beta'**
  String get updateChannelBeta;

  /// Beta update channel description
  ///
  /// In en, this message translates to:
  /// **'New features that are mostly stable. May have bugs.'**
  String get updateChannelBetaDesc;

  /// Development update channel name
  ///
  /// In en, this message translates to:
  /// **'Development'**
  String get updateChannelDev;

  /// Development update channel description
  ///
  /// In en, this message translates to:
  /// **'Bleeding edge features. Expect bugs and instability.'**
  String get updateChannelDevDesc;

  /// Do nothing fallback behavior option
  ///
  /// In en, this message translates to:
  /// **'Do Nothing'**
  String get fallbackBehaviorDoNothing;

  /// Just Chatting fallback behavior option
  ///
  /// In en, this message translates to:
  /// **'Just Chatting'**
  String get fallbackBehaviorJustChatting;

  /// Custom category fallback behavior option
  ///
  /// In en, this message translates to:
  /// **'Custom Category'**
  String get fallbackBehaviorCustom;

  /// Unknown game dialog title
  ///
  /// In en, this message translates to:
  /// **'Game Not Mapped'**
  String get unknownGameDialogTitle;

  /// Unknown game dialog subtitle
  ///
  /// In en, this message translates to:
  /// **'Select a Twitch category for \"{processName}\"'**
  String unknownGameDialogSubtitle(String processName);

  /// Close button tooltip
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get unknownGameDialogClose;

  /// Search section label
  ///
  /// In en, this message translates to:
  /// **'SEARCH TWITCH CATEGORIES'**
  String get unknownGameDialogSearchLabel;

  /// Search input hint text
  ///
  /// In en, this message translates to:
  /// **'Type game name...'**
  String get unknownGameDialogSearchHint;

  /// Options section header
  ///
  /// In en, this message translates to:
  /// **'OPTIONS'**
  String get unknownGameDialogOptionsHeader;

  /// Save locally checkbox label
  ///
  /// In en, this message translates to:
  /// **'Save mapping locally'**
  String get unknownGameDialogSaveLocallyLabel;

  /// Contribute to community checkbox label
  ///
  /// In en, this message translates to:
  /// **'Contribute to community mappings'**
  String get unknownGameDialogContributeLabel;

  /// Contribute to community checkbox subtitle
  ///
  /// In en, this message translates to:
  /// **'Help others by sharing this mapping on GitHub'**
  String get unknownGameDialogContributeSubtitle;

  /// Search error message title
  ///
  /// In en, this message translates to:
  /// **'Search Error'**
  String get unknownGameDialogSearchError;

  /// Prompt to search for categories
  ///
  /// In en, this message translates to:
  /// **'Search for a Twitch category above'**
  String get unknownGameDialogSearchPrompt;

  /// No search results message
  ///
  /// In en, this message translates to:
  /// **'No categories found'**
  String get unknownGameDialogNoResults;

  /// Ignore button text
  ///
  /// In en, this message translates to:
  /// **'Ignore'**
  String get unknownGameDialogIgnore;

  /// Skip button text
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get unknownGameDialogSkip;

  /// Save button text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get unknownGameDialogSave;

  /// Version status tooltip when up to date
  ///
  /// In en, this message translates to:
  /// **'Up to date'**
  String get versionStatusUpToDate;

  /// Version status tooltip when update is available
  ///
  /// In en, this message translates to:
  /// **'Update available'**
  String get versionStatusUpdateAvailable;

  /// Version status tooltip when check failed with error
  ///
  /// In en, this message translates to:
  /// **'Update check failed: {error}'**
  String versionStatusCheckFailed(String error);

  /// Version status tooltip when service is not initialized
  ///
  /// In en, this message translates to:
  /// **'Update service not initialized'**
  String get versionStatusNotInitialized;

  /// Version status tooltip when platform doesn't support updates
  ///
  /// In en, this message translates to:
  /// **'Updates not supported on this platform'**
  String get versionStatusPlatformNotSupported;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'cs',
    'de',
    'en',
    'es',
    'fr',
    'ja',
    'ko',
    'pl',
    'pt',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'cs':
      return AppLocalizationsCs();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
