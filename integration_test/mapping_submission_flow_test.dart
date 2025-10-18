import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tkit/core/providers/providers.dart';
import 'package:tkit/core/routing/app_router.dart';
import 'package:tkit/core/utils/app_logger.dart';
import 'package:tkit/presentation/main_window.dart';
import 'package:tkit/shared/theme/app_theme.dart';

import '../test/helpers/mock_backend.dart';

/// Integration test for mapping submission flow with mock backend
///
/// This test demonstrates how to:
/// - Override Dio providers with mock implementations
/// - Define mock responses for different endpoints
/// - Test complete user flows without hitting real APIs
/// - Change responses easily without modifying test code
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Mapping Submission Flow', () {
    late Dio mockAuthDio;
    late Dio mockApiDio;
    late MockBackend authBackend;
    late MockBackend apiBackend;

    setUp(() {
      // Create Dio instances with mock adapters
      mockAuthDio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );
      mockApiDio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );

      // Wrap with MockBackend
      authBackend = MockBackend(mockAuthDio);
      apiBackend = MockBackend(mockApiDio);
    });

    testWidgets('successfully submits mapping with mock backend', (
      tester,
    ) async {
      // Define mock responses
      authBackend
          .onPost(
            'https://tkit-community-mapping-submission.jan-andrle.workers.dev/',
          )
          .reply(
            200,
            MockResponses.mappingSubmissionSuccess(
              prUrl: 'https://github.com/evobug/tkit-community-mapping/pull/42',
              prNumber: 42,
            ),
          );

      apiBackend
          .onGet('/search/categories')
          .withQueryParameters({'query': 'League of Legends', 'first': 20})
          .reply(
            200,
            MockResponses.twitchSearchCategories([
              {
                'id': '21779',
                'name': 'League of Legends',
                'box_art_url':
                    'https://static-cdn.jtvnw.net/ttv-boxart/League%20of%20Legends-{width}x{height}.jpg',
              },
            ]),
          );

      apiBackend
          .onGet('/users')
          .reply(
            200,
            MockResponses.twitchUserData(
              id: 'mock_user_123',
              login: 'teststreamer',
              displayName: 'Test Streamer',
            ),
          );

      // Create app with overridden providers
      final appRouter = AppRouter();
      final container = ProviderContainer(
        overrides: [
          authDioProvider.overrideWithValue(mockAuthDio),
          apiDioProvider.overrideWithValue(mockApiDio),
          appLoggerProvider.overrideWithValue(AppLogger()),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            theme: AppTheme.darkTheme,
            routerConfig: appRouter.config(),
            builder: (context, child) => MainWindow(
              child: child ?? const SizedBox.shrink(),
              router: appRouter,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify app loaded
      expect(find.byType(MaterialApp), findsOneWidget);

      // TODO: Add actual UI interactions here
      // Example:
      // - Navigate to mapping screen
      // - Fill in process name
      // - Search for category
      // - Submit mapping
      // - Verify success message

      // For now, just verify the app runs with mock backend
      debugPrint('✓ App loaded successfully with mock backend');
    });

    testWidgets('handles backend errors gracefully', (tester) async {
      // Define error response
      authBackend
          .onPost(
            'https://tkit-community-mapping-submission.jan-andrle.workers.dev/',
          )
          .replyError(
            500,
            MockResponses.error('Internal server error', status: 500),
          );

      final appRouter = AppRouter();
      final container = ProviderContainer(
        overrides: [
          authDioProvider.overrideWithValue(mockAuthDio),
          apiDioProvider.overrideWithValue(mockApiDio),
          appLoggerProvider.overrideWithValue(AppLogger()),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            theme: AppTheme.darkTheme,
            routerConfig: appRouter.config(),
            builder: (context, child) => MainWindow(
              child: child ?? const SizedBox.shrink(),
              router: appRouter,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // TODO: Trigger submission and verify error handling
      debugPrint('✓ Error handling test ready');
    });

    testWidgets('handles network timeout', (tester) async {
      // Define timeout response
      authBackend
          .onPost(
            'https://tkit-community-mapping-submission.jan-andrle.workers.dev/',
          )
          .replyTimeout();

      final appRouter = AppRouter();
      final container = ProviderContainer(
        overrides: [
          authDioProvider.overrideWithValue(mockAuthDio),
          apiDioProvider.overrideWithValue(mockApiDio),
          appLoggerProvider.overrideWithValue(AppLogger()),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            theme: AppTheme.darkTheme,
            routerConfig: appRouter.config(),
            builder: (context, child) => MainWindow(
              child: child ?? const SizedBox.shrink(),
              router: appRouter,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // TODO: Trigger submission and verify timeout handling
      debugPrint('✓ Timeout handling test ready');
    });
  });

  group('Mock Response Examples', () {
    test('mapping submission success response structure', () {
      final response = MockResponses.mappingSubmissionSuccess(
        prUrl: 'https://github.com/test/pr/123',
        prNumber: 123,
      );

      expect(response['prUrl'], 'https://github.com/test/pr/123');
      expect(response['prNumber'], 123);
      expect(response['message'], isA<String>());
    });

    test('twitch search categories response structure', () {
      final response = MockResponses.twitchSearchCategories([
        {'id': '1', 'name': 'Game 1'},
        {'id': '2', 'name': 'Game 2'},
      ]);

      expect(response['data'], isList);
      expect(response['data'].length, 2);
      expect(response['data'][0]['id'], '1');
      expect(response['data'][0]['name'], 'Game 1');
    });

    test('error response structure', () {
      final response = MockResponses.error('Test error', status: 400);

      expect(response['error'], 'Test error');
      expect(response['status'], 400);
    });
  });
}
