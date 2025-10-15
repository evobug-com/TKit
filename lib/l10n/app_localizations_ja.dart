// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'TKit';

  @override
  String get welcomeTitle => 'TKitへようこそ';

  @override
  String get selectLanguage => '言語を選択してください';

  @override
  String get languageLabel => '言語';

  @override
  String get continueButton => '続ける';

  @override
  String get confirm => '確認';

  @override
  String get hello => 'こんにちは';

  @override
  String get languageNativeName => '日本語';

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
  String get settingsLanguage => '言語';

  @override
  String get settingsLanguageDescription => 'アプリケーションの優先言語を選択してください';

  @override
  String get languageChangeNotice => '言語が変更されました。アプリケーションは直ちに更新されます。';

  @override
  String get authSuccessAuthenticatedAs => 'として正常に認証されました';

  @override
  String get systemTrayShowTkit => 'TKitを表示';

  @override
  String get authConnectToTwitch => 'Twitchに接続';

  @override
  String get systemTrayAutoSwitcher => '自動切替';

  @override
  String get authLoading => '読み込み中...';

  @override
  String get systemTrayCategoryMappings => 'カテゴリマッピング';

  @override
  String get authRefreshingToken => 'トークンを更新中...';

  @override
  String get systemTraySettings => '設定';

  @override
  String get authSuccessfullyAuthenticated => '正常に認証されました';

  @override
  String get systemTrayExit => '終了';

  @override
  String get authLoggedInAs => 'としてログイン中';

  @override
  String get systemTrayTooltip => 'TKit - Twitchツールキット';

  @override
  String get authErrorAuthenticationFailed => '認証に失敗しました';

  @override
  String get authErrorErrorCode => 'エラーコード：';

  @override
  String get authTryAgain => '再試行';

  @override
  String get authAuthorizationSteps => '認証手順';

  @override
  String get authStep1 => '下の「Twitchに接続」ボタンをクリックしてください';

  @override
  String get authStep2 => 'ブラウザでTwitchの認証ページが開きます';

  @override
  String get authStep3 => 'TKitがチャンネルを管理することを確認し承認してください';

  @override
  String get authStep4 => '認証後、このウィンドウに戻ってください';

  @override
  String get authConnectToTwitchButton => 'TWITCHに接続';

  @override
  String get authRequiresAccessMessage =>
      'TKitはTwitchチャンネルのカテゴリを更新するためのアクセスが必要です。';

  @override
  String get authDeviceCodeTitle => 'Twitchに接続';

  @override
  String get authDeviceCodeInstructions =>
      'Twitchアカウントを接続するには、次の簡単な手順に従ってください：';

  @override
  String get authDeviceCodeStep1 => '次のURLにアクセス';

  @override
  String get authDeviceCodeStep2 => 'このコードを入力してください：';

  @override
  String get authDeviceCodeStep3 => 'TKitがチャンネルカテゴリを管理することを承認してください';

  @override
  String get authDeviceCodeCodeLabel => 'あなたのコード';

  @override
  String get authDeviceCodeCopyCode => 'コードをコピー';

  @override
  String get authDeviceCodeCopied => 'コピーしました！';

  @override
  String get authDeviceCodeOpenBrowser => 'twitch.tv/activateを開く';

  @override
  String get authDeviceCodeWaiting => '承認を待っています...';

  @override
  String authDeviceCodeExpiresIn(String minutes, String seconds) {
    return 'コードの有効期限：$minutes:$seconds';
  }

  @override
  String get authDeviceCodeExpired => 'コードが期限切れです。もう一度お試しください。';

  @override
  String get authDeviceCodeCancel => 'キャンセル';

  @override
  String get authDeviceCodeSuccess => '接続に成功しました！';

  @override
  String get authDeviceCodeError => '接続に失敗しました。もう一度お試しください。';

  @override
  String get authDeviceCodeHelp =>
      '問題が発生していますか？ブラウザでTwitchにログインしていることを確認してください。';

  @override
  String get autoSwitcherPageTitle => '自動切替';

  @override
  String get authStatusAuthenticated => '認証済み';

  @override
  String get autoSwitcherPageDescription =>
      'フォーカスされたアプリケーションに基づいてストリームカテゴリを自動的に更新します';

  @override
  String get authStatusConnecting => '接続中...';

  @override
  String get autoSwitcherStatusHeader => 'ステータス';

  @override
  String get authStatusError => 'エラー';

  @override
  String get autoSwitcherStatusCurrentProcess => '現在のプロセス';

  @override
  String get authStatusNotConnected => '未接続';

  @override
  String get autoSwitcherStatusNone => 'なし';

  @override
  String get autoSwitcherStatusMatchedCategory => '一致したカテゴリ';

  @override
  String get mainWindowNavAutoSwitcher => '自動切替';

  @override
  String get autoSwitcherStatusLastUpdate => '最終更新';

  @override
  String get mainWindowNavMappings => 'マッピング';

  @override
  String get autoSwitcherStatusNever => 'なし';

  @override
  String get mainWindowNavSettings => '設定';

  @override
  String get mainWindowStatusConnected => '接続済み';

  @override
  String get autoSwitcherStatusUpdateStatus => '更新ステータス';

  @override
  String get mainWindowStatusDisconnected => '切断済み';

  @override
  String get autoSwitcherStatusNoUpdatesYet => 'まだ更新がありません';

  @override
  String get mainWindowWindowControlMinimize => '最小化';

  @override
  String get autoSwitcherStatusSuccess => '成功';

  @override
  String get authLoadingStartingAuthentication => '認証を開始しています...';

  @override
  String get mainWindowWindowControlMaximize => '最大化';

  @override
  String get autoSwitcherStatusFailed => '失敗';

  @override
  String get authLoadingLoggingOut => 'ログアウト中...';

  @override
  String get settingsSavedSuccessfully => '設定が正常に保存されました';

  @override
  String get autoSwitcherStatusSystemState => 'システム状態';

  @override
  String get mainWindowWindowControlClose => '閉じる';

  @override
  String get authLoadingCheckingStatus => '認証ステータスを確認中...';

  @override
  String get settingsRetry => '再試行';

  @override
  String get settingsPageTitle => '設定';

  @override
  String get settingsPageDescription => 'アプリケーションの動作と設定を構成';

  @override
  String get settingsTabGeneral => '一般';

  @override
  String get settingsTabAutoSwitcher => '自動切り替え';

  @override
  String get settingsTabKeyboard => 'キーボード';

  @override
  String get settingsTabTwitch => 'Twitch';

  @override
  String get settingsTabAdvanced => '詳細';

  @override
  String get autoSwitcherStatusNotInitialized => '未初期化';

  @override
  String get mainWindowFooterReady => '準備完了';

  @override
  String get authErrorTokenRefreshFailed => 'トークンの更新に失敗しました：';

  @override
  String get settingsAutoSwitcher => '自動切替';

  @override
  String get autoSwitcherStatusIdle => 'アイドル';

  @override
  String get updateDialogTitle => 'アップデートが利用可能です';

  @override
  String get settingsMonitoring => '監視';

  @override
  String get autoSwitcherStatusDetectingProcess => 'プロセスを検出中';

  @override
  String get categoryMappingTitle => 'カテゴリマッピング';

  @override
  String get updateDialogWhatsNew => '新機能：';

  @override
  String get settingsScanIntervalLabel => 'スキャン間隔';

  @override
  String get autoSwitcherStatusSearchingMapping => 'マッピングを検索中';

  @override
  String get categoryMappingSubtitle => '自動切替のためのプロセスとカテゴリのマッピングを管理します';

  @override
  String get updateDialogDownloadComplete => 'ダウンロード完了！インストールの準備ができました。';

  @override
  String get settingsScanIntervalDescription => 'どのアプリケーションにフォーカスがあるかを確認する頻度';

  @override
  String get autoSwitcherStatusUpdatingCategory => 'カテゴリを更新中';

  @override
  String get categoryMappingAddMappingButton => 'マッピングを追加';

  @override
  String get updateDialogDownloadFailed => 'ダウンロードに失敗しました：';

  @override
  String get settingsDebounceTimeLabel => 'デバウンス時間';

  @override
  String get autoSwitcherStatusWaitingDebounce => '待機中（デバウンス）';

  @override
  String get categoryMappingErrorDialogTitle => 'エラー';

  @override
  String get updateDialogRemindLater => '後で通知する';

  @override
  String get settingsDebounceTimeDescription =>
      'アプリ変更後にカテゴリを切り替えるまでの待機時間（高速な切り替えを防止）';

  @override
  String get autoSwitcherStatusError => 'エラー';

  @override
  String get categoryMappingStatsTotalMappings => '合計マッピング';

  @override
  String get updateDialogDownloadUpdate => 'アップデートをダウンロード';

  @override
  String get settingsAutoStartMonitoringLabel => '監視を自動的に開始';

  @override
  String get autoSwitcherControlsHeader => 'コントロール';

  @override
  String get categoryMappingStatsUserDefined => 'ユーザー定義';

  @override
  String get updateDialogCancel => 'キャンセル';

  @override
  String get settingsAutoStartMonitoringSubtitle =>
      'TKit起動時にアクティブなアプリケーションの監視を開始します';

  @override
  String get autoSwitcherControlsStopMonitoring => '監視を停止';

  @override
  String get categoryMappingStatsPresets => 'プリセット';

  @override
  String get updateDialogLater => '後で';

  @override
  String get settingsFallbackBehavior => 'フォールバック動作';

  @override
  String get autoSwitcherControlsStartMonitoring => '監視を開始';

  @override
  String get categoryMappingErrorLoading => 'マッピングの読み込みエラー';

  @override
  String get updateDialogInstallRestart => 'インストールして再起動';

  @override
  String get settingsFallbackBehaviorLabel => 'マッピングが見つからない場合';

  @override
  String get autoSwitcherControlsManualUpdate => '手動更新';

  @override
  String get categoryMappingRetryButton => '再試行';

  @override
  String get updateDialogToday => '今日';

  @override
  String get settingsFallbackBehaviorDescription =>
      'フォーカスされたアプリにカテゴリマッピングがない場合の動作を選択します';

  @override
  String get categoryMappingDeleteDialogTitle => 'マッピングを削除';

  @override
  String get autoSwitcherControlsMonitoringStatus => '監視ステータス';

  @override
  String get updateDialogYesterday => '昨日';

  @override
  String get settingsCustomCategory => 'カスタムカテゴリ';

  @override
  String get categoryMappingDeleteDialogMessage => 'このマッピングを削除してもよろしいですか？';

  @override
  String get autoSwitcherControlsActive => 'アクティブ';

  @override
  String updateDialogDaysAgo(int days) {
    return '$days日前';
  }

  @override
  String get settingsCustomCategoryHint => 'カテゴリを検索...';

  @override
  String get categoryMappingDeleteDialogConfirm => '削除';

  @override
  String get autoSwitcherControlsInactive => '非アクティブ';

  @override
  String updateDialogVersion(String version) {
    return 'バージョン $version';
  }

  @override
  String get categoryMappingDeleteDialogCancel => 'キャンセル';

  @override
  String get settingsCategorySearchUnavailable =>
      'カテゴリ検索はTwitch APIモジュールの完成時に利用可能になります';

  @override
  String get autoSwitcherControlsActiveDescription =>
      'フォーカスされたプロセスに基づいてカテゴリを自動的に更新しています';

  @override
  String updateDialogPublished(String date) {
    return '$dateに公開';
  }

  @override
  String get categoryMappingAddDialogEditTitle => 'マッピングを編集';

  @override
  String get settingsApplication => 'アプリケーション';

  @override
  String get autoSwitcherControlsInactiveDescription =>
      '監視を開始してカテゴリの自動更新を有効にしてください';

  @override
  String get welcomeStepLanguage => '言語';

  @override
  String get categoryMappingAddDialogAddTitle => '新しいマッピングを追加';

  @override
  String get categoryMappingAddDialogClose => '閉じる';

  @override
  String get categoryMappingAddDialogProcessName => 'プロセス名';

  @override
  String get categoryMappingAddDialogExecutablePath => '実行可能ファイルパス（オプション）';

  @override
  String get categoryMappingAddDialogCategoryId => 'TwitchカテゴリID';

  @override
  String get categoryMappingAddDialogCategoryName => 'Twitchカテゴリ名';

  @override
  String get categoryMappingAddDialogCancel => 'キャンセル';

  @override
  String get categoryMappingAddDialogUpdate => '更新';

  @override
  String get categoryMappingAddDialogAdd => '追加';

  @override
  String get settingsAutoStartWindowsLabel => 'Windows起動時に自動起動';

  @override
  String get categoryMappingAddDialogCloseTooltip => '閉じる';

  @override
  String get welcomeStepTwitch => 'Twitch';

  @override
  String get welcomeStepBehavior => '動作';

  @override
  String get welcomeBehaviorStepTitle => 'ステップ3：アプリケーションの動作';

  @override
  String get welcomeBehaviorTitle => 'アプリケーションの動作';

  @override
  String get welcomeBehaviorDescription => 'TKitの起動時および最小化時の動作を設定します。';

  @override
  String get welcomeBehaviorOptionalInfo => 'これらの設定はいつでも設定で変更できます。';

  @override
  String get settingsWindowControlsPositionLabel => 'ウィンドウコントロールの位置';

  @override
  String get settingsWindowControlsPositionDescription =>
      'ウィンドウコントロール（最小化、最大化、閉じる）を表示する場所を選択';

  @override
  String get windowControlsPositionLeft => '左';

  @override
  String get windowControlsPositionCenter => '中央';

  @override
  String get windowControlsPositionRight => '右';

  @override
  String get settingsAutoStartWindowsSubtitle => 'Windows起動時にTKitを自動的に起動します';

  @override
  String get categoryMappingAddDialogProcessNameLabel => 'プロセス名';

  @override
  String get welcomeLanguageStepTitle => 'ステップ1：言語を選択';

  @override
  String get settingsStartMinimizedLabel => '最小化して起動';

  @override
  String get categoryMappingAddDialogProcessNameHint =>
      '例：League of Legends.exe';

  @override
  String get welcomeLanguageChangeLater => 'これは後で設定で変更できます。';

  @override
  String get settingsStartMinimizedSubtitle => 'TKitをシステムトレイに最小化して起動します';

  @override
  String get categoryMappingAddDialogProcessNameRequired => 'プロセス名は必須です';

  @override
  String get welcomeTwitchStepTitle => 'ステップ2：Twitchに接続';

  @override
  String get settingsMinimizeToTrayLabel => 'システムトレイに最小化';

  @override
  String get categoryMappingAddDialogExecutablePathLabel => '実行可能ファイルパス（オプション）';

  @override
  String get welcomeTwitchConnectionTitle => 'Twitch接続';

  @override
  String get settingsMinimizeToTraySubtitle =>
      '閉じるまたは最小化するときにTKitをバックグラウンドで実行し続けます';

  @override
  String get categoryMappingAddDialogExecutablePathHint =>
      '例：C:\\Games\\LeagueOfLegends\\Game\\League of Legends.exe';

  @override
  String welcomeTwitchConnectedAs(String username) {
    return '$usernameとして接続済み';
  }

  @override
  String get settingsShowNotificationsLabel => '通知を表示';

  @override
  String get categoryMappingAddDialogCategoryIdLabel => 'TwitchカテゴリID';

  @override
  String get welcomeTwitchDescription =>
      'Twitchアカウントを接続して、アクティブなアプリケーションに基づいたカテゴリの自動切替を有効にします。';

  @override
  String get settingsShowNotificationsSubtitle => 'カテゴリが更新されたときに通知を表示します';

  @override
  String get settingsNotifyMissingCategoryLabel => 'カテゴリがない場合に通知';

  @override
  String get settingsNotifyMissingCategorySubtitle =>
      'ゲームまたはアプリのマッピングが見つからない場合に通知を表示します';

  @override
  String get categoryMappingAddDialogCategoryIdHint => '例：21779';

  @override
  String get welcomeTwitchOptionalInfo =>
      'このステップはオプションです。スキップして後で設定で設定することができます。';

  @override
  String get settingsKeyboardShortcuts => 'キーボードショートカット';

  @override
  String get categoryMappingAddDialogCategoryIdRequired => 'カテゴリIDは必須です';

  @override
  String get welcomeTwitchAuthorizeButton => 'TWITCHで認証';

  @override
  String get settingsManualUpdateHotkeyLabel => '手動更新ホットキー';

  @override
  String get categoryMappingAddDialogCategoryNameLabel => 'Twitchカテゴリ名';

  @override
  String get welcomeButtonNext => '次へ';

  @override
  String get settingsManualUpdateHotkeyDescription => '手動カテゴリ更新をトリガーします';

  @override
  String get categoryMappingAddDialogCategoryNameHint => '例：League of Legends';

  @override
  String get welcomeButtonBack => '戻る';

  @override
  String get settingsUnsavedChanges => '保存されていない変更があります';

  @override
  String get categoryMappingAddDialogCategoryNameRequired => 'カテゴリ名は必須です';

  @override
  String get settingsDiscard => '破棄';

  @override
  String get categoryMappingAddDialogTip =>
      'ヒント：Twitchカテゴリ検索を使用して正しいIDと名前を見つけてください';

  @override
  String get settingsSave => '保存';

  @override
  String get categoryMappingAddDialogCancelButton => 'キャンセル';

  @override
  String get settingsTwitchConnection => 'Twitch接続';

  @override
  String get categoryMappingAddDialogUpdateButton => '更新';

  @override
  String get settingsTwitchStatusConnected => '接続済み';

  @override
  String get categoryMappingAddDialogAddButton => '追加';

  @override
  String get settingsTwitchStatusNotConnected => '未接続';

  @override
  String get categoryMappingListEmpty => 'カテゴリマッピングがまだありません';

  @override
  String get categoryMappingListEmptyTitle => 'カテゴリマッピングがまだありません';

  @override
  String get settingsTwitchLoggedInAs => 'ログイン中：';

  @override
  String get categoryMappingListEmptySubtitle => '最初のマッピングを追加して始めましょう';

  @override
  String get settingsTwitchDisconnect => '切断';

  @override
  String get categoryMappingListColumnProcessName => 'プロセス名';

  @override
  String get settingsTwitchConnectDescription =>
      'Twitchアカウントを接続してカテゴリの自動切替を有効にします。';

  @override
  String get categoryMappingListColumnCategory => 'カテゴリ';

  @override
  String get settingsTwitchConnect => 'Twitchに接続';

  @override
  String get categoryMappingListColumnLastUsed => '最終使用';

  @override
  String get hotkeyInputCancel => 'キャンセル';

  @override
  String get categoryMappingListColumnType => 'タイプ';

  @override
  String get hotkeyInputChange => '変更';

  @override
  String get categoryMappingListColumnActions => 'アクション';

  @override
  String get hotkeyInputClearHotkey => 'ホットキーをクリア';

  @override
  String get categoryMappingListIdPrefix => 'ID: ';

  @override
  String categoryMappingListCategoryId(String categoryId) {
    return 'ID: $categoryId';
  }

  @override
  String get categoryMappingListNever => 'なし';

  @override
  String get categoryMappingListJustNow => 'たった今';

  @override
  String categoryMappingListMinutesAgo(int minutes) {
    return '$minutes分前';
  }

  @override
  String categoryMappingListHoursAgo(int hours) {
    return '$hours時間前';
  }

  @override
  String categoryMappingListDaysAgo(int days) {
    return '$days日前';
  }

  @override
  String get hotkeyInputSetHotkey => 'ホットキーを設定';

  @override
  String get categoryMappingListNeverUsed => 'なし';

  @override
  String get categoryMappingListTypeUser => 'ユーザー';

  @override
  String get categoryMappingListTypePreset => 'プリセット';

  @override
  String get categoryMappingListEditTooltip => 'マッピングを編集';

  @override
  String get categoryMappingListDeleteTooltip => 'マッピングを削除';

  @override
  String get categoryMappingListTimeJustNow => 'たった今';

  @override
  String get categoryMappingProviderSuccessAdded => 'マッピングが正常に追加されました';

  @override
  String get categoryMappingProviderSuccessUpdated => 'マッピングが正常に更新されました';

  @override
  String get categoryMappingProviderSuccessDeleted => 'マッピングが正常に削除されました';

  @override
  String get commonCancel => 'キャンセル';

  @override
  String get commonOk => 'OK';

  @override
  String get commonConfirm => '確認';

  @override
  String get autoSwitcherProviderErrorPrefix => '失敗しました';

  @override
  String get autoSwitcherProviderStartMonitoring => '監視を開始';

  @override
  String get autoSwitcherProviderStopMonitoring => '監視を停止';

  @override
  String get autoSwitcherProviderManualUpdate => '手動更新を実行';

  @override
  String get autoSwitcherProviderLoadHistory => '履歴を読み込み';

  @override
  String get autoSwitcherProviderClearHistory => '履歴をクリア';

  @override
  String get autoSwitcherProviderSuccessCategoryUpdated => 'カテゴリが正常に更新されました';

  @override
  String get autoSwitcherProviderSuccessHistoryCleared => '履歴が正常にクリアされました';

  @override
  String get autoSwitcherProviderErrorUnknown => '不明なエラー';

  @override
  String get settingsFactoryReset => '工場出荷時設定にリセット';

  @override
  String get settingsFactoryResetDescription => 'すべての設定とデータを工場出荷時の状態にリセットします';

  @override
  String get settingsFactoryResetButton => '工場出荷時の状態にリセット';

  @override
  String get settingsFactoryResetDialogTitle => '工場出荷時設定にリセット';

  @override
  String get settingsFactoryResetDialogMessage =>
      'すべての設定、ローカルデータベース、およびローカルで作成されたすべてのカテゴリが失われます。本当に続行しますか？';

  @override
  String get settingsFactoryResetDialogConfirm => 'リセット';

  @override
  String get settingsFactoryResetSuccess =>
      'アプリケーションは工場出荷時の状態に正常にリセットされました。アプリケーションを再起動してください。';

  @override
  String get settingsUpdates => 'アップデート';

  @override
  String get settingsUpdateChannelLabel => 'アップデートチャンネル';

  @override
  String get settingsUpdateChannelDescription => '受信するアップデートの種類を選択してください';

  @override
  String settingsUpdateChannelChanged(String channel) {
    return 'アップデートチャンネルが$channelに変更されました。アップデートを確認中...';
  }

  @override
  String get updateChannelStable => '安定版';

  @override
  String get updateChannelStableDesc => 'ほとんどのユーザーに推奨。安定版のみ。';

  @override
  String get updateChannelRc => 'Release Candidate';

  @override
  String get updateChannelRcDesc => '安定版リリース前の最終テストを伴う安定機能。';

  @override
  String get updateChannelBeta => 'Beta';

  @override
  String get updateChannelBetaDesc => 'ほぼ安定した新機能。バグがある可能性があります。';

  @override
  String get updateChannelDev => '開発版';

  @override
  String get updateChannelDevDesc => '最先端機能。バグと不安定性が予想されます。';

  @override
  String get fallbackBehaviorDoNothing => '何もしない';

  @override
  String get fallbackBehaviorJustChatting => 'Just Chatting';

  @override
  String get fallbackBehaviorCustom => 'カスタムカテゴリ';

  @override
  String get unknownGameDialogTitle => 'Game Not Mapped';

  @override
  String get unknownGameDialogStepCategory => 'カテゴリー';

  @override
  String get unknownGameDialogStepDestination => '保存先';

  @override
  String get unknownGameDialogStepConfirm => '確認';

  @override
  String get unknownGameDialogConfirmHeader => '確認と承認';

  @override
  String get unknownGameDialogConfirmDescription => '保存する前に選択内容を確認してください';

  @override
  String get unknownGameDialogConfirmCategory => 'TWITCHカテゴリー';

  @override
  String get unknownGameDialogConfirmDestination => '保存先リスト';

  @override
  String get unknownGameDialogBack => '戻る';

  @override
  String get unknownGameDialogNext => '次へ';

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
  String get unknownGameDialogCategoryHeader => 'Twitchカテゴリーを選択';

  @override
  String get unknownGameDialogCategoryDescription =>
      'このゲームのTwitchカテゴリーを検索して選択してください';

  @override
  String get unknownGameDialogListHeader => '保存先を選択';

  @override
  String get unknownGameDialogListDescription => 'このマッピングを保存する場所を選択してください';

  @override
  String get unknownGameDialogNoWritableLists => '書き込み可能なリストがありません';

  @override
  String get unknownGameDialogNoWritableListsHint =>
      'カスタムマッピングを保存するには、カテゴリーマッピングでローカルリストを作成してください';

  @override
  String get unknownGameDialogLocalListsHeader => 'ローカルマッピング';

  @override
  String get unknownGameDialogSubmissionListsHeader => 'コミュニティへの投稿';

  @override
  String get unknownGameDialogWorkflowHeader => '投稿の仕組み';

  @override
  String get unknownGameDialogWorkflowCompactNote =>
      '最初にローカルに保存され、その後コミュニティの承認のために投稿されます';

  @override
  String get unknownGameDialogWorkflowLearnMore => '詳しく見る';

  @override
  String get unknownGameDialogWorkflowStep1Title => 'ローカルに保存（即時）';

  @override
  String get unknownGameDialogWorkflowStep1Description =>
      'マッピングがローカルリストに追加され、すぐに機能します';

  @override
  String get unknownGameDialogWorkflowStep2Title => 'レビューのために投稿';

  @override
  String get unknownGameDialogWorkflowStep2Description =>
      'マッピングが承認のためにコミュニティに投稿されます';

  @override
  String get unknownGameDialogWorkflowStep3Title => '公式にマージ';

  @override
  String get unknownGameDialogWorkflowStep3Description =>
      '承認されると、公式マッピングに表示され、ローカルリストから削除されます';

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
  String get unknownGameDialogThankYouTitle => 'ありがとうございます！';

  @override
  String get unknownGameDialogThankYouMessage => 'あなたの貢献がコミュニティの成長に役立ちます！';

  @override
  String get versionStatusUpToDate => '最新';

  @override
  String get versionStatusUpdateAvailable => '更新が利用可能';

  @override
  String versionStatusCheckFailed(String error) {
    return '更新の確認に失敗しました：$error';
  }

  @override
  String get versionStatusNotInitialized => '更新サービスが初期化されていません';

  @override
  String get versionStatusPlatformNotSupported => 'このプラットフォームでは更新がサポートされていません';
}
