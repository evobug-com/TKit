// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'TKit';

  @override
  String get welcomeTitle => '欢迎使用 TKit';

  @override
  String get selectLanguage => '选择您的语言';

  @override
  String get languageLabel => '语言';

  @override
  String get continueButton => '继续';

  @override
  String get confirm => '确认';

  @override
  String get hello => '你好';

  @override
  String get languageNativeName => '中文';

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
  String get settingsLanguage => '语言';

  @override
  String get settingsLanguageDescription => '为应用程序选择您的首选语言';

  @override
  String get languageChangeNotice => '语言已更改。应用程序将立即更新。';

  @override
  String get authSuccessAuthenticatedAs => '成功验证为';

  @override
  String get systemTrayShowTkit => '显示 TKit';

  @override
  String get authConnectToTwitch => '连接到 Twitch';

  @override
  String get systemTrayAutoSwitcher => '自动切换';

  @override
  String get authLoading => '加载中...';

  @override
  String get systemTrayCategoryMappings => '分类映射';

  @override
  String get authRefreshingToken => '刷新令牌中...';

  @override
  String get systemTraySettings => '设置';

  @override
  String get authSuccessfullyAuthenticated => '成功验证';

  @override
  String get systemTrayExit => '退出';

  @override
  String get authLoggedInAs => '已登录为';

  @override
  String get systemTrayTooltip => 'TKit - Twitch 工具包';

  @override
  String get authErrorAuthenticationFailed => '验证失败';

  @override
  String get authErrorErrorCode => '错误代码：';

  @override
  String get authTryAgain => '重试';

  @override
  String get authAuthorizationSteps => '授权步骤';

  @override
  String get authStep1 => '点击下方的\"连接到 Twitch\"按钮';

  @override
  String get authStep2 => '您的浏览器将打开 Twitch 授权页面';

  @override
  String get authStep3 => '查看并授权 TKit 管理您的频道';

  @override
  String get authStep4 => '授权后返回此窗口';

  @override
  String get authConnectToTwitchButton => '连接到 TWITCH';

  @override
  String get authRequiresAccessMessage => 'TKit 需要访问权限才能更新您的 Twitch 频道分类。';

  @override
  String get authDeviceCodeTitle => '连接到 Twitch';

  @override
  String get authDeviceCodeInstructions => '要连接您的 Twitch 账户，请按照以下简单步骤操作：';

  @override
  String get authDeviceCodeStep1 => '访问';

  @override
  String get authDeviceCodeStep2 => '输入此代码：';

  @override
  String get authDeviceCodeStep3 => '授权 TKit 管理您的频道分类';

  @override
  String get authDeviceCodeCodeLabel => '您的代码';

  @override
  String get authDeviceCodeCopyCode => '复制代码';

  @override
  String get authDeviceCodeCopied => '已复制！';

  @override
  String get authDeviceCodeOpenBrowser => '打开 twitch.tv/activate';

  @override
  String get authDeviceCodeWaiting => '等待授权中...';

  @override
  String authDeviceCodeExpiresIn(String minutes, String seconds) {
    return '代码将在 $minutes:$seconds 后过期';
  }

  @override
  String get authDeviceCodeExpired => '代码已过期。请重试。';

  @override
  String get authDeviceCodeCancel => '取消';

  @override
  String get authDeviceCodeSuccess => '成功连接！';

  @override
  String get authDeviceCodeError => '连接失败。请重试。';

  @override
  String get authDeviceCodeHelp => '遇到问题？请确保您已在浏览器中登录 Twitch。';

  @override
  String get autoSwitcherPageTitle => '自动切换';

  @override
  String get authStatusAuthenticated => '已验证';

  @override
  String get autoSwitcherPageDescription => '根据聚焦的应用程序自动更新直播分类';

  @override
  String get authStatusConnecting => '连接中...';

  @override
  String get autoSwitcherStatusHeader => '状态';

  @override
  String get authStatusError => '错误';

  @override
  String get autoSwitcherStatusCurrentProcess => '当前进程';

  @override
  String get authStatusNotConnected => '未连接';

  @override
  String get autoSwitcherStatusNone => '无';

  @override
  String get autoSwitcherStatusMatchedCategory => '匹配的分类';

  @override
  String get mainWindowNavAutoSwitcher => '自动切换';

  @override
  String get autoSwitcherStatusLastUpdate => '最后更新';

  @override
  String get mainWindowNavMappings => '映射';

  @override
  String get autoSwitcherStatusNever => '从未';

  @override
  String get mainWindowNavSettings => '设置';

  @override
  String get mainWindowStatusConnected => '已连接';

  @override
  String get autoSwitcherStatusUpdateStatus => '更新状态';

  @override
  String get mainWindowStatusDisconnected => '已断开';

  @override
  String get autoSwitcherStatusNoUpdatesYet => '尚无更新';

  @override
  String get mainWindowWindowControlMinimize => '最小化';

  @override
  String get autoSwitcherStatusSuccess => '成功';

  @override
  String get authLoadingStartingAuthentication => '正在启动验证...';

  @override
  String get mainWindowWindowControlMaximize => '最大化';

  @override
  String get autoSwitcherStatusFailed => '失败';

  @override
  String get authLoadingLoggingOut => '正在登出...';

  @override
  String get settingsSavedSuccessfully => '设置已成功保存';

  @override
  String get autoSwitcherStatusSystemState => '系统状态';

  @override
  String get mainWindowWindowControlClose => '关闭';

  @override
  String get authLoadingCheckingStatus => '正在检查验证状态...';

  @override
  String get settingsRetry => '重试';

  @override
  String get settingsPageTitle => '设置';

  @override
  String get settingsPageDescription => '配置应用程序行为和首选项';

  @override
  String get settingsTabGeneral => '常规';

  @override
  String get settingsTabAutoSwitcher => '自动切换器';

  @override
  String get settingsTabKeyboard => '键盘';

  @override
  String get settingsTabTwitch => 'Twitch';

  @override
  String get settingsTabAdvanced => '高级';

  @override
  String get autoSwitcherStatusNotInitialized => '未初始化';

  @override
  String get mainWindowFooterReady => '就绪';

  @override
  String get authErrorTokenRefreshFailed => '令牌刷新失败：';

  @override
  String get settingsAutoSwitcher => '自动切换';

  @override
  String get autoSwitcherStatusIdle => '空闲';

  @override
  String get updateDialogTitle => '更新可用';

  @override
  String get settingsMonitoring => '监控';

  @override
  String get autoSwitcherStatusDetectingProcess => '检测进程中';

  @override
  String get categoryMappingTitle => '分类映射';

  @override
  String get updateDialogWhatsNew => '新功能：';

  @override
  String get settingsScanIntervalLabel => '扫描间隔';

  @override
  String get autoSwitcherStatusSearchingMapping => '搜索映射中';

  @override
  String get categoryMappingSubtitle => '管理进程到分类的映射以实现自动切换';

  @override
  String get updateDialogDownloadComplete => '下载完成！准备安装。';

  @override
  String get settingsScanIntervalDescription => '检查哪个应用程序具有焦点的频率';

  @override
  String get autoSwitcherStatusUpdatingCategory => '更新分类中';

  @override
  String get categoryMappingAddMappingButton => '添加映射';

  @override
  String get updateDialogDownloadFailed => '下载失败：';

  @override
  String get settingsDebounceTimeLabel => '防抖时间';

  @override
  String get autoSwitcherStatusWaitingDebounce => '等待中（防抖）';

  @override
  String get categoryMappingErrorDialogTitle => '错误';

  @override
  String get updateDialogRemindLater => '稍后提醒';

  @override
  String get updateDialogIgnore => '忽略此版本';

  @override
  String get settingsDebounceTimeDescription => '应用更改后切换分类前的等待时间（防止快速切换）';

  @override
  String get autoSwitcherStatusError => '错误';

  @override
  String get categoryMappingStatsTotalMappings => '总映射数';

  @override
  String get updateDialogDownloadUpdate => '下载更新';

  @override
  String get settingsAutoStartMonitoringLabel => '自动开始监控';

  @override
  String get autoSwitcherControlsHeader => '控制';

  @override
  String get categoryMappingStatsUserDefined => '用户定义';

  @override
  String get updateDialogCancel => '取消';

  @override
  String get settingsAutoStartMonitoringSubtitle => 'TKit 启动时开始监控活动应用程序';

  @override
  String get autoSwitcherControlsStopMonitoring => '停止监控';

  @override
  String get categoryMappingStatsPresets => '预设';

  @override
  String get updateDialogLater => '稍后';

  @override
  String get settingsFallbackBehavior => '回退行为';

  @override
  String get autoSwitcherControlsStartMonitoring => '开始监控';

  @override
  String get categoryMappingErrorLoading => '加载映射时出错';

  @override
  String get updateDialogInstallRestart => '安装并重启';

  @override
  String get settingsFallbackBehaviorLabel => '未找到映射时';

  @override
  String get autoSwitcherControlsManualUpdate => '手动更新';

  @override
  String get categoryMappingRetryButton => '重试';

  @override
  String get updateDialogToday => '今天';

  @override
  String get settingsFallbackBehaviorDescription => '选择聚焦的应用没有分类映射时的行为';

  @override
  String get categoryMappingDeleteDialogTitle => '删除映射';

  @override
  String get autoSwitcherControlsMonitoringStatus => '监控状态';

  @override
  String get updateDialogYesterday => '昨天';

  @override
  String get settingsCustomCategory => '自定义分类';

  @override
  String get categoryMappingDeleteDialogMessage => '确定要删除此映射吗？';

  @override
  String get autoSwitcherControlsActive => '活动';

  @override
  String updateDialogDaysAgo(int days) {
    return '$days天前';
  }

  @override
  String get settingsCustomCategoryHint => '搜索分类...';

  @override
  String get categoryMappingDeleteDialogConfirm => '删除';

  @override
  String get autoSwitcherControlsInactive => '非活动';

  @override
  String updateDialogVersion(String version) {
    return '版本 $version';
  }

  @override
  String get categoryMappingDeleteDialogCancel => '取消';

  @override
  String get settingsCategorySearchUnavailable => '分类搜索将在 Twitch API 模块完成后可用';

  @override
  String get autoSwitcherControlsActiveDescription => '根据聚焦的进程自动更新分类';

  @override
  String updateDialogPublished(String date) {
    return '发布于 $date';
  }

  @override
  String get categoryMappingAddDialogEditTitle => '编辑映射';

  @override
  String get settingsApplication => '应用程序';

  @override
  String get autoSwitcherControlsInactiveDescription => '开始监控以启用自动分类更新';

  @override
  String get welcomeStepLanguage => '语言';

  @override
  String get categoryMappingAddDialogAddTitle => '添加新映射';

  @override
  String get categoryMappingAddDialogClose => '关闭';

  @override
  String get categoryMappingAddDialogProcessName => '进程名称';

  @override
  String get categoryMappingAddDialogExecutablePath => '可执行文件路径（可选）';

  @override
  String get categoryMappingAddDialogCategoryId => 'TWITCH 分类 ID';

  @override
  String get categoryMappingAddDialogCategoryName => 'TWITCH 分类名称';

  @override
  String get categoryMappingAddDialogCancel => '取消';

  @override
  String get categoryMappingAddDialogUpdate => '更新';

  @override
  String get categoryMappingAddDialogAdd => '添加';

  @override
  String get settingsAutoStartWindowsLabel => '随 Windows 自动启动';

  @override
  String get categoryMappingAddDialogCloseTooltip => '关闭';

  @override
  String get welcomeStepTwitch => 'Twitch';

  @override
  String get welcomeStepBehavior => '行为';

  @override
  String get welcomeBehaviorStepTitle => '步骤3：应用程序行为';

  @override
  String get welcomeBehaviorTitle => '应用程序行为';

  @override
  String get welcomeBehaviorDescription => '配置TKit启动和最小化时的行为。';

  @override
  String get welcomeBehaviorOptionalInfo => '这些设置可以随时在设置中更改。';

  @override
  String get settingsWindowControlsPositionLabel => '窗口控件位置';

  @override
  String get settingsWindowControlsPositionDescription =>
      '选择窗口控件（最小化、最大化、关闭）出现的位置';

  @override
  String get windowControlsPositionLeft => '左';

  @override
  String get windowControlsPositionCenter => '中';

  @override
  String get windowControlsPositionRight => '右';

  @override
  String get settingsAutoStartWindowsSubtitle => 'Windows 启动时自动启动 TKit';

  @override
  String get categoryMappingAddDialogProcessNameLabel => '进程名称';

  @override
  String get welcomeLanguageStepTitle => '步骤 1：选择您的语言';

  @override
  String get settingsStartMinimizedLabel => '启动时最小化';

  @override
  String get categoryMappingAddDialogProcessNameHint =>
      '例如：League of Legends.exe';

  @override
  String get welcomeLanguageChangeLater => '您可以稍后在设置中更改。';

  @override
  String get settingsStartMinimizedSubtitle => '将 TKit 最小化到系统托盘启动';

  @override
  String get categoryMappingAddDialogProcessNameRequired => '进程名称为必填项';

  @override
  String get welcomeTwitchStepTitle => '步骤 2：连接到 TWITCH';

  @override
  String get settingsMinimizeToTrayLabel => '最小化到系统托盘';

  @override
  String get categoryMappingAddDialogExecutablePathLabel => '可执行文件路径（可选）';

  @override
  String get welcomeTwitchConnectionTitle => 'Twitch 连接';

  @override
  String get settingsMinimizeToTraySubtitle => '关闭或最小化时让 TKit 在后台运行';

  @override
  String get categoryMappingAddDialogExecutablePathHint =>
      '例如：C:\\Games\\LeagueOfLegends\\Game\\League of Legends.exe';

  @override
  String welcomeTwitchConnectedAs(String username) {
    return '已连接为 $username';
  }

  @override
  String get settingsShowNotificationsLabel => '显示通知';

  @override
  String get categoryMappingAddDialogCategoryIdLabel => 'TWITCH 分类 ID';

  @override
  String get welcomeTwitchDescription => '连接您的 Twitch 账户以启用基于活动应用程序的自动分类切换。';

  @override
  String get settingsShowNotificationsSubtitle => '分类更新时显示通知';

  @override
  String get settingsNotifyMissingCategoryLabel => '缺少分类时通知';

  @override
  String get settingsNotifyMissingCategorySubtitle => '未找到游戏或应用程序的映射时显示通知';

  @override
  String get categoryMappingAddDialogCategoryIdHint => '例如：21779';

  @override
  String get welcomeTwitchOptionalInfo => '此步骤是可选的。您可以跳过并稍后在设置中进行配置。';

  @override
  String get settingsKeyboardShortcuts => '键盘快捷键';

  @override
  String get categoryMappingAddDialogCategoryIdRequired => '分类 ID 为必填项';

  @override
  String get welcomeTwitchAuthorizeButton => '使用 TWITCH 授权';

  @override
  String get settingsManualUpdateHotkeyLabel => '手动更新快捷键';

  @override
  String get categoryMappingAddDialogCategoryNameLabel => 'TWITCH 分类名称';

  @override
  String get welcomeButtonNext => '下一步';

  @override
  String get settingsManualUpdateHotkeyDescription => '触发手动分类更新';

  @override
  String get categoryMappingAddDialogCategoryNameHint => '例如：League of Legends';

  @override
  String get welcomeButtonBack => '返回';

  @override
  String get settingsUnsavedChanges => '您有未保存的更改';

  @override
  String get categoryMappingAddDialogCategoryNameRequired => '分类名称为必填项';

  @override
  String get settingsDiscard => '放弃';

  @override
  String get categoryMappingAddDialogTip => '提示：使用 Twitch 分类搜索查找正确的 ID 和名称';

  @override
  String get settingsSave => '保存';

  @override
  String get categoryMappingAddDialogCancelButton => '取消';

  @override
  String get settingsTwitchConnection => 'Twitch 连接';

  @override
  String get categoryMappingAddDialogUpdateButton => '更新';

  @override
  String get settingsTwitchStatusConnected => '已连接';

  @override
  String get categoryMappingAddDialogAddButton => '添加';

  @override
  String get settingsTwitchStatusNotConnected => '未连接';

  @override
  String get categoryMappingListEmpty => '尚无分类映射';

  @override
  String get categoryMappingListEmptyTitle => '尚无分类映射';

  @override
  String get settingsTwitchLoggedInAs => '已登录为：';

  @override
  String get categoryMappingListEmptySubtitle => '添加您的第一个映射以开始';

  @override
  String get settingsTwitchDisconnect => '断开连接';

  @override
  String get categoryMappingListColumnProcessName => '进程名称';

  @override
  String get settingsTwitchConnectDescription => '连接您的 Twitch 账户以启用自动分类切换。';

  @override
  String get categoryMappingListColumnCategory => '分类';

  @override
  String get settingsTwitchConnect => '连接到 Twitch';

  @override
  String get categoryMappingListColumnLastUsed => '最后使用';

  @override
  String get hotkeyInputCancel => '取消';

  @override
  String get categoryMappingListColumnType => '类型';

  @override
  String get hotkeyInputChange => '更改';

  @override
  String get categoryMappingListColumnActions => '操作';

  @override
  String get hotkeyInputClearHotkey => '清除快捷键';

  @override
  String get categoryMappingListIdPrefix => 'ID：';

  @override
  String categoryMappingListCategoryId(String categoryId) {
    return 'ID：$categoryId';
  }

  @override
  String get categoryMappingListNever => '从未';

  @override
  String get categoryMappingListJustNow => '刚刚';

  @override
  String categoryMappingListMinutesAgo(int minutes) {
    return '$minutes分钟前';
  }

  @override
  String categoryMappingListHoursAgo(int hours) {
    return '$hours小时前';
  }

  @override
  String categoryMappingListDaysAgo(int days) {
    return '$days天前';
  }

  @override
  String get hotkeyInputSetHotkey => '设置快捷键';

  @override
  String get categoryMappingListNeverUsed => '从未';

  @override
  String get categoryMappingListTypeUser => '用户';

  @override
  String get categoryMappingListTypePreset => '预设';

  @override
  String get categoryMappingListEditTooltip => '编辑映射';

  @override
  String get categoryMappingListDeleteTooltip => '删除映射';

  @override
  String get categoryMappingListTimeJustNow => '刚刚';

  @override
  String get categoryMappingProviderSuccessAdded => '映射已成功添加';

  @override
  String get categoryMappingProviderSuccessUpdated => '映射已成功更新';

  @override
  String get categoryMappingProviderSuccessDeleted => '映射已成功删除';

  @override
  String get commonCancel => '取消';

  @override
  String get commonOk => '确定';

  @override
  String get commonConfirm => '确认';

  @override
  String get autoSwitcherProviderErrorPrefix => '失败';

  @override
  String get autoSwitcherProviderStartMonitoring => '开始监控';

  @override
  String get autoSwitcherProviderStopMonitoring => '停止监控';

  @override
  String get autoSwitcherProviderManualUpdate => '执行手动更新';

  @override
  String get autoSwitcherProviderLoadHistory => '加载历史记录';

  @override
  String get autoSwitcherProviderClearHistory => '清除历史记录';

  @override
  String get autoSwitcherProviderSuccessCategoryUpdated => '分类已成功更新';

  @override
  String get autoSwitcherProviderSuccessHistoryCleared => '历史记录已成功清除';

  @override
  String get autoSwitcherProviderErrorUnknown => '未知错误';

  @override
  String get settingsFactoryReset => '恢复出厂设置';

  @override
  String get settingsFactoryResetDescription => '将所有设置和数据重置为出厂默认值';

  @override
  String get settingsFactoryResetButton => '重置为出厂默认值';

  @override
  String get settingsFactoryResetDialogTitle => '恢复出厂设置';

  @override
  String get settingsFactoryResetDialogMessage =>
      '所有设置、本地数据库和本地创建的所有分类都将丢失。您确定要继续吗？';

  @override
  String get settingsFactoryResetDialogConfirm => '重置';

  @override
  String get settingsFactoryResetSuccess => '应用程序已成功重置为出厂默认值。请重新启动应用程序。';

  @override
  String get settingsUpdates => '更新';

  @override
  String get settingsUpdateChannelLabel => '更新频道';

  @override
  String get settingsUpdateChannelDescription => '选择您想要接收的更新类型';

  @override
  String settingsUpdateChannelChanged(String channel) {
    return '更新频道已更改为$channel。正在检查更新...';
  }

  @override
  String get updateChannelStable => '稳定版';

  @override
  String get updateChannelStableDesc => '推荐给大多数用户。仅稳定版本。';

  @override
  String get updateChannelRc => 'Release Candidate';

  @override
  String get updateChannelRcDesc => '稳定版发布前的最终测试功能。';

  @override
  String get updateChannelBeta => 'Beta';

  @override
  String get updateChannelBetaDesc => '大部分稳定的新功能。可能有错误。';

  @override
  String get updateChannelDev => '开发版';

  @override
  String get updateChannelDevDesc => '最前沿功能。预计会有错误和不稳定性。';

  @override
  String get fallbackBehaviorDoNothing => '不执行任何操作';

  @override
  String get fallbackBehaviorJustChatting => 'Just Chatting';

  @override
  String get fallbackBehaviorCustom => '自定义分类';

  @override
  String get unknownGameDialogTitle => 'Game Not Mapped';

  @override
  String get unknownGameDialogStepCategory => '类别';

  @override
  String get unknownGameDialogStepDestination => '目标';

  @override
  String get unknownGameDialogStepConfirm => '确认';

  @override
  String get unknownGameDialogConfirmHeader => '审查并确认';

  @override
  String get unknownGameDialogConfirmDescription => '请在保存前检查您的选择';

  @override
  String get unknownGameDialogConfirmCategory => 'TWITCH类别';

  @override
  String get unknownGameDialogConfirmDestination => '目标列表';

  @override
  String get unknownGameDialogBack => '返回';

  @override
  String get unknownGameDialogNext => '下一步';

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
  String get unknownGameDialogCategoryHeader => '选择Twitch类别';

  @override
  String get unknownGameDialogCategoryDescription => '搜索并选择此游戏的Twitch类别';

  @override
  String get unknownGameDialogListHeader => '选择目标';

  @override
  String get unknownGameDialogListDescription => '选择保存此映射的位置';

  @override
  String get unknownGameDialogNoWritableLists => '没有可写列表';

  @override
  String get unknownGameDialogNoWritableListsHint => '在类别映射中创建本地列表以保存自定义映射';

  @override
  String get unknownGameDialogLocalListsHeader => '本地映射';

  @override
  String get unknownGameDialogSubmissionListsHeader => '社区提交';

  @override
  String get unknownGameDialogWorkflowHeader => '提交工作流程';

  @override
  String get unknownGameDialogWorkflowCompactNote => '首先保存到本地，然后提交给社区审批';

  @override
  String get unknownGameDialogWorkflowLearnMore => '了解更多';

  @override
  String get unknownGameDialogWorkflowStep1Title => '本地保存（立即）';

  @override
  String get unknownGameDialogWorkflowStep1Description => '映射被添加到您的本地列表并立即生效';

  @override
  String get unknownGameDialogWorkflowStep2Title => '已提交审核';

  @override
  String get unknownGameDialogWorkflowStep2Description => '您的映射已提交给社区进行审批';

  @override
  String get unknownGameDialogWorkflowStep3Title => '合并到官方';

  @override
  String get unknownGameDialogWorkflowStep3Description =>
      '一旦获得批准，它将出现在官方映射中并从您的本地列表中删除';

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
  String get unknownGameDialogThankYouTitle => '谢谢！';

  @override
  String get unknownGameDialogThankYouMessage => '您的贡献帮助社区成长！';

  @override
  String get versionStatusUpToDate => '已是最新';

  @override
  String get versionStatusUpdateAvailable => '有可用更新';

  @override
  String versionStatusCheckFailed(String error) {
    return '更新检查失败：$error';
  }

  @override
  String get versionStatusNotInitialized => '更新服务未初始化';

  @override
  String get versionStatusPlatformNotSupported => '此平台不支持更新';

  @override
  String get notificationMissingCategoryTitle => '未找到类别映射';

  @override
  String notificationMissingCategoryBody(String processName) {
    return '未找到 $processName 的 Twitch 类别';
  }

  @override
  String get notificationActionAssignCategory => '分配类别';

  @override
  String get notificationCategoryUpdatedTitle => '类别已更新';

  @override
  String notificationCategoryUpdatedBody(
    String categoryName,
    String processName,
  ) {
    return '已为 $processName 切换到\"$categoryName\"';
  }

  @override
  String get mappingListColumnSource => '来源';

  @override
  String get mappingListColumnEnabled => '已启用';

  @override
  String get mappingListTooltipIgnored => '此类别已被忽略';

  @override
  String mappingListTooltipTwitchId(String twitchCategoryId) {
    return 'Twitch ID：$twitchCategoryId';
  }

  @override
  String get mappingListCategoryIgnored => '已忽略';

  @override
  String get mappingListSourceUnknown => '未知';

  @override
  String mappingListSelected(int count) {
    return '已选择 $count 项';
  }

  @override
  String mappingListSelectedVisible(int count, int visible) {
    return '已选择 $count 项（$visible 项可见）';
  }

  @override
  String get mappingListButtonInvert => '反选';

  @override
  String get mappingListButtonClear => '清除';

  @override
  String mappingListButtonUndo(String action) {
    return '撤销$action';
  }

  @override
  String get mappingListButtonExport => '导出';

  @override
  String get mappingListButtonEnable => '启用';

  @override
  String get mappingListButtonDisable => '禁用';

  @override
  String get mappingListButtonDelete => '删除';

  @override
  String get mappingListTooltipCannotDelete => '无法删除只读列表中的映射';

  @override
  String get mappingListTooltipDelete => '删除选定的映射';

  @override
  String get mappingListSearchHint => '按进程名称或类别搜索...';

  @override
  String get mappingListTooltipClearSearch => '清除搜索';

  @override
  String get listManagementEmptyState => '未找到列表';

  @override
  String get listManagementTitle => '管理列表';

  @override
  String get listManagementSyncNow => '立即同步';

  @override
  String get listManagementBadgeLocal => '本地';

  @override
  String get listManagementBadgeOfficial => '官方';

  @override
  String get listManagementBadgeRemote => '远程';

  @override
  String get listManagementBadgeReadOnly => '只读';

  @override
  String get listManagementButtonImport => '导入列表';

  @override
  String get listManagementButtonSyncAll => '全部同步';

  @override
  String get listManagementButtonClose => '关闭';

  @override
  String get listManagementImportTitle => '导入列表';

  @override
  String get listManagementImportUrl => '列表 URL';

  @override
  String get listManagementImportUrlPlaceholder =>
      'https://example.com/mappings.json';

  @override
  String get listManagementImportName => '列表名称（可选）';

  @override
  String get listManagementImportNameHelper => '如果未提供，将使用 JSON 文件中的名称';

  @override
  String get listManagementImportNamePlaceholder => '我的自定义列表';

  @override
  String get listManagementImportDescription => '描述（可选）';

  @override
  String get listManagementImportDescriptionHelper => '如果未提供，将使用 JSON 文件中的描述';

  @override
  String get listManagementImportDescriptionPlaceholder => '游戏映射集合';

  @override
  String get listManagementButtonCancel => '取消';

  @override
  String get listManagementButtonImportConfirm => '导入';

  @override
  String get listManagementDefaultName => '已导入的列表';

  @override
  String get listManagementImportSuccess => '列表导入成功';

  @override
  String get listManagementSyncNever => '从未';

  @override
  String get listManagementSyncJustNow => '刚刚';

  @override
  String listManagementSyncMinutesAgo(int minutes) {
    return '$minutes分钟前';
  }

  @override
  String listManagementSyncHoursAgo(int hours) {
    return '$hours小时前';
  }

  @override
  String listManagementSyncDaysAgo(int days) {
    return '$days天前';
  }

  @override
  String listManagementSyncDaysHoursAgo(int days, int hours) {
    return '$days天$hours小时前';
  }

  @override
  String listManagementMappingsCount(int count) {
    return '$count 个映射';
  }

  @override
  String get listManagementSyncFailed => '同步失败：';

  @override
  String get listManagementLastSynced => '上次同步：';

  @override
  String get unknownGameIgnoreProcess => '忽略进程';

  @override
  String unknownGameCategoryId(String id) {
    return 'ID：$id';
  }

  @override
  String get unknownGameSubmissionTitle => '需要提交';

  @override
  String get unknownGameSubmissionInfo =>
      '此映射将保存在本地并提交给列表所有者进行审批。一旦获得批准并同步，您的本地副本将被自动替换。';

  @override
  String get unknownGameSectionLists => '列表';

  @override
  String unknownGameListMappingCount(int count) {
    return '$count 个映射';
  }

  @override
  String get unknownGameBadgeStaged => '已暂存';

  @override
  String get unknownGameIgnoredProcess => '已忽略的进程';

  @override
  String unknownGameSelectedCategoryId(String id) {
    return 'ID：$id';
  }

  @override
  String get unknownGameWorkflowTitle => '提交工作流程';

  @override
  String get unknownGameWorkflowTitleAlt => '接下来会发生什么';

  @override
  String get unknownGameWorkflowStepLocal => '保存到我的自定义映射';

  @override
  String get unknownGameWorkflowStepLocalDesc => '首先存储在您的设备上，因此映射立即生效';

  @override
  String unknownGameWorkflowStepSubmit(String listName) {
    return '提交到 $listName';
  }

  @override
  String get unknownGameWorkflowStepSubmitDesc => '自动发送给列表所有者进行审核和批准';

  @override
  String get unknownGameWorkflowStepReplace => '批准后替换本地副本';

  @override
  String unknownGameWorkflowStepReplaceDesc(String listName) {
    return '一旦接受并同步，您的本地副本将被删除并替换为 $listName 中的官方版本';
  }

  @override
  String unknownGameSavedTo(String listName) {
    return '已保存到 $listName';
  }

  @override
  String get unknownGameIgnoredInfo => '此进程将被忽略，不会触发通知';

  @override
  String get unknownGameLocalSaveInfo => '您的映射已保存在本地，将立即生效';

  @override
  String get unknownGamePrivacyInfo => '此映射是私有的，仅存储在您的设备上';

  @override
  String autoSwitcherError(String error) {
    return '错误：$error';
  }

  @override
  String get autoSwitcherStatusActive => '自动切换已激活';

  @override
  String get autoSwitcherStatusInactive => '未监控';

  @override
  String get autoSwitcherLabelActiveApp => '活动应用';

  @override
  String get autoSwitcherLabelCategory => '类别';

  @override
  String get autoSwitcherValueNone => '无';

  @override
  String get autoSwitcherDescriptionActive => '当您切换应用时，类别会自动更改。';

  @override
  String get autoSwitcherButtonTurnOff => '关闭';

  @override
  String get autoSwitcherInstructionPress => '按';

  @override
  String get autoSwitcherInstructionManual => '手动更新到焦点进程';

  @override
  String get autoSwitcherHeadingEnable => '启用自动切换';

  @override
  String get autoSwitcherDescriptionInactive => '当您在应用之间切换时，类别将自动更改。';

  @override
  String get autoSwitcherButtonTurnOn => '开启';

  @override
  String get autoSwitcherInstructionOr => '或按';

  @override
  String get settingsTabMappings => '映射';

  @override
  String get settingsTabTheme => '主题';

  @override
  String get settingsAutoSyncOnStart => '启动时自动同步映射';

  @override
  String get settingsAutoSyncOnStartDesc => '应用程序启动时自动同步映射列表';

  @override
  String get settingsAutoSyncInterval => '自动同步间隔';

  @override
  String get settingsAutoSyncIntervalDesc => '自动同步映射列表的频率（0 = 从不）';

  @override
  String get settingsAutoSyncNever => '从不';

  @override
  String get settingsTimingTitle => '这些设置如何协同工作';

  @override
  String settingsTimingStep1(int scanInterval) {
    return '应用每 $scanInterval 秒检查焦点窗口';
  }

  @override
  String get settingsTimingStep2Instant => '检测到新应用后立即切换类别';

  @override
  String settingsTimingStep2Debounce(int debounce) {
    return '检测到新应用后等待 $debounce 秒（防抖）';
  }

  @override
  String settingsTimingStep3Instant(int scanInterval) {
    return '总切换时间：$scanInterval 秒（检测后立即切换）';
  }

  @override
  String settingsTimingStep3Debounce(int scanInterval, int scanDebounce) {
    return '总切换时间：$scanInterval 秒到 $scanDebounce 秒';
  }

  @override
  String get settingsFramelessWindow => '使用无边框窗口';

  @override
  String get settingsFramelessWindowDesc => '移除 Windows 标题栏，呈现带圆角的现代无边框外观';

  @override
  String get settingsInvertLayout => '反转页脚/页眉';

  @override
  String get settingsInvertLayoutDesc => '交换页眉和页脚部分的位置';

  @override
  String get settingsTokenExpired => '已过期';

  @override
  String settingsTokenExpiresDays(int days, int hours) {
    return '$days天$hours小时后过期';
  }

  @override
  String settingsTokenExpiresHours(int hours, int minutes) {
    return '$hours小时$minutes分钟后过期';
  }

  @override
  String settingsTokenExpiresMinutes(int minutes) {
    return '$minutes分钟后过期';
  }

  @override
  String get settingsResetDesc => '将所有设置和数据重置为出厂默认值';

  @override
  String get settingsButtonReset => '重置';

  @override
  String mappingEditorSummary(
    int count,
    String plural,
    int lists,
    String pluralLists,
  ) {
    return '来自 $lists 个活动列表的 $count 个进程映射$plural';
  }

  @override
  String mappingEditorBreakdown(int custom, int community) {
    return '$custom 个自定义，$community 个来自社区列表';
  }

  @override
  String get mappingEditorButtonLists => '列表';

  @override
  String get mappingEditorButtonAdd => '添加';

  @override
  String get mappingEditorDeleteTitle => '删除多个映射';

  @override
  String mappingEditorDeleteMessage(int count, String plural) {
    return '确定要删除 $count 个映射$plural吗？此操作无法撤销。';
  }

  @override
  String get mappingEditorExportTitle => '导出映射';

  @override
  String get mappingEditorExportFilename => 'my-mappings.json';

  @override
  String mappingEditorExportSuccess(int count, String plural) {
    return '已将 $count 个映射$plural导出到';
  }

  @override
  String get mappingEditorExportFailed => '导出失败';

  @override
  String get addMappingPrivacySafe => '隐私安全路径';

  @override
  String get addMappingCustomLocation => '自定义位置';

  @override
  String get addMappingOnlyFolder => '仅存储游戏文件夹名称';

  @override
  String get addMappingNotStored => '为保护隐私不存储路径';

  @override
  String get colorPickerTitle => '选择颜色';

  @override
  String get colorPickerHue => '色调';

  @override
  String get colorPickerSaturation => '饱和度';

  @override
  String get colorPickerValue => '亮度';

  @override
  String get colorPickerButtonCancel => '取消';

  @override
  String get colorPickerButtonSelect => '选择';

  @override
  String get dropdownPlaceholder => '选择一个选项';

  @override
  String get dropdownSearchHint => '搜索...';

  @override
  String get dropdownNoResults => '未找到结果';

  @override
  String paginationPageInfo(int current, int total) {
    return '第 $current 页，共 $total 页';
  }

  @override
  String get paginationGoTo => '跳转到：';

  @override
  String get datePickerPlaceholder => '选择日期';

  @override
  String get timePickerAM => '上午';

  @override
  String get timePickerPM => '下午';

  @override
  String get timePickerPlaceholder => '选择时间';

  @override
  String get fileUploadInstruction => '点击上传文件';

  @override
  String fileUploadAllowed(String extensions) {
    return '允许：$extensions';
  }

  @override
  String get menuButtonTooltip => '更多选项';

  @override
  String get breadcrumbEllipsis => '...';

  @override
  String get breadcrumbTooltipShowPath => '显示路径';

  @override
  String get hotkeyModCtrl => 'Ctrl';

  @override
  String get hotkeyModAlt => 'Alt';

  @override
  String get hotkeyModShift => 'Shift';

  @override
  String get hotkeyModWin => 'Win';

  @override
  String get hotkeySpace => '空格';

  @override
  String get hotkeyEnter => '回车';

  @override
  String get hotkeyTab => 'Tab';

  @override
  String get hotkeyBackspace => '退格';

  @override
  String get hotkeyDelete => '删除';

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
  String get statusDashboardCurrentActivity => '当前活动';

  @override
  String get statusDashboardNotStarted => '未开始';

  @override
  String get statusDashboardReady => '就绪';

  @override
  String get statusDashboardCheckingApp => '检查活动应用';

  @override
  String get statusDashboardFindingCategory => '查找类别';

  @override
  String get statusDashboardUpdating => '更新类别';

  @override
  String get statusDashboardWaiting => '等待确认';

  @override
  String get statusDashboardError => '发生错误';

  @override
  String mappingListOfCount(int count, int total) {
    return '$count / $total';
  }

  @override
  String get mappingListActionDelete => '删除';

  @override
  String get mappingListActionEnable => '启用';

  @override
  String get mappingListActionDisable => '禁用';

  @override
  String autoSwitcherTimeSecondsAgo(int seconds) {
    return '$seconds秒前';
  }

  @override
  String autoSwitcherTimeMinutesAgo(int minutes) {
    return '$minutes分钟前';
  }

  @override
  String autoSwitcherTimeHoursAgo(int hours) {
    return '$hours小时前';
  }
}
