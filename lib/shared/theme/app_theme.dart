import 'package:flutter/material.dart';
import 'colors.dart';
import 'text_styles.dart';

/// TKit application theme
class AppTheme {
  AppTheme._();

  /// Dark theme configuration (primary theme)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color scheme
      colorScheme: const ColorScheme.dark(
        primary: TKitColors.accent,
        onPrimary: TKitColors.textPrimary,
        secondary: TKitColors.accentDim,
        onSecondary: TKitColors.textPrimary,
        error: TKitColors.error,
        onError: TKitColors.textPrimary,
        surface: TKitColors.surface,
        onSurface: TKitColors.textPrimary,
        surfaceContainerHighest: TKitColors.surfaceVariant,
        outline: TKitColors.border,
        outlineVariant: TKitColors.borderLight,
      ),

      // Scaffold
      scaffoldBackgroundColor: TKitColors.background,

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: TKitColors.surface,
        foregroundColor: TKitColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TKitTextStyles.heading3,
        toolbarHeight: 56,
      ),

      // Card
      cardTheme: CardThemeData(
        color: TKitColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0), // Sharp corners
          side: const BorderSide(color: TKitColors.border, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: TKitColors.accent,
          foregroundColor: TKitColors.textPrimary,
          disabledBackgroundColor: TKitColors.surfaceVariant,
          disabledForegroundColor: TKitColors.textDisabled,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0), // Sharp corners
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: TKitTextStyles.button,
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: TKitColors.accent,
          disabledForegroundColor: TKitColors.textDisabled,
          side: const BorderSide(color: TKitColors.accent, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0), // Sharp corners
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: TKitTextStyles.button,
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: TKitColors.accent,
          disabledForegroundColor: TKitColors.textDisabled,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0), // Sharp corners
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: TKitTextStyles.button,
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: TKitColors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0), // Sharp corners
          borderSide: const BorderSide(color: TKitColors.border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: const BorderSide(color: TKitColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: const BorderSide(color: TKitColors.accent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: const BorderSide(color: TKitColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: const BorderSide(color: TKitColors.error, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: const BorderSide(color: TKitColors.borderLight, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        hintStyle: TKitTextStyles.bodyMedium.copyWith(
          color: TKitColors.textMuted,
        ),
        labelStyle: TKitTextStyles.labelMedium.copyWith(
          color: TKitColors.textSecondary,
        ),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: TKitColors.surface,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0), // Sharp corners
          side: const BorderSide(color: TKitColors.border, width: 1),
        ),
        titleTextStyle: TKitTextStyles.heading3,
        contentTextStyle: TKitTextStyles.bodyMedium,
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: TKitColors.border,
        thickness: 1,
        space: 1,
      ),

      // Icon
      iconTheme: const IconThemeData(color: TKitColors.textSecondary, size: 20),

      // Tooltip
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: TKitColors.surfaceVariant,
          border: Border.all(color: TKitColors.border),
          borderRadius: BorderRadius.circular(0), // Sharp corners
        ),
        textStyle: TKitTextStyles.bodySmall.copyWith(
          color: TKitColors.textPrimary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: TKitColors.surface,
        contentTextStyle: TKitTextStyles.bodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0), // Sharp corners
          side: const BorderSide(color: TKitColors.border, width: 1),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Text theme
      textTheme: const TextTheme(
        displayLarge: TKitTextStyles.heading1,
        displayMedium: TKitTextStyles.heading2,
        displaySmall: TKitTextStyles.heading3,
        headlineMedium: TKitTextStyles.heading3,
        headlineSmall: TKitTextStyles.heading4,
        titleLarge: TKitTextStyles.heading3,
        titleMedium: TKitTextStyles.heading4,
        titleSmall: TKitTextStyles.labelLarge,
        bodyLarge: TKitTextStyles.bodyLarge,
        bodyMedium: TKitTextStyles.bodyMedium,
        bodySmall: TKitTextStyles.bodySmall,
        labelLarge: TKitTextStyles.labelLarge,
        labelMedium: TKitTextStyles.labelMedium,
        labelSmall: TKitTextStyles.labelSmall,
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TKitColors.textPrimary;
          }
          return TKitColors.textMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TKitColors.accent;
          }
          return TKitColors.borderLight;
        }),
      ),

      // Checkbox
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TKitColors.accent;
          }
          return TKitColors.transparent;
        }),
        checkColor: WidgetStateProperty.all(TKitColors.textPrimary),
        side: const BorderSide(color: TKitColors.border, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0), // Sharp corners
        ),
      ),

      // Slider
      sliderTheme: const SliderThemeData(
        activeTrackColor: TKitColors.accent,
        inactiveTrackColor: TKitColors.borderLight,
        thumbColor: TKitColors.textPrimary,
        overlayColor: TKitColors.overlayLight,
        valueIndicatorColor: TKitColors.accent,
        valueIndicatorTextStyle: TKitTextStyles.labelSmall,
      ),
    );
  }
}
