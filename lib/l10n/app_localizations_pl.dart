// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'TKit';

  @override
  String get welcomeTitle => 'Witamy w TKit';

  @override
  String get selectLanguage => 'Wybierz swój język';

  @override
  String get languageLabel => 'Język';

  @override
  String get continueButton => 'KONTYNUUJ';

  @override
  String get confirm => 'Potwierdź';

  @override
  String get hello => 'Witaj';

  @override
  String get languageNativeName => 'Polski';

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
  String get settingsLanguage => 'Język';

  @override
  String get settingsLanguageDescription =>
      'Wybierz preferowany język aplikacji';

  @override
  String get languageChangeNotice =>
      'Język został zmieniony. Aplikacja zaktualizuje się natychmiast.';

  @override
  String get authSuccessAuthenticatedAs => 'Pomyślnie uwierzytelniono jako';

  @override
  String get systemTrayShowTkit => 'Pokaż TKit';

  @override
  String get authConnectToTwitch => 'Połącz z Twitch';

  @override
  String get systemTrayAutoSwitcher => 'Auto Switcher';

  @override
  String get authLoading => 'Ładowanie...';

  @override
  String get systemTrayCategoryMappings => 'Mapowania kategorii';

  @override
  String get authRefreshingToken => 'Odświeżanie tokenu...';

  @override
  String get systemTraySettings => 'Ustawienia';

  @override
  String get authSuccessfullyAuthenticated => 'Pomyślnie uwierzytelniono';

  @override
  String get systemTrayExit => 'Zakończ';

  @override
  String get authLoggedInAs => 'Zalogowano jako';

  @override
  String get systemTrayTooltip => 'TKit - Zestaw narzędzi Twitch';

  @override
  String get authErrorAuthenticationFailed =>
      'Uwierzytelnianie nie powiodło się';

  @override
  String get authErrorErrorCode => 'Kod błędu:';

  @override
  String get authTryAgain => 'Spróbuj ponownie';

  @override
  String get authAuthorizationSteps => 'Kroki autoryzacji';

  @override
  String get authStep1 => 'Kliknij przycisk \"Połącz z Twitch\" poniżej';

  @override
  String get authStep2 =>
      'Twoja przeglądarka otworzy stronę autoryzacji Twitch';

  @override
  String get authStep3 =>
      'Przejrzyj i autoryzuj TKit do zarządzania swoim kanałem';

  @override
  String get authStep4 => 'Wróć do tego okna po autoryzacji';

  @override
  String get authConnectToTwitchButton => 'POŁĄCZ Z TWITCH';

  @override
  String get authRequiresAccessMessage =>
      'TKit wymaga dostępu do aktualizacji kategorii Twojego kanału Twitch.';

  @override
  String get authDeviceCodeTitle => 'Połącz z Twitch';

  @override
  String get authDeviceCodeInstructions =>
      'Aby połączyć swoje konto Twitch, wykonaj te proste kroki:';

  @override
  String get authDeviceCodeStep1 => 'Przejdź do';

  @override
  String get authDeviceCodeStep2 => 'Wprowadź ten kod:';

  @override
  String get authDeviceCodeStep3 =>
      'Autoryzuj TKit do zarządzania kategorią Twojego kanału';

  @override
  String get authDeviceCodeCodeLabel => 'Twój kod';

  @override
  String get authDeviceCodeCopyCode => 'Kopiuj kod';

  @override
  String get authDeviceCodeCopied => 'Skopiowano!';

  @override
  String get authDeviceCodeOpenBrowser => 'Otwórz twitch.tv/activate';

  @override
  String get authDeviceCodeWaiting => 'Oczekiwanie na autoryzację...';

  @override
  String authDeviceCodeExpiresIn(String minutes, String seconds) {
    return 'Kod wygasa za $minutes:$seconds';
  }

  @override
  String get authDeviceCodeExpired => 'Kod wygasł. Spróbuj ponownie.';

  @override
  String get authDeviceCodeCancel => 'Anuluj';

  @override
  String get authDeviceCodeSuccess => 'Pomyślnie połączono!';

  @override
  String get authDeviceCodeError => 'Połączenie nieudane. Spróbuj ponownie.';

  @override
  String get authDeviceCodeHelp =>
      'Masz problemy? Upewnij się, że jesteś zalogowany do Twitch w przeglądarce.';

  @override
  String get autoSwitcherPageTitle => 'AUTO SWITCHER';

  @override
  String get authStatusAuthenticated => 'Uwierzytelniono';

  @override
  String get autoSwitcherPageDescription =>
      'Automatycznie aktualizuje kategorię transmisji na podstawie aktywnej aplikacji';

  @override
  String get authStatusConnecting => 'Łączenie...';

  @override
  String get autoSwitcherStatusHeader => 'STATUS';

  @override
  String get authStatusError => 'Błąd';

  @override
  String get autoSwitcherStatusCurrentProcess => 'BIEŻĄCY PROCES';

  @override
  String get authStatusNotConnected => 'Nie połączono';

  @override
  String get autoSwitcherStatusNone => 'Brak';

  @override
  String get autoSwitcherStatusMatchedCategory => 'DOPASOWANA KATEGORIA';

  @override
  String get mainWindowNavAutoSwitcher => 'Auto Switcher';

  @override
  String get autoSwitcherStatusLastUpdate => 'OSTATNIA AKTUALIZACJA';

  @override
  String get mainWindowNavMappings => 'Mapowania';

  @override
  String get autoSwitcherStatusNever => 'Nigdy';

  @override
  String get mainWindowNavSettings => 'Ustawienia';

  @override
  String get mainWindowStatusConnected => 'Połączono';

  @override
  String get autoSwitcherStatusUpdateStatus => 'STATUS AKTUALIZACJI';

  @override
  String get mainWindowStatusDisconnected => 'Rozłączono';

  @override
  String get autoSwitcherStatusNoUpdatesYet => 'Jeszcze brak aktualizacji';

  @override
  String get mainWindowWindowControlMinimize => 'Minimalizuj';

  @override
  String get autoSwitcherStatusSuccess => 'SUKCES';

  @override
  String get authLoadingStartingAuthentication =>
      'Rozpoczynanie uwierzytelniania...';

  @override
  String get mainWindowWindowControlMaximize => 'Maksymalizuj';

  @override
  String get autoSwitcherStatusFailed => 'NIEPOWODZENIE';

  @override
  String get authLoadingLoggingOut => 'Wylogowywanie...';

  @override
  String get settingsSavedSuccessfully => 'Ustawienia zapisane pomyślnie';

  @override
  String get autoSwitcherStatusSystemState => 'STAN SYSTEMU';

  @override
  String get mainWindowWindowControlClose => 'Zamknij';

  @override
  String get authLoadingCheckingStatus =>
      'Sprawdzanie stanu uwierzytelnienia...';

  @override
  String get settingsRetry => 'Ponów próbę';

  @override
  String get settingsPageTitle => 'USTAWIENIA';

  @override
  String get settingsPageDescription =>
      'Skonfiguruj zachowanie i preferencje aplikacji';

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
  String get autoSwitcherStatusNotInitialized => 'NIE ZAINICJALIZOWANO';

  @override
  String get mainWindowFooterReady => 'Gotowy';

  @override
  String get authErrorTokenRefreshFailed =>
      'Odświeżenie tokenu nie powiodło się:';

  @override
  String get settingsAutoSwitcher => 'Auto Switcher';

  @override
  String get autoSwitcherStatusIdle => 'BEZCZYNNY';

  @override
  String get updateDialogTitle => 'Dostępna aktualizacja';

  @override
  String get settingsMonitoring => 'Monitorowanie';

  @override
  String get autoSwitcherStatusDetectingProcess => 'WYKRYWANIE PROCESU';

  @override
  String get categoryMappingTitle => 'MAPOWANIA KATEGORII';

  @override
  String get updateDialogWhatsNew => 'Co nowego:';

  @override
  String get settingsScanIntervalLabel => 'Interwał skanowania';

  @override
  String get autoSwitcherStatusSearchingMapping => 'WYSZUKIWANIE MAPOWANIA';

  @override
  String get categoryMappingSubtitle =>
      'Zarządzaj mapowaniami proces-kategoria dla automatycznego przełączania';

  @override
  String get updateDialogDownloadComplete =>
      'Pobieranie zakończone! Gotowe do instalacji.';

  @override
  String get settingsScanIntervalDescription =>
      'Jak często sprawdzać, która aplikacja ma fokus';

  @override
  String get autoSwitcherStatusUpdatingCategory => 'AKTUALIZOWANIE KATEGORII';

  @override
  String get categoryMappingAddMappingButton => 'DODAJ MAPOWANIE';

  @override
  String get updateDialogDownloadFailed => 'Pobieranie nie powiodło się:';

  @override
  String get settingsDebounceTimeLabel => 'Czas stabilizacji';

  @override
  String get autoSwitcherStatusWaitingDebounce => 'OCZEKIWANIE (STABILIZACJA)';

  @override
  String get categoryMappingErrorDialogTitle => 'Błąd';

  @override
  String get updateDialogRemindLater => 'Przypomnij później';

  @override
  String get settingsDebounceTimeDescription =>
      'Czas oczekiwania przed przełączeniem kategorii po zmianie aplikacji (zapobiega szybkiemu przełączaniu)';

  @override
  String get autoSwitcherStatusError => 'BŁĄD';

  @override
  String get categoryMappingStatsTotalMappings => 'Wszystkie mapowania';

  @override
  String get updateDialogDownloadUpdate => 'Pobierz aktualizację';

  @override
  String get settingsAutoStartMonitoringLabel =>
      'Automatyczne rozpoczęcie monitorowania';

  @override
  String get autoSwitcherControlsHeader => 'STEROWANIE';

  @override
  String get categoryMappingStatsUserDefined =>
      'Zdefiniowane przez użytkownika';

  @override
  String get updateDialogCancel => 'Anuluj';

  @override
  String get settingsAutoStartMonitoringSubtitle =>
      'Rozpocznij monitorowanie aktywnej aplikacji po uruchomieniu TKit';

  @override
  String get autoSwitcherControlsStopMonitoring => 'ZATRZYMAJ MONITOROWANIE';

  @override
  String get categoryMappingStatsPresets => 'Predefiniowane';

  @override
  String get updateDialogLater => 'Później';

  @override
  String get settingsFallbackBehavior => 'Zachowanie zapasowe';

  @override
  String get autoSwitcherControlsStartMonitoring => 'ROZPOCZNIJ MONITOROWANIE';

  @override
  String get categoryMappingErrorLoading => 'Błąd ładowania mapowań';

  @override
  String get updateDialogInstallRestart => 'Zainstaluj i uruchom ponownie';

  @override
  String get settingsFallbackBehaviorLabel => 'Gdy nie znaleziono mapowania';

  @override
  String get autoSwitcherControlsManualUpdate => 'RĘCZNA AKTUALIZACJA';

  @override
  String get categoryMappingRetryButton => 'PONÓW PRÓBĘ';

  @override
  String get updateDialogToday => 'dzisiaj';

  @override
  String get settingsFallbackBehaviorDescription =>
      'Wybierz, co się stanie, gdy aktywna aplikacja nie ma mapowania kategorii';

  @override
  String get categoryMappingDeleteDialogTitle => 'Usuń mapowanie';

  @override
  String get autoSwitcherControlsMonitoringStatus => 'STATUS MONITOROWANIA';

  @override
  String get updateDialogYesterday => 'wczoraj';

  @override
  String get settingsCustomCategory => 'Kategoria niestandardowa';

  @override
  String get categoryMappingDeleteDialogMessage =>
      'Czy na pewno chcesz usunąć to mapowanie?';

  @override
  String get autoSwitcherControlsActive => 'AKTYWNY';

  @override
  String updateDialogDaysAgo(int days) {
    return '$days dni temu';
  }

  @override
  String get settingsCustomCategoryHint => 'Wyszukaj kategorię...';

  @override
  String get categoryMappingDeleteDialogConfirm => 'USUŃ';

  @override
  String get autoSwitcherControlsInactive => 'NIEAKTYWNY';

  @override
  String updateDialogVersion(String version) {
    return 'Wersja $version';
  }

  @override
  String get categoryMappingDeleteDialogCancel => 'ANULUJ';

  @override
  String get settingsCategorySearchUnavailable =>
      'Wyszukiwanie kategorii będzie dostępne po ukończeniu modułu API Twitch';

  @override
  String get autoSwitcherControlsActiveDescription =>
      'Automatyczna aktualizacja kategorii na podstawie aktywnego procesu';

  @override
  String updateDialogPublished(String date) {
    return 'Opublikowano $date';
  }

  @override
  String get categoryMappingAddDialogEditTitle => 'EDYTUJ MAPOWANIE';

  @override
  String get settingsApplication => 'Aplikacja';

  @override
  String get autoSwitcherControlsInactiveDescription =>
      'Rozpocznij monitorowanie, aby włączyć automatyczne aktualizacje kategorii';

  @override
  String get welcomeStepLanguage => 'Język';

  @override
  String get categoryMappingAddDialogAddTitle => 'DODAJ NOWE MAPOWANIE';

  @override
  String get categoryMappingAddDialogClose => 'Zamknij';

  @override
  String get categoryMappingAddDialogProcessName => 'NAZWA PROCESU';

  @override
  String get categoryMappingAddDialogExecutablePath =>
      'ŚCIEŻKA PLIKU WYKONYWALNEGO (OPCJONALNIE)';

  @override
  String get categoryMappingAddDialogCategoryId => 'ID KATEGORII TWITCH';

  @override
  String get categoryMappingAddDialogCategoryName => 'NAZWA KATEGORII TWITCH';

  @override
  String get categoryMappingAddDialogCancel => 'ANULUJ';

  @override
  String get categoryMappingAddDialogUpdate => 'AKTUALIZUJ';

  @override
  String get categoryMappingAddDialogAdd => 'DODAJ';

  @override
  String get settingsAutoStartWindowsLabel =>
      'Automatyczne uruchamianie z Windows';

  @override
  String get categoryMappingAddDialogCloseTooltip => 'Zamknij';

  @override
  String get welcomeStepTwitch => 'Twitch';

  @override
  String get welcomeStepBehavior => 'Zachowanie';

  @override
  String get welcomeBehaviorStepTitle => 'KROK 3: ZACHOWANIE APLIKACJI';

  @override
  String get welcomeBehaviorTitle => 'Zachowanie aplikacji';

  @override
  String get welcomeBehaviorDescription =>
      'Skonfiguruj, jak TKit zachowuje się podczas uruchamiania i minimalizacji.';

  @override
  String get welcomeBehaviorOptionalInfo =>
      'Te ustawienia można zmienić w dowolnym momencie w Ustawieniach.';

  @override
  String get settingsWindowControlsPositionLabel => 'Pozycja kontrolek okna';

  @override
  String get settingsWindowControlsPositionDescription =>
      'Wybierz, gdzie pojawiają się kontrolki okna (minimalizuj, maksymalizuj, zamknij)';

  @override
  String get windowControlsPositionLeft => 'Lewo';

  @override
  String get windowControlsPositionCenter => 'Środek';

  @override
  String get windowControlsPositionRight => 'Prawo';

  @override
  String get settingsAutoStartWindowsSubtitle =>
      'Uruchamiaj TKit automatycznie po uruchomieniu Windows';

  @override
  String get categoryMappingAddDialogProcessNameLabel => 'NAZWA PROCESU';

  @override
  String get welcomeLanguageStepTitle => 'KROK 1: WYBIERZ SWÓJ JĘZYK';

  @override
  String get settingsStartMinimizedLabel => 'Uruchom zminimalizowany';

  @override
  String get categoryMappingAddDialogProcessNameHint =>
      'np. League of Legends.exe';

  @override
  String get welcomeLanguageChangeLater =>
      'Możesz to zmienić później w Ustawieniach.';

  @override
  String get settingsStartMinimizedSubtitle =>
      'Uruchom TKit zminimalizowany do zasobnika systemowego';

  @override
  String get categoryMappingAddDialogProcessNameRequired =>
      'Nazwa procesu jest wymagana';

  @override
  String get welcomeTwitchStepTitle => 'KROK 2: POŁĄCZ Z TWITCH';

  @override
  String get settingsMinimizeToTrayLabel =>
      'Minimalizuj do zasobnika systemowego';

  @override
  String get categoryMappingAddDialogExecutablePathLabel =>
      'ŚCIEŻKA PLIKU WYKONYWALNEGO (OPCJONALNIE)';

  @override
  String get welcomeTwitchConnectionTitle => 'Połączenie Twitch';

  @override
  String get settingsMinimizeToTraySubtitle =>
      'Utrzymuj TKit działający w tle podczas zamykania lub minimalizowania';

  @override
  String get categoryMappingAddDialogExecutablePathHint =>
      'np. C:\\Games\\LeagueOfLegends\\Game\\League of Legends.exe';

  @override
  String welcomeTwitchConnectedAs(String username) {
    return 'Połączono jako $username';
  }

  @override
  String get settingsShowNotificationsLabel => 'Pokaż powiadomienia';

  @override
  String get categoryMappingAddDialogCategoryIdLabel => 'ID KATEGORII TWITCH';

  @override
  String get welcomeTwitchDescription =>
      'Połącz swoje konto Twitch, aby włączyć automatyczne przełączanie kategorii na podstawie aktywnej aplikacji.';

  @override
  String get settingsShowNotificationsSubtitle =>
      'Wyświetlaj powiadomienia po aktualizacji kategorii';

  @override
  String get settingsNotifyMissingCategoryLabel =>
      'Powiadom o brakującej kategorii';

  @override
  String get settingsNotifyMissingCategorySubtitle =>
      'Pokaż powiadomienie, gdy nie znaleziono mapowania dla gry lub aplikacji';

  @override
  String get categoryMappingAddDialogCategoryIdHint => 'np. 21779';

  @override
  String get welcomeTwitchOptionalInfo =>
      'Ten krok jest opcjonalny. Możesz pominąć i skonfigurować to później w Ustawieniach.';

  @override
  String get settingsKeyboardShortcuts => 'Skróty klawiszowe';

  @override
  String get categoryMappingAddDialogCategoryIdRequired =>
      'ID kategorii jest wymagane';

  @override
  String get welcomeTwitchAuthorizeButton => 'AUTORYZUJ Z TWITCH';

  @override
  String get settingsManualUpdateHotkeyLabel => 'Skrót ręcznej aktualizacji';

  @override
  String get categoryMappingAddDialogCategoryNameLabel =>
      'NAZWA KATEGORII TWITCH';

  @override
  String get welcomeButtonNext => 'DALEJ';

  @override
  String get settingsManualUpdateHotkeyDescription =>
      'Wyzwól ręczną aktualizację kategorii';

  @override
  String get categoryMappingAddDialogCategoryNameHint =>
      'np. League of Legends';

  @override
  String get welcomeButtonBack => 'WSTECZ';

  @override
  String get settingsUnsavedChanges => 'Masz niezapisane zmiany';

  @override
  String get categoryMappingAddDialogCategoryNameRequired =>
      'Nazwa kategorii jest wymagana';

  @override
  String get settingsDiscard => 'Odrzuć';

  @override
  String get categoryMappingAddDialogTip =>
      'Wskazówka: Użyj wyszukiwania kategorii Twitch, aby znaleźć poprawne ID i nazwę';

  @override
  String get settingsSave => 'Zapisz';

  @override
  String get categoryMappingAddDialogCancelButton => 'ANULUJ';

  @override
  String get settingsTwitchConnection => 'Połączenie Twitch';

  @override
  String get categoryMappingAddDialogUpdateButton => 'AKTUALIZUJ';

  @override
  String get settingsTwitchStatusConnected => 'Połączono';

  @override
  String get categoryMappingAddDialogAddButton => 'DODAJ';

  @override
  String get settingsTwitchStatusNotConnected => 'Nie połączono';

  @override
  String get categoryMappingListEmpty => 'Jeszcze brak mapowań kategorii';

  @override
  String get categoryMappingListEmptyTitle => 'Jeszcze brak mapowań kategorii';

  @override
  String get settingsTwitchLoggedInAs => 'Zalogowano jako:';

  @override
  String get categoryMappingListEmptySubtitle =>
      'Dodaj swoje pierwsze mapowanie, aby rozpocząć';

  @override
  String get settingsTwitchDisconnect => 'Rozłącz';

  @override
  String get categoryMappingListColumnProcessName => 'NAZWA PROCESU';

  @override
  String get settingsTwitchConnectDescription =>
      'Połącz swoje konto Twitch, aby włączyć automatyczne przełączanie kategorii.';

  @override
  String get categoryMappingListColumnCategory => 'KATEGORIA';

  @override
  String get settingsTwitchConnect => 'Połącz z Twitch';

  @override
  String get categoryMappingListColumnLastUsed => 'OSTATNIO UŻYTE';

  @override
  String get hotkeyInputCancel => 'Anuluj';

  @override
  String get categoryMappingListColumnType => 'TYP';

  @override
  String get hotkeyInputChange => 'Zmień';

  @override
  String get categoryMappingListColumnActions => 'AKCJE';

  @override
  String get hotkeyInputClearHotkey => 'Wyczyść skrót';

  @override
  String get categoryMappingListIdPrefix => 'ID: ';

  @override
  String categoryMappingListCategoryId(String categoryId) {
    return 'ID: $categoryId';
  }

  @override
  String get categoryMappingListNever => 'Nigdy';

  @override
  String get categoryMappingListJustNow => 'Przed chwilą';

  @override
  String categoryMappingListMinutesAgo(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'minuty',
      one: 'minuta',
    );
    return '$minutes $_temp0 temu';
  }

  @override
  String categoryMappingListHoursAgo(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: 'godziny',
      one: 'godzina',
    );
    return '$hours $_temp0 temu';
  }

  @override
  String categoryMappingListDaysAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'dni',
      one: 'dzień',
    );
    return '$days $_temp0 temu';
  }

  @override
  String get hotkeyInputSetHotkey => 'Ustaw skrót';

  @override
  String get categoryMappingListNeverUsed => 'Nigdy';

  @override
  String get categoryMappingListTypeUser => 'UŻYTKOWNIK';

  @override
  String get categoryMappingListTypePreset => 'PREDEFINIOWANE';

  @override
  String get categoryMappingListEditTooltip => 'Edytuj mapowanie';

  @override
  String get categoryMappingListDeleteTooltip => 'Usuń mapowanie';

  @override
  String get categoryMappingListTimeJustNow => 'Przed chwilą';

  @override
  String get categoryMappingProviderSuccessAdded =>
      'Mapowanie dodane pomyślnie';

  @override
  String get categoryMappingProviderSuccessUpdated =>
      'Mapowanie zaktualizowane pomyślnie';

  @override
  String get categoryMappingProviderSuccessDeleted =>
      'Mapowanie usunięte pomyślnie';

  @override
  String get commonCancel => 'Anuluj';

  @override
  String get commonOk => 'OK';

  @override
  String get commonConfirm => 'Potwierdź';

  @override
  String get autoSwitcherProviderErrorPrefix => 'Nie udało się';

  @override
  String get autoSwitcherProviderStartMonitoring => 'rozpocząć monitorowania';

  @override
  String get autoSwitcherProviderStopMonitoring => 'zatrzymać monitorowania';

  @override
  String get autoSwitcherProviderManualUpdate => 'wykonać ręcznej aktualizacji';

  @override
  String get autoSwitcherProviderLoadHistory => 'załadować historii';

  @override
  String get autoSwitcherProviderClearHistory => 'wyczyścić historii';

  @override
  String get autoSwitcherProviderSuccessCategoryUpdated =>
      'Kategoria zaktualizowana pomyślnie';

  @override
  String get autoSwitcherProviderSuccessHistoryCleared =>
      'Historia wyczyszczona pomyślnie';

  @override
  String get autoSwitcherProviderErrorUnknown => 'Nieznany błąd';

  @override
  String get settingsFactoryReset => 'Przywracanie ustawień fabrycznych';

  @override
  String get settingsFactoryResetDescription =>
      'Zresetuj wszystkie ustawienia i dane do wartości domyślnych';

  @override
  String get settingsFactoryResetButton => 'Przywróć ustawienia fabryczne';

  @override
  String get settingsFactoryResetDialogTitle =>
      'Przywracanie ustawień fabrycznych';

  @override
  String get settingsFactoryResetDialogMessage =>
      'Wszystkie ustawienia, lokalna baza danych i wszystkie lokalnie utworzone kategorie zostaną utracone. Czy na pewno chcesz kontynuować?';

  @override
  String get settingsFactoryResetDialogConfirm => 'RESETUJ';

  @override
  String get settingsFactoryResetSuccess =>
      'Aplikacja została przywrócona do ustawień fabrycznych pomyślnie. Proszę uruchomić aplikację ponownie.';

  @override
  String get settingsUpdates => 'Aktualizacje';

  @override
  String get settingsUpdateChannelLabel => 'Kanał aktualizacji';

  @override
  String get settingsUpdateChannelDescription =>
      'Wybierz, jakie typy aktualizacji chcesz otrzymywać';

  @override
  String settingsUpdateChannelChanged(String channel) {
    return 'Kanał aktualizacji zmieniony na $channel. Sprawdzanie aktualizacji...';
  }

  @override
  String get updateChannelStable => 'Stabilny';

  @override
  String get updateChannelStableDesc =>
      'Zalecane dla większości użytkowników. Tylko stabilne wydania.';

  @override
  String get updateChannelRc => 'Release Candidate';

  @override
  String get updateChannelRcDesc =>
      'Stabilne funkcje z końcowymi testami przed stabilnym wydaniem.';

  @override
  String get updateChannelBeta => 'Beta';

  @override
  String get updateChannelBetaDesc =>
      'Nowe funkcje, które są w większości stabilne. Może zawierać błędy.';

  @override
  String get updateChannelDev => 'Deweloperski';

  @override
  String get updateChannelDevDesc =>
      'Najnowsze funkcje. Spodziewaj się błędów i niestabilności.';

  @override
  String get fallbackBehaviorDoNothing => 'Nie rób nic';

  @override
  String get fallbackBehaviorJustChatting => 'Just Chatting';

  @override
  String get fallbackBehaviorCustom => 'Własna kategoria';

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
  String get versionStatusUpToDate => 'Aktualne';

  @override
  String get versionStatusUpdateAvailable => 'Dostępna aktualizacja';

  @override
  String versionStatusCheckFailed(String error) {
    return 'Sprawdzanie aktualizacji nie powiodło się: $error';
  }

  @override
  String get versionStatusNotInitialized =>
      'Usługa aktualizacji nie została zainicjowana';

  @override
  String get versionStatusPlatformNotSupported =>
      'Aktualizacje nie są obsługiwane na tej platformie';
}
