// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'TKit';

  @override
  String get welcomeTitle => 'Bienvenido a TKit';

  @override
  String get selectLanguage => 'Selecciona tu idioma';

  @override
  String get languageLabel => 'Idioma';

  @override
  String get continueButton => 'CONTINUAR';

  @override
  String get confirm => 'Confirmar';

  @override
  String get hello => 'Hola';

  @override
  String get languageNativeName => 'Español';

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
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsLanguageDescription =>
      'Elige tu idioma preferido para la aplicación';

  @override
  String get languageChangeNotice =>
      'Idioma cambiado. La aplicación se actualizará inmediatamente.';

  @override
  String get authSuccessAuthenticatedAs => 'Autenticado correctamente como';

  @override
  String get systemTrayShowTkit => 'Mostrar TKit';

  @override
  String get authConnectToTwitch => 'Conectar con Twitch';

  @override
  String get systemTrayAutoSwitcher => 'Cambio automático';

  @override
  String get authLoading => 'Cargando...';

  @override
  String get systemTrayCategoryMappings => 'Mapeos de categorías';

  @override
  String get authRefreshingToken => 'Actualizando token...';

  @override
  String get systemTraySettings => 'Configuración';

  @override
  String get authSuccessfullyAuthenticated => 'Autenticado correctamente';

  @override
  String get systemTrayExit => 'Salir';

  @override
  String get authLoggedInAs => 'Conectado como';

  @override
  String get systemTrayTooltip => 'TKit - Kit de herramientas de Twitch';

  @override
  String get authErrorAuthenticationFailed => 'Error de autenticación';

  @override
  String get authErrorErrorCode => 'Código de error:';

  @override
  String get authTryAgain => 'Intentar de nuevo';

  @override
  String get authAuthorizationSteps => 'Pasos de autorización';

  @override
  String get authStep1 =>
      'Haz clic en el botón \"Conectar con Twitch\" a continuación';

  @override
  String get authStep2 =>
      'Tu navegador abrirá la página de autorización de Twitch';

  @override
  String get authStep3 => 'Revisa y autoriza a TKit para gestionar tu canal';

  @override
  String get authStep4 => 'Regresa a esta ventana después de la autorización';

  @override
  String get authConnectToTwitchButton => 'CONECTAR CON TWITCH';

  @override
  String get authRequiresAccessMessage =>
      'TKit requiere acceso para actualizar la categoría de tu canal de Twitch.';

  @override
  String get authDeviceCodeTitle => 'Conectar con Twitch';

  @override
  String get authDeviceCodeInstructions =>
      'Para conectar tu cuenta de Twitch, sigue estos sencillos pasos:';

  @override
  String get authDeviceCodeStep1 => 'Ve a';

  @override
  String get authDeviceCodeStep2 => 'Introduce este código:';

  @override
  String get authDeviceCodeStep3 =>
      'Autoriza a TKit para gestionar la categoría de tu canal';

  @override
  String get authDeviceCodeCodeLabel => 'Tu código';

  @override
  String get authDeviceCodeCopyCode => 'Copiar código';

  @override
  String get authDeviceCodeCopied => '¡Copiado!';

  @override
  String get authDeviceCodeOpenBrowser => 'Abrir twitch.tv/activate';

  @override
  String get authDeviceCodeWaiting => 'Esperando autorización...';

  @override
  String authDeviceCodeExpiresIn(String minutes, String seconds) {
    return 'El código expira en $minutes:$seconds';
  }

  @override
  String get authDeviceCodeExpired =>
      'Código expirado. Por favor, inténtalo de nuevo.';

  @override
  String get authDeviceCodeCancel => 'Cancelar';

  @override
  String get authDeviceCodeSuccess => '¡Conectado correctamente!';

  @override
  String get authDeviceCodeError =>
      'Conexión fallida. Por favor, inténtalo de nuevo.';

  @override
  String get authDeviceCodeHelp =>
      '¿Tienes problemas? Asegúrate de haber iniciado sesión en Twitch en tu navegador.';

  @override
  String get autoSwitcherPageTitle => 'CAMBIO AUTOMÁTICO';

  @override
  String get authStatusAuthenticated => 'Autenticado';

  @override
  String get autoSwitcherPageDescription =>
      'Actualiza automáticamente la categoría de transmisión según la aplicación enfocada';

  @override
  String get authStatusConnecting => 'Conectando...';

  @override
  String get autoSwitcherStatusHeader => 'ESTADO';

  @override
  String get authStatusError => 'Error';

  @override
  String get autoSwitcherStatusCurrentProcess => 'PROCESO ACTUAL';

  @override
  String get authStatusNotConnected => 'No conectado';

  @override
  String get autoSwitcherStatusNone => 'Ninguno';

  @override
  String get autoSwitcherStatusMatchedCategory => 'CATEGORÍA COINCIDENTE';

  @override
  String get mainWindowNavAutoSwitcher => 'Cambio automático';

  @override
  String get autoSwitcherStatusLastUpdate => 'ÚLTIMA ACTUALIZACIÓN';

  @override
  String get mainWindowNavMappings => 'Mapeos';

  @override
  String get autoSwitcherStatusNever => 'Nunca';

  @override
  String get mainWindowNavSettings => 'Configuración';

  @override
  String get mainWindowStatusConnected => 'Conectado';

  @override
  String get autoSwitcherStatusUpdateStatus => 'ESTADO DE ACTUALIZACIÓN';

  @override
  String get mainWindowStatusDisconnected => 'Desconectado';

  @override
  String get autoSwitcherStatusNoUpdatesYet => 'Aún no hay actualizaciones';

  @override
  String get mainWindowWindowControlMinimize => 'Minimizar';

  @override
  String get autoSwitcherStatusSuccess => 'ÉXITO';

  @override
  String get authLoadingStartingAuthentication => 'Iniciando autenticación...';

  @override
  String get mainWindowWindowControlMaximize => 'Maximizar';

  @override
  String get autoSwitcherStatusFailed => 'FALLIDO';

  @override
  String get authLoadingLoggingOut => 'Cerrando sesión...';

  @override
  String get settingsSavedSuccessfully =>
      'Configuración guardada correctamente';

  @override
  String get autoSwitcherStatusSystemState => 'ESTADO DEL SISTEMA';

  @override
  String get mainWindowWindowControlClose => 'Cerrar';

  @override
  String get authLoadingCheckingStatus =>
      'Comprobando estado de autenticación...';

  @override
  String get settingsRetry => 'Reintentar';

  @override
  String get settingsPageTitle => 'CONFIGURACIÓN';

  @override
  String get settingsPageDescription =>
      'Configurar comportamiento y preferencias de la aplicación';

  @override
  String get settingsTabGeneral => 'General';

  @override
  String get settingsTabAutoSwitcher => 'Cambio automático';

  @override
  String get settingsTabKeyboard => 'Teclado';

  @override
  String get settingsTabTwitch => 'Twitch';

  @override
  String get settingsTabAdvanced => 'Avanzado';

  @override
  String get autoSwitcherStatusNotInitialized => 'NO INICIALIZADO';

  @override
  String get mainWindowFooterReady => 'Listo';

  @override
  String get authErrorTokenRefreshFailed => 'Error al actualizar el token:';

  @override
  String get settingsAutoSwitcher => 'Cambio automático';

  @override
  String get autoSwitcherStatusIdle => 'INACTIVO';

  @override
  String get updateDialogTitle => 'Actualización disponible';

  @override
  String get settingsMonitoring => 'Monitorización';

  @override
  String get autoSwitcherStatusDetectingProcess => 'DETECTANDO PROCESO';

  @override
  String get categoryMappingTitle => 'MAPEOS DE CATEGORÍAS';

  @override
  String get updateDialogWhatsNew => 'Novedades:';

  @override
  String get settingsScanIntervalLabel => 'Intervalo de escaneo';

  @override
  String get autoSwitcherStatusSearchingMapping => 'BUSCANDO MAPEO';

  @override
  String get categoryMappingSubtitle =>
      'Administra los mapeos de proceso a categoría para el cambio automático';

  @override
  String get updateDialogDownloadComplete =>
      '¡Descarga completa! Listo para instalar.';

  @override
  String get settingsScanIntervalDescription =>
      'Con qué frecuencia verificar qué aplicación tiene el foco';

  @override
  String get autoSwitcherStatusUpdatingCategory => 'ACTUALIZANDO CATEGORÍA';

  @override
  String get categoryMappingAddMappingButton => 'AGREGAR MAPEO';

  @override
  String get updateDialogDownloadFailed => 'Error en la descarga:';

  @override
  String get settingsDebounceTimeLabel => 'Tiempo de rebote';

  @override
  String get autoSwitcherStatusWaitingDebounce => 'ESPERANDO (REBOTE)';

  @override
  String get categoryMappingErrorDialogTitle => 'Error';

  @override
  String get updateDialogRemindLater => 'Recordar más tarde';

  @override
  String get updateDialogIgnore => 'Ignore This Version';

  @override
  String get settingsDebounceTimeDescription =>
      'Tiempo de espera antes de cambiar la categoría después del cambio de aplicación (evita cambios rápidos)';

  @override
  String get autoSwitcherStatusError => 'ERROR';

  @override
  String get categoryMappingStatsTotalMappings => 'Total de mapeos';

  @override
  String get updateDialogDownloadUpdate => 'Descargar actualización';

  @override
  String get settingsAutoStartMonitoringLabel =>
      'Iniciar monitorización automáticamente';

  @override
  String get autoSwitcherControlsHeader => 'CONTROLES';

  @override
  String get categoryMappingStatsUserDefined => 'Definido por el usuario';

  @override
  String get updateDialogCancel => 'Cancelar';

  @override
  String get settingsAutoStartMonitoringSubtitle =>
      'Comenzar a monitorear la aplicación activa cuando TKit se inicie';

  @override
  String get autoSwitcherControlsStopMonitoring => 'DETENER MONITORIZACIÓN';

  @override
  String get categoryMappingStatsPresets => 'Preestablecidos';

  @override
  String get updateDialogLater => 'Más tarde';

  @override
  String get settingsFallbackBehavior => 'Comportamiento alternativo';

  @override
  String get autoSwitcherControlsStartMonitoring => 'INICIAR MONITORIZACIÓN';

  @override
  String get categoryMappingErrorLoading => 'Error al cargar mapeos';

  @override
  String get updateDialogInstallRestart => 'Instalar y reiniciar';

  @override
  String get settingsFallbackBehaviorLabel => 'Cuando no se encuentra mapeo';

  @override
  String get autoSwitcherControlsManualUpdate => 'ACTUALIZACIÓN MANUAL';

  @override
  String get categoryMappingRetryButton => 'REINTENTAR';

  @override
  String get updateDialogToday => 'hoy';

  @override
  String get settingsFallbackBehaviorDescription =>
      'Elige qué sucede cuando la aplicación enfocada no tiene mapeo de categoría';

  @override
  String get categoryMappingDeleteDialogTitle => 'Eliminar mapeo';

  @override
  String get autoSwitcherControlsMonitoringStatus => 'ESTADO DE MONITORIZACIÓN';

  @override
  String get updateDialogYesterday => 'ayer';

  @override
  String get settingsCustomCategory => 'Categoría personalizada';

  @override
  String get categoryMappingDeleteDialogMessage =>
      '¿Estás seguro de que deseas eliminar este mapeo?';

  @override
  String get autoSwitcherControlsActive => 'ACTIVO';

  @override
  String updateDialogDaysAgo(int days) {
    return 'hace $days días';
  }

  @override
  String get settingsCustomCategoryHint => 'Buscar una categoría...';

  @override
  String get categoryMappingDeleteDialogConfirm => 'ELIMINAR';

  @override
  String get autoSwitcherControlsInactive => 'INACTIVO';

  @override
  String updateDialogVersion(String version) {
    return 'Versión $version';
  }

  @override
  String get categoryMappingDeleteDialogCancel => 'CANCELAR';

  @override
  String get settingsCategorySearchUnavailable =>
      'La búsqueda de categorías estará disponible cuando se complete el módulo API de Twitch';

  @override
  String get autoSwitcherControlsActiveDescription =>
      'Actualizando automáticamente la categoría según el proceso enfocado';

  @override
  String updateDialogPublished(String date) {
    return 'Publicado $date';
  }

  @override
  String get categoryMappingAddDialogEditTitle => 'EDITAR MAPEO';

  @override
  String get settingsApplication => 'Aplicación';

  @override
  String get autoSwitcherControlsInactiveDescription =>
      'Inicia la monitorización para habilitar las actualizaciones automáticas de categoría';

  @override
  String get welcomeStepLanguage => 'Idioma';

  @override
  String get categoryMappingAddDialogAddTitle => 'AGREGAR NUEVO MAPEO';

  @override
  String get categoryMappingAddDialogClose => 'Cerrar';

  @override
  String get categoryMappingAddDialogProcessName => 'NOMBRE DEL PROCESO';

  @override
  String get categoryMappingAddDialogExecutablePath =>
      'RUTA DEL EJECUTABLE (OPCIONAL)';

  @override
  String get categoryMappingAddDialogCategoryId => 'ID DE CATEGORÍA DE TWITCH';

  @override
  String get categoryMappingAddDialogCategoryName =>
      'NOMBRE DE CATEGORÍA DE TWITCH';

  @override
  String get categoryMappingAddDialogCancel => 'CANCELAR';

  @override
  String get categoryMappingAddDialogUpdate => 'ACTUALIZAR';

  @override
  String get categoryMappingAddDialogAdd => 'AGREGAR';

  @override
  String get settingsAutoStartWindowsLabel => 'Inicio automático con Windows';

  @override
  String get categoryMappingAddDialogCloseTooltip => 'Cerrar';

  @override
  String get welcomeStepTwitch => 'Twitch';

  @override
  String get welcomeStepBehavior => 'Comportamiento';

  @override
  String get welcomeBehaviorStepTitle =>
      'PASO 3: COMPORTAMIENTO DE LA APLICACIÓN';

  @override
  String get welcomeBehaviorTitle => 'Comportamiento de la aplicación';

  @override
  String get welcomeBehaviorDescription =>
      'Configura cómo se comporta TKit al iniciar y al minimizar.';

  @override
  String get welcomeBehaviorOptionalInfo =>
      'Esta configuración se puede cambiar en cualquier momento en Configuración.';

  @override
  String get settingsWindowControlsPositionLabel =>
      'Posición de los controles de ventana';

  @override
  String get settingsWindowControlsPositionDescription =>
      'Elige dónde aparecen los controles de ventana (minimizar, maximizar, cerrar)';

  @override
  String get windowControlsPositionLeft => 'Izquierda';

  @override
  String get windowControlsPositionCenter => 'Centro';

  @override
  String get windowControlsPositionRight => 'Derecha';

  @override
  String get settingsAutoStartWindowsSubtitle =>
      'Iniciar TKit automáticamente cuando Windows se inicie';

  @override
  String get categoryMappingAddDialogProcessNameLabel => 'NOMBRE DEL PROCESO';

  @override
  String get welcomeLanguageStepTitle => 'PASO 1: SELECCIONA TU IDIOMA';

  @override
  String get settingsStartMinimizedLabel => 'Iniciar minimizado';

  @override
  String get categoryMappingAddDialogProcessNameHint =>
      'p. ej., League of Legends.exe';

  @override
  String get welcomeLanguageChangeLater =>
      'Puedes cambiar esto más tarde en Configuración.';

  @override
  String get settingsStartMinimizedSubtitle =>
      'Iniciar TKit minimizado en la bandeja del sistema';

  @override
  String get categoryMappingAddDialogProcessNameRequired =>
      'El nombre del proceso es obligatorio';

  @override
  String get welcomeTwitchStepTitle => 'PASO 2: CONECTAR CON TWITCH';

  @override
  String get settingsMinimizeToTrayLabel =>
      'Minimizar a la bandeja del sistema';

  @override
  String get categoryMappingAddDialogExecutablePathLabel =>
      'RUTA DEL EJECUTABLE (OPCIONAL)';

  @override
  String get welcomeTwitchConnectionTitle => 'Conexión con Twitch';

  @override
  String get settingsMinimizeToTraySubtitle =>
      'Mantener TKit ejecutándose en segundo plano al cerrar o minimizar';

  @override
  String get categoryMappingAddDialogExecutablePathHint =>
      'p. ej., C:\\Games\\LeagueOfLegends\\Game\\League of Legends.exe';

  @override
  String welcomeTwitchConnectedAs(String username) {
    return 'Conectado como $username';
  }

  @override
  String get settingsShowNotificationsLabel => 'Mostrar notificaciones';

  @override
  String get categoryMappingAddDialogCategoryIdLabel =>
      'ID DE CATEGORÍA DE TWITCH';

  @override
  String get welcomeTwitchDescription =>
      'Conecta tu cuenta de Twitch para habilitar el cambio automático de categoría según la aplicación activa.';

  @override
  String get settingsShowNotificationsSubtitle =>
      'Mostrar notificaciones cuando se actualice la categoría';

  @override
  String get settingsNotifyMissingCategoryLabel =>
      'Notificar categoría faltante';

  @override
  String get settingsNotifyMissingCategorySubtitle =>
      'Mostrar notificación cuando no se encuentre mapeo para un juego o aplicación';

  @override
  String get categoryMappingAddDialogCategoryIdHint => 'p. ej., 21779';

  @override
  String get welcomeTwitchOptionalInfo =>
      'Este paso es opcional. Puedes omitirlo y configurarlo más tarde en Configuración.';

  @override
  String get settingsKeyboardShortcuts => 'Atajos de teclado';

  @override
  String get categoryMappingAddDialogCategoryIdRequired =>
      'El ID de categoría es obligatorio';

  @override
  String get welcomeTwitchAuthorizeButton => 'AUTORIZAR CON TWITCH';

  @override
  String get settingsManualUpdateHotkeyLabel => 'Atajo de actualización manual';

  @override
  String get categoryMappingAddDialogCategoryNameLabel =>
      'NOMBRE DE CATEGORÍA DE TWITCH';

  @override
  String get welcomeButtonNext => 'SIGUIENTE';

  @override
  String get settingsManualUpdateHotkeyDescription =>
      'Activar una actualización manual de categoría';

  @override
  String get categoryMappingAddDialogCategoryNameHint =>
      'p. ej., League of Legends';

  @override
  String get welcomeButtonBack => 'ATRÁS';

  @override
  String get settingsUnsavedChanges => 'Tienes cambios sin guardar';

  @override
  String get categoryMappingAddDialogCategoryNameRequired =>
      'El nombre de categoría es obligatorio';

  @override
  String get settingsDiscard => 'Descartar';

  @override
  String get categoryMappingAddDialogTip =>
      'Consejo: Usa la búsqueda de categorías de Twitch para encontrar el ID y nombre correctos';

  @override
  String get settingsSave => 'Guardar';

  @override
  String get categoryMappingAddDialogCancelButton => 'CANCELAR';

  @override
  String get settingsTwitchConnection => 'Conexión con Twitch';

  @override
  String get categoryMappingAddDialogUpdateButton => 'ACTUALIZAR';

  @override
  String get settingsTwitchStatusConnected => 'Conectado';

  @override
  String get categoryMappingAddDialogAddButton => 'AGREGAR';

  @override
  String get settingsTwitchStatusNotConnected => 'No conectado';

  @override
  String get categoryMappingListEmpty => 'Aún no hay mapeos de categorías';

  @override
  String get categoryMappingListEmptyTitle => 'Aún no hay mapeos de categorías';

  @override
  String get settingsTwitchLoggedInAs => 'Conectado como:';

  @override
  String get categoryMappingListEmptySubtitle =>
      'Agrega tu primer mapeo para comenzar';

  @override
  String get settingsTwitchDisconnect => 'Desconectar';

  @override
  String get categoryMappingListColumnProcessName => 'NOMBRE DEL PROCESO';

  @override
  String get settingsTwitchConnectDescription =>
      'Conecta tu cuenta de Twitch para habilitar el cambio automático de categoría.';

  @override
  String get categoryMappingListColumnCategory => 'CATEGORÍA';

  @override
  String get settingsTwitchConnect => 'Conectar con Twitch';

  @override
  String get categoryMappingListColumnLastUsed => 'ÚLTIMO USO';

  @override
  String get hotkeyInputCancel => 'Cancelar';

  @override
  String get categoryMappingListColumnType => 'TIPO';

  @override
  String get hotkeyInputChange => 'Cambiar';

  @override
  String get categoryMappingListColumnActions => 'ACCIONES';

  @override
  String get hotkeyInputClearHotkey => 'Limpiar atajo';

  @override
  String get categoryMappingListIdPrefix => 'ID: ';

  @override
  String categoryMappingListCategoryId(String categoryId) {
    return 'ID: $categoryId';
  }

  @override
  String get categoryMappingListNever => 'Nunca';

  @override
  String get categoryMappingListJustNow => 'Justo ahora';

  @override
  String categoryMappingListMinutesAgo(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'minutos',
      one: 'minuto',
    );
    return 'hace $minutes $_temp0';
  }

  @override
  String categoryMappingListHoursAgo(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: 'horas',
      one: 'hora',
    );
    return 'hace $hours $_temp0';
  }

  @override
  String categoryMappingListDaysAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'días',
      one: 'día',
    );
    return 'hace $days $_temp0';
  }

  @override
  String get hotkeyInputSetHotkey => 'Establecer atajo';

  @override
  String get categoryMappingListNeverUsed => 'Nunca';

  @override
  String get categoryMappingListTypeUser => 'USUARIO';

  @override
  String get categoryMappingListTypePreset => 'PREESTABLECIDO';

  @override
  String get categoryMappingListEditTooltip => 'Editar mapeo';

  @override
  String get categoryMappingListDeleteTooltip => 'Eliminar mapeo';

  @override
  String get categoryMappingListTimeJustNow => 'Justo ahora';

  @override
  String get categoryMappingProviderSuccessAdded =>
      'Mapeo agregado correctamente';

  @override
  String get categoryMappingProviderSuccessUpdated =>
      'Mapeo actualizado correctamente';

  @override
  String get categoryMappingProviderSuccessDeleted =>
      'Mapeo eliminado correctamente';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonOk => 'OK';

  @override
  String get commonConfirm => 'Confirmar';

  @override
  String get autoSwitcherProviderErrorPrefix => 'Error al';

  @override
  String get autoSwitcherProviderStartMonitoring => 'iniciar la monitorización';

  @override
  String get autoSwitcherProviderStopMonitoring => 'detener la monitorización';

  @override
  String get autoSwitcherProviderManualUpdate =>
      'realizar la actualización manual';

  @override
  String get autoSwitcherProviderLoadHistory => 'cargar el historial';

  @override
  String get autoSwitcherProviderClearHistory => 'limpiar el historial';

  @override
  String get autoSwitcherProviderSuccessCategoryUpdated =>
      'Categoría actualizada correctamente';

  @override
  String get autoSwitcherProviderSuccessHistoryCleared =>
      'Historial limpiado correctamente';

  @override
  String get autoSwitcherProviderErrorUnknown => 'Error desconocido';

  @override
  String get settingsFactoryReset => 'Restablecimiento de fábrica';

  @override
  String get settingsFactoryResetDescription =>
      'Restablecer todas las configuraciones y datos a los valores predeterminados de fábrica';

  @override
  String get settingsFactoryResetButton => 'Restablecer a valores de fábrica';

  @override
  String get settingsFactoryResetDialogTitle => 'Restablecimiento de fábrica';

  @override
  String get settingsFactoryResetDialogMessage =>
      'Se perderán todas las configuraciones, la base de datos local y todas las categorías creadas localmente. ¿Está seguro de que desea continuar?';

  @override
  String get settingsFactoryResetDialogConfirm => 'RESTABLECER';

  @override
  String get settingsFactoryResetSuccess =>
      'La aplicación se restableció a los valores de fábrica correctamente. Por favor, reinicie la aplicación.';

  @override
  String get settingsUpdates => 'Actualizaciones';

  @override
  String get settingsUpdateChannelLabel => 'Canal de actualizaciones';

  @override
  String get settingsUpdateChannelDescription =>
      'Elige qué tipos de actualizaciones deseas recibir';

  @override
  String settingsUpdateChannelChanged(String channel) {
    return 'Canal de actualizaciones cambiado a $channel. Buscando actualizaciones...';
  }

  @override
  String get updateChannelStable => 'Estable';

  @override
  String get updateChannelStableDesc =>
      'Recomendado para la mayoría de usuarios. Solo versiones estables.';

  @override
  String get updateChannelRc => 'Release Candidate';

  @override
  String get updateChannelRcDesc =>
      'Características estables con pruebas finales antes del lanzamiento estable.';

  @override
  String get updateChannelBeta => 'Beta';

  @override
  String get updateChannelBetaDesc =>
      'Nuevas funciones que son mayormente estables. Puede tener errores.';

  @override
  String get updateChannelDev => 'Desarrollo';

  @override
  String get updateChannelDevDesc =>
      'Características de última generación. Espere errores e inestabilidad.';

  @override
  String get fallbackBehaviorDoNothing => 'No hacer nada';

  @override
  String get fallbackBehaviorJustChatting => 'Just Chatting';

  @override
  String get fallbackBehaviorCustom => 'Categoría personalizada';

  @override
  String get unknownGameDialogTitle => 'Game Not Mapped';

  @override
  String get unknownGameDialogStepCategory => 'Categoría';

  @override
  String get unknownGameDialogStepDestination => 'Destino';

  @override
  String get unknownGameDialogStepConfirm => 'Confirmar';

  @override
  String get unknownGameDialogConfirmHeader => 'Revisar y confirmar';

  @override
  String get unknownGameDialogConfirmDescription =>
      'Por favor revisa tus selecciones antes de guardar';

  @override
  String get unknownGameDialogConfirmCategory => 'CATEGORÍA DE TWITCH';

  @override
  String get unknownGameDialogConfirmDestination => 'LISTA DE DESTINO';

  @override
  String get unknownGameDialogBack => 'Atrás';

  @override
  String get unknownGameDialogNext => 'Siguiente';

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
      'Seleccionar categoría de Twitch';

  @override
  String get unknownGameDialogCategoryDescription =>
      'Busca y selecciona la categoría de Twitch para este juego';

  @override
  String get unknownGameDialogListHeader => 'Elegir destino';

  @override
  String get unknownGameDialogListDescription =>
      'Selecciona dónde guardar este mapeo';

  @override
  String get unknownGameDialogNoWritableLists =>
      'No hay listas disponibles para escritura';

  @override
  String get unknownGameDialogNoWritableListsHint =>
      'Crea una lista local en Mapeos de categorías para guardar mapeos personalizados';

  @override
  String get unknownGameDialogLocalListsHeader => 'MAPEOS LOCALES';

  @override
  String get unknownGameDialogSubmissionListsHeader => 'ENVÍO A LA COMUNIDAD';

  @override
  String get unknownGameDialogWorkflowHeader => 'Cómo funciona el envío';

  @override
  String get unknownGameDialogWorkflowCompactNote =>
      'Se guarda localmente primero, luego se envía para aprobación de la comunidad';

  @override
  String get unknownGameDialogWorkflowLearnMore => 'Más información';

  @override
  String get unknownGameDialogWorkflowStep1Title =>
      'Guardado localmente (inmediato)';

  @override
  String get unknownGameDialogWorkflowStep1Description =>
      'El mapeo se agrega a tu lista local y funciona inmediatamente';

  @override
  String get unknownGameDialogWorkflowStep2Title => 'Enviado para revisión';

  @override
  String get unknownGameDialogWorkflowStep2Description =>
      'Tu mapeo se envía a la comunidad para su aprobación';

  @override
  String get unknownGameDialogWorkflowStep3Title => 'Fusionado a oficial';

  @override
  String get unknownGameDialogWorkflowStep3Description =>
      'Una vez aprobado, aparece en los mapeos oficiales y se elimina de tu lista local';

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
  String get unknownGameDialogThankYouTitle => '¡Gracias!';

  @override
  String get unknownGameDialogThankYouMessage =>
      '¡Tu contribución ayuda a que la comunidad crezca!';

  @override
  String get versionStatusUpToDate => 'Actualizado';

  @override
  String get versionStatusUpdateAvailable => 'Actualización disponible';

  @override
  String versionStatusCheckFailed(String error) {
    return 'Error al verificar actualización: $error';
  }

  @override
  String get versionStatusNotInitialized =>
      'Servicio de actualización no inicializado';

  @override
  String get versionStatusPlatformNotSupported =>
      'Actualizaciones no compatibles en esta plataforma';
}
