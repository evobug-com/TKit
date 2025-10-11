import 'package:flutter/material.dart';

/// TKit color palette
/// Philosophy: Mostly monochrome, color only for critical status
class TKitColors {
  TKitColors._();

  // Backgrounds - Pure monochrome
  static const Color background = Color(0xFF0A0A0A); // True black
  static const Color surface = Color(0xFF141414); // Subtle elevation
  static const Color surfaceVariant = Color(0xFF1A1A1A); // Cards/panels

  // Borders - Subtle separators
  static const Color border = Color(0xFF222222);
  static const Color borderLight = Color(0xFF2A2A2A);
  static const Color borderSubtle = Color(0xFF1A1A1A);

  // Accent - Use sparingly, only for primary actions
  static const Color accent = Color(0xFF6B6B6B); // Neutral gray accent
  static const Color accentHover = Color(0xFF808080);
  static const Color accentPressed = Color(0xFF4A4A4A);
  static const Color accentDim = Color(0xFF4A4A4A); // For backwards compatibility

  // Optional bright accent for rare important actions
  static const Color accentBright = Color(0xFFFFFFFF);

  // Text - High contrast monochrome
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textMuted = Color(0xFF707070);
  static const Color textDisabled = Color(0xFF404040);

  // Status - Minimal, only when needed
  static const Color success = Color(0xFF00AA55); // Muted green
  static const Color error = Color(0xFFDD4444); // Muted red
  static const Color warning = Color(0xFFDD9944); // Muted orange
  static const Color info = Color(0xFF6B9BD1); // Muted blue for info
  static const Color idle = Color(0xFF666666);

  // Overlay
  static const Color overlay = Color(0xE6000000); // 90% black
  static const Color overlayLight = Color(0x80000000); // 50% black

  // Transparent
  static const Color transparent = Color(0x00000000);
}

/// Type alias for backwards compatibility
typedef AppColors = TKitColors;
