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
}
