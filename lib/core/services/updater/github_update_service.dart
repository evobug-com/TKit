import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/app_config.dart';
import '../../network/network_config.dart';
import '../../utils/app_logger.dart';
import '../../../features/settings/domain/entities/update_channel.dart';
import 'models/update_info.dart';
import 'models/download_progress.dart';
import 'utils/version_comparator.dart';
import 'utils/installation_detector.dart';

/// Service for checking and managing application updates from GitHub Releases
class GitHubUpdateService {
  static const String _ignoredVersionsKey = 'ignored_update_versions';

  final Dio _dio;
  final AppLogger _logger;
  Future<UpdateChannel> Function()? _channelProvider;

  late final StreamController<UpdateInfo?> _updateAvailableController;
  late final StreamController<DownloadProgress> _downloadProgressController;
  UpdateInfo? _currentUpdateValue;
  DownloadProgress _currentDownloadProgress = DownloadProgress(status: DownloadStatus.idle);

  bool _isInitialized = false;
  DateTime? _lastCheckTime;
  CancelToken? _downloadCancelToken;
  Set<String> _ignoredVersions = {};

  GitHubUpdateService(this._dio, this._logger) {
    _updateAvailableController = StreamController<UpdateInfo?>.broadcast();
    _downloadProgressController = StreamController<DownloadProgress>.broadcast();
  }

  /// Set the channel provider to get user's channel preference
  void setChannelProvider(Future<UpdateChannel> Function() provider) {
    _channelProvider = provider;
  }

  /// Stream of available updates
  Stream<UpdateInfo?> get updateAvailable => _updateAvailableController.stream;

  /// Stream of download progress
  Stream<DownloadProgress> get downloadProgress =>
      _downloadProgressController.stream;

  /// Get current update info if available
  UpdateInfo? get currentUpdate => _currentUpdateValue;

  /// Initialize the update service
  Future<void> initialize() async {
    if (_isInitialized) {
      _logger.warning('GitHub update service already initialized');
      return;
    }

    try {
      _logger.info('Initializing GitHub update service');

      // Only initialize on supported platforms (Windows and macOS)
      if (kIsWeb ||
          (defaultTargetPlatform != TargetPlatform.windows &&
              defaultTargetPlatform != TargetPlatform.macOS)) {
        _logger.info('Updates not supported on this platform');
        return;
      }

      // Load ignored versions from persistent storage
      await _loadIgnoredVersions();

      // Detect installation type
      final installationType = InstallationDetector.detect();
      _logger.info('Detected installation type: ${InstallationDetector.getDescription(installationType)}');

      _isInitialized = true;
      _logger.info('GitHub update service initialized successfully');

      // Check for updates on startup (delayed)
      Future.delayed(const Duration(seconds: 30), () async {
        // Get channel from provider if available, otherwise use stable
        final channel = _channelProvider != null
            ? await _channelProvider!()
            : UpdateChannel.stable;
        checkForUpdates(channel: channel);
      });
    } catch (e, stackTrace) {
      _logger.error('Failed to initialize GitHub update service', e, stackTrace);
    }
  }

