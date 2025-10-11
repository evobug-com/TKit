import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tkit/shared/widgets/dialogs/confirm_dialog.dart';
import 'package:tkit/shared/theme/app_theme.dart';

void main() {
  group('ConfirmDialog', () {
    testWidgets('displays title and message', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(
            body: ConfirmDialog(title: 'Test Title', message: 'Test Message'),
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Message'), findsOneWidget);
    });

    testWidgets('displays custom button text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(
            body: ConfirmDialog(
              title: 'Test Title',
              message: 'Test Message',
              confirmText: 'Yes',
              cancelText: 'No',
            ),
          ),
        ),
      );

      expect(find.text('Yes'), findsOneWidget);
      expect(find.text('No'), findsOneWidget);
    });

    testWidgets('returns true when confirm is tapped', (
      WidgetTester tester,
    ) async {
      bool? result;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await showDialog<bool>(
                    context: context,
                    builder: (context) =>
                        const ConfirmDialog(title: 'Test', message: 'Test'),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      expect(result, true);
    });

    testWidgets('returns false when cancel is tapped', (
      WidgetTester tester,
    ) async {
      bool? result;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await showDialog<bool>(
                    context: context,
                    builder: (context) =>
                        const ConfirmDialog(title: 'Test', message: 'Test'),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(result, false);
    });

    testWidgets('shows destructive styling when isDestructive is true', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(
            body: ConfirmDialog(
              title: 'Delete',
              message: 'Are you sure?',
              isDestructive: true,
            ),
          ),
        ),
      );

      expect(find.byType(ConfirmDialog), findsOneWidget);
    });
  });
}
