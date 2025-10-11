# Deployment Guide

This guide covers how to deploy TKit releases using GitHub Actions with automated builds and installers.

## Table of Contents
- [Version Management](#version-management)
- [Creating Your First Release](#creating-your-first-release)
- [Creating Future Releases](#creating-future-releases)
- [Release Channels](#release-channels)
- [Testing Updates](#testing-updates)
- [Troubleshooting](#troubleshooting)

## Version Management

### Single Source of Truth

**IMPORTANT**: Version is managed in ONE place only - `pubspec.yaml`

```yaml
# pubspec.yaml
version: 0.0.1-dev.1+1
```

The app automatically reads this at runtime using `package_info_plus`. No need to update any other files!

### Version Format

```
MAJOR.MINOR.PATCH[-PRERELEASE]+BUILD
```

Examples:
- `0.0.1-dev.1+1` - Development release
- `1.0.0-beta.1+5` - Beta release
- `1.0.0-rc.1+10` - Release candidate
- `1.0.0+15` - Stable release

## Creating Your First Release

### Step 1: Verify Current Setup

Check your current version:
```yaml
# pubspec.yaml
version: 0.0.1-dev.1+1
```

### Step 2: Update CHANGELOG

Edit `CHANGELOG.md`:
```markdown
## [0.0.1-dev.1] - 2025-10-11

### Added
- Initial development release
- Multiple release channels support (Stable, RC, Beta, Dev)
- Update channel preference in settings
- Automatic prerelease detection based on version suffix
```

### Step 3: Build and Test Locally

```bash
# Build Windows release
flutter build windows --release

# Test the executable
.\build\windows\x64\runner\Release\tkit.exe

# Verify version shows correctly in app
```

### Step 4: Commit Changes

```bash
git add .
git commit -m "Release 0.0.1-dev.1"
git push origin main
```

### Step 5: Create and Push Tag

```bash
# Create tag (must start with 'v')
git tag v0.0.1-dev.1

# Push tag to trigger GitHub Actions
git push origin v0.0.1-dev.1
```

### Step 6: Monitor Build

1. Go to GitHub repository
2. Click **Actions** tab
3. Watch the **Release** workflow
4. Wait for build to complete (~5-10 minutes)

### Step 7: Verify Release

1. Go to **Releases** page
2. Verify `v0.0.1-dev.1` is created
3. Check it's marked as **Pre-release** (yellow tag)
4. Verify Windows installer is attached
5. Check release notes from CHANGELOG appear

## Creating Future Releases

### For Development Releases

**1. Update Version** (ONLY in pubspec.yaml)
```yaml
version: 0.0.2-dev.1+2
```

**2. Update CHANGELOG.md**
```markdown
## [0.0.2-dev.1] - 2025-10-12

### Added
- New feature X

### Fixed
- Bug Y
```

**3. Commit, Tag, Push**
```bash
git add .
git commit -m "Release 0.0.2-dev.1"
git push origin main
git tag v0.0.2-dev.1
git push origin v0.0.2-dev.1
```

### For Beta Releases

```yaml
# pubspec.yaml
version: 0.1.0-beta.1+5
```

```bash
git tag v0.1.0-beta.1
git push origin v0.1.0-beta.1
```

### For Stable Releases

```yaml
# pubspec.yaml - Remove prerelease suffix
version: 1.0.0+10
```

```bash
git tag v1.0.0
git push origin v1.0.0
```

## Release Channels

### How Channels Work

| Channel | Gets Updates | Example Versions |
|---------|-------------|------------------|
| **Stable** | Stable only | `1.0.0`, `1.0.1` |
| **RC** | Stable + RC | `1.0.0`, `1.0.1-rc.1` |
| **Beta** | Stable + RC + Beta | `1.0.0`, `1.0.1-beta.1` |
| **Dev** | All versions | `1.0.0`, `1.0.1-dev.1` |

### Channel Detection

**GitHub Actions** automatically detects channel from version suffix:
- No suffix → **Stable** release
- `-rc.*` → **RC** (Release Candidate)
- `-beta.*` → **Beta** release
- `-dev.*` or `-alpha.*` → **Dev** release

### Automatic Channel Selection

**First-time users** get their update channel automatically set based on the version they install:

- Install `0.0.1-dev.1` → Default to **Dev** channel
- Install `1.0.0-beta.1` → Default to **Beta** channel
- Install `1.0.0-rc.1` → Default to **RC** channel
- Install `1.0.0` → Default to **Stable** channel

This happens automatically on first launch. Users can change their channel preference in Settings → Updates at any time.

## Testing Updates

### Local Testing Workflow

**1. Build Current Version**
```bash
flutter build windows --release
```

**2. Install and Run**
- Run the built executable
- Go to Settings → Updates
- Select "Dev" channel (to see dev releases)

**3. Create New Release**
- Increment version: `0.0.2-dev.1`
- Update CHANGELOG
- Commit, tag, push
- Wait for GitHub Actions build

**4. Test Update**
- In running app: Settings → Check for Updates
- Should see notification for new version
- Test download and installation

### Testing Different Channels

**Test Stable Channel** (ignores prereleases)
```yaml
version: 1.0.0+1  # Stable
```
- Only visible to Stable channel users
- Dev/Beta users won't see it

**Test Dev Channel** (sees everything)
```yaml
version: 0.0.3-dev.1+3  # Dev
```
- Visible to Dev channel users only
- Stable/Beta/RC users won't see it

## Troubleshooting

### Build Fails on GitHub Actions

**Check Flutter Version**
- Workflow uses: `3.35.0`
- Update in `.github/workflows/release.yml` if needed

**Check Dependencies**
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
```

### Installer Not Created

**Check Inno Setup Script**
- File: `windows/installer.iss`
- Verify GUID is set
- Check paths are correct

**Test Locally**
```powershell
# Install Inno Setup
choco install innosetup -y

# Set version
$env:VERSION = "0.0.1-dev.1"

# Build installer
iscc windows\installer.iss

# Check output
ls build\windows\TKit-Setup-*.exe
```

### Update Not Detected

**Check GitHub Repository Settings**
- Repository must be public OR
- App needs GitHub token for private repos

**Verify App Config**
```dart
// lib/core/config/app_config.dart
static const String githubOwner = 'evobug-com';
static const String githubRepo = 'TKit';
```

**Check Logs**
- Run app in debug mode
- Watch console for update check logs
- Look for GitHub API errors

### Version Not Showing

**Verify Package Info**
```bash
# Check version loads
flutter run
# Look for: "App version: 0.0.1-dev.1" in logs
```

**Check pubspec.yaml**
```yaml
version: 0.0.1-dev.1+1  # Must be valid semver
```

### CHANGELOG Not Extracted

**Format Must Be Exact**
```markdown
## [0.0.1-dev.1] - 2025-10-11

### Added
- Item 1

[0.0.1-dev.1]: https://github.com/evobug-com/TKit/releases/tag/v0.0.1-dev.1
```

**Version in CHANGELOG must match tag** (without 'v' prefix)

## Quick Reference

### Complete Release Checklist

- [ ] Update version in `pubspec.yaml` ONLY
- [ ] Add entry to `CHANGELOG.md`
- [ ] Add version link at bottom of CHANGELOG
- [ ] Test build locally: `flutter build windows --release`
- [ ] Commit changes: `git commit -m "Release vX.Y.Z"`
- [ ] Push to main: `git push origin main`
- [ ] Create tag: `git tag vX.Y.Z`
- [ ] Push tag: `git push origin vX.Y.Z`
- [ ] Monitor GitHub Actions build
- [ ] Verify release on GitHub
- [ ] Test update in app

### Version Bump Guide

**Patch Release** (bug fixes)
```
0.0.1 → 0.0.2
1.0.0 → 1.0.1
```

**Minor Release** (new features, backwards compatible)
```
0.0.2 → 0.1.0
1.0.1 → 1.1.0
```

**Major Release** (breaking changes)
```
0.1.0 → 1.0.0
1.1.0 → 2.0.0
```

**Prerelease Progression**
```
0.1.0-dev.1 → 0.1.0-dev.2 → 0.1.0-beta.1 → 0.1.0-rc.1 → 0.1.0
```

## Best Practices

1. **Always test locally** before creating release tag
2. **Use semantic versioning** consistently
3. **Write clear CHANGELOG entries** - users see these in update dialog
4. **Test each channel** before promoting to stable
5. **Keep commits clean** - one release per commit
6. **Never force push** after tagging
7. **Tag from main branch** always
8. **Wait for CI** to complete before announcing release

## GitHub Actions Workflow

The release workflow (`.github/workflows/release.yml`) automatically:

1. ✅ Detects version from tag
2. ✅ Determines release channel from suffix
3. ✅ Runs `flutter pub get`
4. ✅ Runs code generation
5. ✅ Builds Windows release
6. ✅ Creates Inno Setup installer
7. ✅ Extracts release notes from CHANGELOG
8. ✅ Creates GitHub Release
9. ✅ Uploads installer as asset
10. ✅ Marks as prerelease if applicable

**No manual steps required!** Just push a tag.

## Support

For issues or questions:
- Check logs in GitHub Actions
- Review `RELEASE_PROCESS.md` for detailed info
- Check app logs for update errors
- Verify GitHub repository is accessible

---

**Remember**: Version management is now simple - update `pubspec.yaml` and `CHANGELOG.md`, then tag and push. That's it!