  /// Check for updates from GitHub Releases
  /// [channel] specifies which update channel to check (stable, beta, dev, etc.)
  Future<UpdateInfo?> checkForUpdates({
    bool silent = true,
    UpdateChannel channel = UpdateChannel.stable,
  }) async {
    if (!_isInitialized) {
      _logger.warning('Service not initialized');
      return null;
    }

    try {
      // Rate limiting: don't check more than once every 30 minutes
      if (_lastCheckTime != null) {
        final timeSinceLastCheck = DateTime.now().difference(_lastCheckTime!);
        if (timeSinceLastCheck.inMinutes < 30) {
          _logger.debug('Skipping update check, last check was ${timeSinceLastCheck.inMinutes} minutes ago');
          return _currentUpdateValue;
        }
      }

      _logger.info('Checking for updates from GitHub (channel: ${channel.value})');
      _lastCheckTime = DateTime.now();

      // Detect current installation type
      final installationType = InstallationDetector.detect();
      _logger.debug('Using installation type: ${InstallationDetector.getDescription(installationType)}');

      // In debug mode or unknown installations, log a warning
      if (installationType == InstallationType.unknown) {
        _logger.warning('Running in debug/development mode - update checks are for testing only');
      }

      UpdateInfo? updateInfo;

      // Fetch all releases to support multi-version changelogs
      final url = 'https://api.github.com/repos/${AppConfig.githubOwner}/${AppConfig.githubRepo}/releases';

      Response? response;
      try {
        response = await _dio.get(
          url,
          options: Options(
            headers: {
              'Accept': 'application/vnd.github+json',
              'X-GitHub-Api-Version': '2022-11-28',
            },
          ),
        );
      } on DioException catch (e) {
        if (e.response?.statusCode == 404) {
          _logger.debug('No releases found on GitHub yet');
          return null;
        }
        rethrow;
      }

      if (response.statusCode != 200) {
        _logger.warning('Failed to fetch releases: ${response.statusCode}');
        return null;
      }

      final allReleases = response.data as List;

      // Find the latest release matching the channel
      Map<String, dynamic>? latestRelease;
      for (final release in allReleases) {
        final releaseData = release as Map<String, dynamic>;
        final tagName = releaseData['tag_name'] as String;
        final version = tagName.startsWith('v') ? tagName.substring(1) : tagName;

        // For stable channel, check if it's not a prerelease
        if (channel == UpdateChannel.stable) {
          final isPrerelease = releaseData['prerelease'] as bool? ?? false;
          if (!isPrerelease) {
            latestRelease = releaseData;
            break;
          }
        } else {
          // For other channels, check if this version is acceptable
          if (channel.acceptsVersion(version)) {
            latestRelease = releaseData;
            break;
          }
        }
      }

      if (latestRelease == null) {
        _logger.info('No releases found for channel: ${channel.value}');
        return null;
      }

      // Get the latest version
      final latestTagName = latestRelease['tag_name'] as String;
      final latestVersion = latestTagName.startsWith('v')
          ? latestTagName.substring(1)
          : latestTagName;

      // Collect all intermediate releases between current version and latest version
      final intermediateReleases = <Map<String, dynamic>>[];
      for (final release in allReleases) {
        final releaseData = release as Map<String, dynamic>;
        final tagName = releaseData['tag_name'] as String;
        final version = tagName.startsWith('v') ? tagName.substring(1) : tagName;

        // Check if version is between current and latest (inclusive of latest)
        if (VersionComparator.isGreaterThan(version, AppConfig.appVersion) &&
            (VersionComparator.isLessThan(version, latestVersion) ||
             VersionComparator.isEqual(version, latestVersion))) {
          // For stable channel, exclude prereleases
          if (channel == UpdateChannel.stable) {
            final isPrerelease = releaseData['prerelease'] as bool? ?? false;
            if (!isPrerelease) {
              intermediateReleases.add(releaseData);
            }
          } else {
            // For other channels, check if version is acceptable
            if (channel.acceptsVersion(version)) {
              intermediateReleases.add(releaseData);
            }
          }
        }
      }

      // Create UpdateInfo with multiple changelogs if we have intermediate releases
      if (intermediateReleases.isNotEmpty) {
        try {
          updateInfo = UpdateInfo.fromMultipleReleases(
            intermediateReleases,
            installationType: installationType,
          );
        } catch (e) {
          _logger.warning('Failed to parse releases with changelogs, falling back to single release', e);
          // Fallback to single release
          updateInfo = UpdateInfo.fromGitHubRelease(
            latestRelease,
            installationType: installationType,
          );
        }
      } else {
        updateInfo = UpdateInfo.fromGitHubRelease(
          latestRelease,
          installationType: installationType,
        );
      }

      _logger.info('Latest version from GitHub: ${updateInfo.version}');
      _logger.info('Current version: ${AppConfig.appVersion}');
      _logger.info('Selected installer: ${updateInfo.assetName}');
      _logger.info('Found ${updateInfo.versionChangelogs.length} version changelog(s)');

      // Compare versions
      if (VersionComparator.isGreaterThan(
        updateInfo.version,
        AppConfig.appVersion,
      )) {
        _logger.info('Update available: ${updateInfo.version}');

        // Check if this version is ignored
        if (isVersionIgnored(updateInfo.version)) {
          _logger.info('Update version ${updateInfo.version} is ignored - update indicator will show but auto-dialog will not');
        }

        // Always set current update and emit to stream
        // The UpdateNotificationWidget will check if it's ignored before showing dialog
        _currentUpdateValue = updateInfo;
        _updateAvailableController.add(updateInfo);
        return updateInfo;
      } else {
        _logger.info('No updates available, already on latest version');
        _currentUpdateValue = null;
        _updateAvailableController.add(null);
        return null;
      }
    } catch (e, stackTrace) {
      _logger.error('Failed to check for updates', e, stackTrace);
      return null;
    }
  }

