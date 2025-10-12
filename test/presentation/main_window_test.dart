import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:tkit/core/routing/app_router.dart';
import 'package:tkit/core/services/updater/github_update_service.dart';
import 'package:tkit/features/auth/data/datasources/token_local_datasource.dart';
import 'package:tkit/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:tkit/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:tkit/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:tkit/features/auth/domain/usecases/logout_usecase.dart';
import 'package:tkit/features/auth/domain/usecases/refresh_token_usecase.dart';
import 'package:tkit/features/auth/presentation/providers/auth_provider.dart';
import 'package:tkit/l10n/app_localizations.dart';
import 'package:tkit/presentation/main_window.dart';
import 'package:tkit/shared/theme/app_theme.dart';

import 'main_window_test.mocks.dart';

@GenerateMocks([
  LogoutUseCase,
  CheckAuthStatusUseCase,
  RefreshTokenUseCase,
  GetCurrentUserUseCase,
  TokenLocalDataSource,
  IAuthRepository,
  GitHubUpdateService,
])
void main() {
  group('MainWindow', () {
    late AppRouter router;
    late AuthProvider authProvider;
    late MockAuthenticateUseCase mockAuthenticateUseCase;
    late MockLogoutUseCase mockLogoutUseCase;
    late MockCheckAuthStatusUseCase mockCheckAuthStatusUseCase;
    late MockRefreshTokenUseCase mockRefreshTokenUseCase;
    late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;
    late MockTokenLocalDataSource mockTokenLocalDataSource;
    late MockIAuthRepository mockAuthRepository;
    late MockGitHubUpdateService mockGitHubUpdateService;

    setUp(() async {
      router = AppRouter();
      // Pre-initialize the router with a route to avoid null current
      router.push(const AutoSwitcherRoute());

      mockAuthenticateUseCase = MockAuthenticateUseCase();
      mockLogoutUseCase = MockLogoutUseCase();
      mockCheckAuthStatusUseCase = MockCheckAuthStatusUseCase();
      mockRefreshTokenUseCase = MockRefreshTokenUseCase();
      mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();
      mockTokenLocalDataSource = MockTokenLocalDataSource();
      mockAuthRepository = MockIAuthRepository();
      mockGitHubUpdateService = MockGitHubUpdateService();

      authProvider = AuthProvider(
        mockAuthenticateUseCase,
        mockLogoutUseCase,
        mockCheckAuthStatusUseCase,
        mockRefreshTokenUseCase,
        mockGetCurrentUserUseCase,
        mockTokenLocalDataSource,
        mockAuthRepository,
      );

      // Setup default behavior for auth check status
      when(mockCheckAuthStatusUseCase())
          .thenAnswer((_) async => const Right(false));

      // Setup default behavior for update service
      when(mockGitHubUpdateService.updateAvailable)
          .thenAnswer((_) => Stream.value(null));
      when(mockGitHubUpdateService.currentUpdate).thenReturn(null);
    });

    tearDown(() {
      authProvider.dispose();
    });

    Widget createTestWidget(Widget child) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
          Provider<GitHubUpdateService>.value(value: mockGitHubUpdateService),
        ],
        child: MaterialApp(
          theme: AppTheme.darkTheme,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
          ],
          home: MainWindow(
            router: router,
            child: child,
          ),
        ),
      );
    }

    testWidgets('displays header with app name', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(const Center(child: Text('Content'))),
      );
      await tester.pumpAndSettle();

      expect(find.text('TKIT'), findsOneWidget);
    });

    testWidgets('displays sidebar navigation buttons', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(const Center(child: Text('Content'))),
      );
      await tester.pumpAndSettle();

      expect(find.text('AUTO SWITCHER'), findsOneWidget);
      expect(find.text('MAPPINGS'), findsOneWidget);
      expect(find.text('SETTINGS'), findsOneWidget);
    });

    testWidgets('displays child content', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(const Center(child: Text('Test Content'))),
      );
      await tester.pumpAndSettle();

      expect(find.text('Test Content'), findsOneWidget);
    });

    testWidgets('displays footer with version', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(const Center(child: Text('Content'))),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('v'), findsAtLeastNWidgets(1));
    });

    testWidgets('displays authentication status', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(const Center(child: Text('Content'))),
      );
      await tester.pumpAndSettle();

      // AuthProvider starts with AuthInitial, so should show "Disconnected"
      expect(find.text('Disconnected'), findsOneWidget);
    });
  });
}
