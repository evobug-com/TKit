// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'TKit';

  @override
  String get welcomeTitle => 'TKit에 오신 것을 환영합니다';

  @override
  String get selectLanguage => '언어를 선택하세요';

  @override
  String get languageLabel => '언어';

  @override
  String get continueButton => '계속';

  @override
  String get confirm => '확인';

  @override
  String get hello => '안녕하세요';

  @override
  String get languageNativeName => '한국어';

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
  String get settingsLanguage => '언어';

  @override
  String get settingsLanguageDescription => '애플리케이션의 선호 언어를 선택하세요';

  @override
  String get languageChangeNotice => '언어가 변경되었습니다. 애플리케이션이 즉시 업데이트됩니다.';

  @override
  String get authSuccessAuthenticatedAs => '로 성공적으로 인증되었습니다';

  @override
  String get systemTrayShowTkit => 'TKit 표시';

  @override
  String get authConnectToTwitch => 'Twitch에 연결';

  @override
  String get systemTrayAutoSwitcher => '자동 전환';

  @override
  String get authLoading => '로딩 중...';

  @override
  String get systemTrayCategoryMappings => '카테고리 매핑';

  @override
  String get authRefreshingToken => '토큰 새로고침 중...';

  @override
  String get systemTraySettings => '설정';

  @override
  String get authSuccessfullyAuthenticated => '성공적으로 인증되었습니다';

  @override
  String get systemTrayExit => '종료';

  @override
  String get authLoggedInAs => '로 로그인됨';

  @override
  String get systemTrayTooltip => 'TKit - Twitch 툴킷';

  @override
  String get authErrorAuthenticationFailed => '인증 실패';

  @override
  String get authErrorErrorCode => '오류 코드:';

  @override
  String get authTryAgain => '다시 시도';

  @override
  String get authAuthorizationSteps => '인증 단계';

  @override
  String get authStep1 => '아래의 \"Twitch에 연결\" 버튼을 클릭하세요';

  @override
  String get authStep2 => '브라우저에서 Twitch 인증 페이지가 열립니다';

  @override
  String get authStep3 => 'TKit이 채널을 관리하도록 검토하고 승인하세요';

  @override
  String get authStep4 => '인증 후 이 창으로 돌아오세요';

  @override
  String get authConnectToTwitchButton => 'TWITCH에 연결';

  @override
  String get authRequiresAccessMessage =>
      'TKit은 Twitch 채널 카테고리를 업데이트하기 위한 액세스 권한이 필요합니다.';

  @override
  String get authDeviceCodeTitle => 'Twitch에 연결';

  @override
  String get authDeviceCodeInstructions => 'Twitch 계정을 연결하려면 다음의 간단한 단계를 따르세요:';

  @override
  String get authDeviceCodeStep1 => '이동:';

  @override
  String get authDeviceCodeStep2 => '이 코드를 입력하세요:';

  @override
  String get authDeviceCodeStep3 => 'TKit이 채널 카테고리를 관리하도록 승인하세요';

  @override
  String get authDeviceCodeCodeLabel => '귀하의 코드';

  @override
  String get authDeviceCodeCopyCode => '코드 복사';

  @override
  String get authDeviceCodeCopied => '복사됨!';

  @override
  String get authDeviceCodeOpenBrowser => 'twitch.tv/activate 열기';

  @override
  String get authDeviceCodeWaiting => '승인 대기 중...';

  @override
  String authDeviceCodeExpiresIn(String minutes, String seconds) {
    return '코드 만료 시간: $minutes:$seconds';
  }

  @override
  String get authDeviceCodeExpired => '코드가 만료되었습니다. 다시 시도하세요.';

  @override
  String get authDeviceCodeCancel => '취소';

  @override
  String get authDeviceCodeSuccess => '성공적으로 연결되었습니다!';

  @override
  String get authDeviceCodeError => '연결에 실패했습니다. 다시 시도하세요.';

  @override
  String get authDeviceCodeHelp => '문제가 있나요? 브라우저에서 Twitch에 로그인되어 있는지 확인하세요.';

  @override
  String get autoSwitcherPageTitle => '자동 전환';

  @override
  String get authStatusAuthenticated => '인증됨';

  @override
  String get autoSwitcherPageDescription =>
      '포커스된 애플리케이션을 기반으로 스트림 카테고리를 자동으로 업데이트합니다';

  @override
  String get authStatusConnecting => '연결 중...';

  @override
  String get autoSwitcherStatusHeader => '상태';

  @override
  String get authStatusError => '오류';

  @override
  String get autoSwitcherStatusCurrentProcess => '현재 프로세스';

  @override
  String get authStatusNotConnected => '연결되지 않음';

  @override
  String get autoSwitcherStatusNone => '없음';

  @override
  String get autoSwitcherStatusMatchedCategory => '일치하는 카테고리';

  @override
  String get mainWindowNavAutoSwitcher => '자동 전환';

  @override
  String get autoSwitcherStatusLastUpdate => '마지막 업데이트';

  @override
  String get mainWindowNavMappings => '매핑';

  @override
  String get autoSwitcherStatusNever => '없음';

  @override
  String get mainWindowNavSettings => '설정';

  @override
  String get mainWindowStatusConnected => '연결됨';

  @override
  String get autoSwitcherStatusUpdateStatus => '업데이트 상태';

  @override
  String get mainWindowStatusDisconnected => '연결 끊김';

  @override
  String get autoSwitcherStatusNoUpdatesYet => '아직 업데이트가 없습니다';

  @override
  String get mainWindowWindowControlMinimize => '최소화';

  @override
  String get autoSwitcherStatusSuccess => '성공';

  @override
  String get authLoadingStartingAuthentication => '인증을 시작하는 중...';

  @override
  String get mainWindowWindowControlMaximize => '최대화';

  @override
  String get autoSwitcherStatusFailed => '실패';

  @override
  String get authLoadingLoggingOut => '로그아웃 중...';

  @override
  String get settingsSavedSuccessfully => '설정이 성공적으로 저장되었습니다';

  @override
  String get autoSwitcherStatusSystemState => '시스템 상태';

  @override
  String get mainWindowWindowControlClose => '닫기';

  @override
  String get authLoadingCheckingStatus => '인증 상태 확인 중...';

  @override
  String get settingsRetry => '다시 시도';

  @override
  String get settingsPageTitle => '설정';

  @override
  String get settingsPageDescription => '애플리케이션 동작 및 기본 설정 구성';

  @override
  String get settingsTabGeneral => '일반';

  @override
  String get settingsTabAutoSwitcher => '자동 전환기';

  @override
  String get settingsTabKeyboard => '키보드';

  @override
  String get settingsTabTwitch => 'Twitch';

  @override
  String get settingsTabAdvanced => '고급';

  @override
  String get autoSwitcherStatusNotInitialized => '초기화되지 않음';

  @override
  String get mainWindowFooterReady => '준비';

  @override
  String get authErrorTokenRefreshFailed => '토큰 새로고침 실패:';

  @override
  String get settingsAutoSwitcher => '자동 전환';

  @override
  String get autoSwitcherStatusIdle => '유휴';

  @override
  String get updateDialogTitle => '업데이트 사용 가능';

  @override
  String get settingsMonitoring => '모니터링';

  @override
  String get autoSwitcherStatusDetectingProcess => '프로세스 감지 중';

  @override
  String get categoryMappingTitle => '카테고리 매핑';

  @override
  String get updateDialogWhatsNew => '새로운 기능:';

  @override
  String get settingsScanIntervalLabel => '스캔 간격';

  @override
  String get autoSwitcherStatusSearchingMapping => '매핑 검색 중';

  @override
  String get categoryMappingSubtitle => '자동 전환을 위한 프로세스-카테고리 매핑 관리';

  @override
  String get updateDialogDownloadComplete => '다운로드 완료! 설치 준비가 되었습니다.';

  @override
  String get settingsScanIntervalDescription =>
      '어떤 애플리케이션이 포커스를 가지고 있는지 확인하는 빈도';

  @override
  String get autoSwitcherStatusUpdatingCategory => '카테고리 업데이트 중';

  @override
  String get categoryMappingAddMappingButton => '매핑 추가';

  @override
  String get updateDialogDownloadFailed => '다운로드 실패:';

  @override
  String get settingsDebounceTimeLabel => '디바운스 시간';

  @override
  String get autoSwitcherStatusWaitingDebounce => '대기 중(디바운스)';

  @override
  String get categoryMappingErrorDialogTitle => '오류';

  @override
  String get updateDialogRemindLater => '나중에 알림';

  @override
  String get updateDialogIgnore => '이 버전 무시';

  @override
  String get settingsDebounceTimeDescription =>
      '앱 변경 후 카테고리 전환 전 대기 시간(빠른 전환 방지)';

  @override
  String get autoSwitcherStatusError => '오류';

  @override
  String get categoryMappingStatsTotalMappings => '전체 매핑';

  @override
  String get updateDialogDownloadUpdate => '업데이트 다운로드';

  @override
  String get settingsAutoStartMonitoringLabel => '자동으로 모니터링 시작';

  @override
  String get autoSwitcherControlsHeader => '컨트롤';

  @override
  String get categoryMappingStatsUserDefined => '사용자 정의';

  @override
  String get updateDialogCancel => '취소';

  @override
  String get settingsAutoStartMonitoringSubtitle =>
      'TKit 시작 시 활성 애플리케이션 모니터링 시작';

  @override
  String get autoSwitcherControlsStopMonitoring => '모니터링 중지';

  @override
  String get categoryMappingStatsPresets => '프리셋';

  @override
  String get updateDialogLater => '나중에';

  @override
  String get settingsFallbackBehavior => '대체 동작';

  @override
  String get autoSwitcherControlsStartMonitoring => '모니터링 시작';

  @override
  String get categoryMappingErrorLoading => '매핑 로딩 오류';

  @override
  String get updateDialogInstallRestart => '설치 및 재시작';

  @override
  String get settingsFallbackBehaviorLabel => '매핑을 찾을 수 없을 때';

  @override
  String get autoSwitcherControlsManualUpdate => '수동 업데이트';

  @override
  String get categoryMappingRetryButton => '다시 시도';

  @override
  String get updateDialogToday => '오늘';

  @override
  String get settingsFallbackBehaviorDescription =>
      '포커스된 앱에 카테고리 매핑이 없을 때의 동작을 선택하세요';

  @override
  String get categoryMappingDeleteDialogTitle => '매핑 삭제';

  @override
  String get autoSwitcherControlsMonitoringStatus => '모니터링 상태';

  @override
  String get updateDialogYesterday => '어제';

  @override
  String get settingsCustomCategory => '커스텀 카테고리';

  @override
  String get categoryMappingDeleteDialogMessage => '이 매핑을 삭제하시겠습니까?';

  @override
  String get autoSwitcherControlsActive => '활성';

  @override
  String updateDialogDaysAgo(int days) {
    return '$days일 전';
  }

  @override
  String get settingsCustomCategoryHint => '카테고리 검색...';

  @override
  String get categoryMappingDeleteDialogConfirm => '삭제';

  @override
  String get autoSwitcherControlsInactive => '비활성';

  @override
  String updateDialogVersion(String version) {
    return '버전 $version';
  }

  @override
  String get categoryMappingDeleteDialogCancel => '취소';

  @override
  String get settingsCategorySearchUnavailable =>
      '카테고리 검색은 Twitch API 모듈이 완료되면 사용할 수 있습니다';

  @override
  String get autoSwitcherControlsActiveDescription =>
      '포커스된 프로세스를 기반으로 카테고리를 자동으로 업데이트합니다';

  @override
  String updateDialogPublished(String date) {
    return '$date에 게시됨';
  }

  @override
  String get updateDialogVersionLabel => '버전';

  @override
  String get updateDialogSize => '크기';

  @override
  String get updateDialogPublishedLabel => '배포일';

  @override
  String get updateDialogDownloading => '다운로드 중';

  @override
  String get updateDialogReadyToInstall => '설치 준비 완료';

  @override
  String get updateDialogClickInstallRestart => '설치 및 재시작 클릭';

  @override
  String get updateDialogDownloadFailedTitle => '다운로드 실패';

  @override
  String get updateDialogNeverShowTooltip => '이 버전을 다시 표시하지 않음';

  @override
  String get updateDialogIgnoreButton => '무시';

  @override
  String get updateDialogRemindTooltip => '다음에 다시 알림';

  @override
  String get updateDialogPostpone => '연기';

  @override
  String get categoryMappingAddDialogEditTitle => '매핑 편집';

  @override
  String get settingsApplication => '애플리케이션';

  @override
  String get autoSwitcherControlsInactiveDescription =>
      '모니터링을 시작하여 자동 카테고리 업데이트를 활성화하세요';

  @override
  String get welcomeStepLanguage => '언어';

  @override
  String get categoryMappingAddDialogAddTitle => '새 매핑 추가';

  @override
  String get categoryMappingAddDialogClose => '닫기';

  @override
  String get categoryMappingAddDialogProcessName => '프로세스 이름';

  @override
  String get categoryMappingAddDialogExecutablePath => '실행 파일 경로(선택 사항)';

  @override
  String get categoryMappingAddDialogCategoryId => 'Twitch 카테고리 ID';

  @override
  String get categoryMappingAddDialogCategoryName => 'Twitch 카테고리 이름';

  @override
  String get categoryMappingAddDialogCancel => '취소';

  @override
  String get categoryMappingAddDialogUpdate => '업데이트';

  @override
  String get categoryMappingAddDialogAdd => '추가';

  @override
  String get settingsAutoStartWindowsLabel => 'Windows와 함께 자동 시작';

  @override
  String get categoryMappingAddDialogCloseTooltip => '닫기';

  @override
  String get welcomeStepTwitch => 'Twitch';

  @override
  String get welcomeStepBehavior => '동작';

  @override
  String get welcomeBehaviorStepTitle => '3단계: 애플리케이션 동작';

  @override
  String get welcomeBehaviorTitle => '애플리케이션 동작';

  @override
  String get welcomeBehaviorDescription => 'TKit의 시작 및 최소화 시 동작을 설정합니다.';

  @override
  String get welcomeBehaviorOptionalInfo => '이 설정은 언제든지 설정에서 변경할 수 있습니다.';

  @override
  String get settingsWindowControlsPositionLabel => '창 컨트롤 위치';

  @override
  String get settingsWindowControlsPositionDescription =>
      '창 컨트롤(최소화, 최대화, 닫기)이 표시되는 위치 선택';

  @override
  String get windowControlsPositionLeft => '왼쪽';

  @override
  String get windowControlsPositionCenter => '중앙';

  @override
  String get windowControlsPositionRight => '오른쪽';

  @override
  String get settingsAutoStartWindowsSubtitle =>
      'Windows 시작 시 TKit을 자동으로 시작합니다';

  @override
  String get categoryMappingAddDialogProcessNameLabel => '프로세스 이름';

  @override
  String get welcomeLanguageStepTitle => '1단계: 언어 선택';

  @override
  String get settingsStartMinimizedLabel => '최소화하여 시작';

  @override
  String get categoryMappingAddDialogProcessNameHint =>
      '예: League of Legends.exe';

  @override
  String get welcomeLanguageChangeLater => '나중에 설정에서 변경할 수 있습니다.';

  @override
  String get settingsStartMinimizedSubtitle => '시스템 트레이에 최소화하여 TKit 시작';

  @override
  String get categoryMappingAddDialogProcessNameRequired => '프로세스 이름은 필수입니다';

  @override
  String get welcomeTwitchStepTitle => '2단계: TWITCH에 연결';

  @override
  String get settingsMinimizeToTrayLabel => '시스템 트레이로 최소화';

  @override
  String get categoryMappingAddDialogExecutablePathLabel => '실행 파일 경로(선택 사항)';

  @override
  String get welcomeTwitchConnectionTitle => 'Twitch 연결';

  @override
  String get settingsMinimizeToTraySubtitle => '닫거나 최소화할 때 TKit을 백그라운드에서 실행';

  @override
  String get categoryMappingAddDialogExecutablePathHint =>
      '예: C:\\Games\\LeagueOfLegends\\Game\\League of Legends.exe';

  @override
  String welcomeTwitchConnectedAs(String username) {
    return '$username(으)로 연결됨';
  }

  @override
  String get settingsShowNotificationsLabel => '알림 표시';

  @override
  String get categoryMappingAddDialogCategoryIdLabel => 'Twitch 카테고리 ID';

  @override
  String get welcomeTwitchDescription =>
      '활성 애플리케이션을 기반으로 한 자동 카테고리 전환을 활성화하려면 Twitch 계정을 연결하세요.';

  @override
  String get settingsShowNotificationsSubtitle => '카테고리가 업데이트될 때 알림 표시';

  @override
  String get settingsNotifyMissingCategoryLabel => '누락된 카테고리 알림';

  @override
  String get settingsNotifyMissingCategorySubtitle =>
      '게임이나 앱에 대한 매핑을 찾을 수 없을 때 알림 표시';

  @override
  String get categoryMappingAddDialogCategoryIdHint => '예: 21779';

  @override
  String get welcomeTwitchOptionalInfo =>
      '이 단계는 선택 사항입니다. 건너뛰고 나중에 설정에서 설정할 수 있습니다.';

  @override
  String get settingsKeyboardShortcuts => '키보드 단축키';

  @override
  String get categoryMappingAddDialogCategoryIdRequired => '카테고리 ID는 필수입니다';

  @override
  String get welcomeTwitchAuthorizeButton => 'TWITCH로 인증';

  @override
  String get settingsManualUpdateHotkeyLabel => '수동 업데이트 단축키';

  @override
  String get categoryMappingAddDialogCategoryNameLabel => 'Twitch 카테고리 이름';

  @override
  String get welcomeButtonNext => '다음';

  @override
  String get settingsManualUpdateHotkeyDescription => '수동 카테고리 업데이트 트리거';

  @override
  String get categoryMappingAddDialogCategoryNameHint => '예: League of Legends';

  @override
  String get welcomeButtonBack => '뒤로';

  @override
  String get settingsUnsavedChanges => '저장되지 않은 변경 사항이 있습니다';

  @override
  String get categoryMappingAddDialogCategoryNameRequired => '카테고리 이름은 필수입니다';

  @override
  String get settingsDiscard => '취소';

  @override
  String get categoryMappingAddDialogTip =>
      '팁: Twitch 카테고리 검색을 사용하여 올바른 ID와 이름을 찾으세요';

  @override
  String get settingsSave => '저장';

  @override
  String get categoryMappingAddDialogCancelButton => '취소';

  @override
  String get settingsTwitchConnection => 'Twitch 연결';

  @override
  String get categoryMappingAddDialogUpdateButton => '업데이트';

  @override
  String get settingsTwitchStatusConnected => '연결됨';

  @override
  String get categoryMappingAddDialogAddButton => '추가';

  @override
  String get settingsTwitchStatusNotConnected => '연결되지 않음';

  @override
  String get categoryMappingListEmpty => '아직 카테고리 매핑이 없습니다';

  @override
  String get categoryMappingListEmptyTitle => '아직 카테고리 매핑이 없습니다';

  @override
  String get settingsTwitchLoggedInAs => '로그인:';

  @override
  String get categoryMappingListEmptySubtitle => '첫 번째 매핑을 추가하여 시작하세요';

  @override
  String get settingsTwitchDisconnect => '연결 해제';

  @override
  String get categoryMappingListColumnProcessName => '프로세스 이름';

  @override
  String get settingsTwitchConnectDescription =>
      'Twitch 계정을 연결하여 자동 카테고리 전환을 활성화하세요.';

  @override
  String get categoryMappingListColumnCategory => '카테고리';

  @override
  String get settingsTwitchConnect => 'Twitch에 연결';

  @override
  String get categoryMappingListColumnLastUsed => '마지막 사용';

  @override
  String get hotkeyInputCancel => '취소';

  @override
  String get categoryMappingListColumnType => '유형';

  @override
  String get hotkeyInputChange => '변경';

  @override
  String get categoryMappingListColumnActions => '작업';

  @override
  String get hotkeyInputClearHotkey => '단축키 지우기';

  @override
  String get categoryMappingListIdPrefix => 'ID: ';

  @override
  String categoryMappingListCategoryId(String categoryId) {
    return 'ID: $categoryId';
  }

  @override
  String get categoryMappingListNever => '없음';

  @override
  String get categoryMappingListJustNow => '방금';

  @override
  String categoryMappingListMinutesAgo(int minutes) {
    return '$minutes분 전';
  }

  @override
  String categoryMappingListHoursAgo(int hours) {
    return '$hours시간 전';
  }

  @override
  String categoryMappingListDaysAgo(int days) {
    return '$days일 전';
  }

  @override
  String get hotkeyInputSetHotkey => '단축키 설정';

  @override
  String get categoryMappingListNeverUsed => '없음';

  @override
  String get categoryMappingListTypeUser => '사용자';

  @override
  String get categoryMappingListTypePreset => '프리셋';

  @override
  String get categoryMappingListEditTooltip => '매핑 편집';

  @override
  String get categoryMappingListDeleteTooltip => '매핑 삭제';

  @override
  String get categoryMappingListTimeJustNow => '방금';

  @override
  String get categoryMappingProviderSuccessAdded => '매핑이 성공적으로 추가되었습니다';

  @override
  String get categoryMappingProviderSuccessUpdated => '매핑이 성공적으로 업데이트되었습니다';

  @override
  String get categoryMappingProviderSuccessDeleted => '매핑이 성공적으로 삭제되었습니다';

  @override
  String get commonCancel => '취소';

  @override
  String get commonOk => '확인';

  @override
  String get commonConfirm => '확인';

  @override
  String get autoSwitcherProviderErrorPrefix => '실패';

  @override
  String get autoSwitcherProviderStartMonitoring => '모니터링 시작';

  @override
  String get autoSwitcherProviderStopMonitoring => '모니터링 중지';

  @override
  String get autoSwitcherProviderManualUpdate => '수동 업데이트 수행';

  @override
  String get autoSwitcherProviderLoadHistory => '기록 로드';

  @override
  String get autoSwitcherProviderClearHistory => '기록 지우기';

  @override
  String get autoSwitcherProviderSuccessCategoryUpdated =>
      '카테고리가 성공적으로 업데이트되었습니다';

  @override
  String get autoSwitcherProviderSuccessHistoryCleared => '기록이 성공적으로 지워졌습니다';

  @override
  String get autoSwitcherProviderErrorUnknown => '알 수 없는 오류';

  @override
  String get settingsFactoryReset => '공장 초기화';

  @override
  String get settingsFactoryResetDescription => '모든 설정 및 데이터를 공장 기본값으로 재설정';

  @override
  String get settingsFactoryResetButton => '공장 기본값으로 재설정';

  @override
  String get settingsFactoryResetDialogTitle => '공장 초기화';

  @override
  String get settingsFactoryResetDialogMessage =>
      '모든 설정, 로컬 데이터베이스 및 로컬로 생성된 모든 카테고리가 손실됩니다. 계속하시겠습니까?';

  @override
  String get settingsFactoryResetDialogConfirm => '재설정';

  @override
  String get settingsFactoryResetSuccess =>
      '애플리케이션이 공장 기본값으로 성공적으로 재설정되었습니다. 애플리케이션을 다시 시작하세요.';

  @override
  String get settingsUpdates => '업데이트';

  @override
  String get settingsUpdateChannelLabel => '업데이트 채널';

  @override
  String get settingsUpdateChannelDescription => '받고 싶은 업데이트 유형을 선택하세요';

  @override
  String settingsUpdateChannelChanged(String channel) {
    return '업데이트 채널이 $channel(으)로 변경되었습니다. 업데이트 확인 중...';
  }

  @override
  String get updateChannelStable => '안정판';

  @override
  String get updateChannelStableDesc => '대부분의 사용자에게 권장됩니다. 안정판만 제공됩니다.';

  @override
  String get updateChannelRc => 'Release Candidate';

  @override
  String get updateChannelRcDesc => '안정판 출시 전 최종 테스트를 거친 안정적인 기능.';

  @override
  String get updateChannelBeta => 'Beta';

  @override
  String get updateChannelBetaDesc => '대부분 안정적인 새 기능. 버그가 있을 수 있습니다.';

  @override
  String get updateChannelDev => '개발판';

  @override
  String get updateChannelDevDesc => '최신 기능. 버그와 불안정성이 예상됩니다.';

  @override
  String get fallbackBehaviorDoNothing => '아무 작업도 안 함';

  @override
  String get fallbackBehaviorJustChatting => 'Just Chatting';

  @override
  String get fallbackBehaviorCustom => '커스텀 카테고리';

  @override
  String get unknownGameDialogTitle => 'Game Not Mapped';

  @override
  String get unknownGameDialogStepCategory => '카테고리';

  @override
  String get unknownGameDialogStepDestination => '대상';

  @override
  String get unknownGameDialogStepConfirm => '확인';

  @override
  String get unknownGameDialogConfirmHeader => '검토 및 확인';

  @override
  String get unknownGameDialogConfirmDescription => '저장하기 전에 선택 내용을 검토하세요';

  @override
  String get unknownGameDialogConfirmCategory => '트위치 카테고리';

  @override
  String get unknownGameDialogConfirmDestination => '대상 목록';

  @override
  String get unknownGameDialogBack => '뒤로';

  @override
  String get unknownGameDialogNext => '다음';

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
  String get unknownGameDialogCategoryHeader => '트위치 카테고리 선택';

  @override
  String get unknownGameDialogCategoryDescription =>
      '이 게임의 트위치 카테고리를 검색하고 선택하세요';

  @override
  String get unknownGameDialogListHeader => '대상 선택';

  @override
  String get unknownGameDialogListDescription => '이 매핑을 저장할 위치를 선택하세요';

  @override
  String get unknownGameDialogNoWritableLists => '쓰기 가능한 목록이 없습니다';

  @override
  String get unknownGameDialogNoWritableListsHint =>
      '사용자 정의 매핑을 저장하려면 카테고리 매핑에서 로컬 목록을 만드세요';

  @override
  String get unknownGameDialogLocalListsHeader => '로컬 매핑';

  @override
  String get unknownGameDialogSubmissionListsHeader => '커뮤니티 제출';

  @override
  String get unknownGameDialogWorkflowHeader => '제출 방법';

  @override
  String get unknownGameDialogWorkflowCompactNote =>
      '먼저 로컬에 저장된 후 커뮤니티 승인을 위해 제출됩니다';

  @override
  String get unknownGameDialogWorkflowLearnMore => '자세히 알아보기';

  @override
  String get unknownGameDialogWorkflowStep1Title => '로컬에 저장됨 (즉시)';

  @override
  String get unknownGameDialogWorkflowStep1Description =>
      '매핑이 로컬 목록에 추가되고 즉시 작동합니다';

  @override
  String get unknownGameDialogWorkflowStep2Title => '검토를 위해 제출됨';

  @override
  String get unknownGameDialogWorkflowStep2Description =>
      '매핑이 승인을 위해 커뮤니티에 제출됩니다';

  @override
  String get unknownGameDialogWorkflowStep3Title => '공식에 병합됨';

  @override
  String get unknownGameDialogWorkflowStep3Description =>
      '승인되면 공식 매핑에 나타나고 로컬 목록에서 제거됩니다';

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
  String get unknownGameDialogThankYouTitle => '감사합니다!';

  @override
  String get unknownGameDialogThankYouMessage => '여러분의 기여가 커뮤니티 성장에 도움이 됩니다!';

  @override
  String get versionStatusUpToDate => '최신 상태';

  @override
  String get versionStatusUpdateAvailable => '업데이트 가능';

  @override
  String versionStatusCheckFailed(String error) {
    return '업데이트 확인 실패: $error';
  }

  @override
  String get versionStatusNotInitialized => '업데이트 서비스가 초기화되지 않음';

  @override
  String get versionStatusPlatformNotSupported => '이 플랫폼에서는 업데이트가 지원되지 않습니다';

  @override
  String get notificationMissingCategoryTitle => '카테고리 매핑을 찾을 수 없음';

  @override
  String notificationMissingCategoryBody(String processName) {
    return '$processName에 대한 Twitch 카테고리를 찾을 수 없습니다';
  }

  @override
  String get notificationActionAssignCategory => '카테고리 할당';

  @override
  String get notificationCategoryUpdatedTitle => '카테고리 업데이트됨';

  @override
  String notificationCategoryUpdatedBody(
    String categoryName,
    String processName,
  ) {
    return '$processName을(를) 위해 \"$categoryName\"(으)로 전환했습니다';
  }

  @override
  String get mappingListColumnSource => '소스';

  @override
  String get mappingListColumnEnabled => '활성화됨';

  @override
  String get mappingListTooltipIgnored => '이 카테고리는 무시됨';

  @override
  String mappingListTooltipTwitchId(String twitchCategoryId) {
    return 'Twitch ID: $twitchCategoryId';
  }

  @override
  String get mappingListCategoryIgnored => '무시됨';

  @override
  String get mappingListSourceUnknown => '알 수 없음';

  @override
  String mappingListSelected(int count) {
    return '$count개 선택됨';
  }

  @override
  String mappingListSelectedVisible(int count, int visible) {
    return '$count개 선택됨 ($visible개 표시됨)';
  }

  @override
  String get mappingListButtonInvert => '반전';

  @override
  String get mappingListButtonClear => '지우기';

  @override
  String mappingListButtonUndo(String action) {
    return '$action 실행 취소';
  }

  @override
  String get mappingListButtonExport => '내보내기';

  @override
  String get mappingListButtonEnable => '활성화';

  @override
  String get mappingListButtonDisable => '비활성화';

  @override
  String get mappingListButtonDelete => '삭제';

  @override
  String get mappingListTooltipCannotDelete => '읽기 전용 목록의 매핑은 삭제할 수 없습니다';

  @override
  String get mappingListTooltipDelete => '선택한 매핑 삭제';

  @override
  String get mappingListSearchHint => '프로세스 이름 또는 카테고리로 검색...';

  @override
  String get mappingListTooltipClearSearch => '검색 지우기';

  @override
  String get listManagementEmptyState => '목록을 찾을 수 없음';

  @override
  String get listManagementTitle => '목록 관리';

  @override
  String get listManagementSyncNow => '지금 동기화';

  @override
  String get listManagementBadgeLocal => '로컬';

  @override
  String get listManagementBadgeOfficial => '공식';

  @override
  String get listManagementBadgeRemote => '원격';

  @override
  String get listManagementBadgeReadOnly => '읽기 전용';

  @override
  String get listManagementButtonImport => '목록 가져오기';

  @override
  String get listManagementButtonSyncAll => '모두 동기화';

  @override
  String get listManagementButtonClose => '닫기';

  @override
  String get listManagementImportTitle => '목록 가져오기';

  @override
  String get listManagementImportUrl => '목록 URL';

  @override
  String get listManagementImportUrlPlaceholder =>
      'https://example.com/mappings.json';

  @override
  String get listManagementImportName => '목록 이름 (선택 사항)';

  @override
  String get listManagementImportNameHelper => '제공되지 않으면 JSON 파일의 이름을 사용합니다';

  @override
  String get listManagementImportNamePlaceholder => '나만의 커스텀 목록';

  @override
  String get listManagementImportDescription => '설명 (선택 사항)';

  @override
  String get listManagementImportDescriptionHelper =>
      '제공되지 않으면 JSON 파일의 설명을 사용합니다';

  @override
  String get listManagementImportDescriptionPlaceholder => '게임 매핑 모음';

  @override
  String get listManagementButtonCancel => '취소';

  @override
  String get listManagementButtonImportConfirm => '가져오기';

  @override
  String get listManagementDefaultName => '가져온 목록';

  @override
  String get listManagementImportSuccess => '목록을 성공적으로 가져왔습니다';

  @override
  String get listManagementSyncNever => '한 번도 없음';

  @override
  String get listManagementSyncJustNow => '방금';

  @override
  String listManagementSyncMinutesAgo(int minutes) {
    return '$minutes분 전';
  }

  @override
  String listManagementSyncHoursAgo(int hours) {
    return '$hours시간 전';
  }

  @override
  String listManagementSyncDaysAgo(int days) {
    return '$days일 전';
  }

  @override
  String listManagementSyncDaysHoursAgo(int days, int hours) {
    return '$days일 $hours시간 전';
  }

  @override
  String listManagementMappingsCount(int count) {
    return '$count개 매핑';
  }

  @override
  String get listManagementSyncFailed => '동기화 실패:';

  @override
  String get listManagementLastSynced => '마지막 동기화:';

  @override
  String get unknownGameIgnoreProcess => '프로세스 무시';

  @override
  String unknownGameCategoryId(String id) {
    return 'ID: $id';
  }

  @override
  String get unknownGameSubmissionTitle => '제출 필요';

  @override
  String get unknownGameSubmissionInfo =>
      '이 매핑은 로컬에 저장되고 승인을 위해 목록 소유자에게 제출됩니다. 승인 및 동기화되면 로컬 사본이 자동으로 교체됩니다.';

  @override
  String get unknownGameSectionLists => '목록';

  @override
  String unknownGameListMappingCount(int count) {
    return '$count개 매핑';
  }

  @override
  String get unknownGameBadgeStaged => '준비됨';

  @override
  String get unknownGameIgnoredProcess => '무시된 프로세스';

  @override
  String unknownGameSelectedCategoryId(String id) {
    return 'ID: $id';
  }

  @override
  String get unknownGameWorkflowTitle => '제출 워크플로';

  @override
  String get unknownGameWorkflowTitleAlt => '다음에 일어날 일';

  @override
  String get unknownGameWorkflowStepLocal => '나만의 커스텀 매핑에 로컬로 저장됨';

  @override
  String get unknownGameWorkflowStepLocalDesc => '먼저 기기에 저장되므로 매핑이 즉시 작동합니다';

  @override
  String unknownGameWorkflowStepSubmit(String listName) {
    return '$listName에 제출됨';
  }

  @override
  String get unknownGameWorkflowStepSubmitDesc =>
      '검토 및 승인을 위해 목록 소유자에게 자동으로 전송됩니다';

  @override
  String get unknownGameWorkflowStepReplace => '승인 시 로컬 사본 교체됨';

  @override
  String unknownGameWorkflowStepReplaceDesc(String listName) {
    return '승인 및 동기화되면 로컬 사본이 제거되고 $listName의 공식 버전으로 교체됩니다';
  }

  @override
  String unknownGameSavedTo(String listName) {
    return '$listName에 저장됨';
  }

  @override
  String get unknownGameIgnoredInfo => '이 프로세스는 무시되며 알림을 트리거하지 않습니다';

  @override
  String get unknownGameLocalSaveInfo => '매핑이 로컬에 저장되었으며 즉시 작동합니다';

  @override
  String get unknownGamePrivacyInfo => '이 매핑은 비공개이며 기기에만 저장됩니다';

  @override
  String autoSwitcherError(String error) {
    return '오류: $error';
  }

  @override
  String get autoSwitcherStatusActive => '자동 전환 활성화';

  @override
  String get autoSwitcherStatusInactive => '모니터링하지 않음';

  @override
  String get autoSwitcherLabelActiveApp => '활성 앱';

  @override
  String get autoSwitcherLabelCategory => '카테고리';

  @override
  String get autoSwitcherValueNone => '없음';

  @override
  String get autoSwitcherDescriptionActive => '앱을 전환하면 카테고리가 자동으로 변경됩니다.';

  @override
  String get autoSwitcherButtonTurnOff => '끄기';

  @override
  String get autoSwitcherInstructionPress => '누르기';

  @override
  String get autoSwitcherInstructionManual => '포커스된 프로세스로 수동 업데이트';

  @override
  String get autoSwitcherHeadingEnable => '자동 전환 활성화';

  @override
  String get autoSwitcherDescriptionInactive => '앱을 전환하면 카테고리가 자동으로 변경됩니다.';

  @override
  String get autoSwitcherButtonTurnOn => '켜기';

  @override
  String get autoSwitcherInstructionOr => '또는 누르기';

  @override
  String get settingsTabMappings => '매핑';

  @override
  String get settingsTabTheme => '테마';

  @override
  String get settingsAutoSyncOnStart => '앱 시작 시 매핑 자동 동기화';

  @override
  String get settingsAutoSyncOnStartDesc => '애플리케이션 시작 시 매핑 목록을 자동으로 동기화합니다';

  @override
  String get settingsAutoSyncInterval => '자동 동기화 간격';

  @override
  String get settingsAutoSyncIntervalDesc =>
      '매핑 목록을 자동으로 동기화하는 주기 (0 = 사용 안 함)';

  @override
  String get settingsAutoSyncNever => '사용 안 함';

  @override
  String get settingsTimingTitle => '이 설정들이 함께 작동하는 방법';

  @override
  String settingsTimingStep1(int scanInterval) {
    return '앱이 $scanInterval초마다 포커스된 창을 확인합니다';
  }

  @override
  String get settingsTimingStep2Instant => '새 앱이 감지되면 즉시 카테고리 전환';

  @override
  String settingsTimingStep2Debounce(int debounce) {
    return '새 앱 감지 후 $debounce초 대기 (디바운스)';
  }

  @override
  String settingsTimingStep3Instant(int scanInterval) {
    return '총 전환 시간: $scanInterval초 (감지 후 즉시)';
  }

  @override
  String settingsTimingStep3Debounce(int scanInterval, int scanDebounce) {
    return '총 전환 시간: $scanInterval초 ~ $scanDebounce초';
  }

  @override
  String get settingsFramelessWindow => '프레임 없는 창 사용';

  @override
  String get settingsFramelessWindowDesc =>
      '모던하고 테두리 없는 느낌과 둥근 모서리를 위해 Windows 제목 표시줄을 제거합니다';

  @override
  String get settingsInvertLayout => '푸터/헤더 반전';

  @override
  String get settingsInvertLayoutDesc => '헤더와 푸터 섹션의 위치를 교환합니다';

  @override
  String get settingsTokenExpired => '만료됨';

  @override
  String settingsTokenExpiresDays(int days, int hours) {
    return '$days일 $hours시간 후 만료';
  }

  @override
  String settingsTokenExpiresHours(int hours, int minutes) {
    return '$hours시간 $minutes분 후 만료';
  }

  @override
  String settingsTokenExpiresMinutes(int minutes) {
    return '$minutes분 후 만료';
  }

  @override
  String get settingsResetDesc => '모든 설정 및 데이터를 공장 기본값으로 재설정';

  @override
  String get settingsButtonReset => '재설정';

  @override
  String mappingEditorSummary(
    int count,
    String plural,
    int lists,
    String pluralLists,
  ) {
    return '$lists개 활성 목록에서 $count개 프로세스 매핑$plural';
  }

  @override
  String mappingEditorBreakdown(int custom, int community) {
    return '$custom개 커스텀, $community개 커뮤니티 목록';
  }

  @override
  String get mappingEditorButtonLists => '목록';

  @override
  String get mappingEditorButtonAdd => '추가';

  @override
  String get mappingEditorDeleteTitle => '여러 매핑 삭제';

  @override
  String mappingEditorDeleteMessage(int count, String plural) {
    return '$count개 매핑$plural을(를) 삭제하시겠습니까? 이 작업은 취소할 수 없습니다.';
  }

  @override
  String get mappingEditorExportTitle => '매핑 내보내기';

  @override
  String get mappingEditorExportFilename => 'my-mappings.json';

  @override
  String mappingEditorExportSuccess(int count, String plural) {
    return '$count개 매핑$plural을(를) 내보냈습니다';
  }

  @override
  String get mappingEditorExportFailed => '내보내기 실패';

  @override
  String get addMappingPrivacySafe => '개인정보 보호 경로';

  @override
  String get addMappingCustomLocation => '사용자 지정 위치';

  @override
  String get addMappingOnlyFolder => '게임 폴더 이름만 저장됨';

  @override
  String get addMappingNotStored => '개인정보 보호를 위해 경로가 저장되지 않음';

  @override
  String get colorPickerTitle => '색상 선택';

  @override
  String get colorPickerHue => '색상';

  @override
  String get colorPickerSaturation => '채도';

  @override
  String get colorPickerValue => '명도';

  @override
  String get colorPickerButtonCancel => '취소';

  @override
  String get colorPickerButtonSelect => '선택';

  @override
  String get dropdownPlaceholder => '옵션을 선택하세요';

  @override
  String get dropdownSearchHint => '검색...';

  @override
  String get dropdownNoResults => '결과를 찾을 수 없음';

  @override
  String paginationPageInfo(int current, int total) {
    return '페이지 $current / $total';
  }

  @override
  String get paginationGoTo => '이동:';

  @override
  String get datePickerPlaceholder => '날짜 선택';

  @override
  String get timePickerAM => '오전';

  @override
  String get timePickerPM => '오후';

  @override
  String get timePickerPlaceholder => '시간 선택';

  @override
  String get fileUploadInstruction => '클릭하여 파일 업로드';

  @override
  String fileUploadAllowed(String extensions) {
    return '허용됨: $extensions';
  }

  @override
  String get menuButtonTooltip => '더 많은 옵션';

  @override
  String get breadcrumbEllipsis => '...';

  @override
  String get breadcrumbTooltipShowPath => '경로 표시';

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
  String get statusDashboardCurrentActivity => '현재 활동';

  @override
  String get statusDashboardNotStarted => '시작 안 됨';

  @override
  String get statusDashboardReady => '준비';

  @override
  String get statusDashboardCheckingApp => '활성 앱 확인 중';

  @override
  String get statusDashboardFindingCategory => '카테고리 찾는 중';

  @override
  String get statusDashboardUpdating => '카테고리 업데이트 중';

  @override
  String get statusDashboardWaiting => '확인 대기 중';

  @override
  String get statusDashboardError => '오류 발생';

  @override
  String mappingListOfCount(int count, int total) {
    return '$total개 중 $count개';
  }

  @override
  String get mappingListActionDelete => '삭제';

  @override
  String get mappingListActionEnable => '활성화';

  @override
  String get mappingListActionDisable => '비활성화';

  @override
  String autoSwitcherTimeSecondsAgo(int seconds) {
    return '$seconds초 전';
  }

  @override
  String autoSwitcherTimeMinutesAgo(int minutes) {
    return '$minutes분 전';
  }

  @override
  String autoSwitcherTimeHoursAgo(int hours) {
    return '$hours시간 전';
  }
}
