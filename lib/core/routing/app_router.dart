import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:tkit/features/auth/presentation/pages/auth_page.dart';
import 'package:tkit/features/auto_switcher/presentation/pages/auto_switcher_page.dart';
import 'package:tkit/features/category_mapping/presentation/pages/category_mapping_editor_page.dart';
import 'package:tkit/features/settings/presentation/pages/settings_page.dart';
import 'package:tkit/features/welcome/presentation/pages/welcome_page.dart';
import 'package:tkit/features/dev_showcase/presentation/pages/showcase_page.dart';

part 'app_router.gr.dart';

/// Tab order mapping for directional transitions
const _tabOrder = {
  'AutoSwitcherRoute': 0,
  'CategoryMappingEditorRoute': 1,
  'SettingsRoute': 2,
  'ShowcaseRoute': 3, // Dev only
};

/// Custom transition builder that slides left/right based on tab navigation direction
Widget _buildDirectionalSlideTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  // Get the current and previous routes
  final router = context.router;

  // Determine slide direction based on tab indices
  Offset beginOffset = const Offset(1.0, 0.0); // Default: slide from right

  if (router.stack.length > 1) {
    final previousRoute = router.stack[router.stack.length - 2];
    final currentRoute = router.stack[router.stack.length - 1];
    final currentRouteName = currentRoute.name;
    final previousRouteName = previousRoute.name;

    final currentIndex = _tabOrder[currentRouteName] ?? -1;
    final previousIndex = _tabOrder[previousRouteName] ?? -1;

    // If both routes are tabs, determine direction
    if (currentIndex != -1 && previousIndex != -1) {
      if (currentIndex < previousIndex) {
        // Moving backward (right to left), slide from left
        beginOffset = const Offset(-1.0, 0.0);
      }
      // else: Moving forward (left to right), slide from right (default)
    }
  }

  final tween = Tween(begin: beginOffset, end: Offset.zero)
      .chain(CurveTween(curve: Curves.easeInOut));
  final offsetAnimation = animation.drive(tween);

  return SlideTransition(
    position: offsetAnimation,
    child: child,
  );
}

/// App routing configuration using auto_route
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        // Welcome screen (for first-time setup)
        AutoRoute(page: WelcomeRoute.page),
        // Auto Switcher (initial route)
        CustomRoute(
          page: AutoSwitcherRoute.page,
          initial: true,
          transitionsBuilder: _buildDirectionalSlideTransition,
          duration: const Duration(milliseconds: 250),
        ),
        // Category Mapping Editor
        CustomRoute(
          page: CategoryMappingEditorRoute.page,
          transitionsBuilder: _buildDirectionalSlideTransition,
          duration: const Duration(milliseconds: 250),
        ),
        // Settings
        CustomRoute(
          page: SettingsRoute.page,
          transitionsBuilder: _buildDirectionalSlideTransition,
          duration: const Duration(milliseconds: 250),
        ),
        // Design System Showcase (dev only)
        CustomRoute(
          page: ShowcaseRoute.page,
          transitionsBuilder: _buildDirectionalSlideTransition,
          duration: const Duration(milliseconds: 250),
        ),
        // Auth (used as dialog)
        AutoRoute(page: AuthRoute.page),
      ];
}
