// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get appTitle => 'TKit';

  @override
  String get welcomeTitle => 'Vítejte v TKit';

  @override
  String get selectLanguage => 'Vyberte svůj jazyk';

  @override
  String get languageLabel => 'Jazyk';

  @override
  String get continueButton => 'POKRAČOVAT';

  @override
  String get confirm => 'Potvrdit';

  @override
  String get hello => 'Ahoj';

  @override
  String get languageNativeName => 'Čeština';

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
  String get settingsLanguage => 'Jazyk';

  @override
  String get settingsLanguageDescription =>
      'Vyberte preferovaný jazyk aplikace';

  @override
  String get languageChangeNotice =>
      'Jazyk byl změněn. Aplikace se okamžitě aktualizuje.';

  @override
  String get authSuccessAuthenticatedAs => 'Úspěšně ověřen jako';

  @override
  String get systemTrayShowTkit => 'Zobrazit TKit';

  @override
  String get authConnectToTwitch => 'Připojit k Twitch';

  @override
  String get systemTrayAutoSwitcher => 'Automatické přepínání';

  @override
  String get authLoading => 'Načítání...';

  @override
  String get systemTrayCategoryMappings => 'Mapování kategorií';

  @override
  String get authRefreshingToken => 'Obnovování tokenu...';

  @override
  String get systemTraySettings => 'Nastavení';

  @override
  String get authSuccessfullyAuthenticated => 'Úspěšně ověřeno';

  @override
  String get systemTrayExit => 'Ukončit';

  @override
  String get authLoggedInAs => 'Přihlášen jako';

  @override
  String get systemTrayTooltip => 'TKit - Twitch Toolkit';

  @override
  String get authErrorAuthenticationFailed => 'Ověření selhalo';

  @override
  String get authErrorErrorCode => 'Kód chyby:';

  @override
  String get authTryAgain => 'Zkusit znovu';

  @override
  String get authAuthorizationSteps => 'Kroky autorizace';

  @override
  String get authStep1 => 'Klikněte na tlačítko \"Připojit k Twitch\" níže';

  @override
  String get authStep2 => 'V prohlížeči se otevře autorizační stránka Twitch';

  @override
  String get authStep3 =>
      'Zkontrolujte a autorizujte TKit ke správě vašeho kanálu';

  @override
  String get authStep4 => 'Po autorizaci se vraťte do tohoto okna';

  @override
  String get authConnectToTwitchButton => 'PŘIPOJIT K TWITCH';

  @override
  String get authRequiresAccessMessage =>
      'TKit vyžaduje přístup k aktualizaci kategorie vašeho Twitch kanálu.';

  @override
  String get authDeviceCodeTitle => 'Připojit k Twitch';

  @override
  String get authDeviceCodeInstructions =>
      'Pro připojení vašeho Twitch účtu postupujte podle těchto jednoduchých kroků:';

  @override
  String get authDeviceCodeStep1 => 'Přejděte na';

  @override
  String get authDeviceCodeStep2 => 'Zadejte tento kód:';

  @override
  String get authDeviceCodeStep3 =>
      'Autorizujte TKit ke správě kategorie vašeho kanálu';

  @override
  String get authDeviceCodeCodeLabel => 'Váš kód';

  @override
  String get authDeviceCodeCopyCode => 'Kopírovat kód';

  @override
  String get authDeviceCodeCopied => 'Zkopírováno!';

  @override
  String get authDeviceCodeOpenBrowser => 'Otevřít twitch.tv/activate';

  @override
  String get authDeviceCodeWaiting => 'Čekání na autorizaci...';

  @override
  String authDeviceCodeExpiresIn(String minutes, String seconds) {
    return 'Kód vyprší za $minutes:$seconds';
  }

  @override
  String get authDeviceCodeExpired => 'Kód vypršel. Zkuste to prosím znovu.';

  @override
  String get authDeviceCodeCancel => 'Zrušit';

  @override
  String get authDeviceCodeSuccess => 'Úspěšně připojeno!';

  @override
  String get authDeviceCodeError =>
      'Připojení selhalo. Zkuste to prosím znovu.';

  @override
  String get authDeviceCodeHelp =>
      'Máte problémy? Ujistěte se, že jste přihlášeni k Twitch ve vašem prohlížeči.';

  @override
  String get autoSwitcherPageTitle => 'AUTOMATICKÉ PŘEPÍNÁNÍ';

  @override
  String get authStatusAuthenticated => 'Ověřeno';

  @override
  String get autoSwitcherPageDescription =>
      'Automaticky aktualizuje kategorii streamu podle aktivní aplikace';

  @override
  String get authStatusConnecting => 'Připojování...';

  @override
  String get autoSwitcherStatusHeader => 'STAV';

  @override
  String get authStatusError => 'Chyba';

  @override
  String get autoSwitcherStatusCurrentProcess => 'AKTUÁLNÍ PROCES';

  @override
  String get authStatusNotConnected => 'Nepřipojeno';

  @override
  String get autoSwitcherStatusNone => 'Žádný';

  @override
  String get autoSwitcherStatusMatchedCategory => 'NALEZENÁ KATEGORIE';

  @override
  String get mainWindowNavAutoSwitcher => 'Automatické přepínání';

  @override
  String get autoSwitcherStatusLastUpdate => 'POSLEDNÍ AKTUALIZACE';

  @override
  String get mainWindowNavMappings => 'Mapování';

  @override
  String get autoSwitcherStatusNever => 'Nikdy';

  @override
  String get mainWindowNavSettings => 'Nastavení';

  @override
  String get mainWindowStatusConnected => 'Připojeno';

  @override
  String get autoSwitcherStatusUpdateStatus => 'STAV AKTUALIZACE';

  @override
  String get mainWindowStatusDisconnected => 'Odpojeno';

  @override
  String get autoSwitcherStatusNoUpdatesYet => 'Zatím žádné aktualizace';

  @override
  String get mainWindowWindowControlMinimize => 'Minimalizovat';

  @override
  String get autoSwitcherStatusSuccess => 'ÚSPĚCH';

  @override
  String get authLoadingStartingAuthentication => 'Zahajování ověření...';

  @override
  String get mainWindowWindowControlMaximize => 'Maximalizovat';

  @override
  String get autoSwitcherStatusFailed => 'SELHALO';

  @override
  String get authLoadingLoggingOut => 'Odhlašování...';

  @override
  String get settingsSavedSuccessfully => 'Nastavení úspěšně uloženo';

  @override
  String get autoSwitcherStatusSystemState => 'STAV SYSTÉMU';

  @override
  String get mainWindowWindowControlClose => 'Zavřít';

  @override
  String get authLoadingCheckingStatus => 'Kontrola stavu ověření...';

  @override
  String get settingsRetry => 'Zkusit znovu';

  @override
  String get settingsPageTitle => 'NASTAVENÍ';

  @override
  String get settingsPageDescription =>
      'Konfigurace chování a preferencí aplikace';

  @override
  String get settingsTabGeneral => 'Obecné';

  @override
  String get settingsTabAutoSwitcher => 'Automatický přepínač';

  @override
  String get settingsTabKeyboard => 'Klávesnice';

  @override
  String get settingsTabTwitch => 'Twitch';

  @override
  String get settingsTabAdvanced => 'Pokročilé';

  @override
  String get autoSwitcherStatusNotInitialized => 'NEINICIALIZOVÁNO';

  @override
  String get mainWindowFooterReady => 'Připraven';

  @override
  String get authErrorTokenRefreshFailed => 'Obnovení tokenu selhalo:';

  @override
  String get settingsAutoSwitcher => 'Automatické přepínání';

  @override
  String get autoSwitcherStatusIdle => 'NEČINNÝ';

  @override
  String get updateDialogTitle => 'Dostupná aktualizace';

  @override
  String get settingsMonitoring => 'Monitorování';

  @override
  String get autoSwitcherStatusDetectingProcess => 'DETEKCE PROCESU';

  @override
  String get categoryMappingTitle => 'MAPOVÁNÍ KATEGORIÍ';

  @override
  String get updateDialogWhatsNew => 'Co je nového:';

  @override
  String get settingsScanIntervalLabel => 'Interval skenování';

  @override
  String get autoSwitcherStatusSearchingMapping => 'HLEDÁNÍ MAPOVÁNÍ';

  @override
  String get categoryMappingSubtitle =>
      'Spravujte mapování procesů na kategorie pro automatické přepínání';

  @override
  String get updateDialogDownloadComplete =>
      'Stahování dokončeno! Připraven k instalaci.';

  @override
  String get settingsScanIntervalDescription =>
      'Jak často kontrolovat, která aplikace je aktivní';

  @override
  String get autoSwitcherStatusUpdatingCategory => 'AKTUALIZACE KATEGORIE';

  @override
  String get categoryMappingAddMappingButton => 'PŘIDAT MAPOVÁNÍ';

  @override
  String get updateDialogDownloadFailed => 'Stahování selhalo:';

  @override
  String get settingsDebounceTimeLabel => 'Čas prodlevy';

  @override
  String get autoSwitcherStatusWaitingDebounce => 'ČEKÁNÍ (PRODLEVA)';

  @override
  String get categoryMappingErrorDialogTitle => 'Chyba';

  @override
  String get updateDialogRemindLater => 'Připomenout později';

  @override
  String get updateDialogIgnore => 'Ignorovat tuto verzi';

  @override
  String get settingsDebounceTimeDescription =>
      'Čekací doba před přepnutím kategorie po změně aplikace (zabraňuje rychlému přepínání)';

  @override
  String get autoSwitcherStatusError => 'CHYBA';

  @override
  String get categoryMappingStatsTotalMappings => 'Celkem mapování';

  @override
  String get updateDialogDownloadUpdate => 'Stáhnout aktualizaci';

  @override
  String get settingsAutoStartMonitoringLabel =>
      'Automaticky spustit monitorování';

  @override
  String get autoSwitcherControlsHeader => 'OVLÁDÁNÍ';

  @override
  String get categoryMappingStatsUserDefined => 'Definováno uživatelem';

  @override
  String get updateDialogCancel => 'Zrušit';

  @override
  String get settingsAutoStartMonitoringSubtitle =>
      'Zahájí monitorování aktivní aplikace při spuštění TKit';

  @override
  String get autoSwitcherControlsStopMonitoring => 'ZASTAVIT MONITOROVÁNÍ';

  @override
  String get categoryMappingStatsPresets => 'Předvolby';

  @override
  String get updateDialogLater => 'Později';

  @override
  String get settingsFallbackBehavior => 'Pojistné chování';

  @override
  String get autoSwitcherControlsStartMonitoring => 'SPUSTIT MONITOROVÁNÍ';

  @override
  String get categoryMappingErrorLoading => 'Chyba při načítání mapování';

  @override
  String get updateDialogInstallRestart => 'Instalovat a restartovat';

  @override
  String get settingsFallbackBehaviorLabel => 'Když není nalezeno mapování';

  @override
  String get autoSwitcherControlsManualUpdate => 'RUČNÍ AKTUALIZACE';

  @override
  String get categoryMappingRetryButton => 'ZKUSIT ZNOVU';

  @override
  String get updateDialogToday => 'dnes';

  @override
  String get settingsFallbackBehaviorDescription =>
      'Zvolte, co se stane, když aktivní aplikace nemá mapování kategorie';

  @override
  String get categoryMappingDeleteDialogTitle => 'Smazat mapování';

  @override
  String get autoSwitcherControlsMonitoringStatus => 'STAV MONITOROVÁNÍ';

  @override
  String get updateDialogYesterday => 'včera';

  @override
  String get settingsCustomCategory => 'Vlastní kategorie';

  @override
  String get categoryMappingDeleteDialogMessage =>
      'Opravdu chcete smazat toto mapování?';

  @override
  String get autoSwitcherControlsActive => 'AKTIVNÍ';

  @override
  String updateDialogDaysAgo(int days) {
    return 'před $days dny';
  }

  @override
  String get settingsCustomCategoryHint => 'Hledat kategorii...';

  @override
  String get categoryMappingDeleteDialogConfirm => 'SMAZAT';

  @override
  String get autoSwitcherControlsInactive => 'NEAKTIVNÍ';

  @override
  String updateDialogVersion(String version) {
    return 'Verze $version';
  }

  @override
  String get categoryMappingDeleteDialogCancel => 'ZRUŠIT';

  @override
  String get settingsCategorySearchUnavailable =>
      'Vyhledávání kategorií bude k dispozici po dokončení Twitch API modulu';

  @override
  String get autoSwitcherControlsActiveDescription =>
      'Automatická aktualizace kategorie podle aktivního procesu';

  @override
  String updateDialogPublished(String date) {
    return 'Publikováno $date';
  }

  @override
  String get categoryMappingAddDialogEditTitle => 'UPRAVIT MAPOVÁNÍ';

  @override
  String get settingsApplication => 'Aplikace';

  @override
  String get autoSwitcherControlsInactiveDescription =>
      'Spusťte monitorování pro povolení automatických aktualizací kategorie';

  @override
  String get welcomeStepLanguage => 'Jazyk';

  @override
  String get categoryMappingAddDialogAddTitle => 'PŘIDAT NOVÉ MAPOVÁNÍ';

  @override
  String get categoryMappingAddDialogClose => 'Zavřít';

  @override
  String get categoryMappingAddDialogProcessName => 'NÁZEV PROCESU';

  @override
  String get categoryMappingAddDialogExecutablePath =>
      'CESTA K SOUBORU (VOLITELNÉ)';

  @override
  String get categoryMappingAddDialogCategoryId => 'TWITCH ID KATEGORIE';

  @override
  String get categoryMappingAddDialogCategoryName => 'NÁZEV TWITCH KATEGORIE';

  @override
  String get categoryMappingAddDialogCancel => 'ZRUŠIT';

  @override
  String get categoryMappingAddDialogUpdate => 'AKTUALIZOVAT';

  @override
  String get categoryMappingAddDialogAdd => 'PŘIDAT';

  @override
  String get settingsAutoStartWindowsLabel => 'Automaticky spustit s Windows';

  @override
  String get categoryMappingAddDialogCloseTooltip => 'Zavřít';

  @override
  String get welcomeStepTwitch => 'Twitch';

  @override
  String get welcomeStepBehavior => 'Chování';

  @override
  String get welcomeBehaviorStepTitle => 'KROK 3: CHOVÁNÍ APLIKACE';

  @override
  String get welcomeBehaviorTitle => 'Chování aplikace';

  @override
  String get welcomeBehaviorDescription =>
      'Konfigurace chování TKit při spuštění a minimalizaci.';

  @override
  String get welcomeBehaviorOptionalInfo =>
      'Tato nastavení lze kdykoli změnit v Nastavení.';

  @override
  String get settingsWindowControlsPositionLabel =>
      'Pozice ovládacích prvků okna';

  @override
  String get settingsWindowControlsPositionDescription =>
      'Vyberte, kde se zobrazí ovládací prvky okna (minimalizovat, maximalizovat, zavřít)';

  @override
  String get windowControlsPositionLeft => 'Vlevo';

  @override
  String get windowControlsPositionCenter => 'Uprostřed';

  @override
  String get windowControlsPositionRight => 'Vpravo';

  @override
  String get settingsAutoStartWindowsSubtitle =>
      'Spustit TKit automaticky při startu Windows';

  @override
  String get categoryMappingAddDialogProcessNameLabel => 'NÁZEV PROCESU';

  @override
  String get welcomeLanguageStepTitle => 'KROK 1: VYBERTE SVŮJ JAZYK';

  @override
  String get settingsStartMinimizedLabel => 'Spustit minimalizovaný';

  @override
  String get categoryMappingAddDialogProcessNameHint =>
      'např. League of Legends.exe';

  @override
  String get welcomeLanguageChangeLater =>
      'Toto můžete změnit později v Nastavení.';

  @override
  String get settingsStartMinimizedSubtitle =>
      'Spustit TKit minimalizovaný do systémové lišty';

  @override
  String get categoryMappingAddDialogProcessNameRequired =>
      'Název procesu je povinný';

  @override
  String get welcomeTwitchStepTitle => 'KROK 2: PŘIPOJTE SE K TWITCH';

  @override
  String get settingsMinimizeToTrayLabel => 'Minimalizovat do systémové lišty';

  @override
  String get categoryMappingAddDialogExecutablePathLabel =>
      'CESTA K SOUBORU (VOLITELNÉ)';

  @override
  String get welcomeTwitchConnectionTitle => 'Připojení k Twitch';

  @override
  String get settingsMinimizeToTraySubtitle =>
      'Ponechat TKit spuštěný na pozadí při zavření nebo minimalizaci';

  @override
  String get categoryMappingAddDialogExecutablePathHint =>
      'např. C:\\Hry\\LeagueOfLegends\\Game\\League of Legends.exe';

  @override
  String welcomeTwitchConnectedAs(String username) {
    return 'Připojeno jako $username';
  }

  @override
  String get settingsShowNotificationsLabel => 'Zobrazit notifikace';

  @override
  String get categoryMappingAddDialogCategoryIdLabel => 'TWITCH ID KATEGORIE';

  @override
  String get welcomeTwitchDescription =>
      'Připojte svůj Twitch účet pro povolení automatického přepínání kategorie podle aktivní aplikace.';

  @override
  String get settingsShowNotificationsSubtitle =>
      'Zobrazit notifikace při aktualizaci kategorie';

  @override
  String get settingsNotifyMissingCategoryLabel =>
      'Upozornit na chybějící kategorii';

  @override
  String get settingsNotifyMissingCategorySubtitle =>
      'Zobrazit notifikaci, když není nalezeno mapování pro hru nebo aplikaci';

  @override
  String get categoryMappingAddDialogCategoryIdHint => 'např. 21779';

  @override
  String get welcomeTwitchOptionalInfo =>
      'Tento krok je volitelný. Můžete ho přeskočit a nastavit později v Nastavení.';

  @override
  String get settingsKeyboardShortcuts => 'Klávesové zkratky';

  @override
  String get categoryMappingAddDialogCategoryIdRequired =>
      'ID kategorie je povinné';

  @override
  String get welcomeTwitchAuthorizeButton => 'AUTORIZOVAT S TWITCH';

  @override
  String get settingsManualUpdateHotkeyLabel =>
      'Klávesová zkratka pro ruční aktualizaci';

  @override
  String get categoryMappingAddDialogCategoryNameLabel =>
      'NÁZEV TWITCH KATEGORIE';

  @override
  String get welcomeButtonNext => 'DALŠÍ';

  @override
  String get settingsManualUpdateHotkeyDescription =>
      'Spustit ruční aktualizaci kategorie';

  @override
  String get categoryMappingAddDialogCategoryNameHint =>
      'např. League of Legends';

  @override
  String get welcomeButtonBack => 'ZPĚT';

  @override
  String get settingsUnsavedChanges => 'Máte neuložené změny';

  @override
  String get categoryMappingAddDialogCategoryNameRequired =>
      'Název kategorie je povinný';

  @override
  String get settingsDiscard => 'Zahodit';

  @override
  String get categoryMappingAddDialogTip =>
      'Tip: Použijte vyhledávání kategorií Twitch k nalezení správného ID a názvu';

  @override
  String get settingsSave => 'Uložit';

  @override
  String get categoryMappingAddDialogCancelButton => 'ZRUŠIT';

  @override
  String get settingsTwitchConnection => 'Připojení k Twitch';

  @override
  String get categoryMappingAddDialogUpdateButton => 'AKTUALIZOVAT';

  @override
  String get settingsTwitchStatusConnected => 'Připojeno';

  @override
  String get categoryMappingAddDialogAddButton => 'PŘIDAT';

  @override
  String get settingsTwitchStatusNotConnected => 'Nepřipojeno';

  @override
  String get categoryMappingListEmpty => 'Zatím žádná mapování kategorií';

  @override
  String get categoryMappingListEmptyTitle => 'Zatím žádná mapování kategorií';

  @override
  String get settingsTwitchLoggedInAs => 'Přihlášen jako:';

  @override
  String get categoryMappingListEmptySubtitle =>
      'Přidejte své první mapování pro začátek';

  @override
  String get settingsTwitchDisconnect => 'Odpojit';

  @override
  String get categoryMappingListColumnProcessName => 'NÁZEV PROCESU';

  @override
  String get settingsTwitchConnectDescription =>
      'Připojte svůj Twitch účet pro povolení automatického přepínání kategorie.';

  @override
  String get categoryMappingListColumnCategory => 'KATEGORIE';

  @override
  String get settingsTwitchConnect => 'Připojit k Twitch';

  @override
  String get categoryMappingListColumnLastUsed => 'NAPOSLEDY POUŽITO';

  @override
  String get hotkeyInputCancel => 'Zrušit';

  @override
  String get categoryMappingListColumnType => 'TYP';

  @override
  String get hotkeyInputChange => 'Změnit';

  @override
  String get categoryMappingListColumnActions => 'AKCE';

  @override
  String get hotkeyInputClearHotkey => 'Vymazat klávesovou zkratku';

  @override
  String get categoryMappingListIdPrefix => 'ID: ';

  @override
  String categoryMappingListCategoryId(String categoryId) {
    return 'ID: $categoryId';
  }

  @override
  String get categoryMappingListNever => 'Nikdy';

  @override
  String get categoryMappingListJustNow => 'Právě teď';

  @override
  String categoryMappingListMinutesAgo(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'minut',
      few: 'minuty',
      one: 'minuta',
    );
    return '$minutes $_temp0 zpět';
  }

  @override
  String categoryMappingListHoursAgo(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: 'hodin',
      few: 'hodiny',
      one: 'hodina',
    );
    return '$hours $_temp0 zpět';
  }

  @override
  String categoryMappingListDaysAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'dní',
      few: 'dny',
      one: 'den',
    );
    return '$days $_temp0 zpět';
  }

  @override
  String get hotkeyInputSetHotkey => 'Nastavit klávesovou zkratku';

  @override
  String get categoryMappingListNeverUsed => 'Nikdy';

  @override
  String get categoryMappingListTypeUser => 'UŽIVATEL';

  @override
  String get categoryMappingListTypePreset => 'PŘEDVOLBA';

  @override
  String get categoryMappingListEditTooltip => 'Upravit mapování';

  @override
  String get categoryMappingListDeleteTooltip => 'Smazat mapování';

  @override
  String get categoryMappingListTimeJustNow => 'Právě teď';

  @override
  String get categoryMappingProviderSuccessAdded => 'Mapování úspěšně přidáno';

  @override
  String get categoryMappingProviderSuccessUpdated =>
      'Mapování úspěšně aktualizováno';

  @override
  String get categoryMappingProviderSuccessDeleted =>
      'Mapování úspěšně smazáno';

  @override
  String get commonCancel => 'Zrušit';

  @override
  String get commonOk => 'OK';

  @override
  String get commonConfirm => 'Potvrdit';

  @override
  String get autoSwitcherProviderErrorPrefix => 'Nepodařilo se';

  @override
  String get autoSwitcherProviderStartMonitoring => 'spustit monitorování';

  @override
  String get autoSwitcherProviderStopMonitoring => 'zastavit monitorování';

  @override
  String get autoSwitcherProviderManualUpdate => 'provést ruční aktualizaci';

  @override
  String get autoSwitcherProviderLoadHistory => 'načíst historii';

  @override
  String get autoSwitcherProviderClearHistory => 'vymazat historii';

  @override
  String get autoSwitcherProviderSuccessCategoryUpdated =>
      'Kategorie byla úspěšně aktualizována';

  @override
  String get autoSwitcherProviderSuccessHistoryCleared =>
      'Historie byla úspěšně vymazána';

  @override
  String get autoSwitcherProviderErrorUnknown => 'Neznámá chyba';

  @override
  String get settingsFactoryReset => 'Tovární nastavení';

  @override
  String get settingsFactoryResetDescription =>
      'Obnovit všechna nastavení a data na tovární výchozí hodnoty';

  @override
  String get settingsFactoryResetButton => 'Obnovit tovární nastavení';

  @override
  String get settingsFactoryResetDialogTitle => 'Tovární nastavení';

  @override
  String get settingsFactoryResetDialogMessage =>
      'Všechna nastavení, lokální databáze a všechny lokálně vytvořené kategorie budou ztraceny. Opravdu chcete pokračovat?';

  @override
  String get settingsFactoryResetDialogConfirm => 'OBNOVIT';

  @override
  String get settingsFactoryResetSuccess =>
      'Aplikace byla úspěšně obnovena na tovární nastavení. Prosím restartujte aplikaci.';

  @override
  String get settingsUpdates => 'Aktualizace';

  @override
  String get settingsUpdateChannelLabel => 'Aktualizační kanál';

  @override
  String get settingsUpdateChannelDescription =>
      'Vyberte, jaké typy aktualizací chcete přijímat';

  @override
  String settingsUpdateChannelChanged(String channel) {
    return 'Aktualizační kanál změněn na $channel. Kontrola aktualizací...';
  }

  @override
  String get updateChannelStable => 'Stabilní';

  @override
  String get updateChannelStableDesc =>
      'Doporučeno pro většinu uživatelů. Pouze stabilní verze.';

  @override
  String get updateChannelRc => 'Kandidát na vydání';

  @override
  String get updateChannelRcDesc =>
      'Stabilní funkce s finálním testováním před stabilním vydáním.';

  @override
  String get updateChannelBeta => 'Beta';

  @override
  String get updateChannelBetaDesc =>
      'Nové funkce, které jsou většinou stabilní. Mohou obsahovat chyby.';

  @override
  String get updateChannelDev => 'Vývojový';

  @override
  String get updateChannelDevDesc =>
      'Nejnovější funkce. Očekávejte chyby a nestabilitu.';

  @override
  String get fallbackBehaviorDoNothing => 'Nedělat nic';

  @override
  String get fallbackBehaviorJustChatting => 'Just Chatting';

  @override
  String get fallbackBehaviorCustom => 'Vlastní kategorie';

  @override
  String get unknownGameDialogTitle => 'Game Not Mapped';

  @override
  String get unknownGameDialogStepCategory => 'Kategorie';

  @override
  String get unknownGameDialogStepDestination => 'Cíl';

  @override
  String get unknownGameDialogStepConfirm => 'Potvrdit';

  @override
  String get unknownGameDialogConfirmHeader => 'Zkontrolovat a potvrdit';

  @override
  String get unknownGameDialogConfirmDescription =>
      'Před uložením zkontrolujte svůj výběr';

  @override
  String get unknownGameDialogConfirmCategory => 'KATEGORIE TWITCH';

  @override
  String get unknownGameDialogConfirmDestination => 'CÍLOVÝ SEZNAM';

  @override
  String get unknownGameDialogBack => 'Zpět';

  @override
  String get unknownGameDialogNext => 'Další';

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
  String get unknownGameDialogCategoryHeader => 'Vyberte kategorii Twitch';

  @override
  String get unknownGameDialogCategoryDescription =>
      'Vyhledejte a vyberte kategorii Twitch pro tuto hru';

  @override
  String get unknownGameDialogListHeader => 'Zvolte cíl';

  @override
  String get unknownGameDialogListDescription =>
      'Vyberte, kam chcete toto mapování uložit';

  @override
  String get unknownGameDialogNoWritableLists =>
      'Nejsou k dispozici žádné zapisovatelné seznamy';

  @override
  String get unknownGameDialogNoWritableListsHint =>
      'Vytvořte místní seznam v Mapování kategorií pro uložení vlastních mapování';

  @override
  String get unknownGameDialogLocalListsHeader => 'MÍSTNÍ MAPOVÁNÍ';

  @override
  String get unknownGameDialogSubmissionListsHeader => 'PŘÍSPĚVEK KOMUNITY';

  @override
  String get unknownGameDialogWorkflowHeader =>
      'Jak funguje odesílání příspěvků';

  @override
  String get unknownGameDialogWorkflowCompactNote =>
      'Nejprve se uloží místně, poté se odešle ke schválení komunitou';

  @override
  String get unknownGameDialogWorkflowLearnMore => 'Zjistit více';

  @override
  String get unknownGameDialogWorkflowStep1Title => 'Uloženo místně (okamžitě)';

  @override
  String get unknownGameDialogWorkflowStep1Description =>
      'Mapování je přidáno do místního seznamu a funguje okamžitě';

  @override
  String get unknownGameDialogWorkflowStep2Title => 'Odesláno ke kontrole';

  @override
  String get unknownGameDialogWorkflowStep2Description =>
      'Vaše mapování je odesláno komunitě ke schválení';

  @override
  String get unknownGameDialogWorkflowStep3Title => 'Sloučeno do oficiálního';

  @override
  String get unknownGameDialogWorkflowStep3Description =>
      'Po schválení se zobrazí v oficiálních mapováních a bude odstraněno z místního seznamu';

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
  String get unknownGameDialogThankYouTitle => 'Děkujeme!';

  @override
  String get unknownGameDialogThankYouMessage =>
      'Váš příspěvek pomáhá růst komunitě!';

  @override
  String get versionStatusUpToDate => 'Aktuální';

  @override
  String get versionStatusUpdateAvailable => 'Aktualizace k dispozici';

  @override
  String versionStatusCheckFailed(String error) {
    return 'Kontrola aktualizace selhala: $error';
  }

  @override
  String get versionStatusNotInitialized =>
      'Služba aktualizací není inicializována';

  @override
  String get versionStatusPlatformNotSupported =>
      'Aktualizace nejsou na této platformě podporovány';

  @override
  String get notificationMissingCategoryTitle =>
      'Mapování kategorie nenalezeno';

  @override
  String notificationMissingCategoryBody(String processName) {
    return 'Nebyla nalezena kategorie Twitch pro: $processName';
  }

  @override
  String get notificationActionAssignCategory => 'Přiřadit kategorii';

  @override
  String get notificationCategoryUpdatedTitle => 'Kategorie aktualizována';

  @override
  String notificationCategoryUpdatedBody(
    String categoryName,
    String processName,
  ) {
    return 'Přepnuto na \"$categoryName\" pro $processName';
  }

  @override
  String get mappingListColumnSource => 'Zdroj';

  @override
  String get mappingListColumnEnabled => 'Povoleno';

  @override
  String get mappingListTooltipIgnored => 'Tato kategorie je ignorována';

  @override
  String mappingListTooltipTwitchId(String twitchCategoryId) {
    return 'Twitch ID: $twitchCategoryId';
  }

  @override
  String get mappingListCategoryIgnored => 'Ignorováno';

  @override
  String get mappingListSourceUnknown => 'Neznámý';

  @override
  String mappingListSelected(int count) {
    return '$count vybráno';
  }

  @override
  String mappingListSelectedVisible(int count, int visible) {
    return '$count vybráno ($visible viditelných)';
  }

  @override
  String get mappingListButtonInvert => 'Invertovat';

  @override
  String get mappingListButtonClear => 'Vymazat';

  @override
  String mappingListButtonUndo(String action) {
    return 'Vrátit $action';
  }

  @override
  String get mappingListButtonExport => 'Exportovat';

  @override
  String get mappingListButtonEnable => 'Povolit';

  @override
  String get mappingListButtonDisable => 'Zakázat';

  @override
  String get mappingListButtonDelete => 'Smazat';

  @override
  String get mappingListTooltipCannotDelete =>
      'Nelze smazat mapování ze seznamů pouze pro čtení';

  @override
  String get mappingListTooltipDelete => 'Smazat vybraná mapování';

  @override
  String get mappingListSearchHint =>
      'Hledat podle názvu procesu nebo kategorie...';

  @override
  String get mappingListTooltipClearSearch => 'Vymazat vyhledávání';

  @override
  String get listManagementEmptyState => 'Nebyly nalezeny žádné seznamy';

  @override
  String get listManagementTitle => 'Spravovat seznamy';

  @override
  String get listManagementSyncNow => 'Synchronizovat nyní';

  @override
  String get listManagementBadgeLocal => 'MÍSTNÍ';

  @override
  String get listManagementBadgeOfficial => 'OFICIÁLNÍ';

  @override
  String get listManagementBadgeRemote => 'VZDÁLENÝ';

  @override
  String get listManagementBadgeReadOnly => 'POUZE PRO ČTENÍ';

  @override
  String get listManagementButtonImport => 'Importovat seznam';

  @override
  String get listManagementButtonSyncAll => 'Synchronizovat vše';

  @override
  String get listManagementButtonClose => 'Zavřít';

  @override
  String get listManagementImportTitle => 'Importovat seznam';

  @override
  String get listManagementImportUrl => 'URL seznamu';

  @override
  String get listManagementImportUrlPlaceholder =>
      'https://example.com/mappings.json';

  @override
  String get listManagementImportName => 'Název seznamu (volitelné)';

  @override
  String get listManagementImportNameHelper =>
      'Pokud není zadán, použije se název z JSON souboru';

  @override
  String get listManagementImportNamePlaceholder => 'Můj vlastní seznam';

  @override
  String get listManagementImportDescription => 'Popis (volitelné)';

  @override
  String get listManagementImportDescriptionHelper =>
      'Pokud není zadán, použije se popis z JSON souboru';

  @override
  String get listManagementImportDescriptionPlaceholder =>
      'Sbírka herních mapování';

  @override
  String get listManagementButtonCancel => 'Zrušit';

  @override
  String get listManagementButtonImportConfirm => 'Importovat';

  @override
  String get listManagementDefaultName => 'Importovaný seznam';

  @override
  String get listManagementImportSuccess => 'Seznam úspěšně importován';

  @override
  String get listManagementSyncNever => 'nikdy';

  @override
  String get listManagementSyncJustNow => 'právě teď';

  @override
  String listManagementSyncMinutesAgo(int minutes) {
    return 'před ${minutes}m';
  }

  @override
  String listManagementSyncHoursAgo(int hours) {
    return 'před ${hours}h';
  }

  @override
  String listManagementSyncDaysAgo(int days) {
    return 'před ${days}d';
  }

  @override
  String listManagementSyncDaysHoursAgo(int days, int hours) {
    return 'před ${days}d ${hours}h';
  }

  @override
  String listManagementMappingsCount(int count) {
    return '$count mapování';
  }

  @override
  String get listManagementSyncFailed => 'Synchronizace selhala:';

  @override
  String get listManagementLastSynced => 'Naposledy synchronizováno:';

  @override
  String get unknownGameIgnoreProcess => 'Ignorovat proces';

  @override
  String unknownGameCategoryId(String id) {
    return 'ID: $id';
  }

  @override
  String get unknownGameSubmissionTitle => 'Vyžadováno odeslání';

  @override
  String get unknownGameSubmissionInfo =>
      'Toto mapování bude uloženo místně a odesláno vlastníkovi seznamu ke schválení. Po schválení a synchronizaci bude vaše místní kopie automaticky nahrazena.';

  @override
  String get unknownGameSectionLists => 'SEZNAMY';

  @override
  String unknownGameListMappingCount(int count) {
    return '$count mapování';
  }

  @override
  String get unknownGameBadgeStaged => 'PŘIPRAVENO';

  @override
  String get unknownGameIgnoredProcess => 'IGNOROVANÝ PROCES';

  @override
  String unknownGameSelectedCategoryId(String id) {
    return 'ID: $id';
  }

  @override
  String get unknownGameWorkflowTitle => 'Proces odeslání';

  @override
  String get unknownGameWorkflowTitleAlt => 'Co se stane dále';

  @override
  String get unknownGameWorkflowStepLocal =>
      'Uloženo místně do Mých vlastních mapování';

  @override
  String get unknownGameWorkflowStepLocalDesc =>
      'Nejprve uloženo na vašem zařízení, takže mapování funguje okamžitě';

  @override
  String unknownGameWorkflowStepSubmit(String listName) {
    return 'Odesláno do $listName';
  }

  @override
  String get unknownGameWorkflowStepSubmitDesc =>
      'Automaticky odesláno vlastníkovi seznamu ke kontrole a schválení';

  @override
  String get unknownGameWorkflowStepReplace =>
      'Místní kopie nahrazena po schválení';

  @override
  String unknownGameWorkflowStepReplaceDesc(String listName) {
    return 'Po přijetí a synchronizaci bude vaše místní kopie odstraněna a nahrazena oficiální verzí z $listName';
  }

  @override
  String unknownGameSavedTo(String listName) {
    return 'Uloženo do $listName';
  }

  @override
  String get unknownGameIgnoredInfo =>
      'Tento proces bude ignorován a nespustí notifikace';

  @override
  String get unknownGameLocalSaveInfo =>
      'Vaše mapování je uloženo místně a bude fungovat okamžitě';

  @override
  String get unknownGamePrivacyInfo =>
      'Toto mapování je soukromé a uloženo pouze na vašem zařízení';

  @override
  String autoSwitcherError(String error) {
    return 'Chyba: $error';
  }

  @override
  String get autoSwitcherStatusActive => 'Automatické přepínání aktivní';

  @override
  String get autoSwitcherStatusInactive => 'Nemonitoruje se';

  @override
  String get autoSwitcherLabelActiveApp => 'Aktivní aplikace';

  @override
  String get autoSwitcherLabelCategory => 'Kategorie';

  @override
  String get autoSwitcherValueNone => 'Žádná';

  @override
  String get autoSwitcherDescriptionActive =>
      'Vaše kategorie se automaticky mění při přepínání aplikací.';

  @override
  String get autoSwitcherButtonTurnOff => 'Vypnout';

  @override
  String get autoSwitcherInstructionPress => 'Stiskněte';

  @override
  String get autoSwitcherInstructionManual =>
      'pro ruční aktualizaci na zaměřený proces';

  @override
  String get autoSwitcherHeadingEnable => 'Povolit automatické přepínání';

  @override
  String get autoSwitcherDescriptionInactive =>
      'Kategorie se budou automaticky měnit při přepínání mezi aplikacemi.';

  @override
  String get autoSwitcherButtonTurnOn => 'Zapnout';

  @override
  String get autoSwitcherInstructionOr => 'Nebo stiskněte';

  @override
  String get settingsTabMappings => 'Mapování';

  @override
  String get settingsTabTheme => 'Motiv';

  @override
  String get settingsAutoSyncOnStart =>
      'Automaticky synchronizovat mapování při spuštění aplikace';

  @override
  String get settingsAutoSyncOnStartDesc =>
      'Automaticky synchronizovat seznamy mapování při startu aplikace';

  @override
  String get settingsAutoSyncInterval => 'Interval automatické synchronizace';

  @override
  String get settingsAutoSyncIntervalDesc =>
      'Jak často automaticky synchronizovat seznamy mapování (0 = nikdy)';

  @override
  String get settingsAutoSyncNever => 'Nikdy';

  @override
  String get settingsTimingTitle => 'JAK TATO NASTAVENÍ SPOLUPRACUJÍ';

  @override
  String settingsTimingStep1(int scanInterval) {
    return 'Aplikace kontroluje zaměřené okno každých ${scanInterval}s';
  }

  @override
  String get settingsTimingStep2Instant =>
      'Kategorie se přepne okamžitě po detekci nové aplikace';

  @override
  String settingsTimingStep2Debounce(int debounce) {
    return 'Čeká ${debounce}s po detekci nové aplikace (prodleva)';
  }

  @override
  String settingsTimingStep3Instant(int scanInterval) {
    return 'Celkový čas přepnutí: ${scanInterval}s (okamžitě po detekci)';
  }

  @override
  String settingsTimingStep3Debounce(int scanInterval, int scanDebounce) {
    return 'Celkový čas přepnutí: ${scanInterval}s až ${scanDebounce}s';
  }

  @override
  String get settingsFramelessWindow => 'Použít okno bez rámečku';

  @override
  String get settingsFramelessWindowDesc =>
      'Odstranit záhlaví okna Windows pro moderní vzhled bez okrajů se zaoblenými rohy';

  @override
  String get settingsInvertLayout => 'Invertovat zápatí/záhlaví';

  @override
  String get settingsInvertLayoutDesc => 'Prohodit pozice záhlaví a zápatí';

  @override
  String get settingsTokenExpired => 'Vypršel';

  @override
  String settingsTokenExpiresDays(int days, int hours) {
    return 'Vyprší za ${days}d ${hours}h';
  }

  @override
  String settingsTokenExpiresHours(int hours, int minutes) {
    return 'Vyprší za ${hours}h ${minutes}m';
  }

  @override
  String settingsTokenExpiresMinutes(int minutes) {
    return 'Vyprší za ${minutes}m';
  }

  @override
  String get settingsResetDesc =>
      'Obnovit všechna nastavení a data na tovární výchozí hodnoty';

  @override
  String get settingsButtonReset => 'Obnovit';

  @override
  String mappingEditorSummary(
    int count,
    String plural,
    int lists,
    String pluralLists,
  ) {
    return '$count mapování proces$plural z $lists aktivního seznam$pluralLists';
  }

  @override
  String mappingEditorBreakdown(int custom, int community) {
    return '$custom vlastních, $community z komunitních seznamů';
  }

  @override
  String get mappingEditorButtonLists => 'Seznamy';

  @override
  String get mappingEditorButtonAdd => 'Přidat';

  @override
  String get mappingEditorDeleteTitle => 'Smazat více mapování';

  @override
  String mappingEditorDeleteMessage(int count, String plural) {
    return 'Opravdu chcete smazat $count mapování$plural? Tuto akci nelze vrátit zpět.';
  }

  @override
  String get mappingEditorExportTitle => 'Exportovat mapování';

  @override
  String get mappingEditorExportFilename => 'moje-mapovani.json';

  @override
  String mappingEditorExportSuccess(int count, String plural) {
    return 'Exportováno $count mapování$plural do';
  }

  @override
  String get mappingEditorExportFailed => 'Export selhal';

  @override
  String get addMappingPrivacySafe => 'Cesta bezpečná pro soukromí';

  @override
  String get addMappingCustomLocation => 'Vlastní umístění';

  @override
  String get addMappingOnlyFolder => 'Uloženy pouze názvy herních složek';

  @override
  String get addMappingNotStored => 'Cesta není uložena kvůli soukromí';

  @override
  String get colorPickerTitle => 'Vybrat barvu';

  @override
  String get colorPickerHue => 'Odstín';

  @override
  String get colorPickerSaturation => 'Sytost';

  @override
  String get colorPickerValue => 'Hodnota';

  @override
  String get colorPickerButtonCancel => 'Zrušit';

  @override
  String get colorPickerButtonSelect => 'Vybrat';

  @override
  String get dropdownPlaceholder => 'Vyberte možnost';

  @override
  String get dropdownSearchHint => 'Hledat...';

  @override
  String get dropdownNoResults => 'Nebyly nalezeny žádné výsledky';

  @override
  String paginationPageInfo(int current, int total) {
    return 'Stránka $current z $total';
  }

  @override
  String get paginationGoTo => 'Přejít na:';

  @override
  String get datePickerPlaceholder => 'Vybrat datum';

  @override
  String get timePickerAM => 'AM';

  @override
  String get timePickerPM => 'PM';

  @override
  String get timePickerPlaceholder => 'Vybrat čas';

  @override
  String get fileUploadInstruction => 'Klikněte pro nahrání souboru';

  @override
  String fileUploadAllowed(String extensions) {
    return 'Povoleno: $extensions';
  }

  @override
  String get menuButtonTooltip => 'Více možností';

  @override
  String get breadcrumbEllipsis => '...';

  @override
  String get breadcrumbTooltipShowPath => 'Zobrazit cestu';

  @override
  String get hotkeyModCtrl => 'Ctrl';

  @override
  String get hotkeyModAlt => 'Alt';

  @override
  String get hotkeyModShift => 'Shift';

  @override
  String get hotkeyModWin => 'Win';

  @override
  String get hotkeySpace => 'Mezerník';

  @override
  String get hotkeyEnter => 'Enter';

  @override
  String get hotkeyTab => 'Tab';

  @override
  String get hotkeyBackspace => 'Backspace';

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
  String get statusDashboardCurrentActivity => 'Aktuální aktivita';

  @override
  String get statusDashboardNotStarted => 'Nezahájeno';

  @override
  String get statusDashboardReady => 'Připraven';

  @override
  String get statusDashboardCheckingApp => 'Kontrola aktivní aplikace';

  @override
  String get statusDashboardFindingCategory => 'Hledání kategorie';

  @override
  String get statusDashboardUpdating => 'Aktualizace kategorie';

  @override
  String get statusDashboardWaiting => 'Čekání na potvrzení';

  @override
  String get statusDashboardError => 'Došlo k chybě';

  @override
  String mappingListOfCount(int count, int total) {
    return '$count z $total';
  }

  @override
  String get mappingListActionDelete => 'Smazat';

  @override
  String get mappingListActionEnable => 'Povolit';

  @override
  String get mappingListActionDisable => 'Zakázat';

  @override
  String autoSwitcherTimeSecondsAgo(int seconds) {
    return 'před ${seconds}s';
  }

  @override
  String autoSwitcherTimeMinutesAgo(int minutes) {
    return 'před ${minutes}m';
  }

  @override
  String autoSwitcherTimeHoursAgo(int hours) {
    return 'před ${hours}h';
  }
}