  File? _downloadedFile;

  /// Download the update installer
  Future<File?> downloadUpdate(UpdateInfo updateInfo) async {
    try {
      // If already downloaded, return the cached file
      if (_downloadedFile != null && _downloadedFile!.existsSync()) {
        _logger.info('Update already downloaded: ${_downloadedFile!.path}');
        return _downloadedFile;
      }

      _logger.info('=== STARTING UPDATE DOWNLOAD ===');
      _logger.info('Asset name: ${updateInfo.assetName}');
      _logger.info('Download URL: ${updateInfo.downloadUrl}');
      _logger.info('File size: ${updateInfo.fileSize} bytes');

      // Reset download progress
      _currentDownloadProgress = DownloadProgress(
        status: DownloadStatus.downloading,
        totalBytes: updateInfo.fileSize,
      );
      _downloadProgressController.add(_currentDownloadProgress);

      // Create temp directory
      final tempDir = Directory.systemTemp.createTempSync('tkit_update_');
      final savePath = '${tempDir.path}${Platform.pathSeparator}${updateInfo.assetName}';
      _logger.info('Save path: $savePath');

      _downloadCancelToken = CancelToken();

      // Download with progress tracking (use long timeout for large files)
      await _dio.download(
        updateInfo.downloadUrl,
        savePath,
        cancelToken: _downloadCancelToken,
        options: Options(
          receiveTimeout: NetworkConfig.longTimeout,
          sendTimeout: NetworkConfig.longTimeout,
        ),
        onReceiveProgress: (received, total) {
          _currentDownloadProgress = DownloadProgress(
            status: DownloadStatus.downloading,
            bytesReceived: received,
            totalBytes: total > 0 ? total : updateInfo.fileSize,
          );
          _downloadProgressController.add(_currentDownloadProgress);
        },
      );

      final file = File(savePath);

      if (!file.existsSync()) {
        throw Exception('Downloaded file not found');
      }

      _currentDownloadProgress = DownloadProgress(
        status: DownloadStatus.completed,
        bytesReceived: updateInfo.fileSize,
        totalBytes: updateInfo.fileSize,
      );
      _downloadProgressController.add(_currentDownloadProgress);

      // Cache the downloaded file for reuse
      _downloadedFile = file;

      _logger.info('=== DOWNLOAD COMPLETED ===');
      _logger.info('File path: $savePath');
      _logger.info('File size: ${file.lengthSync()} bytes');
      return file;
    } catch (e, stackTrace) {
      _logger.error('Failed to download update', e, stackTrace);

      _currentDownloadProgress = DownloadProgress(
        status: DownloadStatus.failed,
        error: e.toString(),
      );
      _downloadProgressController.add(_currentDownloadProgress);

      return null;
    }
  }

  /// Cancel ongoing download
  void cancelDownload() {
    if (_downloadCancelToken != null && !_downloadCancelToken!.isCancelled) {
      _downloadCancelToken!.cancel('User cancelled download');
      _currentDownloadProgress = DownloadProgress(status: DownloadStatus.cancelled);
      _downloadProgressController.add(_currentDownloadProgress);
      _logger.info('Download cancelled by user');
    }
  }

