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

  factory UpdateInfo.fromGitHubRelease(Map<String, dynamic> release) {
    final assets = release['assets'] as List;
    final windowsAsset = _findWindowsAsset(assets);

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

  static Map<String, dynamic> _findWindowsAsset(List assets) {
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
