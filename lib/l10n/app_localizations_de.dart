// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'TKit';

  @override
  String get welcomeTitle => 'Willkommen bei TKit';

  @override
  String get selectLanguage => 'Wählen Sie Ihre Sprache';

  @override
  String get languageLabel => 'Sprache';

  @override
  String get continueButton => 'WEITER';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get hello => 'Hallo';

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
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsLanguageDescription =>
      'Wählen Sie Ihre bevorzugte Sprache für die Anwendung';

  @override
  String get languageChangeNotice =>
      'Sprache geändert. Die Anwendung wird sofort aktualisiert.';

  @override
  String get authSuccessAuthenticatedAs => 'Erfolgreich authentifiziert als';

  @override
  String get systemTrayShowTkit => 'TKit anzeigen';

  @override
  String get authConnectToTwitch => 'Mit Twitch verbinden';

  @override
  String get systemTrayAutoSwitcher => 'Auto-Umschalter';

  @override
  String get authLoading => 'Wird geladen...';

  @override
  String get systemTrayCategoryMappings => 'Kategorie-Zuordnungen';

  @override
  String get authRefreshingToken => 'Token wird aktualisiert...';

  @override
  String get systemTraySettings => 'Einstellungen';

  @override
  String get authSuccessfullyAuthenticated => 'Erfolgreich authentifiziert';

  @override
  String get systemTrayExit => 'Beenden';

  @override
  String get authLoggedInAs => 'Angemeldet als';

  @override
  String get systemTrayTooltip => 'TKit - Twitch-Toolkit';

  @override
  String get authErrorAuthenticationFailed =>
      'Authentifizierung fehlgeschlagen';

  @override
  String get authErrorErrorCode => 'Fehlercode:';

  @override
  String get authTryAgain => 'Erneut versuchen';

  @override
  String get authAuthorizationSteps => 'Autorisierungsschritte';

  @override
  String get authStep1 =>
      'Klicken Sie unten auf die Schaltfläche \"Mit Twitch verbinden\"';

  @override
  String get authStep2 => 'Ihr Browser öffnet die Twitch-Autorisierungsseite';

  @override
  String get authStep3 =>
      'Überprüfen und autorisieren Sie TKit zur Verwaltung Ihres Kanals';

  @override
  String get authStep4 =>
      'Kehren Sie nach der Autorisierung zu diesem Fenster zurück';

  @override
  String get authConnectToTwitchButton => 'MIT TWITCH VERBINDEN';

  @override
  String get authRequiresAccessMessage =>
      'TKit benötigt Zugriff, um die Kategorie Ihres Twitch-Kanals zu aktualisieren.';

  @override
  String get authDeviceCodeTitle => 'Mit Twitch verbinden';

  @override
  String get authDeviceCodeInstructions =>
      'Um Ihr Twitch-Konto zu verbinden, folgen Sie diesen einfachen Schritten:';

  @override
  String get authDeviceCodeStep1 => 'Gehen Sie zu';

  @override
  String get authDeviceCodeStep2 => 'Geben Sie diesen Code ein:';

  @override
  String get authDeviceCodeStep3 =>
      'Autorisieren Sie TKit zur Verwaltung Ihrer Kanalkategorie';

  @override
  String get authDeviceCodeCodeLabel => 'Ihr Code';

  @override
  String get authDeviceCodeCopyCode => 'Code kopieren';

  @override
  String get authDeviceCodeCopied => 'Kopiert!';

  @override
  String get authDeviceCodeOpenBrowser => 'twitch.tv/activate öffnen';

  @override
  String get authDeviceCodeWaiting => 'Warten auf Autorisierung...';

  @override
  String authDeviceCodeExpiresIn(String minutes, String seconds) {
    return 'Code läuft ab in $minutes:$seconds';
  }

  @override
  String get authDeviceCodeExpired =>
      'Code abgelaufen. Bitte versuchen Sie es erneut.';

  @override
  String get authDeviceCodeCancel => 'Abbrechen';

  @override
  String get authDeviceCodeSuccess => 'Erfolgreich verbunden!';

  @override
  String get authDeviceCodeError =>
      'Verbindung fehlgeschlagen. Bitte versuchen Sie es erneut.';

  @override
  String get authDeviceCodeHelp =>
      'Probleme? Stellen Sie sicher, dass Sie in Ihrem Browser bei Twitch angemeldet sind.';

  @override
  String get autoSwitcherPageTitle => 'AUTO-UMSCHALTER';

  @override
  String get authStatusAuthenticated => 'Authentifiziert';

  @override
  String get autoSwitcherPageDescription =>
      'Aktualisiert die Stream-Kategorie automatisch basierend auf der fokussierten Anwendung';

  @override
  String get authStatusConnecting => 'Verbindung wird hergestellt...';

  @override
  String get autoSwitcherStatusHeader => 'STATUS';

  @override
  String get authStatusError => 'Fehler';

  @override
  String get autoSwitcherStatusCurrentProcess => 'AKTUELLER PROZESS';

  @override
  String get authStatusNotConnected => 'Nicht verbunden';

  @override
  String get autoSwitcherStatusNone => 'Keine';

  @override
  String get autoSwitcherStatusMatchedCategory => 'ÜBEREINSTIMMENDE KATEGORIE';

  @override
  String get mainWindowNavAutoSwitcher => 'Auto-Umschalter';

  @override
  String get autoSwitcherStatusLastUpdate => 'LETZTE AKTUALISIERUNG';

  @override
  String get mainWindowNavMappings => 'Zuordnungen';

  @override
  String get autoSwitcherStatusNever => 'Nie';

  @override
  String get mainWindowNavSettings => 'Einstellungen';

  @override
  String get mainWindowStatusConnected => 'Verbunden';

  @override
  String get autoSwitcherStatusUpdateStatus => 'AKTUALISIERUNGSSTATUS';

  @override
  String get mainWindowStatusDisconnected => 'Getrennt';

  @override
  String get autoSwitcherStatusNoUpdatesYet => 'Noch keine Aktualisierungen';

  @override
  String get mainWindowWindowControlMinimize => 'Minimieren';

  @override
  String get autoSwitcherStatusSuccess => 'ERFOLG';

  @override
  String get authLoadingStartingAuthentication =>
      'Authentifizierung wird gestartet...';

  @override
  String get mainWindowWindowControlMaximize => 'Maximieren';

  @override
  String get autoSwitcherStatusFailed => 'FEHLGESCHLAGEN';

  @override
  String get authLoadingLoggingOut => 'Wird abgemeldet...';

  @override
  String get settingsSavedSuccessfully =>
      'Einstellungen erfolgreich gespeichert';

  @override
  String get autoSwitcherStatusSystemState => 'SYSTEMZUSTAND';

  @override
  String get mainWindowWindowControlClose => 'Schließen';

  @override
  String get authLoadingCheckingStatus =>
      'Authentifizierungsstatus wird überprüft...';

  @override
  String get settingsRetry => 'Wiederholen';

  @override
  String get settingsPageTitle => 'EINSTELLUNGEN';

  @override
  String get settingsPageDescription =>
      'Anwendungsverhalten und Einstellungen konfigurieren';

  @override
  String get autoSwitcherStatusNotInitialized => 'NICHT INITIALISIERT';

  @override
  String get mainWindowFooterReady => 'Bereit';

  @override
  String get authErrorTokenRefreshFailed =>
      'Token-Aktualisierung fehlgeschlagen:';

  @override
  String get settingsAutoSwitcher => 'Auto-Umschalter';

  @override
  String get autoSwitcherStatusIdle => 'INAKTIV';

  @override
  String get updateDialogTitle => 'Aktualisierung verfügbar';

  @override
  String get settingsMonitoring => 'Überwachung';

  @override
  String get autoSwitcherStatusDetectingProcess => 'PROZESS WIRD ERKANNT';

  @override
  String get categoryMappingTitle => 'KATEGORIE-ZUORDNUNGEN';

  @override
  String get updateDialogWhatsNew => 'Was ist neu:';

  @override
  String get settingsScanIntervalLabel => 'Scan-Intervall';

  @override
  String get autoSwitcherStatusSearchingMapping => 'ZUORDNUNG WIRD GESUCHT';

  @override
  String get categoryMappingSubtitle =>
      'Verwalten Sie Prozess-zu-Kategorie-Zuordnungen für automatisches Umschalten';

  @override
  String get updateDialogDownloadComplete =>
      'Download abgeschlossen! Bereit zur Installation.';

  @override
  String get settingsScanIntervalDescription =>
      'Wie oft überprüft werden soll, welche Anwendung den Fokus hat';

  @override
  String get autoSwitcherStatusUpdatingCategory =>
      'KATEGORIE WIRD AKTUALISIERT';

  @override
  String get categoryMappingAddMappingButton => 'ZUORDNUNG HINZUFÜGEN';

  @override
  String get updateDialogDownloadFailed => 'Download fehlgeschlagen:';

  @override
  String get settingsDebounceTimeLabel => 'Entprellzeit';

  @override
  String get autoSwitcherStatusWaitingDebounce => 'WARTEN (ENTPRELLEN)';

  @override
  String get categoryMappingErrorDialogTitle => 'Fehler';

  @override
  String get updateDialogRemindLater => 'Später erinnern';

  @override
  String get settingsDebounceTimeDescription =>
      'Wartezeit vor dem Kategorienwechsel nach App-Wechsel (verhindert schnelles Umschalten)';

  @override
  String get autoSwitcherStatusError => 'FEHLER';

  @override
  String get categoryMappingStatsTotalMappings => 'Zuordnungen gesamt';

  @override
  String get updateDialogDownloadUpdate => 'Aktualisierung herunterladen';

  @override
  String get settingsAutoStartMonitoringLabel =>
      'Überwachung automatisch starten';

  @override
  String get autoSwitcherControlsHeader => 'STEUERUNG';

  @override
  String get categoryMappingStatsUserDefined => 'Benutzerdefiniert';

  @override
  String get updateDialogCancel => 'Abbrechen';

  @override
  String get settingsAutoStartMonitoringSubtitle =>
      'Überwachung für aktive Anwendung beim Start von TKit beginnen';

  @override
  String get autoSwitcherControlsStopMonitoring => 'ÜBERWACHUNG STOPPEN';

  @override
  String get categoryMappingStatsPresets => 'Voreinstellungen';

  @override
  String get updateDialogLater => 'Später';

  @override
  String get settingsFallbackBehavior => 'Fallback-Verhalten';

  @override
  String get autoSwitcherControlsStartMonitoring => 'ÜBERWACHUNG STARTEN';

  @override
  String get categoryMappingErrorLoading => 'Fehler beim Laden der Zuordnungen';

  @override
  String get updateDialogInstallRestart => 'Installieren und neu starten';

  @override
  String get settingsFallbackBehaviorLabel =>
      'Wenn keine Zuordnung gefunden wird';

  @override
  String get autoSwitcherControlsManualUpdate => 'MANUELLE AKTUALISIERUNG';

  @override
  String get categoryMappingRetryButton => 'WIEDERHOLEN';

  @override
  String get updateDialogToday => 'heute';

  @override
  String get settingsFallbackBehaviorDescription =>
      'Wählen Sie, was passiert, wenn die fokussierte App keine Kategoriezuordnung hat';

  @override
  String get categoryMappingDeleteDialogTitle => 'Zuordnung löschen';

  @override
  String get autoSwitcherControlsMonitoringStatus => 'ÜBERWACHUNGSSTATUS';

  @override
  String get updateDialogYesterday => 'gestern';

  @override
  String get settingsCustomCategory => 'Benutzerdefinierte Kategorie';

  @override
  String get categoryMappingDeleteDialogMessage =>
      'Möchten Sie diese Zuordnung wirklich löschen?';

  @override
  String get autoSwitcherControlsActive => 'AKTIV';

  @override
  String updateDialogDaysAgo(int days) {
    return 'vor $days Tagen';
  }

  @override
  String get settingsCustomCategoryHint => 'Nach einer Kategorie suchen...';

  @override
  String get categoryMappingDeleteDialogConfirm => 'LÖSCHEN';

  @override
  String get autoSwitcherControlsInactive => 'INAKTIV';

  @override
  String updateDialogVersion(String version) {
    return 'Version $version';
  }

  @override
  String get categoryMappingDeleteDialogCancel => 'ABBRECHEN';

  @override
  String get settingsCategorySearchUnavailable =>
      'Kategoriesuche wird verfügbar sein, wenn das Twitch-API-Modul fertiggestellt ist';

  @override
  String get autoSwitcherControlsActiveDescription =>
      'Kategorie wird automatisch basierend auf dem fokussierten Prozess aktualisiert';

  @override
  String updateDialogPublished(String date) {
    return 'Veröffentlicht am $date';
  }

  @override
  String get categoryMappingAddDialogEditTitle => 'ZUORDNUNG BEARBEITEN';

  @override
  String get settingsApplication => 'Anwendung';

  @override
  String get autoSwitcherControlsInactiveDescription =>
      'Starten Sie die Überwachung, um automatische Kategorieaktualisierungen zu aktivieren';

  @override
  String get welcomeStepLanguage => 'Sprache';

  @override
  String get categoryMappingAddDialogAddTitle => 'NEUE ZUORDNUNG HINZUFÜGEN';

  @override
  String get categoryMappingAddDialogClose => 'Schließen';

  @override
  String get categoryMappingAddDialogProcessName => 'PROZESSNAME';

  @override
  String get categoryMappingAddDialogExecutablePath =>
      'AUSFÜHRBARER PFAD (OPTIONAL)';

  @override
  String get categoryMappingAddDialogCategoryId => 'TWITCH-KATEGORIE-ID';

  @override
  String get categoryMappingAddDialogCategoryName => 'TWITCH-KATEGORIENAME';

  @override
  String get categoryMappingAddDialogCancel => 'ABBRECHEN';

  @override
  String get categoryMappingAddDialogUpdate => 'AKTUALISIEREN';

  @override
  String get categoryMappingAddDialogAdd => 'HINZUFÜGEN';

  @override
  String get settingsAutoStartWindowsLabel => 'Automatischer Start mit Windows';

  @override
  String get categoryMappingAddDialogCloseTooltip => 'Schließen';

  @override
  String get welcomeStepTwitch => 'Twitch';

  @override
  String get welcomeStepBehavior => 'Verhalten';

  @override
  String get welcomeBehaviorStepTitle => 'SCHRITT 3: ANWENDUNGSVERHALTEN';

  @override
  String get welcomeBehaviorTitle => 'Anwendungsverhalten';

  @override
  String get welcomeBehaviorDescription =>
      'Konfigurieren Sie, wie sich TKit beim Start und beim Minimieren verhält.';

  @override
  String get welcomeBehaviorOptionalInfo =>
      'Diese Einstellungen können jederzeit in den Einstellungen geändert werden.';

  @override
  String get settingsWindowControlsPositionLabel =>
      'Position der Fenstersteuerelemente';

  @override
  String get settingsWindowControlsPositionDescription =>
      'Wählen Sie, wo Fenstersteuerelemente (Minimieren, Maximieren, Schließen) angezeigt werden';

  @override
  String get windowControlsPositionLeft => 'Links';

  @override
  String get windowControlsPositionCenter => 'Mitte';

  @override
  String get windowControlsPositionRight => 'Rechts';

  @override
  String get settingsAutoStartWindowsSubtitle =>
      'TKit automatisch beim Start von Windows starten';

  @override
  String get categoryMappingAddDialogProcessNameLabel => 'PROZESSNAME';

  @override
  String get welcomeLanguageStepTitle => 'SCHRITT 1: WÄHLEN SIE IHRE SPRACHE';

  @override
  String get settingsStartMinimizedLabel => 'Minimiert starten';

  @override
  String get categoryMappingAddDialogProcessNameHint =>
      'z. B. League of Legends.exe';

  @override
  String get welcomeLanguageChangeLater =>
      'Sie können dies später in den Einstellungen ändern.';

  @override
  String get settingsStartMinimizedSubtitle =>
      'TKit minimiert in der Taskleiste starten';

  @override
  String get categoryMappingAddDialogProcessNameRequired =>
      'Prozessname ist erforderlich';

  @override
  String get welcomeTwitchStepTitle => 'SCHRITT 2: MIT TWITCH VERBINDEN';

  @override
  String get settingsMinimizeToTrayLabel => 'In Taskleiste minimieren';

  @override
  String get categoryMappingAddDialogExecutablePathLabel =>
      'AUSFÜHRBARER PFAD (OPTIONAL)';

  @override
  String get welcomeTwitchConnectionTitle => 'Twitch-Verbindung';

  @override
  String get settingsMinimizeToTraySubtitle =>
      'TKit beim Schließen oder Minimieren im Hintergrund weiterlaufen lassen';

  @override
  String get categoryMappingAddDialogExecutablePathHint =>
      'z. B. C:\\Games\\LeagueOfLegends\\Game\\League of Legends.exe';

  @override
  String welcomeTwitchConnectedAs(String username) {
    return 'Verbunden als $username';
  }

  @override
  String get settingsShowNotificationsLabel => 'Benachrichtigungen anzeigen';

  @override
  String get categoryMappingAddDialogCategoryIdLabel => 'TWITCH-KATEGORIE-ID';

  @override
  String get welcomeTwitchDescription =>
      'Verbinden Sie Ihr Twitch-Konto, um automatisches Kategorienwechseln basierend auf der aktiven Anwendung zu aktivieren.';

  @override
  String get settingsShowNotificationsSubtitle =>
      'Benachrichtigungen anzeigen, wenn die Kategorie aktualisiert wird';

  @override
  String get settingsNotifyMissingCategoryLabel =>
      'Bei fehlender Kategorie benachrichtigen';

  @override
  String get settingsNotifyMissingCategorySubtitle =>
      'Benachrichtigung anzeigen, wenn keine Zuordnung für ein Spiel oder eine App gefunden wird';

  @override
  String get categoryMappingAddDialogCategoryIdHint => 'z. B. 21779';

  @override
  String get welcomeTwitchOptionalInfo =>
      'Dieser Schritt ist optional. Sie können ihn überspringen und später in den Einstellungen einrichten.';

  @override
  String get settingsKeyboardShortcuts => 'Tastenkombinationen';

  @override
  String get categoryMappingAddDialogCategoryIdRequired =>
      'Kategorie-ID ist erforderlich';

  @override
  String get welcomeTwitchAuthorizeButton => 'MIT TWITCH AUTORISIEREN';

  @override
  String get settingsManualUpdateHotkeyLabel =>
      'Manuelle Aktualisierungs-Tastenkombination';

  @override
  String get categoryMappingAddDialogCategoryNameLabel =>
      'TWITCH-KATEGORIENAME';

  @override
  String get welcomeButtonNext => 'WEITER';

  @override
  String get settingsManualUpdateHotkeyDescription =>
      'Manuelle Kategorieaktualisierung auslösen';

  @override
  String get categoryMappingAddDialogCategoryNameHint =>
      'z. B. League of Legends';

  @override
  String get welcomeButtonBack => 'ZURÜCK';

  @override
  String get settingsUnsavedChanges =>
      'Sie haben nicht gespeicherte Änderungen';

  @override
  String get categoryMappingAddDialogCategoryNameRequired =>
      'Kategoriename ist erforderlich';

  @override
  String get settingsDiscard => 'Verwerfen';

  @override
  String get categoryMappingAddDialogTip =>
      'Tipp: Verwenden Sie die Twitch-Kategoriesuche, um die richtige ID und den Namen zu finden';

  @override
  String get settingsSave => 'Speichern';

  @override
  String get categoryMappingAddDialogCancelButton => 'ABBRECHEN';

  @override
  String get settingsTwitchConnection => 'Twitch-Verbindung';

  @override
  String get categoryMappingAddDialogUpdateButton => 'AKTUALISIEREN';

  @override
  String get settingsTwitchStatusConnected => 'Verbunden';

  @override
  String get categoryMappingAddDialogAddButton => 'HINZUFÜGEN';

  @override
  String get settingsTwitchStatusNotConnected => 'Nicht verbunden';

  @override
  String get categoryMappingListEmpty => 'Noch keine Kategoriezuordnungen';

  @override
  String get categoryMappingListEmptyTitle => 'Noch keine Kategoriezuordnungen';

  @override
  String get settingsTwitchLoggedInAs => 'Angemeldet als:';

  @override
  String get categoryMappingListEmptySubtitle =>
      'Fügen Sie Ihre erste Zuordnung hinzu, um zu beginnen';

  @override
  String get settingsTwitchDisconnect => 'Trennen';

  @override
  String get categoryMappingListColumnProcessName => 'PROZESSNAME';

  @override
  String get settingsTwitchConnectDescription =>
      'Verbinden Sie Ihr Twitch-Konto, um automatisches Kategorienwechseln zu aktivieren.';

  @override
  String get categoryMappingListColumnCategory => 'KATEGORIE';

  @override
  String get settingsTwitchConnect => 'Mit Twitch verbinden';

  @override
  String get categoryMappingListColumnLastUsed => 'ZULETZT VERWENDET';

  @override
  String get hotkeyInputCancel => 'Abbrechen';

  @override
  String get categoryMappingListColumnType => 'TYP';

  @override
  String get hotkeyInputChange => 'Ändern';

  @override
  String get categoryMappingListColumnActions => 'AKTIONEN';

  @override
  String get hotkeyInputClearHotkey => 'Tastenkombination löschen';

  @override
  String get categoryMappingListIdPrefix => 'ID: ';

  @override
  String categoryMappingListCategoryId(String categoryId) {
    return 'ID: $categoryId';
  }

  @override
  String get categoryMappingListNever => 'Nie';

  @override
  String get categoryMappingListJustNow => 'Gerade eben';

  @override
  String categoryMappingListMinutesAgo(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'Minuten',
      one: 'Minute',
    );
    return 'vor $minutes $_temp0';
  }

  @override
  String categoryMappingListHoursAgo(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: 'Stunden',
      one: 'Stunde',
    );
    return 'vor $hours $_temp0';
  }

  @override
  String categoryMappingListDaysAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Tagen',
      one: 'Tag',
    );
    return 'vor $days $_temp0';
  }

  @override
  String get hotkeyInputSetHotkey => 'Tastenkombination festlegen';

  @override
  String get categoryMappingListNeverUsed => 'Nie';

  @override
  String get categoryMappingListTypeUser => 'BENUTZER';

  @override
  String get categoryMappingListTypePreset => 'VOREINSTELLUNG';

  @override
  String get categoryMappingListEditTooltip => 'Zuordnung bearbeiten';

  @override
  String get categoryMappingListDeleteTooltip => 'Zuordnung löschen';

  @override
  String get categoryMappingListTimeJustNow => 'Gerade eben';

  @override
  String get categoryMappingProviderSuccessAdded =>
      'Zuordnung erfolgreich hinzugefügt';

  @override
  String get categoryMappingProviderSuccessUpdated =>
      'Zuordnung erfolgreich aktualisiert';

  @override
  String get categoryMappingProviderSuccessDeleted =>
      'Zuordnung erfolgreich gelöscht';

  @override
  String get commonCancel => 'Abbrechen';

  @override
  String get commonOk => 'OK';

  @override
  String get commonConfirm => 'Bestätigen';

  @override
  String get autoSwitcherProviderErrorPrefix => 'Fehler beim';

  @override
  String get autoSwitcherProviderStartMonitoring => 'Starten der Überwachung';

  @override
  String get autoSwitcherProviderStopMonitoring => 'Stoppen der Überwachung';

  @override
  String get autoSwitcherProviderManualUpdate =>
      'Durchführen der manuellen Aktualisierung';

  @override
  String get autoSwitcherProviderLoadHistory => 'Laden des Verlaufs';

  @override
  String get autoSwitcherProviderClearHistory => 'Löschen des Verlaufs';

  @override
  String get autoSwitcherProviderSuccessCategoryUpdated =>
      'Kategorie erfolgreich aktualisiert';

  @override
  String get autoSwitcherProviderSuccessHistoryCleared =>
      'Verlauf erfolgreich gelöscht';

  @override
  String get autoSwitcherProviderErrorUnknown => 'Unbekannter Fehler';

  @override
  String get settingsFactoryReset => 'Zurücksetzen auf Werkseinstellungen';

  @override
  String get settingsFactoryResetDescription =>
      'Alle Einstellungen und Daten auf Werkseinstellungen zurücksetzen';

  @override
  String get settingsFactoryResetButton =>
      'Auf Werkseinstellungen zurücksetzen';

  @override
  String get settingsFactoryResetDialogTitle =>
      'Zurücksetzen auf Werkseinstellungen';

  @override
  String get settingsFactoryResetDialogMessage =>
      'Alle Einstellungen, die lokale Datenbank und alle lokal erstellten Kategorien gehen verloren. Möchten Sie wirklich fortfahren?';

  @override
  String get settingsFactoryResetDialogConfirm => 'ZURÜCKSETZEN';

  @override
  String get settingsFactoryResetSuccess =>
      'Die Anwendung wurde erfolgreich auf Werkseinstellungen zurückgesetzt. Bitte starten Sie die Anwendung neu.';

  @override
  String get settingsUpdates => 'Aktualisierungen';

  @override
  String get settingsUpdateChannelLabel => 'Aktualisierungskanal';

  @override
  String get settingsUpdateChannelDescription =>
      'Wählen Sie, welche Arten von Aktualisierungen Sie erhalten möchten';

  @override
  String settingsUpdateChannelChanged(String channel) {
    return 'Aktualisierungskanal geändert zu $channel. Suche nach Aktualisierungen...';
  }

  @override
  String get updateChannelStable => 'Stabil';

  @override
  String get updateChannelStableDesc =>
      'Empfohlen für die meisten Benutzer. Nur stabile Versionen.';

  @override
  String get updateChannelRc => 'Release Candidate';

  @override
  String get updateChannelRcDesc =>
      'Stabile Funktionen mit abschließendem Test vor der stabilen Version.';

  @override
  String get updateChannelBeta => 'Beta';

  @override
  String get updateChannelBetaDesc =>
      'Neue Funktionen, die größtenteils stabil sind. Kann Fehler enthalten.';

  @override
  String get updateChannelDev => 'Entwicklung';

  @override
  String get updateChannelDevDesc =>
      'Neueste Funktionen. Erwarten Sie Fehler und Instabilität.';

  @override
  String get fallbackBehaviorDoNothing => 'Nichts tun';

  @override
  String get fallbackBehaviorJustChatting => 'Just Chatting';

  @override
  String get fallbackBehaviorCustom => 'Eigene Kategorie';

  @override
  String get unknownGameDialogTitle => 'Game Not Mapped';

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
  String get unknownGameDialogOptionsHeader => 'OPTIONS';

  @override
  String get unknownGameDialogSaveLocallyLabel => 'Save mapping locally';

  @override
  String get unknownGameDialogContributeLabel =>
      'Contribute to community mappings';

  @override
  String get unknownGameDialogContributeSubtitle =>
      'Help others by sharing this mapping on GitHub';

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
  String get versionStatusUpToDate => 'Auf dem neuesten Stand';

  @override
  String get versionStatusUpdateAvailable => 'Update verfügbar';

  @override
  String versionStatusCheckFailed(String error) {
    return 'Update-Prüfung fehlgeschlagen: $error';
  }

  @override
  String get versionStatusNotInitialized => 'Update-Dienst nicht initialisiert';

  @override
  String get versionStatusPlatformNotSupported =>
      'Updates auf dieser Plattform nicht unterstützt';
}
