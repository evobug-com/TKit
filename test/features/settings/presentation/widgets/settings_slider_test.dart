import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tkit/l10n/app_localizations.dart';
import 'package:tkit/features/settings/presentation/widgets/settings_slider.dart';

void main() {
  group('SettingsSlider', () {
    testWidgets('should display label and value', (tester) async {
      // Arrange
      double currentValue = 10;

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
            body: SettingsSlider(
              label: 'Test Slider',
              value: currentValue,
              min: 0,
              max: 60,
              divisions: 60,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Slider'), findsOneWidget);
      expect(find.text('10s'), findsOneWidget);
    });

    testWidgets('should call onChanged when slider moves', (tester) async {
      // Arrange
      double currentValue = 10;
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
            body: SettingsSlider(
              label: 'Test Slider',
              value: currentValue,
              min: 0,
              max: 60,
              divisions: 60,
              onChanged: (value) {
                onChangedCalled = true;
                currentValue = value;
              },
            ),
          ),
        ),
      );

      // Find and drag the slider
      await tester.drag(find.byType(Slider), const Offset(100, 0));
      await tester.pumpAndSettle();

      // Assert
      expect(onChangedCalled, true);
    });

    testWidgets('should respect min and max values', (tester) async {
      // Arrange
      const double minValue = 1;
      const double maxValue = 300;

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
            body: SettingsSlider(
              label: 'Test Slider',
              value: 150,
              min: minValue,
              max: maxValue,
              divisions: 299,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      // Assert
      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.min, minValue);
      expect(slider.max, maxValue);
    });

    testWidgets('should display custom suffix', (tester) async {
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
            body: SettingsSlider(
              label: 'Test Slider',
              value: 10,
              min: 0,
              max: 100,
              divisions: 100,
              suffix: ' units',
              onChanged: (_) {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('10 units'), findsOneWidget);
    });
  });
}
