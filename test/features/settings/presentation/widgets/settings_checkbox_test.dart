import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tkit/l10n/app_localizations.dart';
import 'package:tkit/features/settings/presentation/widgets/settings_checkbox.dart';

void main() {
  group('SettingsCheckbox', () {
    testWidgets('should display label', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SettingsCheckbox(
              label: 'Test Checkbox',
              value: false,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Checkbox'), findsOneWidget);
    });

    testWidgets('should display subtitle when provided', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SettingsCheckbox(
              label: 'Test Checkbox',
              subtitle: 'This is a subtitle',
              value: false,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Checkbox'), findsOneWidget);
      expect(find.text('This is a subtitle'), findsOneWidget);
    });

    testWidgets('should reflect checked state', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SettingsCheckbox(
              label: 'Test Checkbox',
              value: true,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      // Assert
      final checkbox = tester.widget<CheckboxListTile>(
        find.byType(CheckboxListTile),
      );
      expect(checkbox.value, true);
    });

    testWidgets('should call onChanged when tapped', (tester) async {
      // Arrange
      bool value = false;
      bool onChangedCalled = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SettingsCheckbox(
              label: 'Test Checkbox',
              value: value,
              onChanged: (newValue) {
                onChangedCalled = true;
                value = newValue ?? false;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CheckboxListTile));
      await tester.pumpAndSettle();

      // Assert
      expect(onChangedCalled, true);
    });
  });
}
