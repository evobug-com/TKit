// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AuthPage]
class AuthRoute extends PageRouteInfo<AuthRouteArgs> {
  AuthRoute({
    Key? key,
    VoidCallback? onAuthSuccess,
    List<PageRouteInfo>? children,
  }) : super(
         AuthRoute.name,
         args: AuthRouteArgs(key: key, onAuthSuccess: onAuthSuccess),
         initialChildren: children,
       );

  static const String name = 'AuthRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AuthRouteArgs>(
        orElse: () => const AuthRouteArgs(),
      );
      return AuthPage(key: args.key, onAuthSuccess: args.onAuthSuccess);
    },
  );
}

class AuthRouteArgs {
  const AuthRouteArgs({this.key, this.onAuthSuccess});

  final Key? key;

  final VoidCallback? onAuthSuccess;

  @override
  String toString() {
    return 'AuthRouteArgs{key: $key, onAuthSuccess: $onAuthSuccess}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AuthRouteArgs) return false;
    return key == other.key && onAuthSuccess == other.onAuthSuccess;
  }

  @override
  int get hashCode => key.hashCode ^ onAuthSuccess.hashCode;
}

/// generated route for
/// [AutoSwitcherPage]
class AutoSwitcherRoute extends PageRouteInfo<void> {
  const AutoSwitcherRoute({List<PageRouteInfo>? children})
    : super(AutoSwitcherRoute.name, initialChildren: children);

  static const String name = 'AutoSwitcherRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AutoSwitcherPage();
    },
  );
}

/// generated route for
/// [CategoryMappingEditorPage]
class CategoryMappingEditorRoute extends PageRouteInfo<void> {
  const CategoryMappingEditorRoute({List<PageRouteInfo>? children})
    : super(CategoryMappingEditorRoute.name, initialChildren: children);

  static const String name = 'CategoryMappingEditorRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CategoryMappingEditorPage();
    },
  );
}

/// generated route for
/// [SettingsPage]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SettingsPage();
    },
  );
}

/// generated route for
/// [ShowcasePage]
class ShowcaseRoute extends PageRouteInfo<void> {
  const ShowcaseRoute({List<PageRouteInfo>? children})
    : super(ShowcaseRoute.name, initialChildren: children);

  static const String name = 'ShowcaseRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ShowcasePage();
    },
  );
}

/// generated route for
/// [WelcomePage]
class WelcomeRoute extends PageRouteInfo<WelcomeRouteArgs> {
  WelcomeRoute({
    Key? key,
    void Function(Locale)? onLocaleChange,
    List<PageRouteInfo>? children,
  }) : super(
         WelcomeRoute.name,
         args: WelcomeRouteArgs(key: key, onLocaleChange: onLocaleChange),
         initialChildren: children,
       );

  static const String name = 'WelcomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<WelcomeRouteArgs>(
        orElse: () => const WelcomeRouteArgs(),
      );
      return WelcomePage(key: args.key, onLocaleChange: args.onLocaleChange);
    },
  );
}

class WelcomeRouteArgs {
  const WelcomeRouteArgs({this.key, this.onLocaleChange});

  final Key? key;

  final void Function(Locale)? onLocaleChange;

  @override
  String toString() {
    return 'WelcomeRouteArgs{key: $key, onLocaleChange: $onLocaleChange}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! WelcomeRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}
