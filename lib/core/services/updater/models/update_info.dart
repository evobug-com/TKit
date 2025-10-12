import '../utils/installation_detector.dart';

/// Information about an available update
class UpdateInfo {
  final String version;
  final String downloadUrl;
  final String releaseNotes;
  final String assetName;
  final int fileSize;
  final DateTime publishedAt;

  UpdateInfo({
    required this.version,
    required this.downloadUrl,
    required this.releaseNotes,
    required this.assetName,
    required this.fileSize,
    required this.publishedAt,
  });

  factory UpdateInfo.fromGitHubRelease(
    Map<String, dynamic> release, {
    InstallationType? installationType,
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
    );
  }

  static String _parseVersion(String tagName) {
    // Remove 'v' prefix if present
    return tagName.startsWith('v') ? tagName.substring(1) : tagName;
  }

  static Map<String, dynamic> _findWindowsAsset(
    List assets,
    InstallationType? installationType,
  ) {
    // Determine preferred extension based on installation type
    final preferredExtension = installationType != null
        ? InstallationDetector.getPreferredExtension(installationType)
        : null;

    // First try to find asset matching the installation type
    if (preferredExtension != null) {
      for (final asset in assets) {
        final name = (asset['name'] as String).toLowerCase();
        if (name.endsWith(preferredExtension)) {
          return asset as Map<String, dynamic>;
        }
      }
    }

    // Fallback for unknown installations: prefer MSIX (safer, sandboxed)
    if (installationType == InstallationType.unknown) {
      // Try MSIX first
      for (final asset in assets) {
        final name = (asset['name'] as String).toLowerCase();
        if (name.endsWith('.msix')) {
          return asset as Map<String, dynamic>;
        }
      }

      // Then try EXE
      for (final asset in assets) {
        final name = (asset['name'] as String).toLowerCase();
        if (name.endsWith('.exe')) {
          return asset as Map<String, dynamic>;
        }
      }
    }

    // Final fallback: find any Windows asset
    for (final asset in assets) {
      final name = (asset['name'] as String).toLowerCase();
      if (name.endsWith('.exe') ||
          name.endsWith('.msi') ||
          name.endsWith('.msix') ||
          name.contains('windows')) {
        return asset as Map<String, dynamic>;
      }
    }

    throw Exception('No Windows asset found in release');
  }
}
