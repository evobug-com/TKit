import 'package:shared_preferences/shared_preferences.dart';
import 'package:tkit/core/utils/app_logger.dart';
import 'package:tkit/core/services/updater/github_update_service.dart';
import 'package:tkit/core/services/updater/models/update_info.dart';

/// Service to track and display "What's New" after updates
class WhatsNewService {
  static const _lastSeenVersionKey = 'last_seen_version';

  final AppLogger _logger;
  final GitHubUpdateService _updateService;

  WhatsNewService(this._logger, this._updateService);

  /// Check if current version is newer than last seen version
  Future<bool> shouldShowWhatsNew(String currentVersion) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastSeenVersion = prefs.getString(_lastSeenVersionKey);

      _logger.info('Current version: $currentVersion');
      _logger.info('Last seen version: ${lastSeenVersion ?? "none"}');

      if (lastSeenVersion == null) {
        // First time running the app
        _logger.info('First launch - not showing whats new');
        await markVersionAsSeen(currentVersion);
        return false;
      }

      if (lastSeenVersion == currentVersion) {
        // Same version, don't show
        return false;
      }

      // Different version - show what's new
      _logger.info('New version detected - will show whats new');
      return true;
    } catch (e, stackTrace) {
      _logger.error('Failed to check if should show whats new', e, stackTrace);
      return false;
    }
  }

  /// Get changelog for current version
  Future<UpdateInfo?> getChangelogForVersion(String version) async {
    try {
      _logger.info('Fetching changelog for version: $version');

      // Use the update service to fetch release info from GitHub
      final releases = await _updateService.fetchAllReleases();

      // Find the release matching this version
      for (final release in releases) {
        final releaseData = release as Map<String, dynamic>;
        final tagName = releaseData['tag_name'] as String? ?? '';

        if (tagName == version || tagName == 'v$version') {
          _logger.info('Found release info for version $version');

          // Parse the release into UpdateInfo
          final changelog = releaseData['body'] as String? ?? 'No changelog available';
          final publishedAt = releaseData['published_at'] as String? ?? '';

          return UpdateInfo(
            version: version,
            downloadUrl: '', // Not needed for changelog display
            fileSize: 0, // Not needed for changelog display
            assetName: '', // Not needed for changelog display
            releaseNotes: changelog,
            publishedAt: publishedAt.isNotEmpty ? DateTime.parse(publishedAt) : DateTime.now(),
          );
        }
      }

      _logger.warning('No release info found for version $version');
      return null;
    } catch (e, stackTrace) {
      _logger.error('Failed to get changelog for version', e, stackTrace);
      return null;
    }
  }

  /// Mark current version as seen
  Future<void> markVersionAsSeen(String version) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastSeenVersionKey, version);
      _logger.info('Marked version $version as seen');
    } catch (e, stackTrace) {
      _logger.error('Failed to mark version as seen', e, stackTrace);
    }
  }
}
