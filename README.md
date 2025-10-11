# TKit - Twitch Toolkit

**Automatically update your Twitch category based on what you're doing**

TKit is a Windows desktop application that monitors your active window and automatically switches your Twitch stream category to match the application or game you're currently using. Stop manually updating your Twitch category every time you switch games - let TKit do it for you.

## What Does TKit Do?

If you're a Twitch streamer who:
- Switches between multiple games during a stream
- Alternates between gaming and other activities (coding, art, music production, etc.)
- Forgets to update your category when switching games
- Wants to maintain accurate categories for better discoverability

TKit solves this by automatically detecting which application has focus and updating your Twitch category accordingly.

## Key Features

### Automatic Category Switching
- Monitors your active window in real-time
- Automatically updates your Twitch category when you switch applications
- Configurable scan interval and debounce settings to prevent rapid switches

### Smart Process Mapping
- Map any application or game to a Twitch category
- Pre-seeded with common games and applications
- Search Twitch's category database to find the right match
- Import/export mapping configurations

### Convenient Controls
- System tray integration - runs quietly in the background
- Global hotkeys for quick manual category updates
- Enable/disable auto-switching with one click
- View update history to track category changes

### Streamer-Friendly
- Multi-language support (English, Czech, Polish, Spanish, French, German, Portuguese, Japanese, Korean, Chinese)
- Desktop notifications for category changes
- Fallback behavior for unmapped processes
- Runs minimized to system tray to stay out of your way

## Installation

### Requirements
- Windows 10 or later
- A Twitch account with streaming privileges

### Setup
1. Download the latest release from the [Releases page](../../releases)
2. Extract the archive to your preferred location
3. Run `tkit.exe`
4. On first launch:
   - Select your preferred language
   - Authenticate with your Twitch account
   - Configure your initial process-to-category mappings

## Usage

### First Time Setup

1. **Authentication**
   - Click "Connect with Twitch" on the Auth page
   - Log in with your Twitch credentials
   - Authorize TKit to manage your broadcast settings

2. **Configure Mappings**
   - Navigate to "Category Mappings"
   - Add mappings for your common applications/games
   - Search for Twitch categories using the built-in search
   - Click "Add Mapping" to save

3. **Start Auto-Switching**
   - Go to "Auto Switcher"
   - Click "Start Monitoring"
   - TKit will now watch for window changes and update your category

### Settings

Configure TKit to match your workflow:

- **Scan Interval**: How often TKit checks your active window (1-300 seconds)
- **Debounce Interval**: Delay before switching categories to prevent rapid changes (0-300 seconds)
- **Fallback Behavior**: What to do when an unmapped process is detected
  - Ignore (keep current category)
  - Stop monitoring
  - Switch to a default category
- **Hotkeys**: Set global keyboard shortcuts for manual updates
- **Notifications**: Toggle desktop notifications for category changes

### System Tray

TKit runs in the system tray for quick access:
- **Show TKit**: Open the main window
- **Auto Switcher**: Jump to the auto-switcher page
- **Category Mappings**: Manage your mappings
- **Settings**: Configure TKit
- **Exit**: Close TKit

## How It Works

```
┌─────────────────────┐
│  Active Window      │
│  (e.g., League of   │
│   Legends)          │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  TKit Process       │
│  Detection          │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  Category Mapping   │
│  Lookup             │
│  LoL → League of    │
│        Legends      │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  Twitch API Update  │
│  Set category to    │
│  "League of         │
│   Legends"          │
└─────────────────────┘
```

## Architecture (For Developers)

TKit is built with Flutter for Windows and follows Clean Architecture principles:

### Tech Stack
- **Flutter**: Cross-platform UI framework
- **Provider**: State management
- **Drift**: Local SQLite database for persistent storage
- **Dio**: HTTP client for Twitch API integration
- **flutter_secure_storage**: Secure token storage
- **window_manager**: Native window management
- **hotkey_manager**: Global hotkey support

### Project Structure

```
lib/
├── core/
│   ├── config/           # App configuration
│   ├── database/         # Drift database setup
│   ├── errors/           # Error handling
│   ├── platform/         # Windows platform channels
│   ├── routing/          # Auto-route navigation
│   └── services/         # Core services (tray, hotkeys, updates, etc.)
├── features/             # Feature modules (Clean Architecture)
│   ├── auth/             # Twitch OAuth authentication
│   ├── auto_switcher/    # Main orchestration logic
│   ├── category_mapping/ # Process-to-category mappings
│   ├── process_detection/# Active window detection
│   ├── settings/         # App settings management
│   ├── twitch_api/       # Twitch API integration
│   └── welcome/          # First-run experience
├── presentation/         # Shared UI components
├── shared/              # Shared utilities and theme
└── main.dart            # Application entry point
```

### Clean Architecture Layers

Each feature follows Clean Architecture:
- **Domain**: Entities, repositories (interfaces), use cases
- **Data**: Repository implementations, data sources, models
- **Presentation**: UI, state management (providers), widgets

### Building from Source

#### Prerequisites
```bash
Flutter SDK (>=3.11.0)
Dart SDK (>=3.11.0-8.0.dev)
Windows development tools
```

#### Steps
```bash
# Clone the repository
git clone <repository-url>
cd TKitFlutter

# Install dependencies
flutter pub get

# Generate code (for Drift, JSON serialization, routing)
dart run build_runner build --delete-conflicting-outputs

# Generate localizations
flutter gen-l10n

# Run in development mode
flutter run -d windows

# Build release
flutter build windows --release
```

### Contributing

Contributions are welcome! This project follows Clean Architecture principles:

1. **Features are isolated**: Each feature has its own domain, data, and presentation layers
2. **Dependency injection**: Manual DI setup in `main.dart`
3. **Use cases**: Business logic is encapsulated in use case classes
4. **Repositories**: Abstract interfaces in domain, implementations in data
5. **State management**: Provider for reactive state updates

When adding new features:
1. Create the feature structure under `lib/features/`
2. Define domain entities and repository interfaces
3. Implement data sources and repository
4. Create use cases for business logic
5. Build UI with providers for state management
6. Wire up dependencies in `main.dart`

## API Configuration

TKit uses the Twitch Helix API. The OAuth client ID is configured in `lib/core/config/app_config.dart`:

```dart
static const String twitchClientId = 'cvl099faue5hszx1so8y21844l7avb';
static const String twitchRedirectUri = 'http://localhost:3000/callback';
```

### Required Scopes
- `user:read:email`: Read user email
- `channel:manage:broadcast`: Update channel information (category)

## Roadmap

Future enhancements planned:
- [ ] Multi-platform support (macOS, Linux)
- [ ] Title/tag auto-updates alongside category
- [ ] Time-based category scheduling
- [ ] Advanced mapping rules (by window title, executable path, etc.)
- [ ] Integration with other streaming platforms
- [ ] Cloud sync for mappings across devices

## Known Limitations

- **Windows only**: Currently only supports Windows due to platform-specific process detection
- **Manual OAuth**: Requires browser-based OAuth flow for Twitch authentication
- **Local mappings**: Process mappings are stored locally (no cloud sync yet)

## License

[Add your license information here]

## Support

If you encounter issues or have questions:
- Open an issue on GitHub
- Check existing issues for solutions
- Provide logs from the application (stored in the application directory)

## Credits

Built with Flutter and inspired by the need for better stream automation tools.

Special thanks to the Twitch developer community for API documentation and support.

---

**Note**: TKit is not affiliated with or endorsed by Twitch Interactive, Inc.
