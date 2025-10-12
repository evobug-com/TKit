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
      'Zahájit monitorování aktivní aplikace při spuštění TKit';

  @override
  String get autoSwitcherControlsStopMonitoring => 'ZASTAVIT MONITOROVÁNÍ';

  @override
  String get categoryMappingStatsPresets => 'Předvolby';

  @override
  String get updateDialogLater => 'Později';

  @override
  String get settingsFallbackBehavior => 'Záložní chování';

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
}
