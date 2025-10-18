import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tkit/core/routing/app_router.dart';
import 'package:tkit/features/auto_switcher/data/repositories/auto_switcher_repository_impl.dart';
import 'package:tkit/features/auto_switcher/presentation/providers/auto_switcher_providers.dart';
import 'package:tkit/features/category_mapping/domain/entities/category_mapping.dart';
import 'package:tkit/features/category_mapping/presentation/dialogs/unknown_game_dialog.dart';

/// Helper to wait for a widget to appear
Future<void> waitForWidget(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 10),
  Duration pollInterval = const Duration(milliseconds: 100),
}) async {
  final end = DateTime.now().add(timeout);

  while (DateTime.now().isBefore(end)) {
    await tester.pumpAndSettle(pollInterval);

    if (finder.evaluate().isNotEmpty) {
      return;
    }

    await Future<void>.delayed(pollInterval);
  }

  throw TimeoutException(
    'Widget not found after $timeout',
    timeout,
  );
}

/// Helper to wait for a dialog to appear
Future<void> waitForDialog(
  WidgetTester tester,
  Type dialogType, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  await waitForWidget(
    tester,
    find.byType(dialogType),
    timeout: timeout,
  );
}

/// Helper to wait for text to appear
Future<void> waitForText(
  WidgetTester tester,
  String text, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  await waitForWidget(
    tester,
    find.text(text),
    timeout: timeout,
  );
}

/// Helper to verify dialog is shown
void expectDialogShown(Type dialogType) {
  expect(find.byType(dialogType), findsOneWidget);
}

/// Helper to verify dialog is not shown
void expectDialogNotShown(Type dialogType) {
  expect(find.byType(dialogType), findsNothing);
}

/// Helper to tap a button and wait for navigation
Future<void> tapAndSettle(
  WidgetTester tester,
  Finder finder, {
  Duration settleDuration = const Duration(milliseconds: 500),
}) async {
  await tester.tap(finder);
  await tester.pumpAndSettle(settleDuration);
}

/// Helper to enable auto switcher
Future<void> enableAutoSwitcher(WidgetTester tester) async {
  // Find the Turn On button using its key
  final turnOnButton = find.byKey(const Key('auto-switcher-turn-on-button'));
  if (turnOnButton.evaluate().isEmpty) {
    // Already enabled
    return;
  }

  await tapAndSettle(tester, turnOnButton);
}

/// Helper to navigate to a specific page
Future<void> navigateToPage(WidgetTester tester, String pageName) async {
  // Use keys for navigation tabs
  final Key navKey;
  switch (pageName) {
    case 'Auto Switcher':
      navKey = const Key('nav-tab-auto-switcher');
      break;
    case 'Mappings':
      navKey = const Key('nav-tab-mappings');
      break;
    case 'Settings':
      navKey = const Key('nav-tab-settings');
      break;
    default:
      // Fallback to text search for custom pages
      final pageButton = find.text(pageName);
      if (pageButton.evaluate().isNotEmpty) {
        await tapAndSettle(tester, pageButton);
      }
      return;
  }

  final pageButton = find.byKey(navKey);
  if (pageButton.evaluate().isNotEmpty) {
    await tapAndSettle(tester, pageButton);
  }
}

/// Helper to setup unknown game callback for tests
Future<void> setupUnknownGameCallback(
  ProviderContainer container,
  AppRouter appRouter,
) async {
  // Wait for repository to be ready and cast to implementation
  final repository = await container.read(autoSwitcherRepositoryProvider.future) as AutoSwitcherRepositoryImpl;

  // Set up the callback to show the dialog
  repository.unknownGameCallback = ({
    required String processName,
    String? executablePath,
    String? windowTitle,
  }) async {
    final navigatorContext = appRouter.navigatorKey.currentContext;
    if (navigatorContext == null) {
      return null;
    }

    final result = await showDialog<Map<String, dynamic>>(
      context: navigatorContext,
      barrierDismissible: false,
      builder: (context) => UnknownGameDialog(
        processName: processName,
        executablePath: executablePath,
        windowTitle: windowTitle,
      ),
    );

    if (result == null) {
      return null;
    }

    // Return the mapping from the dialog result
    final now = DateTime.now();
    return CategoryMapping(
      processName: processName,
      twitchCategoryId: result['categoryId'] as String,
      twitchCategoryName: result['categoryName'] as String,
      normalizedInstallPaths: executablePath != null ? [executablePath] : const [],
      createdAt: now,
      lastApiFetch: now,
      cacheExpiresAt: now.add(const Duration(hours: 24)),
      manualOverride: true,
    );
  };
}
