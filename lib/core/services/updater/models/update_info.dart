import 'package:tkit/core/services/updater/utils/installation_detector.dart';

/// Changelog for a specific version
class VersionChangelog {
  final String version;
  final DateTime publishedAt;
  final String notes;

  VersionChangelog({
    required this.version,
    required this.publishedAt,
    required this.notes,
  });
}

/// Information about an available update
class UpdateInfo {
  final String version;
  final String downloadUrl;
  final String releaseNotes;
  final String assetName;
  final int fileSize;
  final DateTime publishedAt;
  final List<VersionChangelog> versionChangelogs;

  UpdateInfo({
    required this.version,
    required this.downloadUrl,
    required this.releaseNotes,
    required this.assetName,
    required this.fileSize,
    required this.publishedAt,
    List<VersionChangelog>? versionChangelogs,
  }) : versionChangelogs = versionChangelogs ?? [];

  factory UpdateInfo.fromGitHubRelease(
    Map<String, dynamic> release, {
    InstallationType? installationType,
    List<VersionChangelog>? versionChangelogs,
  }) {
    final assets = release['assets'] as List;
    final windowsAsset = _findWindowsAsset(assets, installationType);

    return UpdateInfo(
      version: _parseVersion(release['tag_name'] as String),
      downloadUrl: windowsAsset['browser_download_url'] as String,
      releaseNotes: release['body'] as String? ?? 'No release notes available.',
      assetName: windowsAsset['name'] as String,
      fileSize: windowsAsset['size'] as int? ?? 0,
      publishedAt: DateTime.parse(release['published_at'] as String),
      versionChangelogs: versionChangelogs,
    );
  }

  /// Create UpdateInfo with multiple version changelogs from a list of releases
  factory UpdateInfo.fromMultipleReleases(
    List<Map<String, dynamic>> releases, {
    InstallationType? installationType,
  }) {
    if (releases.isEmpty) {
      throw ArgumentError('Releases list cannot be empty');
    }

    // Latest release is the first one
    final latestRelease = releases.first;
    final assets = latestRelease['assets'] as List;
    final windowsAsset = _findWindowsAsset(assets, installationType);

    // Build list of version changelogs (newest to oldest)
    final changelogs = releases.map((release) {
      return VersionChangelog(
        version: _parseVersion(release['tag_name'] as String),
        publishedAt: DateTime.parse(release['published_at'] as String),
        notes: release['body'] as String? ?? 'No release notes available.',
      );
    }).toList();

    return UpdateInfo(
      version: _parseVersion(latestRelease['tag_name'] as String),
      downloadUrl: windowsAsset['browser_download_url'] as String,
      releaseNotes: latestRelease['body'] as String? ?? 'No release notes available.',
      assetName: windowsAsset['name'] as String,
      fileSize: windowsAsset['size'] as int? ?? 0,
      publishedAt: DateTime.parse(latestRelease['published_at'] as String),
      versionChangelogs: changelogs,
    );
  }

  static String _parseVersion(String tagName) {
    // Remove 'v' prefix if present
    return tagName.startsWith('v') ? tagName.substring(1) : tagName;
  }

  static Map<String, dynamic> _findWindowsAsset(
    List<dynamic> assets,
    InstallationType? installationType,
  ) {
    // Determine preferred extension based on installation type
    final preferredExtension = installationType != null
        ? InstallationDetector.getPreferredExtension(installationType)
        : null;

    // First try to find asset matching the installation type
    if (preferredExtension != null) {
      for (final asset in assets) {
        final assetMap = asset as Map<String, dynamic>;
        final name = (assetMap['name'] as String).toLowerCase();
        if (name.endsWith(preferredExtension)) {
          return assetMap;
        }
      }
    }

    // Fallback for unknown installations: prefer MSIX (safer, sandboxed)
    if (installationType == InstallationType.unknown) {
      // Try EXE first
      for (final asset in assets) {
        final assetMap = asset as Map<String, dynamic>;
        final name = (assetMap['name'] as String).toLowerCase();
        if (name.endsWith('.exe')) {
          return assetMap;
        }
      }

      // Then try MSIX
      for (final asset in assets) {
        final assetMap = asset as Map<String, dynamic>;
        final name = (assetMap['name'] as String).toLowerCase();
        if (name.endsWith('.msix')) {
          return assetMap;
        }
      }
    }

    // Final fallback: find any Windows asset
    for (final asset in assets) {
      final assetMap = asset as Map<String, dynamic>;
      final name = (assetMap['name'] as String).toLowerCase();
      if (name.endsWith('.exe') ||
          name.endsWith('.msi') ||
          name.endsWith('.msix') ||
          name.contains('windows')) {
        return assetMap;
      }
    }

    throw Exception('No Windows asset found in release');
  }
}
