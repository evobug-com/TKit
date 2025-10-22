import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tkit/core/config/app_config.dart';
import 'package:tkit/core/network/network_config.dart';
import 'package:tkit/core/utils/app_logger.dart';
import 'package:tkit/features/settings/domain/entities/update_channel.dart';
import 'package:tkit/core/services/updater/models/update_info.dart';
import 'package:tkit/core/services/updater/models/download_progress.dart';
import 'package:tkit/core/services/updater/utils/version_comparator.dart';
import 'package:tkit/core/services/updater/utils/installation_detector.dart';

/// Service for checking and managing application updates from GitHub Releases
class GitHubUpdateService {
  static const _ignoredVersionsKey = 'ignored_update_versions';

  final Dio _dio;
  final AppLogger _logger;
  Future<UpdateChannel> Function()? _channelProvider;

  late final StreamController<UpdateInfo?> _updateAvailableController;
  late final StreamController<DownloadProgress> _downloadProgressController;
  UpdateInfo? _currentUpdateValue;
  var _currentDownloadProgress = DownloadProgress(status: DownloadStatus.idle);

  var _isInitialized = false;
  DateTime? _lastCheckTime;
  CancelToken? _downloadCancelToken;
  Set<String> _ignoredVersions = {};

  GitHubUpdateService(this._dio, this._logger) {
    _updateAvailableController = StreamController<UpdateInfo?>.broadcast();
    _downloadProgressController =
        StreamController<DownloadProgress>.broadcast();
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

      // Load ignored versions from persistent storage with timeout
      try {
        await _loadIgnoredVersions().timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            _logger.warning('Timeout loading ignored versions, continuing...');
          },
        );
      } on TimeoutException catch (e) {
        _logger.warning('Timeout loading ignored versions: ${e.message}');
        // Continue without ignored versions
      }

      // Detect installation type
      final installationType = InstallationDetector.detect();
      _logger.info(
        'Detected installation type: ${InstallationDetector.getDescription(installationType)}',
      );

      _isInitialized = true;
      _logger.info('GitHub update service initialized successfully');

      // Check for updates on startup (brief delay to let app finish initializing)
      unawaited(
        Future.delayed(const Duration(seconds: 2), () async {
          try {
            // Get channel from provider if available, otherwise use stable
            final channel = _channelProvider != null
                ? await _channelProvider!().timeout(
                    const Duration(seconds: 5),
                    onTimeout: () {
                      _logger.warning('Timeout getting update channel');
                      return UpdateChannel.stable;
                    },
                  )
                : UpdateChannel.stable;
            await checkForUpdates(channel: channel);
          } catch (e, stackTrace) {
            _logger.error('Error during startup update check', e, stackTrace);
          }
        }),
      );
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to initialize GitHub update service',
        e,
        stackTrace,
      );
      // Don't rethrow - updates are not critical for app functionality
    }
  }

  /// Fetch all releases from GitHub
  /// Returns a list of release data from GitHub API
  Future<List<dynamic>> fetchAllReleases() async {
    try {
      final url =
          'https://api.github.com/repos/${AppConfig.githubOwner}/${AppConfig.githubRepo}/releases';

      final response = await _dio.get<dynamic>(
        url,
        options: Options(
          headers: {
            'Accept': 'application/vnd.github+json',
            'X-GitHub-Api-Version': '2022-11-28',
          },
        ),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('Fetching releases timed out');
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is! List) {
          _logger.warning('Unexpected response format: expected List');
          return [];
        }
        return data;
      }

      _logger.warning('Failed to fetch releases: ${response.statusCode}');
      return [];
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        _logger.debug('No releases found on GitHub yet');
        return [];
      } else if (e.response?.statusCode == 403) {
        _logger.warning('GitHub API rate limit exceeded');
        return [];
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        _logger.error('Network timeout fetching releases', e);
        return [];
      } else if (e.type == DioExceptionType.connectionError) {
        _logger.warning('No network connection to fetch releases');
        return [];
      }
      _logger.error('Network error fetching releases: ${e.message}', e);
      return [];
    } on TimeoutException catch (e, stackTrace) {
      _logger.error('Timeout fetching releases', e, stackTrace);
      return [];
    } on FormatException catch (e, stackTrace) {
      _logger.error('Invalid JSON format in releases response', e, stackTrace);
      return [];
    } catch (e, stackTrace) {
      _logger.error('Unexpected error fetching releases', e, stackTrace);
      return [];
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
          _logger.debug(
            'Skipping update check, last check was ${timeSinceLastCheck.inMinutes} minutes ago',
          );
          return _currentUpdateValue;
        }
      }

      _logger.info(
        'Checking for updates from GitHub (channel: ${channel.value})',
      );
      _lastCheckTime = DateTime.now();

      // Detect current installation type
      final installationType = InstallationDetector.detect();
      _logger.debug(
        'Using installation type: ${InstallationDetector.getDescription(installationType)}',
      );

      // In debug mode or unknown installations, log a warning
      if (installationType == InstallationType.unknown) {
        _logger.warning(
          'Running in debug/development mode - update checks are for testing only',
        );
      }

      UpdateInfo? updateInfo;

      // Fetch all releases to support multi-version changelogs
      final url =
          'https://api.github.com/repos/${AppConfig.githubOwner}/${AppConfig.githubRepo}/releases';

      Response<dynamic>? response;
      try {
        response = await _dio.get<List<dynamic>>(
          url,
          options: Options(
            headers: {
              'Accept': 'application/vnd.github+json',
              'X-GitHub-Api-Version': '2022-11-28',
            },
          ),
        ).timeout(
          const Duration(seconds: 30),
          onTimeout: () {
            throw TimeoutException('Update check timed out');
          },
        );
      } on DioException catch (e) {
        if (e.response?.statusCode == 404) {
          _logger.debug('No releases found on GitHub yet');
          return null;
        } else if (e.response?.statusCode == 403) {
          _logger.warning('GitHub API rate limit exceeded');
          return null;
        } else if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          _logger.error('Network timeout checking for updates', e);
          return null;
        } else if (e.type == DioExceptionType.connectionError) {
          _logger.warning('No network connection to check for updates');
          return null;
        }
        rethrow;
      } on TimeoutException catch (e, stackTrace) {
        _logger.error('Timeout checking for updates', e, stackTrace);
        return null;
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
        final version = tagName.startsWith('v')
            ? tagName.substring(1)
            : tagName;

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
        final version = tagName.startsWith('v')
            ? tagName.substring(1)
            : tagName;

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
        } on FormatException catch (e) {
          _logger.warning(
            'Invalid format parsing releases, falling back to single release',
            e,
          );
          // Fallback to single release
          try {
            updateInfo = UpdateInfo.fromGitHubRelease(
              latestRelease,
              installationType: installationType,
            );
          } catch (fallbackError, fallbackStackTrace) {
            _logger.error(
              'Failed to parse even single release',
              fallbackError,
              fallbackStackTrace,
            );
            return null;
          }
        } catch (e, stackTrace) {
          _logger.warning(
            'Error parsing releases with changelogs, falling back to single release',
            e,
            stackTrace,
          );
          // Fallback to single release
          try {
            updateInfo = UpdateInfo.fromGitHubRelease(
              latestRelease,
              installationType: installationType,
            );
          } catch (fallbackError, fallbackStackTrace) {
            _logger.error(
              'Failed to parse even single release',
              fallbackError,
              fallbackStackTrace,
            );
            return null;
          }
        }
      } else {
        try {
          updateInfo = UpdateInfo.fromGitHubRelease(
            latestRelease,
            installationType: installationType,
          );
        } on FormatException catch (e, stackTrace) {
          _logger.error('Invalid format in release data', e, stackTrace);
          return null;
        } catch (e, stackTrace) {
          _logger.error('Failed to parse release data', e, stackTrace);
          return null;
        }
      }

      _logger.info('Latest version from GitHub: ${updateInfo.version}');
      _logger.info('Current version: ${AppConfig.appVersion}');
      _logger.info('Selected installer: ${updateInfo.assetName}');
      _logger.info(
        'Found ${updateInfo.versionChangelogs.length} version changelog(s)',
      );

      // Compare versions
      if (VersionComparator.isGreaterThan(
        updateInfo.version,
        AppConfig.appVersion,
      )) {
        _logger.info('Update available: ${updateInfo.version}');

        // Check if this version is ignored
        if (isVersionIgnored(updateInfo.version)) {
          _logger.info(
            'Update version ${updateInfo.version} is ignored - update indicator will show but auto-dialog will not',
          );
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
    } on DioException catch (e, stackTrace) {
      _logger.error('Network error checking for updates: ${e.message}', e, stackTrace);
      return null;
    } on TimeoutException catch (e, stackTrace) {
      _logger.error('Timeout checking for updates', e, stackTrace);
      return null;
    } on FormatException catch (e, stackTrace) {
      _logger.error('Invalid data format from GitHub API', e, stackTrace);
      return null;
    } catch (e, stackTrace) {
      _logger.error('Unexpected error checking for updates', e, stackTrace);
      return null;
    }
  }

  File? _downloadedFile;

  /// Download the update installer
  Future<File?> downloadUpdate(UpdateInfo updateInfo) async {
    try {
      // Use a consistent temp directory path (not a new random one each time)
      final tempDirPath =
          '${Directory.systemTemp.path}${Platform.pathSeparator}tkit_updates';
      final savePath =
          '$tempDirPath${Platform.pathSeparator}${updateInfo.assetName}';
      final file = File(savePath);

      // Check if file already exists on disk (works even after app restart)
      if (file.existsSync()) {
        try {
          final fileSize = file.lengthSync();
          _logger.info('Update already exists on disk: $savePath');
          _logger.info('File size: $fileSize bytes');

          // Verify file size matches expected size
          if (fileSize != updateInfo.fileSize) {
            _logger.warning(
              'Existing file size ($fileSize) does not match expected size (${updateInfo.fileSize}), re-downloading',
            );
            file.deleteSync();
          } else {
            // Cache it in memory for this session
            _downloadedFile = file;

            // Set progress to completed
            _currentDownloadProgress = DownloadProgress(
              status: DownloadStatus.completed,
              bytesReceived: updateInfo.fileSize,
              totalBytes: updateInfo.fileSize,
            );
            _downloadProgressController.add(_currentDownloadProgress);

            return file;
          }
        } on FileSystemException catch (e, stackTrace) {
          _logger.warning(
            'Error accessing existing file, will re-download: ${e.message}',
            e,
            stackTrace,
          );
          // Continue with download
        }
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

      final tempDir = Directory(tempDirPath);

      // Create the directory if it doesn't exist
      try {
        if (!tempDir.existsSync()) {
          tempDir.createSync(recursive: true);
          _logger.info('Created temp directory: $tempDirPath');
        }
      } on FileSystemException catch (e, stackTrace) {
        _logger.error(
          'Failed to create temp directory: ${e.message}',
          e,
          stackTrace,
        );
        throw Exception('Cannot create download directory: ${e.message}');
      }

      _logger.info('Save path: $savePath');

      _downloadCancelToken = CancelToken();

      // Download with progress tracking (use long timeout for large files)
      try {
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
      } on DioException catch (e) {
        if (e.type == DioExceptionType.cancel) {
          _logger.info('Download cancelled by user');
          return null;
        } else if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          throw TimeoutException('Download timed out: ${e.message}');
        } else if (e.type == DioExceptionType.connectionError) {
          throw Exception('Network error during download: ${e.message}');
        } else if (e.response?.statusCode == 404) {
          throw Exception('Update file not found on server');
        } else if (e.response?.statusCode == 403) {
          throw Exception('Access denied to update file');
        }
        rethrow;
      }

      // Verify file was downloaded
      if (!file.existsSync()) {
        throw FileSystemException(
          'Downloaded file not found at expected location',
          savePath,
        );
      }

      // Verify file size
      final downloadedSize = file.lengthSync();
      if (downloadedSize != updateInfo.fileSize) {
        _logger.warning(
          'Downloaded file size ($downloadedSize) does not match expected size (${updateInfo.fileSize})',
        );
        // Continue anyway as GitHub API might report incorrect size
      }

      _currentDownloadProgress = DownloadProgress(
        status: DownloadStatus.completed,
        bytesReceived: downloadedSize,
        totalBytes: updateInfo.fileSize,
      );
      _downloadProgressController.add(_currentDownloadProgress);

      // Cache the downloaded file for reuse
      _downloadedFile = file;

      _logger.info('=== DOWNLOAD COMPLETED ===');
      _logger.info('File path: $savePath');
      _logger.info('File size: $downloadedSize bytes');
      return file;
    } on DioException catch (e, stackTrace) {
      final errorMessage = 'Network error downloading update: ${e.message}';
      _logger.error(errorMessage, e, stackTrace);

      _currentDownloadProgress = DownloadProgress(
        status: DownloadStatus.failed,
        error: errorMessage,
      );
      _downloadProgressController.add(_currentDownloadProgress);

      return null;
    } on TimeoutException catch (e, stackTrace) {
      const errorMessage = 'Download timed out';
      _logger.error(errorMessage, e, stackTrace);

      _currentDownloadProgress = DownloadProgress(
        status: DownloadStatus.failed,
        error: errorMessage,
      );
      _downloadProgressController.add(_currentDownloadProgress);

      return null;
    } on FileSystemException catch (e, stackTrace) {
      final errorMessage = 'File system error: ${e.message}';
      _logger.error(errorMessage, e, stackTrace);

      _currentDownloadProgress = DownloadProgress(
        status: DownloadStatus.failed,
        error: errorMessage,
      );
      _downloadProgressController.add(_currentDownloadProgress);

      return null;
    } catch (e, stackTrace) {
      final errorMessage = 'Unexpected error downloading update: $e';
      _logger.error(errorMessage, e, stackTrace);

      _currentDownloadProgress = DownloadProgress(
        status: DownloadStatus.failed,
        error: errorMessage,
      );
      _downloadProgressController.add(_currentDownloadProgress);

      return null;
    }
  }

  /// Cancel ongoing download
  void cancelDownload() {
    if (_downloadCancelToken != null && !_downloadCancelToken!.isCancelled) {
      _downloadCancelToken!.cancel('User cancelled download');
      _currentDownloadProgress = DownloadProgress(
        status: DownloadStatus.cancelled,
      );
      _downloadProgressController.add(_currentDownloadProgress);
      _logger.info('Download cancelled by user');
    }
  }

  /// Install the downloaded update
  Future<bool> installUpdate(File installerFile) async {
    try {
      _logger.info('=== STARTING UPDATE INSTALLATION ===');
      _logger.info('Installer file path: ${installerFile.path}');

      // Verify file exists
      try {
        final exists = installerFile.existsSync();
        _logger.info('File exists: $exists');
        if (!exists) {
          throw FileSystemException(
            'Installer file not found',
            installerFile.path,
          );
        }
      } on FileSystemException catch (e) {
        _logger.error('Installer file not accessible: ${e.message}', e);
        throw Exception('Installer file not found: ${e.message}');
      }

      // Get and log file size
      int fileSize;
      try {
        fileSize = installerFile.lengthSync();
        _logger.info('File size: $fileSize bytes');
        if (fileSize == 0) {
          throw FileSystemException(
            'Installer file is empty',
            installerFile.path,
          );
        }
      } on FileSystemException catch (e) {
        _logger.error('Cannot read installer file: ${e.message}', e);
        throw Exception('Cannot read installer file: ${e.message}');
      }

      // Determine file type and launch appropriately
      final fileName = installerFile.path.toLowerCase();
      final extension = fileName.substring(fileName.lastIndexOf('.'));
      _logger.info('Detected file extension: $extension');

      if (fileName.endsWith('.exe')) {
        // For .exe files: Launch directly with silent install flags
        _logger.info('Launching EXE installer with silent mode...');
        _logger.info(
          'Command: ${installerFile.path} /VERYSILENT /NORESTART /RESTARTAPPLICATIONS',
        );

        try {
          final process = await Process.start(
            installerFile.path,
            [
              '/VERYSILENT', // Completely silent install (Inno Setup)
              '/NORESTART', // Don't restart the computer
              '/RESTARTAPPLICATIONS', // Restart applications after install (auto-launch)
            ],
            mode: ProcessStartMode.detached,
            runInShell: false,
          ).timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw TimeoutException('Installer process start timed out');
            },
          );

          _logger.info('EXE installer launched with PID: ${process.pid}');
        } on ProcessException catch (e, stackTrace) {
          _logger.error(
            'Failed to start installer process: ${e.message}',
            e,
            stackTrace,
          );
          throw Exception('Cannot start installer: ${e.message}');
        } on TimeoutException catch (e, stackTrace) {
          _logger.error('Timeout starting installer', e, stackTrace);
          throw Exception('Installer start timed out');
        }
      } else {
        // For MSIX and other files: Use explorer.exe for true process independence
        _logger.info(
          'Launching installer via explorer.exe for independent process...',
        );
        _logger.info('File: ${installerFile.path}');

        try {
          final process = await Process.start(
            'explorer.exe',
            [installerFile.path],
            mode: ProcessStartMode.detached,
            runInShell: false,
          ).timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw TimeoutException('Explorer.exe launch timed out');
            },
          );

          _logger.info(
            'Installer launched via explorer.exe with PID: ${process.pid}',
          );
        } on ProcessException catch (e, stackTrace) {
          _logger.error(
            'Failed to launch via explorer.exe: ${e.message}',
            e,
            stackTrace,
          );
          throw Exception('Cannot launch installer: ${e.message}');
        } on TimeoutException catch (e, stackTrace) {
          _logger.error('Timeout launching installer', e, stackTrace);
          throw Exception('Installer launch timed out');
        }
      }

      _logger.info('Installer launched successfully');
      _logger.info('Application will exit in 3 seconds...');

      // Exit the current application to allow update
      // Give the installer process time to fully start before exiting
      Future.delayed(const Duration(seconds: 3), () {
        _logger.info('Exiting application for update installation');
        exit(0);
      });

      return true;
    } on FileSystemException catch (e, stackTrace) {
      _logger.error('=== UPDATE INSTALLATION FAILED ===');
      _logger.error('File system error: ${e.message}', e, stackTrace);
      return false;
    } on ProcessException catch (e, stackTrace) {
      _logger.error('=== UPDATE INSTALLATION FAILED ===');
      _logger.error('Process error: ${e.message}', e, stackTrace);
      return false;
    } on TimeoutException catch (e, stackTrace) {
      _logger.error('=== UPDATE INSTALLATION FAILED ===');
      _logger.error('Timeout error: ${e.message}', e, stackTrace);
      return false;
    } catch (e, stackTrace) {
      _logger.error('=== UPDATE INSTALLATION FAILED ===');
      _logger.error('Unexpected error: $e', e, stackTrace);
      return false;
    }
  }

  /// Load ignored versions from persistent storage
  Future<void> _loadIgnoredVersions() async {
    try {
      final prefs = await SharedPreferences.getInstance().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException('Loading preferences timed out');
        },
      );
      final ignoredList = prefs.getStringList(_ignoredVersionsKey) ?? [];
      _ignoredVersions = ignoredList.toSet();
      _logger.info(
        'Loaded ${_ignoredVersions.length} ignored version(s): ${_ignoredVersions.join(", ")}',
      );
    } on TimeoutException catch (e, stackTrace) {
      _logger.error('Timeout loading ignored versions', e, stackTrace);
      _ignoredVersions = {}; // Use empty set as fallback
    } catch (e, stackTrace) {
      _logger.error('Failed to load ignored versions', e, stackTrace);
      _ignoredVersions = {}; // Use empty set as fallback
    }
  }

  /// Save ignored versions to persistent storage
  Future<void> _saveIgnoredVersions() async {
    try {
      final prefs = await SharedPreferences.getInstance().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException('Loading preferences timed out');
        },
      );
      await prefs.setStringList(_ignoredVersionsKey, _ignoredVersions.toList()).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException('Saving preferences timed out');
        },
      );
      _logger.info('Saved ${_ignoredVersions.length} ignored version(s)');
    } on TimeoutException catch (e, stackTrace) {
      _logger.error('Timeout saving ignored versions', e, stackTrace);
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

  /// Check if update is already downloaded
  bool get isUpdateDownloaded {
    // First check in-memory cache
    if (_downloadedFile != null && _downloadedFile!.existsSync()) {
      return true;
    }

    // Then check on disk if we have current update info
    if (_currentUpdateValue != null) {
      final tempDirPath =
          '${Directory.systemTemp.path}${Platform.pathSeparator}tkit_updates';
      final savePath =
          '$tempDirPath${Platform.pathSeparator}${_currentUpdateValue!.assetName}';
      final file = File(savePath);

      if (file.existsSync()) {
        // Cache it for next time
        _downloadedFile = file;
        return true;
      }
    }

    return false;
  }

  /// Get the downloaded file if it exists
  File? get downloadedFile {
    if (isUpdateDownloaded) {
      return _downloadedFile;
    }
    return null;
  }

  /// Dispose resources
  Future<void> dispose() async {
    try {
      await _updateAvailableController.close();
      await _downloadProgressController.close();
      _downloadCancelToken?.cancel();
      _logger.info('GitHub update service disposed');
    } catch (e, stackTrace) {
      _logger.error('Error disposing update service', e, stackTrace);
    }
  }
}
