// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the app logger instance

@ProviderFor(appLogger)
const appLoggerProvider = AppLoggerProvider._();

/// Provides the app logger instance

final class AppLoggerProvider
    extends $FunctionalProvider<AppLogger, AppLogger, AppLogger>
    with $Provider<AppLogger> {
  /// Provides the app logger instance
  const AppLoggerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLoggerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLoggerHash();

  @$internal
  @override
  $ProviderElement<AppLogger> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppLogger create(Ref ref) {
    return appLogger(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppLogger value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppLogger>(value),
    );
  }
}

String _$appLoggerHash() => r'3699c15aceb1e23139f386ef70915703ccabf195';

/// Provides SharedPreferences instance

@ProviderFor(sharedPreferences)
const sharedPreferencesProvider = SharedPreferencesProvider._();

/// Provides SharedPreferences instance

final class SharedPreferencesProvider
    extends
        $FunctionalProvider<
          AsyncValue<SharedPreferences>,
          SharedPreferences,
          FutureOr<SharedPreferences>
        >
    with
        $FutureModifier<SharedPreferences>,
        $FutureProvider<SharedPreferences> {
  /// Provides SharedPreferences instance
  const SharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $FutureProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SharedPreferences> create(Ref ref) {
    return sharedPreferences(ref);
  }
}

String _$sharedPreferencesHash() => r'd22b545aefe95500327f9dce52c645d746349271';

/// Provides Auth Dio instance (no interceptors, for OAuth)

@ProviderFor(authDio)
const authDioProvider = AuthDioProvider._();

/// Provides Auth Dio instance (no interceptors, for OAuth)

final class AuthDioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// Provides Auth Dio instance (no interceptors, for OAuth)
  const AuthDioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authDioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authDioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return authDio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$authDioHash() => r'9a054292ebc4da5c3a81fec9dabb250d9f15b5bc';

/// Provides API Dio instance (with auth interceptors)

@ProviderFor(apiDio)
const apiDioProvider = ApiDioProvider._();

/// Provides API Dio instance (with auth interceptors)

final class ApiDioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// Provides API Dio instance (with auth interceptors)
  const ApiDioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiDioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiDioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return apiDio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$apiDioHash() => r'2fc42abff68868c8ce89bad8ba2f22a41b8ff5dc';

/// Provides FlutterSecureStorage instance

@ProviderFor(secureStorage)
const secureStorageProvider = SecureStorageProvider._();

/// Provides FlutterSecureStorage instance

final class SecureStorageProvider
    extends
        $FunctionalProvider<
          FlutterSecureStorage,
          FlutterSecureStorage,
          FlutterSecureStorage
        >
    with $Provider<FlutterSecureStorage> {
  /// Provides FlutterSecureStorage instance
  const SecureStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'secureStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$secureStorageHash();

  @$internal
  @override
  $ProviderElement<FlutterSecureStorage> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FlutterSecureStorage create(Ref ref) {
    return secureStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FlutterSecureStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FlutterSecureStorage>(value),
    );
  }
}

String _$secureStorageHash() => r'97f21970d5a31566856cff3edf2185f36a625602';

/// Provides AppDatabase instance

@ProviderFor(appDatabase)
const appDatabaseProvider = AppDatabaseProvider._();

/// Provides AppDatabase instance

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  /// Provides AppDatabase instance
  const AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'6db5c6e8abbcbc1700e5d6d9989b84206be84f9b';

/// Provides WindowsPlatformChannel

@ProviderFor(windowsPlatformChannel)
const windowsPlatformChannelProvider = WindowsPlatformChannelProvider._();

/// Provides WindowsPlatformChannel

final class WindowsPlatformChannelProvider
    extends
        $FunctionalProvider<
          WindowsPlatformChannel,
          WindowsPlatformChannel,
          WindowsPlatformChannel
        >
    with $Provider<WindowsPlatformChannel> {
  /// Provides WindowsPlatformChannel
  const WindowsPlatformChannelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'windowsPlatformChannelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$windowsPlatformChannelHash();

  @$internal
  @override
  $ProviderElement<WindowsPlatformChannel> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WindowsPlatformChannel create(Ref ref) {
    return windowsPlatformChannel(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WindowsPlatformChannel value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WindowsPlatformChannel>(value),
    );
  }
}

String _$windowsPlatformChannelHash() =>
    r'158fd977a62cadbd676f926d0fa9d7027aa09d7d';

/// Provides LanguageService

@ProviderFor(languageService)
const languageServiceProvider = LanguageServiceProvider._();

/// Provides LanguageService

final class LanguageServiceProvider
    extends
        $FunctionalProvider<
          AsyncValue<LanguageService>,
          LanguageService,
          FutureOr<LanguageService>
        >
    with $FutureModifier<LanguageService>, $FutureProvider<LanguageService> {
  /// Provides LanguageService
  const LanguageServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'languageServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$languageServiceHash();

  @$internal
  @override
  $FutureProviderElement<LanguageService> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LanguageService> create(Ref ref) {
    return languageService(ref);
  }
}

