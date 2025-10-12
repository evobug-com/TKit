import 'dart:io';
import 'package:flutter/foundation.dart';

/// Enum representing the type of installation
enum InstallationType {
  /// Installed as MSIX package (Windows Store/App Installer)
  msix,

  /// Installed as traditional EXE
  exe,

  /// Unknown installation type (development, other platforms)
  unknown,
}

/// Utility class to detect how the application was installed
class InstallationDetector {
  /// Detect the current installation type
  static InstallationType detect() {
    // Only relevant for Windows
    if (!Platform.isWindows) {
      return InstallationType.unknown;
    }

    // In debug/profile mode, return unknown
    if (kDebugMode || kProfileMode) {
      return InstallationType.unknown;
    }

    try {
      // Get the executable path
      final executablePath = Platform.resolvedExecutable;

      // MSIX apps are installed in WindowsApps directory
      // Typical path: C:\Program Files\WindowsApps\PublisherName.AppName_version_arch__hash\AppName.exe
      if (executablePath.contains('WindowsApps')) {
        return InstallationType.msix;
      }

      // Check if running from Program Files (typical EXE installation)
      if (executablePath.contains('Program Files') ||
          executablePath.contains('Program Files (x86)')) {
        return InstallationType.exe;
      }

      // Check environment variables that are set for MSIX apps
      final isPackaged = Platform.environment.containsKey('APPX_PROCESS');
      if (isPackaged) {
        return InstallationType.msix;
      }

      // Default to EXE for release builds on Windows
      if (kReleaseMode) {
        return InstallationType.exe;
      }

      return InstallationType.unknown;
    } catch (e) {
      // If detection fails, assume unknown
      return InstallationType.unknown;
    }
  }

  /// Get the preferred file extension for updates based on installation type
  /// Returns null for unknown installation types (e.g., running from Flutter)
  static String? getPreferredExtension(InstallationType type) {
    switch (type) {
      case InstallationType.msix:
        return '.msix';
      case InstallationType.exe:
        return '.exe';
      case InstallationType.unknown:
        // Don't prefer any installer for unknown installations
        // (e.g., running from Flutter in debug mode)
        return null;
    }
  }

  /// Get a human-readable description of the installation type
  static String getDescription(InstallationType type) {
    switch (type) {
      case InstallationType.msix:
        return 'MSIX Package (Windows Store)';
      case InstallationType.exe:
        return 'Traditional Installer';
      case InstallationType.unknown:
        return 'Unknown Installation';
    }
  }
}
