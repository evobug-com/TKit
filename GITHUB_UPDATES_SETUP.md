# GitHub Releases Auto-Update Setup

This app uses a custom GitHub Releases-based auto-update system with Flutter-native UI that matches the app's dark theme.

## How It Works

1. **Update Checking**: The app checks GitHub Releases API for new versions 30 seconds after startup
2. **Version Comparison**: Uses semantic versioning to compare current version with latest release
3. **Download**: Downloads the installer directly from GitHub Releases with progress tracking
4. **Installation**: Launches the installer and exits the current app

## Configuration

Update these values in `lib/core/config/app_config.dart`:

```dart
// GitHub Repository for Updates
static const String githubOwner = 'yourname'; // Your GitHub username
static const String githubRepo = 'TKitFlutter'; // Your repository name
```

## Creating a Release

### 1. Build Your Application

```bash
flutter build windows --release
```

### 2. Package Your Application

Create an installer using Inno Setup, NSIS, or WiX. Example with Inno Setup:

```iss
[Setup]
AppName=TKit
AppVersion=1.0.1
DefaultDirName={pf}\TKit
DefaultGroupName=TKit
OutputBaseFilename=TKit-1.0.1-windows-setup
Compression=lzma2
SolidCompression=yes

[Files]
Source: "build\windows\runner\Release\*"; DestDir: "{app}"; Flags: recursesubdirs
```

### 3. Create GitHub Release

1. Go to your repository on GitHub
2. Click "Releases" → "Create a new release"
3. Tag version: `v1.0.1` (must start with 'v')
4. Release title: `Version 1.0.1`
5. Description: Write release notes in markdown
6. Upload your installer (e.g., `TKit-1.0.1-windows-setup.exe`)
7. Publish release

### 4. Version Numbering

The app automatically strips the 'v' prefix from tags:
- GitHub tag: `v1.0.1`
- Detected version: `1.0.1`

Ensure your `pubspec.yaml` version matches:
```yaml
version: 1.0.0+1  # Will be detected as 1.0.0
```

## Update Flow

1. **Startup Check**: App checks for updates 30 seconds after launch
2. **Rate Limiting**: Maximum one check every 30 minutes
3. **Update Available**: Custom dialog shows:
   - Version number
   - Publish date
   - Release notes
   - Download button

4. **Download**: Progress bar shows download status
5. **Install**: Button to install and restart app
6. **Silent Install**: Installer runs with `/VERYSILENT /NORESTART` flags

## UI Customization

The update dialog is located in:
```
lib/presentation/widgets/update_notification_widget.dart
```

It automatically uses your app's theme:
- Dark background matching `AppTheme.darkTheme`
- Primary color for accents
- Material 3 design language

## Testing

### Test Locally

1. Set current version to `1.0.0` in `pubspec.yaml`
2. Create a GitHub release `v1.0.1`
3. Run the app
4. After 30 seconds, update dialog should appear

### Test Without Publishing

Use a test repository:

```dart
// In app_config.dart
static const String githubOwner = 'test-account';
static const String githubRepo = 'test-repo';
```

Create releases in the test repo to verify the update flow.

## GitHub API Rate Limiting

- **Unauthenticated**: 60 requests per hour per IP
- **With Token**: 5,000 requests per hour (not recommended for client apps)

The app implements intelligent rate limiting:
- Minimum 30 minutes between checks
- Caches last check time
- No background polling (only checks on startup)

## Security Considerations

1. **HTTPS Only**: All downloads use HTTPS from GitHub's CDN
2. **Version Verification**: Semantic version comparison prevents downgrades
3. **User Control**: Users can dismiss updates or install later
4. **No Auto-Install**: Updates never install without explicit user consent

## Asset Naming

The app looks for Windows assets in this order:
1. Files ending with `.exe`
2. Files ending with `.msi`
3. Files ending with `.msix`
4. Files containing "windows" in the name

Recommended naming: `AppName-Version-windows-setup.exe`

Example: `TKit-1.0.1-windows-setup.exe`

## Manual Update Check

To add a manual update check button:

```dart
import 'package:get_it/get_it.dart';
import 'core/services/updater/github_update_service.dart';

// In your UI
ElevatedButton(
  onPressed: () async {
    final updateService = GetIt.instance<GitHubUpdateService>();
    await updateService.checkForUpdates(silent: false);
  },
  child: Text('Check for Updates'),
)
```

## Troubleshooting

### Update not detected
- Verify GitHub repository owner/name in `app_config.dart`
- Check GitHub release tag starts with 'v'
- Ensure release is not marked as "pre-release"
- Verify Windows asset exists in release

### Download fails
- Check internet connection
- Verify asset URL is accessible
- Check GitHub's status page for outages
- Look for errors in application logs

### Install fails
- Ensure installer supports silent install flags
- Check Windows permissions
- Verify installer isn't corrupted

### Rate limit exceeded
- Wait 30 minutes before checking again
- Reduce check frequency if needed
- Check logs for excessive API calls

## Production Checklist

- [ ] Update `githubOwner` in `app_config.dart`
- [ ] Update `githubRepo` in `app_config.dart`
- [ ] Version in `pubspec.yaml` matches current release
- [ ] Installer supports `/VERYSILENT /NORESTART` flags
- [ ] Created GitHub release with `v` prefix
- [ ] Uploaded Windows installer to release
- [ ] Release notes are user-friendly
- [ ] Tested update flow from previous version

## Benefits Over WinSparkle/Sparkle

1. **Visual Integration**: UI matches your app's theme perfectly
2. **No XML Feeds**: Direct GitHub API integration, no appcast.xml maintenance
3. **No Code Signing Required**: GitHub HTTPS provides security
4. **Free Hosting**: GitHub Releases CDN is free and fast
5. **Simple Deployment**: Just create a release, no infrastructure needed
6. **Cross-Platform Ready**: Easy to extend to macOS/Linux with same architecture

## Architecture

```
lib/core/services/updater/
├── github_update_service.dart    # Main service
├── models/
│   ├── update_info.dart          # Update metadata
│   └── download_progress.dart    # Progress tracking
└── utils/
    └── version_comparator.dart   # Semantic versioning

lib/presentation/widgets/
└── update_notification_widget.dart  # Flutter UI
```
