// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'TKit';

  @override
  String get welcomeTitle => 'Bienvenue sur TKit';

  @override
  String get selectLanguage => 'Sélectionnez votre langue';

  @override
  String get languageLabel => 'Langue';

  @override
  String get continueButton => 'CONTINUER';

  @override
  String get confirm => 'Confirmer';

  @override
  String get hello => 'Bonjour';

  @override
  String get languageNativeName => 'Français';

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
  String get settingsLanguage => 'Langue';

  @override
  String get settingsLanguageDescription =>
      'Choisissez votre langue préférée pour l\'application';

  @override
  String get languageChangeNotice =>
      'Langue modifiée. L\'application sera mise à jour immédiatement.';

  @override
  String get authSuccessAuthenticatedAs =>
      'Authentifié avec succès en tant que';

  @override
  String get systemTrayShowTkit => 'Afficher TKit';

  @override
  String get authConnectToTwitch => 'Se connecter à Twitch';

  @override
  String get systemTrayAutoSwitcher => 'Commutation automatique';

  @override
  String get authLoading => 'Chargement...';

  @override
  String get systemTrayCategoryMappings => 'Mappages de catégories';

  @override
  String get authRefreshingToken => 'Actualisation du jeton...';

  @override
  String get systemTraySettings => 'Paramètres';

  @override
  String get authSuccessfullyAuthenticated => 'Authentifié avec succès';

  @override
  String get systemTrayExit => 'Quitter';

  @override
  String get authLoggedInAs => 'Connecté en tant que';

  @override
  String get systemTrayTooltip => 'TKit - Boîte à outils Twitch';

  @override
  String get authErrorAuthenticationFailed => 'Échec de l\'authentification';

  @override
  String get authErrorErrorCode => 'Code d\'erreur :';

  @override
  String get authTryAgain => 'Réessayer';

  @override
  String get authAuthorizationSteps => 'Étapes d\'autorisation';

  @override
  String get authStep1 =>
      'Cliquez sur le bouton \"Se connecter à Twitch\" ci-dessous';

  @override
  String get authStep2 =>
      'Votre navigateur ouvrira la page d\'autorisation Twitch';

  @override
  String get authStep3 => 'Examinez et autorisez TKit à gérer votre chaîne';

  @override
  String get authStep4 => 'Revenez à cette fenêtre après l\'autorisation';

  @override
  String get authConnectToTwitchButton => 'SE CONNECTER À TWITCH';

  @override
  String get authRequiresAccessMessage =>
      'TKit nécessite un accès pour mettre à jour la catégorie de votre chaîne Twitch.';

  @override
  String get authDeviceCodeTitle => 'Se connecter à Twitch';

  @override
  String get authDeviceCodeInstructions =>
      'Pour connecter votre compte Twitch, suivez ces étapes simples :';

  @override
  String get authDeviceCodeStep1 => 'Allez sur';

  @override
  String get authDeviceCodeStep2 => 'Entrez ce code :';

  @override
  String get authDeviceCodeStep3 =>
      'Autorisez TKit à gérer la catégorie de votre chaîne';

  @override
  String get authDeviceCodeCodeLabel => 'Votre code';

  @override
  String get authDeviceCodeCopyCode => 'Copier le code';

  @override
  String get authDeviceCodeCopied => 'Copié !';

  @override
  String get authDeviceCodeOpenBrowser => 'Ouvrir twitch.tv/activate';

  @override
  String get authDeviceCodeWaiting => 'En attente d\'autorisation...';

  @override
  String authDeviceCodeExpiresIn(String minutes, String seconds) {
    return 'Le code expire dans $minutes:$seconds';
  }

  @override
  String get authDeviceCodeExpired => 'Code expiré. Veuillez réessayer.';

  @override
  String get authDeviceCodeCancel => 'Annuler';

  @override
  String get authDeviceCodeSuccess => 'Connecté avec succès !';

  @override
  String get authDeviceCodeError =>
      'Échec de la connexion. Veuillez réessayer.';

  @override
  String get authDeviceCodeHelp =>
      'Des problèmes ? Assurez-vous d\'être connecté à Twitch dans votre navigateur.';

  @override
  String get autoSwitcherPageTitle => 'COMMUTATION AUTOMATIQUE';

  @override
  String get authStatusAuthenticated => 'Authentifié';

  @override
  String get autoSwitcherPageDescription =>
      'Met à jour automatiquement la catégorie de diffusion en fonction de l\'application active';

  @override
  String get authStatusConnecting => 'Connexion...';

  @override
  String get autoSwitcherStatusHeader => 'ÉTAT';

  @override
  String get authStatusError => 'Erreur';

  @override
  String get autoSwitcherStatusCurrentProcess => 'PROCESSUS ACTUEL';

  @override
  String get authStatusNotConnected => 'Non connecté';

  @override
  String get autoSwitcherStatusNone => 'Aucun';

  @override
  String get autoSwitcherStatusMatchedCategory => 'CATÉGORIE CORRESPONDANTE';

  @override
  String get mainWindowNavAutoSwitcher => 'Commutation automatique';

  @override
  String get autoSwitcherStatusLastUpdate => 'DERNIÈRE MISE À JOUR';

  @override
  String get mainWindowNavMappings => 'Mappages';

  @override
  String get autoSwitcherStatusNever => 'Jamais';

  @override
  String get mainWindowNavSettings => 'Paramètres';

  @override
  String get mainWindowStatusConnected => 'Connecté';

  @override
  String get autoSwitcherStatusUpdateStatus => 'ÉTAT DE MISE À JOUR';

  @override
  String get mainWindowStatusDisconnected => 'Déconnecté';

  @override
  String get autoSwitcherStatusNoUpdatesYet => 'Pas encore de mises à jour';

  @override
  String get mainWindowWindowControlMinimize => 'Réduire';

  @override
  String get autoSwitcherStatusSuccess => 'SUCCÈS';

  @override
  String get authLoadingStartingAuthentication =>
      'Démarrage de l\'authentification...';

  @override
  String get mainWindowWindowControlMaximize => 'Agrandir';

  @override
  String get autoSwitcherStatusFailed => 'ÉCHEC';

  @override
  String get authLoadingLoggingOut => 'Déconnexion...';

  @override
  String get settingsSavedSuccessfully => 'Paramètres enregistrés avec succès';

  @override
  String get autoSwitcherStatusSystemState => 'ÉTAT DU SYSTÈME';

  @override
  String get mainWindowWindowControlClose => 'Fermer';

  @override
  String get authLoadingCheckingStatus =>
      'Vérification de l\'état d\'authentification...';

  @override
  String get settingsRetry => 'Réessayer';

  @override
  String get settingsPageTitle => 'PARAMÈTRES';

  @override
  String get settingsPageDescription =>
      'Configurer le comportement et les préférences de l\'application';

  @override
  String get settingsTabGeneral => 'Général';

  @override
  String get settingsTabAutoSwitcher => 'Commutateur automatique';

  @override
  String get settingsTabKeyboard => 'Clavier';

  @override
  String get settingsTabTwitch => 'Twitch';

  @override
  String get settingsTabAdvanced => 'Avancé';

  @override
  String get autoSwitcherStatusNotInitialized => 'NON INITIALISÉ';

  @override
  String get mainWindowFooterReady => 'Prêt';

  @override
  String get authErrorTokenRefreshFailed =>
      'Échec de l\'actualisation du jeton :';

  @override
  String get settingsAutoSwitcher => 'Commutation automatique';

  @override
  String get autoSwitcherStatusIdle => 'INACTIF';

  @override
  String get updateDialogTitle => 'Mise à jour disponible';

  @override
  String get settingsMonitoring => 'Surveillance';

  @override
  String get autoSwitcherStatusDetectingProcess => 'DÉTECTION DU PROCESSUS';

  @override
  String get categoryMappingTitle => 'MAPPAGES DE CATÉGORIES';

  @override
  String get updateDialogWhatsNew => 'Nouveautés :';

  @override
  String get settingsScanIntervalLabel => 'Intervalle de balayage';

  @override
  String get autoSwitcherStatusSearchingMapping => 'RECHERCHE DE MAPPAGE';

  @override
  String get categoryMappingSubtitle =>
      'Gérez les mappages processus-catégorie pour la commutation automatique';

  @override
  String get updateDialogDownloadComplete =>
      'Téléchargement terminé ! Prêt à installer.';

  @override
  String get settingsScanIntervalDescription =>
      'À quelle fréquence vérifier quelle application a le focus';

  @override
  String get autoSwitcherStatusUpdatingCategory =>
      'MISE À JOUR DE LA CATÉGORIE';

  @override
  String get categoryMappingAddMappingButton => 'AJOUTER UN MAPPAGE';

  @override
  String get updateDialogDownloadFailed => 'Échec du téléchargement :';

  @override
  String get settingsDebounceTimeLabel => 'Temps d\'anti-rebond';

  @override
  String get autoSwitcherStatusWaitingDebounce => 'EN ATTENTE (ANTI-REBOND)';

  @override
  String get categoryMappingErrorDialogTitle => 'Erreur';

  @override
  String get updateDialogRemindLater => 'Me rappeler plus tard';

  @override
  String get updateDialogIgnore => 'Ignorer cette version';

  @override
  String get settingsDebounceTimeDescription =>
      'Temps d\'attente avant de changer de catégorie après le changement d\'application (évite les changements rapides)';

  @override
  String get autoSwitcherStatusError => 'ERREUR';

  @override
  String get categoryMappingStatsTotalMappings => 'Total des mappages';

  @override
  String get updateDialogDownloadUpdate => 'Télécharger la mise à jour';

  @override
  String get settingsAutoStartMonitoringLabel =>
      'Démarrer la surveillance automatiquement';

  @override
  String get autoSwitcherControlsHeader => 'CONTRÔLES';

  @override
  String get categoryMappingStatsUserDefined => 'Défini par l\'utilisateur';

  @override
  String get updateDialogCancel => 'Annuler';

  @override
  String get settingsAutoStartMonitoringSubtitle =>
      'Commencer à surveiller l\'application active au démarrage de TKit';

  @override
  String get autoSwitcherControlsStopMonitoring => 'ARRÊTER LA SURVEILLANCE';

  @override
  String get categoryMappingStatsPresets => 'Préréglages';

  @override
  String get updateDialogLater => 'Plus tard';

  @override
  String get settingsFallbackBehavior => 'Comportement de secours';

  @override
  String get autoSwitcherControlsStartMonitoring => 'DÉMARRER LA SURVEILLANCE';

  @override
  String get categoryMappingErrorLoading =>
      'Erreur lors du chargement des mappages';

  @override
  String get updateDialogInstallRestart => 'Installer et redémarrer';

  @override
  String get settingsFallbackBehaviorLabel =>
      'Lorsqu\'aucun mappage n\'est trouvé';

  @override
  String get autoSwitcherControlsManualUpdate => 'MISE À JOUR MANUELLE';

  @override
  String get categoryMappingRetryButton => 'RÉESSAYER';

  @override
  String get updateDialogToday => 'aujourd\'hui';

  @override
  String get settingsFallbackBehaviorDescription =>
      'Choisissez ce qui se passe lorsque l\'application active n\'a pas de mappage de catégorie';

  @override
  String get categoryMappingDeleteDialogTitle => 'Supprimer le mappage';

  @override
  String get autoSwitcherControlsMonitoringStatus => 'ÉTAT DE SURVEILLANCE';

  @override
  String get updateDialogYesterday => 'hier';

  @override
  String get settingsCustomCategory => 'Catégorie personnalisée';

  @override
  String get categoryMappingDeleteDialogMessage =>
      'Êtes-vous sûr de vouloir supprimer ce mappage ?';

  @override
  String get autoSwitcherControlsActive => 'ACTIF';

  @override
  String updateDialogDaysAgo(int days) {
    return 'il y a $days jours';
  }

  @override
  String get settingsCustomCategoryHint => 'Rechercher une catégorie...';

  @override
  String get categoryMappingDeleteDialogConfirm => 'SUPPRIMER';

  @override
  String get autoSwitcherControlsInactive => 'INACTIF';

  @override
  String updateDialogVersion(String version) {
    return 'Version $version';
  }

  @override
  String get categoryMappingDeleteDialogCancel => 'ANNULER';

  @override
  String get settingsCategorySearchUnavailable =>
      'La recherche de catégories sera disponible lorsque le module API Twitch sera terminé';

  @override
  String get autoSwitcherControlsActiveDescription =>
      'Mise à jour automatique de la catégorie en fonction du processus actif';

  @override
  String updateDialogPublished(String date) {
    return 'Publié le $date';
  }

  @override
  String get updateDialogVersionLabel => 'VERSION';

  @override
  String get updateDialogSize => 'Taille';

  @override
  String get updateDialogPublishedLabel => 'Publié';

  @override
  String get updateDialogDownloading => 'Téléchargement en cours';

  @override
  String get updateDialogReadyToInstall => 'Prêt à installer';

  @override
  String get updateDialogClickInstallRestart =>
      'Cliquez sur Installer et Redémarrer';

  @override
  String get updateDialogDownloadFailedTitle => 'Échec du téléchargement';

  @override
  String get updateDialogNeverShowTooltip => 'Ne plus afficher cette version';

  @override
  String get updateDialogIgnoreButton => 'Ignorer';

  @override
  String get updateDialogRemindTooltip => 'Me le rappeler la prochaine fois';

  @override
  String get updateDialogPostpone => 'Reporter';

  @override
  String get categoryMappingAddDialogEditTitle => 'MODIFIER LE MAPPAGE';

  @override
  String get settingsApplication => 'Application';

  @override
  String get autoSwitcherControlsInactiveDescription =>
      'Démarrez la surveillance pour activer les mises à jour automatiques de catégorie';

  @override
  String get welcomeStepLanguage => 'Langue';

  @override
  String get categoryMappingAddDialogAddTitle => 'AJOUTER UN NOUVEAU MAPPAGE';

  @override
  String get categoryMappingAddDialogClose => 'Fermer';

  @override
  String get categoryMappingAddDialogProcessName => 'NOM DU PROCESSUS';

  @override
  String get categoryMappingAddDialogExecutablePath =>
      'CHEMIN DE L\'EXÉCUTABLE (FACULTATIF)';

  @override
  String get categoryMappingAddDialogCategoryId => 'ID DE CATÉGORIE TWITCH';

  @override
  String get categoryMappingAddDialogCategoryName => 'NOM DE CATÉGORIE TWITCH';

  @override
  String get categoryMappingAddDialogCancel => 'ANNULER';

  @override
  String get categoryMappingAddDialogUpdate => 'METTRE À JOUR';

  @override
  String get categoryMappingAddDialogAdd => 'AJOUTER';

  @override
  String get settingsAutoStartWindowsLabel =>
      'Démarrage automatique avec Windows';

  @override
  String get categoryMappingAddDialogCloseTooltip => 'Fermer';

  @override
  String get welcomeStepTwitch => 'Twitch';

  @override
  String get welcomeStepBehavior => 'Comportement';

  @override
  String get welcomeBehaviorStepTitle =>
      'ÉTAPE 3 : COMPORTEMENT DE L\'APPLICATION';

  @override
  String get welcomeBehaviorTitle => 'Comportement de l\'application';

  @override
  String get welcomeBehaviorDescription =>
      'Configurez le comportement de TKit au démarrage et lors de la réduction.';

  @override
  String get welcomeBehaviorOptionalInfo =>
      'Ces paramètres peuvent être modifiés à tout moment dans Paramètres.';

  @override
  String get settingsWindowControlsPositionLabel =>
      'Position des contrôles de fenêtre';

  @override
  String get settingsWindowControlsPositionDescription =>
      'Choisissez où apparaissent les contrôles de fenêtre (réduire, agrandir, fermer)';

  @override
  String get windowControlsPositionLeft => 'Gauche';

  @override
  String get windowControlsPositionCenter => 'Centre';

  @override
  String get windowControlsPositionRight => 'Droite';

  @override
  String get settingsAutoStartWindowsSubtitle =>
      'Lancer TKit automatiquement au démarrage de Windows';

  @override
  String get categoryMappingAddDialogProcessNameLabel => 'NOM DU PROCESSUS';

  @override
  String get welcomeLanguageStepTitle => 'ÉTAPE 1 : SÉLECTIONNEZ VOTRE LANGUE';

  @override
  String get settingsStartMinimizedLabel => 'Démarrer réduit';

  @override
  String get categoryMappingAddDialogProcessNameHint =>
      'p. ex., League of Legends.exe';

  @override
  String get welcomeLanguageChangeLater =>
      'Vous pouvez modifier cela plus tard dans les paramètres.';

  @override
  String get settingsStartMinimizedSubtitle =>
      'Lancer TKit réduit dans la barre système';

  @override
  String get categoryMappingAddDialogProcessNameRequired =>
      'Le nom du processus est obligatoire';

  @override
  String get welcomeTwitchStepTitle => 'ÉTAPE 2 : SE CONNECTER À TWITCH';

  @override
  String get settingsMinimizeToTrayLabel => 'Réduire dans la barre système';

  @override
  String get categoryMappingAddDialogExecutablePathLabel =>
      'CHEMIN DE L\'EXÉCUTABLE (FACULTATIF)';

  @override
  String get welcomeTwitchConnectionTitle => 'Connexion Twitch';

  @override
  String get settingsMinimizeToTraySubtitle =>
      'Garder TKit en cours d\'exécution en arrière-plan lors de la fermeture ou de la réduction';

  @override
  String get categoryMappingAddDialogExecutablePathHint =>
      'p. ex., C:\\Games\\LeagueOfLegends\\Game\\League of Legends.exe';

  @override
  String welcomeTwitchConnectedAs(String username) {
    return 'Connecté en tant que $username';
  }

  @override
  String get settingsShowNotificationsLabel => 'Afficher les notifications';

  @override
  String get categoryMappingAddDialogCategoryIdLabel =>
      'ID DE CATÉGORIE TWITCH';

  @override
  String get welcomeTwitchDescription =>
      'Connectez votre compte Twitch pour activer le changement automatique de catégorie en fonction de l\'application active.';

  @override
  String get settingsShowNotificationsSubtitle =>
      'Afficher les notifications lorsque la catégorie est mise à jour';

  @override
  String get settingsNotifyMissingCategoryLabel =>
      'Notifier en cas de catégorie manquante';

  @override
  String get settingsNotifyMissingCategorySubtitle =>
      'Afficher une notification lorsqu\'aucun mappage n\'est trouvé pour un jeu ou une application';

  @override
  String get categoryMappingAddDialogCategoryIdHint => 'p. ex., 21779';

  @override
  String get welcomeTwitchOptionalInfo =>
      'Cette étape est facultative. Vous pouvez ignorer et configurer cela plus tard dans les paramètres.';

  @override
  String get settingsKeyboardShortcuts => 'Raccourcis clavier';

  @override
  String get categoryMappingAddDialogCategoryIdRequired =>
      'L\'ID de catégorie est obligatoire';

  @override
  String get welcomeTwitchAuthorizeButton => 'AUTORISER AVEC TWITCH';

  @override
  String get settingsManualUpdateHotkeyLabel =>
      'Raccourci de mise à jour manuelle';

  @override
  String get categoryMappingAddDialogCategoryNameLabel =>
      'NOM DE CATÉGORIE TWITCH';

  @override
  String get welcomeButtonNext => 'SUIVANT';

  @override
  String get settingsManualUpdateHotkeyDescription =>
      'Déclencher une mise à jour manuelle de catégorie';

  @override
  String get categoryMappingAddDialogCategoryNameHint =>
      'p. ex., League of Legends';

  @override
  String get welcomeButtonBack => 'RETOUR';

  @override
  String get settingsUnsavedChanges =>
      'Vous avez des modifications non enregistrées';

  @override
  String get categoryMappingAddDialogCategoryNameRequired =>
      'Le nom de catégorie est obligatoire';

  @override
  String get settingsDiscard => 'Abandonner';

  @override
  String get categoryMappingAddDialogTip =>
      'Conseil : Utilisez la recherche de catégories Twitch pour trouver l\'ID et le nom corrects';

  @override
  String get settingsSave => 'Enregistrer';

  @override
  String get categoryMappingAddDialogCancelButton => 'ANNULER';

  @override
  String get settingsTwitchConnection => 'Connexion Twitch';

  @override
  String get categoryMappingAddDialogUpdateButton => 'METTRE À JOUR';

  @override
  String get settingsTwitchStatusConnected => 'Connecté';

  @override
  String get categoryMappingAddDialogAddButton => 'AJOUTER';

  @override
  String get settingsTwitchStatusNotConnected => 'Non connecté';

  @override
  String get categoryMappingListEmpty =>
      'Aucun mappage de catégories pour le moment';

  @override
  String get categoryMappingListEmptyTitle =>
      'Aucun mappage de catégories pour le moment';

  @override
  String get settingsTwitchLoggedInAs => 'Connecté en tant que :';

  @override
  String get categoryMappingListEmptySubtitle =>
      'Ajoutez votre premier mappage pour commencer';

  @override
  String get settingsTwitchDisconnect => 'Déconnecter';

  @override
  String get categoryMappingListColumnProcessName => 'NOM DU PROCESSUS';

  @override
  String get settingsTwitchConnectDescription =>
      'Connectez votre compte Twitch pour activer le changement automatique de catégorie.';

  @override
  String get categoryMappingListColumnCategory => 'CATÉGORIE';

  @override
  String get settingsTwitchConnect => 'Se connecter à Twitch';

  @override
  String get categoryMappingListColumnLastUsed => 'DERNIÈRE UTILISATION';

  @override
  String get hotkeyInputCancel => 'Annuler';

  @override
  String get categoryMappingListColumnType => 'TYPE';

  @override
  String get hotkeyInputChange => 'Modifier';

  @override
  String get categoryMappingListColumnActions => 'ACTIONS';

  @override
  String get hotkeyInputClearHotkey => 'Effacer le raccourci';

  @override
  String get categoryMappingListIdPrefix => 'ID : ';

  @override
  String categoryMappingListCategoryId(String categoryId) {
    return 'ID : $categoryId';
  }

  @override
  String get categoryMappingListNever => 'Jamais';

  @override
  String get categoryMappingListJustNow => 'À l\'instant';

  @override
  String categoryMappingListMinutesAgo(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'minutes',
      one: 'minute',
    );
    return 'il y a $minutes $_temp0';
  }

  @override
  String categoryMappingListHoursAgo(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: 'heures',
      one: 'heure',
    );
    return 'il y a $hours $_temp0';
  }

  @override
  String categoryMappingListDaysAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'jours',
      one: 'jour',
    );
    return 'il y a $days $_temp0';
  }

  @override
  String get hotkeyInputSetHotkey => 'Définir le raccourci';

  @override
  String get categoryMappingListNeverUsed => 'Jamais';

  @override
  String get categoryMappingListTypeUser => 'UTILISATEUR';

  @override
  String get categoryMappingListTypePreset => 'PRÉRÉGLAGE';

  @override
  String get categoryMappingListEditTooltip => 'Modifier le mappage';

  @override
  String get categoryMappingListDeleteTooltip => 'Supprimer le mappage';

  @override
  String get categoryMappingListTimeJustNow => 'À l\'instant';

  @override
  String get categoryMappingProviderSuccessAdded =>
      'Mappage ajouté avec succès';

  @override
  String get categoryMappingProviderSuccessUpdated =>
      'Mappage mis à jour avec succès';

  @override
  String get categoryMappingProviderSuccessDeleted =>
      'Mappage supprimé avec succès';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonOk => 'OK';

  @override
  String get commonConfirm => 'Confirmer';

  @override
  String get autoSwitcherProviderErrorPrefix => 'Échec de';

  @override
  String get autoSwitcherProviderStartMonitoring => 'démarrer la surveillance';

  @override
  String get autoSwitcherProviderStopMonitoring => 'arrêter la surveillance';

  @override
  String get autoSwitcherProviderManualUpdate =>
      'effectuer la mise à jour manuelle';

  @override
  String get autoSwitcherProviderLoadHistory => 'charger l\'historique';

  @override
  String get autoSwitcherProviderClearHistory => 'effacer l\'historique';

  @override
  String get autoSwitcherProviderSuccessCategoryUpdated =>
      'Catégorie mise à jour avec succès';

  @override
  String get autoSwitcherProviderSuccessHistoryCleared =>
      'Historique effacé avec succès';

  @override
  String get autoSwitcherProviderErrorUnknown => 'Erreur inconnue';

  @override
  String get settingsFactoryReset => 'Réinitialisation d\'usine';

  @override
  String get settingsFactoryResetDescription =>
      'Réinitialiser tous les paramètres et données aux valeurs par défaut d\'usine';

  @override
  String get settingsFactoryResetButton =>
      'Réinitialiser aux paramètres d\'usine';

  @override
  String get settingsFactoryResetDialogTitle => 'Réinitialisation d\'usine';

  @override
  String get settingsFactoryResetDialogMessage =>
      'Tous les paramètres, la base de données locale et toutes les catégories créées localement seront perdus. Êtes-vous sûr de vouloir continuer ?';

  @override
  String get settingsFactoryResetDialogConfirm => 'RÉINITIALISER';

  @override
  String get settingsFactoryResetSuccess =>
      'L\'application a été réinitialisée aux paramètres d\'usine avec succès. Veuillez redémarrer l\'application.';

  @override
  String get settingsUpdates => 'Mises à jour';

  @override
  String get settingsUpdateChannelLabel => 'Canal de mise à jour';

  @override
  String get settingsUpdateChannelDescription =>
      'Choisissez les types de mises à jour que vous souhaitez recevoir';

  @override
  String settingsUpdateChannelChanged(String channel) {
    return 'Canal de mise à jour changé en $channel. Vérification des mises à jour...';
  }

  @override
  String get updateChannelStable => 'Stable';

  @override
  String get updateChannelStableDesc =>
      'Recommandé pour la plupart des utilisateurs. Uniquement des versions stables.';

  @override
  String get updateChannelRc => 'Release Candidate';

  @override
  String get updateChannelRcDesc =>
      'Fonctionnalités stables avec tests finaux avant la version stable.';

  @override
  String get updateChannelBeta => 'Beta';

  @override
  String get updateChannelBetaDesc =>
      'Nouvelles fonctionnalités principalement stables. Peut contenir des bugs.';

  @override
  String get updateChannelDev => 'Développement';

  @override
  String get updateChannelDevDesc =>
      'Fonctionnalités de pointe. Attendez-vous à des bugs et de l\'instabilité.';

  @override
  String get fallbackBehaviorDoNothing => 'Ne rien faire';

  @override
  String get fallbackBehaviorJustChatting => 'Just Chatting';

  @override
  String get fallbackBehaviorCustom => 'Catégorie personnalisée';

  @override
  String get unknownGameDialogTitle => 'Game Not Mapped';

  @override
  String get unknownGameDialogStepCategory => 'Catégorie';

  @override
  String get unknownGameDialogStepDestination => 'Destination';

  @override
  String get unknownGameDialogStepConfirm => 'Confirmer';

  @override
  String get unknownGameDialogConfirmHeader => 'Vérifier et confirmer';

  @override
  String get unknownGameDialogConfirmDescription =>
      'Veuillez vérifier vos sélections avant d\'enregistrer';

  @override
  String get unknownGameDialogConfirmCategory => 'CATÉGORIE TWITCH';

  @override
  String get unknownGameDialogConfirmDestination => 'LISTE DE DESTINATION';

  @override
  String get unknownGameDialogBack => 'Retour';

  @override
  String get unknownGameDialogNext => 'Suivant';

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
  String get unknownGameDialogCategoryHeader =>
      'Sélectionner la catégorie Twitch';

  @override
  String get unknownGameDialogCategoryDescription =>
      'Rechercher et sélectionner la catégorie Twitch pour ce jeu';

  @override
  String get unknownGameDialogListHeader => 'Choisir la destination';

  @override
  String get unknownGameDialogListDescription =>
      'Sélectionner où enregistrer ce mappage';

  @override
  String get unknownGameDialogNoWritableLists =>
      'Aucune liste modifiable disponible';

  @override
  String get unknownGameDialogNoWritableListsHint =>
      'Créer une liste locale dans Mappages de catégories pour enregistrer des mappages personnalisés';

  @override
  String get unknownGameDialogLocalListsHeader => 'MAPPAGES LOCAUX';

  @override
  String get unknownGameDialogSubmissionListsHeader =>
      'SOUMISSION COMMUNAUTAIRE';

  @override
  String get unknownGameDialogWorkflowHeader =>
      'Comment fonctionne la soumission';

  @override
  String get unknownGameDialogWorkflowCompactNote =>
      'Enregistré localement d\'abord, puis soumis pour approbation communautaire';

  @override
  String get unknownGameDialogWorkflowLearnMore => 'En savoir plus';

  @override
  String get unknownGameDialogWorkflowStep1Title =>
      'Enregistré localement (immédiat)';

  @override
  String get unknownGameDialogWorkflowStep1Description =>
      'Le mappage est ajouté à votre liste locale et fonctionne immédiatement';

  @override
  String get unknownGameDialogWorkflowStep2Title => 'Soumis pour examen';

  @override
  String get unknownGameDialogWorkflowStep2Description =>
      'Votre mappage est soumis à la communauté pour approbation';

  @override
  String get unknownGameDialogWorkflowStep3Title => 'Fusionné dans l\'officiel';

  @override
  String get unknownGameDialogWorkflowStep3Description =>
      'Une fois approuvé, il apparaît dans les mappages officiels et est retiré de votre liste locale';

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
  String get unknownGameDialogThankYouTitle => 'Merci !';

  @override
  String get unknownGameDialogThankYouMessage =>
      'Votre contribution aide la communauté à grandir !';

  @override
  String get versionStatusUpToDate => 'À jour';

  @override
  String get versionStatusUpdateAvailable => 'Mise à jour disponible';

  @override
  String versionStatusCheckFailed(String error) {
    return 'Échec de la vérification de mise à jour : $error';
  }

  @override
  String get versionStatusNotInitialized =>
      'Service de mise à jour non initialisé';

  @override
  String get versionStatusPlatformNotSupported =>
      'Mises à jour non prises en charge sur cette plateforme';

  @override
  String get notificationMissingCategoryTitle =>
      'Mappage de catégorie introuvable';

  @override
  String notificationMissingCategoryBody(String processName) {
    return 'Aucune catégorie Twitch trouvée pour : $processName';
  }

  @override
  String get notificationActionAssignCategory => 'Attribuer une catégorie';

  @override
  String get notificationCategoryUpdatedTitle => 'Catégorie mise à jour';

  @override
  String notificationCategoryUpdatedBody(
    String categoryName,
    String processName,
  ) {
    return 'Changement vers \"$categoryName\" pour $processName';
  }

  @override
  String get mappingListColumnSource => 'Source';

  @override
  String get mappingListColumnEnabled => 'Activé';

  @override
  String get mappingListTooltipIgnored => 'Cette catégorie est ignorée';

  @override
  String mappingListTooltipTwitchId(String twitchCategoryId) {
    return 'ID Twitch : $twitchCategoryId';
  }

  @override
  String get mappingListCategoryIgnored => 'Ignoré';

  @override
  String get mappingListSourceUnknown => 'Inconnu';

  @override
  String mappingListSelected(int count) {
    return '$count sélectionné';
  }

  @override
  String mappingListSelectedVisible(int count, int visible) {
    return '$count sélectionné ($visible visible)';
  }

  @override
  String get mappingListButtonInvert => 'Inverser';

  @override
  String get mappingListButtonClear => 'Effacer';

  @override
  String mappingListButtonUndo(String action) {
    return 'Annuler $action';
  }

  @override
  String get mappingListButtonExport => 'Exporter';

  @override
  String get mappingListButtonEnable => 'Activer';

  @override
  String get mappingListButtonDisable => 'Désactiver';

  @override
  String get mappingListButtonDelete => 'Supprimer';

  @override
  String get mappingListTooltipCannotDelete =>
      'Impossible de supprimer les mappages des listes en lecture seule';

  @override
  String get mappingListTooltipDelete => 'Supprimer les mappages sélectionnés';

  @override
  String get mappingListSearchHint =>
      'Rechercher par nom de processus ou catégorie...';

  @override
  String get mappingListTooltipClearSearch => 'Effacer la recherche';

  @override
  String get listManagementEmptyState => 'Aucune liste trouvée';

  @override
  String get listManagementTitle => 'Gérer les listes';

  @override
  String get listManagementSyncNow => 'Synchroniser maintenant';

  @override
  String get listManagementBadgeLocal => 'LOCAL';

  @override
  String get listManagementBadgeOfficial => 'OFFICIEL';

  @override
  String get listManagementBadgeRemote => 'DISTANT';

  @override
  String get listManagementBadgeReadOnly => 'LECTURE SEULE';

  @override
  String get listManagementButtonImport => 'Importer une liste';

  @override
  String get listManagementButtonSyncAll => 'Tout synchroniser';

  @override
  String get listManagementButtonClose => 'Fermer';

  @override
  String get listManagementImportTitle => 'Importer une liste';

  @override
  String get listManagementImportUrl => 'URL de la liste';

  @override
  String get listManagementImportUrlPlaceholder =>
      'https://exemple.com/mappings.json';

  @override
  String get listManagementImportName => 'Nom de la liste (facultatif)';

  @override
  String get listManagementImportNameHelper =>
      'S\'il n\'est pas fourni, le nom du fichier JSON sera utilisé';

  @override
  String get listManagementImportNamePlaceholder => 'Ma liste personnalisée';

  @override
  String get listManagementImportDescription => 'Description (facultatif)';

  @override
  String get listManagementImportDescriptionHelper =>
      'Si elle n\'est pas fournie, la description du fichier JSON sera utilisée';

  @override
  String get listManagementImportDescriptionPlaceholder =>
      'Une collection de mappages de jeux';

  @override
  String get listManagementButtonCancel => 'Annuler';

  @override
  String get listManagementButtonImportConfirm => 'Importer';

  @override
  String get listManagementDefaultName => 'Liste importée';

  @override
  String get listManagementImportSuccess => 'Liste importée avec succès';

  @override
  String get listManagementSyncNever => 'jamais';

  @override
  String get listManagementSyncJustNow => 'à l\'instant';

  @override
  String listManagementSyncMinutesAgo(int minutes) {
    return 'il y a ${minutes}m';
  }

  @override
  String listManagementSyncHoursAgo(int hours) {
    return 'il y a ${hours}h';
  }

  @override
  String listManagementSyncDaysAgo(int days) {
    return 'il y a ${days}j';
  }

  @override
  String listManagementSyncDaysHoursAgo(int days, int hours) {
    return 'il y a ${days}j ${hours}h';
  }

  @override
  String listManagementMappingsCount(int count) {
    return '$count mappages';
  }

  @override
  String get listManagementSyncFailed => 'Échec de la synchronisation :';

  @override
  String get listManagementLastSynced => 'Dernière synchronisation :';

  @override
  String get unknownGameIgnoreProcess => 'Ignorer le processus';

  @override
  String unknownGameCategoryId(String id) {
    return 'ID : $id';
  }

  @override
  String get unknownGameSubmissionTitle => 'Soumission requise';

  @override
  String get unknownGameSubmissionInfo =>
      'Ce mappage sera enregistré localement et soumis au propriétaire de la liste pour approbation. Une fois approuvé et synchronisé, votre copie locale sera automatiquement remplacée.';

  @override
  String get unknownGameSectionLists => 'LISTES';

  @override
  String unknownGameListMappingCount(int count) {
    return '$count mappages';
  }

  @override
  String get unknownGameBadgeStaged => 'EN ATTENTE';

  @override
  String get unknownGameIgnoredProcess => 'PROCESSUS IGNORÉ';

  @override
  String unknownGameSelectedCategoryId(String id) {
    return 'ID : $id';
  }

  @override
  String get unknownGameWorkflowTitle => 'Processus de soumission';

  @override
  String get unknownGameWorkflowTitleAlt => 'Que se passe-t-il ensuite';

  @override
  String get unknownGameWorkflowStepLocal =>
      'Enregistré localement dans Mes mappages personnalisés';

  @override
  String get unknownGameWorkflowStepLocalDesc =>
      'Stocké d\'abord sur votre appareil, le mappage fonctionne donc immédiatement';

  @override
  String unknownGameWorkflowStepSubmit(String listName) {
    return 'Soumis à $listName';
  }

  @override
  String get unknownGameWorkflowStepSubmitDesc =>
      'Automatiquement envoyé au propriétaire de la liste pour examen et approbation';

  @override
  String get unknownGameWorkflowStepReplace =>
      'Copie locale remplacée après approbation';

  @override
  String unknownGameWorkflowStepReplaceDesc(String listName) {
    return 'Une fois accepté et synchronisé, votre copie locale est supprimée et remplacée par la version officielle de $listName';
  }

  @override
  String unknownGameSavedTo(String listName) {
    return 'Enregistré dans $listName';
  }

  @override
  String get unknownGameIgnoredInfo =>
      'Ce processus sera ignoré et ne déclenchera pas de notifications';

  @override
  String get unknownGameLocalSaveInfo =>
      'Votre mappage est enregistré localement et fonctionnera immédiatement';

  @override
  String get unknownGamePrivacyInfo =>
      'Ce mappage est privé et uniquement stocké sur votre appareil';

  @override
  String autoSwitcherError(String error) {
    return 'Erreur : $error';
  }

  @override
  String get autoSwitcherStatusActive => 'Commutation automatique active';

  @override
  String get autoSwitcherStatusInactive => 'Ne surveille pas';

  @override
  String get autoSwitcherLabelActiveApp => 'Application active';

  @override
  String get autoSwitcherLabelCategory => 'Catégorie';

  @override
  String get autoSwitcherValueNone => 'Aucun';

  @override
  String get autoSwitcherDescriptionActive =>
      'Votre catégorie change automatiquement lorsque vous changez d\'application.';

  @override
  String get autoSwitcherButtonTurnOff => 'Désactiver';

  @override
  String get autoSwitcherInstructionPress => 'Appuyez sur';

  @override
  String get autoSwitcherInstructionManual =>
      'pour mettre à jour manuellement vers le processus actif';

  @override
  String get autoSwitcherHeadingEnable => 'Activer la commutation automatique';

  @override
  String get autoSwitcherDescriptionInactive =>
      'Les catégories changeront automatiquement lorsque vous basculez entre les applications.';

  @override
  String get autoSwitcherButtonTurnOn => 'Activer';

  @override
  String get autoSwitcherInstructionOr => 'Ou appuyez sur';

  @override
  String get settingsTabMappings => 'Mappages';

  @override
  String get settingsTabTheme => 'Thème';

  @override
  String get settingsAutoSyncOnStart =>
      'Synchroniser automatiquement les mappages au démarrage';

  @override
  String get settingsAutoSyncOnStartDesc =>
      'Synchroniser automatiquement les listes de mappages au démarrage de l\'application';

  @override
  String get settingsAutoSyncInterval =>
      'Intervalle de synchronisation automatique';

  @override
  String get settingsAutoSyncIntervalDesc =>
      'Fréquence de synchronisation automatique des listes de mappages (0 = jamais)';

  @override
  String get settingsAutoSyncNever => 'Jamais';

  @override
  String get settingsTimingTitle =>
      'COMMENT CES PARAMÈTRES FONCTIONNENT ENSEMBLE';

  @override
  String settingsTimingStep1(int scanInterval) {
    return 'L\'application vérifie la fenêtre active toutes les ${scanInterval}s';
  }

  @override
  String get settingsTimingStep2Instant =>
      'La catégorie change immédiatement lors de la détection d\'une nouvelle application';

  @override
  String settingsTimingStep2Debounce(int debounce) {
    return 'Attend ${debounce}s après la détection d\'une nouvelle application (anti-rebond)';
  }

  @override
  String settingsTimingStep3Instant(int scanInterval) {
    return 'Temps de changement total : ${scanInterval}s (instantané après détection)';
  }

  @override
  String settingsTimingStep3Debounce(int scanInterval, int scanDebounce) {
    return 'Temps de changement total : ${scanInterval}s à ${scanDebounce}s';
  }

  @override
  String get settingsFramelessWindow => 'Utiliser une fenêtre sans bordure';

  @override
  String get settingsFramelessWindowDesc =>
      'Supprimer la barre de titre Windows pour un look moderne et sans bordure avec des coins arrondis';

  @override
  String get settingsInvertLayout => 'Inverser pied de page/en-tête';

  @override
  String get settingsInvertLayoutDesc =>
      'Échanger les positions des sections d\'en-tête et de pied de page';

  @override
  String get settingsTokenExpired => 'Expiré';

  @override
  String settingsTokenExpiresDays(int days, int hours) {
    return 'Expire dans ${days}j ${hours}h';
  }

  @override
  String settingsTokenExpiresHours(int hours, int minutes) {
    return 'Expire dans ${hours}h ${minutes}m';
  }

  @override
  String settingsTokenExpiresMinutes(int minutes) {
    return 'Expire dans ${minutes}m';
  }

  @override
  String get settingsResetDesc =>
      'Réinitialiser tous les paramètres et données aux valeurs par défaut';

  @override
  String get settingsButtonReset => 'Réinitialiser';

  @override
  String mappingEditorSummary(
    int count,
    String plural,
    int lists,
    String pluralLists,
  ) {
    return '$count mappage$plural de processus depuis $lists liste$pluralLists active$pluralLists';
  }

  @override
  String mappingEditorBreakdown(int custom, int community) {
    return '$custom personnalisé, $community depuis les listes communautaires';
  }

  @override
  String get mappingEditorButtonLists => 'Listes';

  @override
  String get mappingEditorButtonAdd => 'Ajouter';

  @override
  String get mappingEditorDeleteTitle => 'Supprimer plusieurs mappages';

  @override
  String mappingEditorDeleteMessage(int count, String plural) {
    return 'Êtes-vous sûr de vouloir supprimer $count mappage$plural ? Cette action ne peut pas être annulée.';
  }

  @override
  String get mappingEditorExportTitle => 'Exporter les mappages';

  @override
  String get mappingEditorExportFilename => 'mes-mappages.json';

  @override
  String mappingEditorExportSuccess(int count, String plural) {
    return '$count mappage$plural exporté$plural vers';
  }

  @override
  String get mappingEditorExportFailed => 'Échec de l\'exportation';

  @override
  String get addMappingPrivacySafe => 'Chemin respectueux de la vie privée';

  @override
  String get addMappingCustomLocation => 'Emplacement personnalisé';

  @override
  String get addMappingOnlyFolder =>
      'Seuls les noms de dossiers de jeux stockés';

  @override
  String get addMappingNotStored => 'Chemin non stocké pour la confidentialité';

  @override
  String get colorPickerTitle => 'Choisir une couleur';

  @override
  String get colorPickerHue => 'Teinte';

  @override
  String get colorPickerSaturation => 'Saturation';

  @override
  String get colorPickerValue => 'Valeur';

  @override
  String get colorPickerButtonCancel => 'Annuler';

  @override
  String get colorPickerButtonSelect => 'Sélectionner';

  @override
  String get dropdownPlaceholder => 'Sélectionner une option';

  @override
  String get dropdownSearchHint => 'Rechercher...';

  @override
  String get dropdownNoResults => 'Aucun résultat trouvé';

  @override
  String paginationPageInfo(int current, int total) {
    return 'Page $current sur $total';
  }

  @override
  String get paginationGoTo => 'Aller à :';

  @override
  String get datePickerPlaceholder => 'Sélectionner une date';

  @override
  String get timePickerAM => 'AM';

  @override
  String get timePickerPM => 'PM';

  @override
  String get timePickerPlaceholder => 'Sélectionner une heure';

  @override
  String get fileUploadInstruction => 'Cliquer pour télécharger un fichier';

  @override
  String fileUploadAllowed(String extensions) {
    return 'Autorisé : $extensions';
  }

  @override
  String get menuButtonTooltip => 'Plus d\'options';

  @override
  String get breadcrumbEllipsis => '...';

  @override
  String get breadcrumbTooltipShowPath => 'Afficher le chemin';

  @override
  String get hotkeyModCtrl => 'Ctrl';

  @override
  String get hotkeyModAlt => 'Alt';

  @override
  String get hotkeyModShift => 'Maj';

  @override
  String get hotkeyModWin => 'Win';

  @override
  String get hotkeySpace => 'Espace';

  @override
  String get hotkeyEnter => 'Entrée';

  @override
  String get hotkeyTab => 'Tab';

  @override
  String get hotkeyBackspace => 'Retour';

  @override
  String get hotkeyDelete => 'Suppr';

  @override
  String get hotkeyEscape => 'Échap';

  @override
  String get hotkeyHome => 'Début';

  @override
  String get hotkeyEnd => 'Fin';

  @override
  String get hotkeyPageUp => 'Page préc.';

  @override
  String get hotkeyPageDown => 'Page suiv.';

  @override
  String get statusDashboardCurrentActivity => 'Activité actuelle';

  @override
  String get statusDashboardNotStarted => 'Non démarré';

  @override
  String get statusDashboardReady => 'Prêt';

  @override
  String get statusDashboardCheckingApp =>
      'Vérification de l\'application active';

  @override
  String get statusDashboardFindingCategory => 'Recherche de catégorie';

  @override
  String get statusDashboardUpdating => 'Mise à jour de la catégorie';

  @override
  String get statusDashboardWaiting => 'En attente de confirmation';

  @override
  String get statusDashboardError => 'Erreur survenue';

  @override
  String mappingListOfCount(int count, int total) {
    return '$count sur $total';
  }

  @override
  String get mappingListActionDelete => 'Supprimer';

  @override
  String get mappingListActionEnable => 'Activer';

  @override
  String get mappingListActionDisable => 'Désactiver';

  @override
  String autoSwitcherTimeSecondsAgo(int seconds) {
    return 'il y a ${seconds}s';
  }

  @override
  String autoSwitcherTimeMinutesAgo(int minutes) {
    return 'il y a ${minutes}m';
  }

  @override
  String autoSwitcherTimeHoursAgo(int hours) {
    return 'il y a ${hours}h';
  }

  @override
  String get settingsSentry => 'Suivi des erreurs et des performances';

  @override
  String get settingsSentryDescription =>
      'Aidez à améliorer TKit en envoyant des rapports de plantage et des données de performance anonymes';

  @override
  String get settingsEnableErrorTrackingLabel => 'Activer le suivi des erreurs';

  @override
  String get settingsEnableErrorTrackingSubtitle =>
      'Envoyer des rapports de plantage pour nous aider à corriger les bugs plus rapidement (nécessite un redémarrage de l\'application)';

  @override
  String get settingsEnablePerformanceMonitoringLabel =>
      'Activer la surveillance des performances';

  @override
  String get settingsEnablePerformanceMonitoringSubtitle =>
      'Suivre les performances de l\'application pour identifier les ralentissements (nécessite un redémarrage de l\'application)';

  @override
  String get settingsEnableSessionReplayLabel =>
      'Activer la relecture de session';

  @override
  String get settingsEnableSessionReplaySubtitle =>
      'Enregistrer les interactions avec l\'application pour aider à diagnostiquer les problèmes complexes (nécessite un redémarrage de l\'application)';

  @override
  String get settingsSentryRestartRequired =>
      'Les modifications nécessitent un redémarrage de l\'application pour prendre effet';

  @override
  String get welcomeSentryTitle => 'Confidentialité et diagnostics';

  @override
  String get welcomeSentryDescription =>
      'Aidez-nous à améliorer TKit en envoyant des rapports de plantage et des données de performance anonymes. Vous pouvez modifier cela à tout moment dans les paramètres.';

  @override
  String get welcomeSentryEnableErrorTracking =>
      'Envoyer les rapports d\'erreurs';

  @override
  String get welcomeSentryEnablePerformanceMonitoring =>
      'Envoyer les données de performance';

  @override
  String get welcomeSentryEnableSessionReplay =>
      'Activer la relecture de session (facultatif)';

  @override
  String get tutorialSkipButton => 'Passer le tutoriel';

  @override
  String get tutorialRestartButton => 'Afficher le tutoriel';

  @override
  String get tutorialAutoSwitcherTabTitle => 'Changement automatique';

  @override
  String get tutorialAutoSwitcherTabDescription =>
      'Ceci est votre centre de contrôle principal. Cliquez ici pour surveiller et contrôler le changement automatique de catégorie en fonction de votre application active.';

  @override
  String get tutorialMappingsTabTitle => 'Associations';

  @override
  String get tutorialMappingsTabDescription =>
      'Gérez vos associations jeu-catégorie ici. Ajoutez des associations personnalisées ou utilisez des préconfigurations communautaires pour changer automatiquement votre catégorie Twitch.';

  @override
  String get tutorialSettingsTabTitle => 'Paramètres';

  @override
  String get tutorialSettingsTabDescription =>
      'Personnalisez le comportement et l\'apparence de TKit, et configurez votre connexion Twitch.';

  @override
  String get tutorialAutoSwitcherControlTitle =>
      'Changement automatique vs manuel';

  @override
  String get tutorialAutoSwitcherControlDescription =>
      'Cliquez sur le bouton ACTIVER pour activer le changement automatique lorsque vous lancez des jeux. Vous voulez qu\'il démarre automatiquement ? Allez dans Paramètres et activez \'Démarrer la surveillance au lancement de l\'application\'.\n\nMode automatique : Changement mains libres pour tous les jeux associés.\nMode manuel : Utilisez votre raccourci clavier pour un contrôle total lorsque vous souhaitez mettre à jour.';

  @override
  String get tutorialAutoSwitcherPageTitle =>
      'Comment fonctionne le changement automatique';

  @override
  String get tutorialAutoSwitcherPageDescription =>
      'TKit surveille votre fenêtre active. Lorsque vous passez à un jeu, il met automatiquement à jour votre catégorie Twitch en fonction de vos associations. Appuyez sur \'Activer\' pour commencer la surveillance.';

  @override
  String get tutorialMappingsPageTitle => 'Gestion des associations';

  @override
  String get tutorialMappingsPageDescription =>
      'Les associations connectent les applications aux catégories Twitch. Cliquez sur \'Ajouter une association\' pour en créer de personnalisées, ou gérez les listes communautaires pour importer des associations vérifiées d\'autres utilisateurs.';
}
