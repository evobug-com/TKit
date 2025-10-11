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
}
