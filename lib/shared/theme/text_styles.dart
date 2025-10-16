import 'package:flutter/material.dart';
import 'package:tkit/shared/theme/colors.dart';

/// TKit text styles
class TKitTextStyles {
  TKitTextStyles._();

  // Font family
  static const _fontFamily = 'Inter'; // Will use system font if not available

  // Headings
  static const heading1 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.2,
    color: TKitColors.textPrimary,
  );

  static const heading2 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
    height: 1.2,
    color: TKitColors.textPrimary,
  );

  static const heading3 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.2,
    color: TKitColors.textPrimary,
  );

  static const heading4 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.2,
    color: TKitColors.textPrimary,
  );

  // Body text - Compact
  static const bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: TKitColors.textPrimary,
  );

  static const bodyMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: TKitColors.textPrimary,
  );

  static const bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 1.3,
    color: TKitColors.textSecondary,
  );

  // Labels
  static const labelLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.3,
    color: TKitColors.textPrimary,
  );

  static const labelMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.3,
    color: TKitColors.textPrimary,
  );

  static const labelSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.3,
    color: TKitColors.textSecondary,
  );

  // Button text
  static const button = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.0,
    color: TKitColors.textPrimary,
  );

  static const buttonSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.0,
    color: TKitColors.textPrimary,
  );

  // Caption
  static const caption = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.3,
    color: TKitColors.textMuted,
  );

  // Code/Monospace
  static const code = TextStyle(
    fontFamily: 'Consolas',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: TKitColors.textPrimary,
  );

  // Link
  static const link = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.underline,
    height: 1.5,
    color: TKitColors.accent,
  );

  // Alias for body (defaults to bodyMedium)
  static const TextStyle body = bodyMedium;
}

/// Type alias for backwards compatibility
typedef AppTextStyles = TKitTextStyles;
