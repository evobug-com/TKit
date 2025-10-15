import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:tkit/core/services/updater/models/download_progress.dart';
import 'package:tkit/core/services/updater/models/update_info.dart';
import 'package:tkit/core/providers/providers.dart';
import 'package:tkit/l10n/app_localizations.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/text_styles.dart';
import 'package:tkit/shared/widgets/buttons/primary_button.dart';
import 'package:tkit/shared/widgets/buttons/accent_button.dart';

/// Status indicator that shows whether the app is up to date
enum UpdateCheckStatus {
  /// Haven't checked for updates yet or check failed
  unknown,
  /// Update is available
  updateAvailable,
  /// App is on the latest version
  upToDate,
}

class VersionStatusIndicator extends ConsumerStatefulWidget {
  final GlobalKey<NavigatorState>? navigatorKey;

  const VersionStatusIndicator({super.key, this.navigatorKey});

  @override
  ConsumerState<VersionStatusIndicator> createState() => _VersionStatusIndicatorState();
}

class _VersionStatusIndicatorState extends ConsumerState<VersionStatusIndicator> {
  UpdateCheckStatus _status = UpdateCheckStatus.unknown;
  var _isHovering = false;
  String? _errorMessage;
  var _shouldShowDialog = false; // Flag to show dialog from build

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkInitializationStatus();
      _listenToUpdates();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Show dialog from here if flag is set and we have a Navigator
    if (_shouldShowDialog) {
      _shouldShowDialog = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showUpdateDialog(context);
        }
      });
    }
  }

  void _checkInitializationStatus() {
    final updateService = ref.read(githubUpdateServiceProvider);

    // Check if service is initialized
    if (!updateService.isInitialized) {
      // Check if platform is supported
      if (kIsWeb ||
          (defaultTargetPlatform != TargetPlatform.windows &&
              defaultTargetPlatform != TargetPlatform.macOS)) {
        _errorMessage = 'platform_not_supported';
      } else {
        _errorMessage = 'not_initialized';
      }
    } else {
      // Service is initialized - check if there's already a completed update check
      if (updateService.currentUpdate == null) {
        // No update available means we're up to date
        _status = UpdateCheckStatus.upToDate;
        _errorMessage = null;
      }
    }
  }

  void _listenToUpdates() {
    final updateService = ref.read(githubUpdateServiceProvider);

    // Listen for update availability changes
    updateService.updateAvailable.listen((updateInfo) {
      if (mounted) {
        setState(() {
          if (updateInfo != null) {
            _status = UpdateCheckStatus.updateAvailable;
            _errorMessage = null; // Clear any previous errors
            // Note: We don't auto-show dialog here anymore since UpdateNotificationWidget handles that
          } else {
            // null means we checked and are up to date
            _status = UpdateCheckStatus.upToDate;
            _errorMessage = null; // Clear any previous errors
          }
        });
      }
    }, onError: (error) {
      if (mounted) {
        setState(() {
          _status = UpdateCheckStatus.unknown;
          // Capture the error message
          _errorMessage = error.toString();
        });
      }
    });
  }

  IconData _getIcon() {
    switch (_status) {
      case UpdateCheckStatus.upToDate:
        return Icons.check_circle;
      case UpdateCheckStatus.updateAvailable:
        return Icons.notification_important;
      case UpdateCheckStatus.unknown:
        return Icons.help_outline;
    }
  }

  Color _getColor() {
    switch (_status) {
      case UpdateCheckStatus.upToDate:
        return TKitColors.success; // Green
      case UpdateCheckStatus.updateAvailable:
        return Colors.orange; // Yellow/Orange
      case UpdateCheckStatus.unknown:
        return TKitColors.error; // Red
    }
  }

  String _getTooltip(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    switch (_status) {
      case UpdateCheckStatus.upToDate:
        return l10n.versionStatusUpToDate;
      case UpdateCheckStatus.updateAvailable:
        return l10n.versionStatusUpdateAvailable;
      case UpdateCheckStatus.unknown:
        // Provide specific error message if available
        if (_errorMessage != null) {
          if (_errorMessage == 'platform_not_supported') {
            return l10n.versionStatusPlatformNotSupported;
          } else if (_errorMessage == 'not_initialized') {
            return l10n.versionStatusNotInitialized;
          } else {
            // Show the actual error message
            return l10n.versionStatusCheckFailed(_errorMessage!);
          }
        }
        return l10n.versionStatusNotInitialized;
    }
  }

  void _showUpdateDialog(BuildContext context) {
    final logger = ref.read(appLoggerProvider);
    final updateService = ref.read(githubUpdateServiceProvider);
    final updateInfo = updateService.currentUpdate;

    if (updateInfo == null) {
      logger.warning('[VersionIndicator] Attempted to show update dialog but no update available');
      return;
    }

    logger.info('[VersionIndicator] Showing update dialog for version ${updateInfo.version}');

    // Use navigator key context if available, otherwise fall back to widget context
    final dialogContext = widget.navigatorKey?.currentContext ?? context;

    showDialog(
      context: dialogContext,
      barrierDismissible: false,
      builder: (context) => _UpdateDialog(updateInfo: updateInfo),
    ).then((_) {
      logger.info('[VersionIndicator] Update dialog closed');
    });
  }

  @override
  Widget build(BuildContext context) {
    final isClickable = _status == UpdateCheckStatus.updateAvailable;

    return Builder(
      builder: (context) => MouseRegion(
        cursor: isClickable ? SystemMouseCursors.click : SystemMouseCursors.help,
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: GestureDetector(
          onTap: isClickable ? () => _showUpdateDialog(context) : null,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                _getIcon(),
                size: 12,
                color: _getColor(),
              ),
              if (_isHovering)
                Positioned(
                  bottom: 16,
                  right: -8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      isClickable
                          ? '${_getTooltip(context)} (Click to update)'
                          : _getTooltip(context),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.center,
                      softWrap: false,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dialog for downloading and installing updates
class _UpdateDialog extends ConsumerStatefulWidget {
  final UpdateInfo updateInfo;

  const _UpdateDialog({required this.updateInfo});

  @override
  ConsumerState<_UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends ConsumerState<_UpdateDialog> {
  var _isDownloading = false;
  var _isInstalling = false;
  DownloadProgress? _downloadProgress;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _listenToDownloadProgress();
    });
  }

  void _listenToDownloadProgress() {
    final updateService = ref.read(githubUpdateServiceProvider);
    updateService.downloadProgress.listen((progress) {
      if (mounted) {
        setState(() {
          _downloadProgress = progress;
          if (progress.status == DownloadStatus.completed) {
            _isDownloading = false;
          } else if (progress.status == DownloadStatus.failed ||
              progress.status == DownloadStatus.cancelled) {
            _isDownloading = false;
          }
        });
      }
    });
  }

  Future<void> _downloadAndInstall() async {
    final logger = ref.read(appLoggerProvider);
    final updateService = ref.read(githubUpdateServiceProvider);

    logger.info('[VersionIndicator] Download & Install clicked for version ${widget.updateInfo.version}');

    setState(() {
      _isDownloading = true;
    });

    logger.info('[VersionIndicator] Starting download...');

    // Download the update
    final file = await updateService.downloadUpdate(widget.updateInfo);

    if (file == null) {
      // Download failed
      logger.error('[VersionIndicator] Download failed');
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to download update'),
            backgroundColor: TKitColors.error,
          ),
        );
      }
      return;
    }

    logger.info('[VersionIndicator] Download completed: ${file.path}');

    setState(() {
      _isDownloading = false;
      _isInstalling = true;
    });

    logger.info('[VersionIndicator] Starting installation...');

    // Install the update
    final success = await updateService.installUpdate(file);

    if (!success && mounted) {
      logger.error('[VersionIndicator] Installation failed');
      setState(() {
        _isInstalling = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to install update'),
          backgroundColor: TKitColors.error,
        ),
      );
    } else {
      logger.info('[VersionIndicator] Installation started successfully, app will exit');
    }
    // If successful, the app will close automatically
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final updateInfo = widget.updateInfo;

    return AlertDialog(
      backgroundColor: TKitColors.surface,
      title: Text(
        'Update Available',
        style: TKitTextStyles.heading3.copyWith(color: TKitColors.textPrimary),
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Version ${updateInfo.version} is now available.',
              style: TKitTextStyles.bodyMedium.copyWith(color: TKitColors.textPrimary),
            ),
            const SizedBox(height: 16),
            if (updateInfo.releaseNotes != null) ...[
              Text(
                'What\'s New:',
                style: TKitTextStyles.bodySmall.copyWith(
                  color: TKitColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                constraints: const BoxConstraints(maxHeight: 300),
                decoration: BoxDecoration(
                  color: TKitColors.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: TKitColors.border),
                ),
                child: updateInfo.versionChangelogs.isEmpty
                    ? Markdown(
                        data: updateInfo.releaseNotes,
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(12),
                        styleSheet: MarkdownStyleSheet(
                          p: TKitTextStyles.bodyMedium,
                          h1: TKitTextStyles.heading2,
                          h2: TKitTextStyles.heading3,
                          h3: TKitTextStyles.heading4,
                          code: TKitTextStyles.code,
                          listBullet: TKitTextStyles.bodyMedium,
                          a: TKitTextStyles.bodyMedium.copyWith(
                            color: TKitColors.accentBright,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(12),
                        itemCount: updateInfo.versionChangelogs.length,
                        itemBuilder: (context, index) {
                          final changelog = updateInfo.versionChangelogs[index];
                          final isFirst = index == 0;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!isFirst) const Divider(height: 24),
                              Row(
                                children: [
                                  Text(
                                    'Version ${changelog.version}',
                                    style: TKitTextStyles.bodySmall.copyWith(
                                      color: TKitColors.accentBright,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '(${_formatDate(changelog.publishedAt)})',
                                    style: TKitTextStyles.caption.copyWith(
                                      color: TKitColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Markdown(
                                data: changelog.notes,
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                styleSheet: MarkdownStyleSheet(
                                  p: TKitTextStyles.bodySmall,
                                  h1: TKitTextStyles.heading3,
                                  h2: TKitTextStyles.heading4,
                                  h3: TKitTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                                  code: TKitTextStyles.code.copyWith(fontSize: 12),
                                  listBullet: TKitTextStyles.bodySmall,
                                  a: TKitTextStyles.bodySmall.copyWith(
                                    color: TKitColors.accentBright,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
              ),
              const SizedBox(height: 16),
            ],
            if (_isDownloading || _isInstalling) ...[
              const SizedBox(height: 16),
              if (_isDownloading && _downloadProgress != null) ...[
                Text(
                  'Downloading update...',
                  style: TKitTextStyles.bodySmall.copyWith(
                    color: TKitColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: _downloadProgress!.progress,
                  backgroundColor: TKitColors.borderLight,
                  valueColor: const AlwaysStoppedAnimation<Color>(TKitColors.accentBright),
                ),
                const SizedBox(height: 4),
                Text(
                  _downloadProgress!.progressPercentage,
                  style: TKitTextStyles.caption.copyWith(
                    color: TKitColors.textMuted,
                  ),
                ),
              ],
              if (_isInstalling) ...[
                Text(
                  'Installing update...',
                  style: TKitTextStyles.bodySmall.copyWith(
                    color: TKitColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                const LinearProgressIndicator(
                  backgroundColor: TKitColors.borderLight,
                  valueColor: AlwaysStoppedAnimation<Color>(TKitColors.accentBright),
                ),
              ],
            ],
          ],
        ),
      ),
      actions: [
        if (!_isDownloading && !_isInstalling) ...[
          AccentButton(
            text: 'Ignore',
            onPressed: () async {
              // Ignore this update version - won't auto-show dialog again, but indicator stays visible
              await ref.read(githubUpdateServiceProvider).ignoreUpdate();
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
          const SizedBox(width: 8),
          AccentButton(
            text: 'Later',
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 8),
          PrimaryButton(
            text: 'Download & Install',
            icon: Icons.download,
            onPressed: _downloadAndInstall,
          ),
        ],
        if (_isDownloading) ...[
          AccentButton(
            text: 'Cancel',
            onPressed: () {
              ref.read(githubUpdateServiceProvider).cancelDownload();
              Navigator.of(context).pop();
            },
          ),
        ],
      ],
    );
  }
}
