# Changelog

All notable changes to TKit will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### TKit

#### Added
- Checkboxes in mappings to perform bulk actions (enable/disable, delete, invert, export)
- Export selected mappings to JSON file
- Search bar in mappings tab
- Ability to swap header with footer
- Support for custom listings with only read or write access and hooks for adding new items
- Clickable Source label in mappings table that opens List Management dialog
- List name display in Source column (populated from mapping lists)
- New Mappings tab in Settings with auto-sync configuration
- Auto-sync mappings on app start setting
- Configurable auto-sync interval (1-168 hours)

#### Fixed
- Twitch error when adding a process to the ignore list
- Source column now shows actual list name instead of "Unknown"
- JSON parsing error when syncing mapping lists (manual decode for String responses)
- Added comprehensive error logging to all datasource layers with stack traces

#### Changed
- Changelog now displays differences between current and latest release
- Application icon updated
- Removed Auto Switcher, Category Mappings, and Settings from the tray menu
- Removed web, Android, and iOS platforms from the project
- Renamed "Community Mappings" to "Community Games"
- Source column styled as clickable badge with blue theme
- Official lists now appear at the top of list management dialog
- Enhanced time formatting: shows "never" for null values and displays days + hours (e.g., "1d 5h ago") for times >= 24 hours
- Auto-sync interval slider now supports 0 (Never) and displays formatted values (e.g., "1d", "1d 5h")

## [0.0.1-dev.5] - 2025-10-13

### TKit

#### Changed
- Removed fuzzy matching for process names in auto-switcher (exact match only)
- Removed Implicit Flow in OAuth

#### Fixed
- Avoid twitch token to expire (missing token refresh)
- Fallback detection of some games (e.g., Helldivers 2)

## [0.0.1-dev.4] - 2025-10-12

### TKit
#### Added
- Normalized path to game in submission

## [0.0.1-dev.3] - 2025-10-12

### TKit

#### Added
- Persistent storage for ignored update versions using SharedPreferences
- Update indicator remains visible even when version is ignored
- Installation type detection (MSIX vs EXE) for automatic installer matching
- Download buttons with version badges in README for all release channels
- F2 to toggle log window visibility
- Toggle for Custom/Community mappings tab in Mappings section

#### Changed
- Update "Ignore" behavior: now version-specific and persistent across restarts
- Auto-dialog skips ignored versions but indicator stays visible for manual updates
- MSIX installer launches via PowerShell for proper process detachment
- Improved installer comparison in README with clearer recommendations

#### Fixed
- MSIX installer now launches correctly when app closes during update
- Update exit delay increased to 2 seconds to ensure installer fully starts

### Documentation

#### Added
- RELEASE_GUIDE.md with comprehensive release process documentation
- Version naming conventions for all release channels
- Asset naming requirements for consistent downloads
- Installer comparison table in README
- Download links for stable and pre-release channels

#### Changed
- Simplified download section in README for better clarity
- Reorganized installation instructions with side-by-side comparison


## [0.0.1-dev.2] - 2025-10-12

### TKit
#### Added
- Icon for tray and the app

- Avoid closing settings when changes are unsaved/undiscarded
- Theme tab in settings to turn frameless mode on/off
- Enabled checkbox in mappings
- Ability to move exit/maximize/minimize buttons

#### Changed
- Compact UI for settings and mappings
- Check for updates on startup
- Improved welcome screen

#### Fixed
- Save in settings not disappearing after saving
- Ignored applications don't throw notifications anymore

### Installer

#### Added
- Msix installer

#### Changed
- Logo for Inno Setup installer
- Changed installer name to TKit


## [0.0.1-dev.1] - 2025-10-11

### TKit

#### Added
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

#### Changed
- Version now read from pubspec.yaml automatically
- No need to manually update version in multiple files


#### Features
- **Category Mapping**: Map executable paths to Twitch categories
- **Auto Switcher**: Automatically detect running processes and switch categories
- **Process Detection**: Real-time Windows process monitoring
- **Settings**: Configurable scan intervals, debounce times, and preferences
- **Twitch Integration**: OAuth authentication and category management
- **System Tray**: Minimize to tray, quick access to features
- **Auto Updates**: Check for and install updates from GitHub releases

[Unreleased]: https://github.com/evobug-com/TKit/compare/v0.0.1-dev.5...HEAD
[0.0.1-dev.5]: https://github.com/evobug-com/TKit/releases/tag/v0.0.1-dev.5
[0.0.1-dev.4]: https://github.com/evobug-com/TKit/releases/tag/v0.0.1-dev.4
[0.0.1-dev.3]: https://github.com/evobug-com/TKit/releases/tag/v0.0.1-dev.3
[0.0.1-dev.2]: https://github.com/evobug-com/TKit/releases/tag/v0.0.1-dev.2
[0.0.1-dev.1]: https://github.com/evobug-com/TKit/releases/tag/v0.0.1-dev.1