import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tkit/l10n/app_localizations.dart';
import 'package:tkit/features/settings/presentation/widgets/settings_dropdown.dart';

void main() {
  group('SettingsDropdown', () {
    testWidgets('should display label and current value', (tester) async {
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
            body: SettingsDropdown<String>(
              label: 'Test Dropdown',
              value: 'option1',
              items: const [
                DropdownMenuItem(value: 'option1', child: Text('Option 1')),
                DropdownMenuItem(value: 'option2', child: Text('Option 2')),
              ],
              onChanged: (_) {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Dropdown'), findsOneWidget);
      expect(find.text('Option 1'), findsOneWidget);
    });

    testWidgets('should show options when tapped', (tester) async {
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
            body: SettingsDropdown<String>(
              label: 'Test Dropdown',
              value: 'option1',
              items: const [
                DropdownMenuItem(value: 'option1', child: Text('Option 1')),
                DropdownMenuItem(value: 'option2', child: Text('Option 2')),
                DropdownMenuItem(value: 'option3', child: Text('Option 3')),
              ],
              onChanged: (_) {},
            ),
          ),
        ),
      );

      // Tap to open dropdown
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();

      // Assert
      expect(
        find.text('Option 1'),
        findsNWidgets(2),
      ); // One in button, one in menu
      expect(find.text('Option 2'), findsOneWidget);
      expect(find.text('Option 3'), findsOneWidget);
    });

    testWidgets('should call onChanged when option selected', (tester) async {
      // Arrange
      String currentValue = 'option1';
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
            body: SettingsDropdown<String>(
              label: 'Test Dropdown',
              value: currentValue,
              items: const [
                DropdownMenuItem(value: 'option1', child: Text('Option 1')),
                DropdownMenuItem(value: 'option2', child: Text('Option 2')),
              ],
              onChanged: (value) {
                onChangedCalled = true;
                currentValue = value ?? 'option1';
              },
            ),
          ),
        ),
      );

      // Tap to open dropdown
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();

      // Select second option
      await tester.tap(find.text('Option 2').last);
      await tester.pumpAndSettle();

      // Assert
      expect(onChangedCalled, true);
      expect(currentValue, 'option2');
    });
  });
}
