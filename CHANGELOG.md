# Changelog

All notable changes to TKit will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### TKit

#### Added
- What's new dialog on app start showing latest changes
- Plus button next to Active App to add mapping of the current process
- Automatic start of auto-updater on app launch (if enabled in settings)

#### Fixed
- Automatic start of auto-switcher on app launch (setting existed but wasn't actually implemented)
- Auto-sync mappings on app start now works correctly (setting existed but wasn't being checked)

## [0.0.1-dev.7] - 2025-10-18

### TKit

#### Added
- Sentry error tracking and performance monitoring
- Tutorial screens for first-time users

#### Changed
- Redesigned autoupdate screen
- Redesigned autoswitch screen
- Improved design on Mappings screen
- Removed headings from all screens
- Markdown styles improvements in changelog

#### Fixed
- Fixed autoupdate (it was running in subprocess and on app exit it closed the updater too)
- Missing translations
- Previously ignored processes were not working with new list management system

## [0.0.1-dev.6] - 2025-10-15

### TKit

#### Added
- List Management system with support for custom mapping lists (both read-only and writable)
- Ability to import mapping lists from URLs
- Auto-sync functionality for mapping lists on app start
- Configurable auto-sync interval (1-168 hours) with "Never" option
- Ignored processes feature to prevent specific executables from triggering auto-switcher
- Checkboxes in mappings table for bulk actions (enable/disable, delete, invert, export)
- Export selected mappings to JSON file
- Search bar in mappings tab
- Clickable Source badges in mappings table that open List Management dialog
- List name display in Source column (populated from mapping lists)
- Mappings tab in Settings with auto-sync configuration
- Ability to make the app window draggable by the footer
- Official lists now appear at the top of List Management dialog
- Toggle visibility for Custom/Community mappings sections
- Ability to swap header with footer position

#### Changed
- Changelog now displays differences between current version and latest release
- Application icon and logo updated (rebrand)
- Tray menu simplified (removed Auto Switcher, Category Mappings, and Settings options)
- Removed web, Android, and iOS platforms from the project
- Source column styled as clickable badge with blue theme
- Enhanced time formatting: displays "never" for null values and formatted durations (e.g., "1d 5h ago") for times >= 24 hours
- Auto-sync interval slider now supports 0 (Never) and displays formatted values
- Fallback behavior now executes when no process is detected
- Updated metadata now syncs properly with mapping lists
- Simplified submission links to community repository
- Import paths now consistently use package imports throughout the codebase
- Error messages and logging experience improved with better context
- IGNORE key replaced with -1 for better semantic clarity
- Faster application shutdown process
- Code cleanup and refactoring improvements

#### Fixed
- Ignore mappings now always enabled
- Disabled mappings now show unknown game dialog instead of silent skip
- Process names now remove .exe extension for cross-platform compatibility
- Twitch error when adding items to ignored list
- Application hang on close
- Loading mappings from database
- Running database migrations correctly with improved logging
- Tray icon not showing properly
- Version status display issues
- Race condition causing update indicator to show "Update service not initialized" intermittently on startup

#### Removed
- Source, verification, and lastVerified fields from mapping submissions (simplified submission flow)

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

[Unreleased]: https://github.com/evobug-com/TKit/compare/v0.0.1-dev.7...HEAD
[0.0.1-dev.7]: https://github.com/evobug-com/TKit/releases/tag/v0.0.1-dev.7
[0.0.1-dev.6]: https://github.com/evobug-com/TKit/releases/tag/v0.0.1-dev.6
[0.0.1-dev.5]: https://github.com/evobug-com/TKit/releases/tag/v0.0.1-dev.5
[0.0.1-dev.4]: https://github.com/evobug-com/TKit/releases/tag/v0.0.1-dev.4
[0.0.1-dev.3]: https://github.com/evobug-com/TKit/releases/tag/v0.0.1-dev.3
[0.0.1-dev.2]: https://github.com/evobug-com/TKit/releases/tag/v0.0.1-dev.2
[0.0.1-dev.1]: https://github.com/evobug-com/TKit/releases/tag/v0.0.1-dev.1