import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../core/services/updater/github_update_service.dart';
import '../../core/services/updater/models/download_progress.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/theme/colors.dart';
import '../../shared/theme/text_styles.dart';
import '../../shared/widgets/buttons/primary_button.dart';
import '../../shared/widgets/buttons/accent_button.dart';

/// Status indicator that shows whether the app is up to date
enum UpdateCheckStatus {
  /// Haven't checked for updates yet or check failed
  unknown,
  /// Update is available
  updateAvailable,
  /// App is on the latest version
  upToDate,
}

class VersionStatusIndicator extends StatefulWidget {
  final GlobalKey<NavigatorState>? navigatorKey;

  const VersionStatusIndicator({super.key, this.navigatorKey});

  @override
  State<VersionStatusIndicator> createState() => _VersionStatusIndicatorState();
}

class _VersionStatusIndicatorState extends State<VersionStatusIndicator> {
  UpdateCheckStatus _status = UpdateCheckStatus.unknown;
  bool _isHovering = false;
  String? _errorMessage;
  String? _shownUpdateVersion; // Track which update version we've shown
  bool _shouldShowDialog = false; // Flag to show dialog from build

  @override
  void initState() {
    super.initState();
    _checkInitializationStatus();
    _listenToUpdates();
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
    final updateService = context.read<GitHubUpdateService>();

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
    }
  }

  void _listenToUpdates() {
    final updateService = context.read<GitHubUpdateService>();

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

    // If the service already has a current update, show it
    if (updateService.currentUpdate != null) {
      setState(() {
        _status = UpdateCheckStatus.updateAvailable;
        _errorMessage = null;
      });
      // Note: We don't auto-show dialog here since UpdateNotificationWidget handles that
    }
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
    final updateService = context.read<GitHubUpdateService>();
    final updateInfo = updateService.currentUpdate;

    if (updateInfo == null) return;

    // Use navigator key context if available, otherwise fall back to widget context
    final dialogContext = widget.navigatorKey?.currentContext ?? context;

    showDialog(
      context: dialogContext,
      barrierDismissible: false,
      builder: (context) => _UpdateDialog(updateInfo: updateInfo),
    );
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
                          color: Colors.black.withOpacity(0.3),
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
class _UpdateDialog extends StatefulWidget {
  final dynamic updateInfo;

  const _UpdateDialog({required this.updateInfo});

  @override
  State<_UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<_UpdateDialog> {
  bool _isDownloading = false;
  bool _isInstalling = false;
  DownloadProgress? _downloadProgress;
  File? _downloadedFile;

  @override
  void initState() {
    super.initState();
    _listenToDownloadProgress();
  }

  void _listenToDownloadProgress() {
    final updateService = context.read<GitHubUpdateService>();
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
    final updateService = context.read<GitHubUpdateService>();

    setState(() {
      _isDownloading = true;
    });

    // Download the update
    final file = await updateService.downloadUpdate(widget.updateInfo);

    if (file == null) {
      // Download failed
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

    setState(() {
      _downloadedFile = file;
      _isDownloading = false;
      _isInstalling = true;
    });

    // Install the update
    final success = await updateService.installUpdate(file);

    if (!success && mounted) {
      setState(() {
        _isInstalling = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to install update'),
          backgroundColor: TKitColors.error,
        ),
      );
    }
    // If successful, the app will close automatically
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                constraints: const BoxConstraints(maxHeight: 200),
                decoration: BoxDecoration(
                  color: TKitColors.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: TKitColors.border),
                ),
                child: Markdown(
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
              await context.read<GitHubUpdateService>().ignoreUpdate();
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
              context.read<GitHubUpdateService>().cancelDownload();
              Navigator.of(context).pop();
            },
          ),
        ],
      ],
    );
  }
}
