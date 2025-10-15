import 'package:flutter/material.dart';

/// TKit color palette
/// Philosophy: Mostly monochrome, color only for critical status
class TKitColors {
  TKitColors._();

  // Backgrounds - Pure monochrome
  static const background = Color(0xFF0A0A0A); // True black
  static const surface = Color(0xFF141414); // Subtle elevation
  static const surfaceVariant = Color(0xFF1A1A1A); // Cards/panels

  // Borders - Subtle separators
  static const border = Color(0xFF222222);
  static const borderLight = Color(0xFF2A2A2A);
  static const borderSubtle = Color(0xFF1A1A1A);

  // Accent - Use sparingly, only for primary actions
  static const accent = Color(0xFF6B6B6B); // Neutral gray accent
  static const accentHover = Color(0xFF808080);
  static const accentPressed = Color(0xFF4A4A4A);
  static const accentDim = Color(0xFF4A4A4A); // For backwards compatibility

  // Optional bright accent for rare important actions
  static const accentBright = Color(0xFFFFFFFF);

  // Text - High contrast monochrome
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFB0B0B0);
  static const textMuted = Color(0xFF707070);
  static const textDisabled = Color(0xFF404040);

  // Status - Minimal, only when needed
  static const success = Color(0xFF00AA55); // Muted green
  static const error = Color(0xFFDD4444); // Muted red
  static const warning = Color(0xFFDD9944); // Muted orange
  static const info = Color(0xFF6B9BD1); // Muted blue for info
  static const idle = Color(0xFF666666);

  // Overlay
  static const overlay = Color(0xE6000000); // 90% black
  static const overlayLight = Color(0x80000000); // 50% black

  // Transparent
  static const transparent = Color(0x00000000);
}

/// Type alias for backwards compatibility
typedef AppColors = TKitColors;
