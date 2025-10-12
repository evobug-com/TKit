# Changelog

All notable changes to TKit will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Icon for tray and the app
- Msix installer 
- Avoid closing settings when changes are unsaved/undiscarded

### Changed
- Compact UI for settings and mappings
- Check for updates on startup
- Improved welcome screen

### Fixed
- Save in settings not disappearing after saving

## [0.0.1-dev.1] - 2025-10-11

### Added
- Initial release of TKit (Twitch Toolkit)
- Initial development release
- Multiple release channels support (Stable, RC, Beta, Dev)
- Update channel preference in settings
- GitHub Actions workflow support for prereleases
- Automatic prerelease detection based on version suffix
- Single source of truth for versioning (pubspec.yaml)
- Automatic Twitch category switching based on active process detection
- Category mapping management with search and filtering
- Twitch OAuth authentication
- Process detection for Windows
- Auto-switcher functionality with configurable scan intervals
- System tray integration
- Update notification system with automatic downloads
- Comprehensive settings management
- Multi-language support (English, Czech, Polish, Spanish, French, German, Portuguese, Japanese, Korean, Chinese)
- Dark theme support

### Changed
- Version now read from pubspec.yaml automatically
- No need to manually update version in multiple files


### Features
- **Category Mapping**: Map executable paths to Twitch categories
- **Auto Switcher**: Automatically detect running processes and switch categories
- **Process Detection**: Real-time Windows process monitoring
- **Settings**: Configurable scan intervals, debounce times, and preferences
- **Twitch Integration**: OAuth authentication and category management
- **System Tray**: Minimize to tray, quick access to features
- **Auto Updates**: Check for and install updates from GitHub releases

[Unreleased]: https://github.com/evobug-com/TKit/compare/v0.0.1-dev.1...HEAD
[0.0.1-dev.1]: https://github.com/evobug-com/TKit/releases/tag/v0.0.1-dev.1