String _$languageServiceHash() => r'3b17f5bba3faf41fe9ca5bad0620a83cedaf5694';

/// Provides SystemTrayService

@ProviderFor(systemTrayService)
const systemTrayServiceProvider = SystemTrayServiceProvider._();

/// Provides SystemTrayService

final class SystemTrayServiceProvider
    extends
        $FunctionalProvider<
          SystemTrayService,
          SystemTrayService,
          SystemTrayService
        >
    with $Provider<SystemTrayService> {
  /// Provides SystemTrayService
  const SystemTrayServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'systemTrayServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$systemTrayServiceHash();

  @$internal
  @override
  $ProviderElement<SystemTrayService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SystemTrayService create(Ref ref) {
    return systemTrayService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SystemTrayService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SystemTrayService>(value),
    );
  }
}

String _$systemTrayServiceHash() => r'f27c7e5df56d3dcf49c2ff82fcc99a22f6703c56';

/// Provides GitHubUpdateService

@ProviderFor(githubUpdateService)
const githubUpdateServiceProvider = GithubUpdateServiceProvider._();

/// Provides GitHubUpdateService

final class GithubUpdateServiceProvider
    extends
        $FunctionalProvider<
          GitHubUpdateService,
          GitHubUpdateService,
          GitHubUpdateService
        >
    with $Provider<GitHubUpdateService> {
  /// Provides GitHubUpdateService
  const GithubUpdateServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'githubUpdateServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$githubUpdateServiceHash();

  @$internal
  @override
  $ProviderElement<GitHubUpdateService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GitHubUpdateService create(Ref ref) {
    return githubUpdateService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GitHubUpdateService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GitHubUpdateService>(value),
    );
  }
}

String _$githubUpdateServiceHash() =>
    r'e653fb512f8b7b553251d8f78adc0e003588f832';

/// Provides NotificationService

@ProviderFor(notificationService)
const notificationServiceProvider = NotificationServiceProvider._();

/// Provides NotificationService

final class NotificationServiceProvider
    extends
        $FunctionalProvider<
          NotificationService,
          NotificationService,
          NotificationService
        >
    with $Provider<NotificationService> {
  /// Provides NotificationService
  const NotificationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationServiceHash();

  @$internal
  @override
  $ProviderElement<NotificationService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NotificationService create(Ref ref) {
    return notificationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationService>(value),
    );
  }
}

String _$notificationServiceHash() =>
    r'65166639ada55bc7c24e1a066af94fa3688390bd';

/// Provides WindowService

@ProviderFor(windowService)
const windowServiceProvider = WindowServiceProvider._();

/// Provides WindowService

final class WindowServiceProvider
    extends $FunctionalProvider<WindowService, WindowService, WindowService>
    with $Provider<WindowService> {
  /// Provides WindowService
  const WindowServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'windowServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$windowServiceHash();

  @$internal
  @override
  $ProviderElement<WindowService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WindowService create(Ref ref) {
    return windowService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WindowService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WindowService>(value),
    );
  }
}

String _$windowServiceHash() => r'ade4ff8dbf17ac1eaee4ac59fe7d8ed2077c6b82';

/// Provides HotkeyService

@ProviderFor(hotkeyService)
const hotkeyServiceProvider = HotkeyServiceProvider._();

/// Provides HotkeyService

final class HotkeyServiceProvider
    extends
        $FunctionalProvider<
          AsyncValue<HotkeyService>,
          HotkeyService,
          FutureOr<HotkeyService>
        >
    with $FutureModifier<HotkeyService>, $FutureProvider<HotkeyService> {
  /// Provides HotkeyService
  const HotkeyServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hotkeyServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hotkeyServiceHash();

  @$internal
  @override
  $FutureProviderElement<HotkeyService> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<HotkeyService> create(Ref ref) {
    return hotkeyService(ref);
  }
}

String _$hotkeyServiceHash() => r'928e56386df23d251f6b7e2b31cb161798a3541e';

/// Provides TutorialService

@ProviderFor(tutorialService)
const tutorialServiceProvider = TutorialServiceProvider._();

/// Provides TutorialService

final class TutorialServiceProvider
    extends
        $FunctionalProvider<
          AsyncValue<TutorialService>,
          TutorialService,
          FutureOr<TutorialService>
        >
    with $FutureModifier<TutorialService>, $FutureProvider<TutorialService> {
  /// Provides TutorialService
  const TutorialServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tutorialServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tutorialServiceHash();

  @$internal
  @override
  $FutureProviderElement<TutorialService> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<TutorialService> create(Ref ref) {
    return tutorialService(ref);
  }
}

String _$tutorialServiceHash() => r'a70214eb2843922dd8e4a910112f9c0b9a64b4d0';
