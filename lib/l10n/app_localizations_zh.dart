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
}
