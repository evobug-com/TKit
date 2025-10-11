import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../config/app_config.dart';
import '../../utils/app_logger.dart';
import '../../../features/settings/domain/entities/update_channel.dart';
import 'models/update_info.dart';
import 'models/download_progress.dart';
import 'utils/version_comparator.dart';

/// Service for checking and managing application updates from GitHub Releases
class GitHubUpdateService {
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

      UpdateInfo? updateInfo;

      if (channel == UpdateChannel.stable) {
        // For stable, use /releases/latest endpoint
        final url = 'https://api.github.com/repos/${AppConfig.githubOwner}/${AppConfig.githubRepo}/releases/latest';

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

        final release = response.data as Map<String, dynamic>;
        updateInfo = UpdateInfo.fromGitHubRelease(release);
      } else {
        // For other channels, fetch all releases and find the latest matching channel
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

        final releases = response.data as List;

        // Find the first (latest) release that matches the channel
        for (final release in releases) {
          final releaseData = release as Map<String, dynamic>;
          final tagName = releaseData['tag_name'] as String;
          final version = tagName.startsWith('v') ? tagName.substring(1) : tagName;

          // Check if this version is acceptable for the channel
          if (channel.acceptsVersion(version)) {
            try {
              updateInfo = UpdateInfo.fromGitHubRelease(releaseData);
              break;
            } catch (e) {
              _logger.warning('Failed to parse release: $tagName', e);
              continue;
            }
          }
        }

        if (updateInfo == null) {
          _logger.info('No releases found for channel: ${channel.value}');
          return null;
        }
      }

      _logger.info('Latest version from GitHub: ${updateInfo.version}');
      _logger.info('Current version: ${AppConfig.appVersion}');

      // Compare versions
      if (VersionComparator.isGreaterThan(
        updateInfo.version,
        AppConfig.appVersion,
      )) {
        _logger.info('Update available: ${updateInfo.version}');
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

  /// Download the update installer
  Future<File?> downloadUpdate(UpdateInfo updateInfo) async {
    try {
      _logger.info('Starting download: ${updateInfo.assetName}');

      // Reset download progress
      _currentDownloadProgress = DownloadProgress(
        status: DownloadStatus.downloading,
        totalBytes: updateInfo.fileSize,
      );
      _downloadProgressController.add(_currentDownloadProgress);

      // Create temp directory
      final tempDir = Directory.systemTemp.createTempSync('tkit_update_');
      final savePath = '${tempDir.path}${Platform.pathSeparator}${updateInfo.assetName}';

      _downloadCancelToken = CancelToken();

      // Download with progress tracking
      await _dio.download(
        updateInfo.downloadUrl,
        savePath,
        cancelToken: _downloadCancelToken,
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

      _logger.info('Download completed: $savePath');
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
      _logger.info('Starting update installation: ${installerFile.path}');

      if (!installerFile.existsSync()) {
        throw Exception('Installer file not found');
      }

      // Launch the installer
      // For .exe files, launch with silent install flags if supported
      final fileName = installerFile.path.toLowerCase();

      List<String> args = [];
      if (fileName.endsWith('.exe')) {
        // Common silent install arguments (adjust based on your installer)
        args = ['/VERYSILENT', '/NORESTART'];
      }

      await Process.start(
        installerFile.path,
        args,
        mode: ProcessStartMode.detached,
      );

      _logger.info('Installer launched successfully');

      // Exit the current application to allow update
      Future.delayed(const Duration(seconds: 1), () {
        exit(0);
      });

      return true;
    } catch (e, stackTrace) {
      _logger.error('Failed to install update', e, stackTrace);
      return false;
    }
  }

  /// Dismiss the current update notification
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