  /// Install the downloaded update
  Future<bool> installUpdate(File installerFile) async {
    try {
      _logger.info('=== STARTING UPDATE INSTALLATION ===');
      _logger.info('Installer file path: ${installerFile.path}');
      _logger.info('File exists: ${installerFile.existsSync()}');

      if (!installerFile.existsSync()) {
        _logger.error('Installer file not found at: ${installerFile.path}');
        throw Exception('Installer file not found');
      }

      _logger.info('File size: ${installerFile.lengthSync()} bytes');

      // Launch the installer based on file type
      final fileName = installerFile.path.toLowerCase();
      _logger.info('Detected file extension: ${fileName.substring(fileName.lastIndexOf('.'))}');

      if (fileName.endsWith('.msix')) {
        // For MSIX files, use cmd.exe to launch with default handler
        // This opens the Windows App Installer UI
        _logger.info('Launching MSIX package via cmd.exe...');
        _logger.info('Command: cmd.exe /c start "" "${installerFile.path}"');

        final process = await Process.start(
          'cmd.exe',
          [
            '/c',
            'start',
            '""',
            installerFile.path,
          ],
          mode: ProcessStartMode.detached,
        );

        _logger.info('CMD process started with PID: ${process.pid}');
      } else if (fileName.endsWith('.exe')) {
        // For .exe files, launch with silent install flags if supported
        _logger.info('Launching EXE installer...');

        final process = await Process.start(
          installerFile.path,
          ['/VERYSILENT', '/NORESTART'],
          mode: ProcessStartMode.detached,
        );

        _logger.info('EXE process started with PID: ${process.pid}');
      } else {
        // For other file types, just open them with default handler
        _logger.info('Opening installer with default handler...');

        final process = await Process.start(
          'cmd.exe',
          ['/c', 'start', '""', installerFile.path],
          mode: ProcessStartMode.detached,
        );

        _logger.info('Process started with PID: ${process.pid}');
      }

      _logger.info('Installer launched successfully');
      _logger.info('Application will exit in 2 seconds...');

      // Exit the current application to allow update
      // Give the installer process time to fully start before exiting
      Future.delayed(const Duration(seconds: 2), () {
        _logger.info('Exiting application for update installation');
        exit(0);
      });

      return true;
    } catch (e, stackTrace) {
      _logger.error('=== UPDATE INSTALLATION FAILED ===');
      _logger.error('Error: $e');
      _logger.error('Stack trace: $stackTrace');
      return false;
    }
  }

  /// Load ignored versions from persistent storage
  Future<void> _loadIgnoredVersions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ignoredList = prefs.getStringList(_ignoredVersionsKey) ?? [];
      _ignoredVersions = ignoredList.toSet();
      _logger.info('Loaded ${_ignoredVersions.length} ignored version(s): ${_ignoredVersions.join(", ")}');
    } catch (e, stackTrace) {
      _logger.error('Failed to load ignored versions', e, stackTrace);
    }
  }

  /// Save ignored versions to persistent storage
  Future<void> _saveIgnoredVersions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_ignoredVersionsKey, _ignoredVersions.toList());
      _logger.info('Saved ${_ignoredVersions.length} ignored version(s)');
    } catch (e, stackTrace) {
      _logger.error('Failed to save ignored versions', e, stackTrace);
    }
  }

  /// Check if a version is ignored
  bool isVersionIgnored(String version) {
    return _ignoredVersions.contains(version);
  }

  /// Ignore the current update version (don't show auto-dialog, but keep indicator visible)
  Future<void> ignoreUpdate() async {
    if (_currentUpdateValue != null) {
      _ignoredVersions.add(_currentUpdateValue!.version);
      await _saveIgnoredVersions();
      _logger.info('Ignored update version: ${_currentUpdateValue!.version}');
      // Note: We don't clear _currentUpdateValue here, so the indicator stays visible
    }
  }

  /// Clear ignored versions (for settings/debugging)
  Future<void> clearIgnoredVersions() async {
    _ignoredVersions.clear();
    await _saveIgnoredVersions();
    _logger.info('Cleared all ignored versions');
  }

  /// Dismiss the current update notification (temporary, until next check)
  void dismissUpdate() {
    _currentUpdateValue = null;
    _updateAvailableController.add(null);
    _logger.info('Update notification dismissed');
  }

  /// Check if service is initialized
  bool get isInitialized => _isInitialized;

  /// Dispose resources
  void dispose() {
    _updateAvailableController.close();
    _downloadProgressController.close();
    _downloadCancelToken?.cancel();
  }
}
