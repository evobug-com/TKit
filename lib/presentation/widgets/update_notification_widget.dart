import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:tkit/l10n/app_localizations.dart';
import '../../core/services/updater/github_update_service.dart';
import '../../core/services/updater/models/update_info.dart';
import '../../core/services/updater/models/download_progress.dart';
import '../../core/utils/app_logger.dart';
import '../../shared/theme/colors.dart';
import '../../shared/theme/text_styles.dart';
import '../../shared/widgets/buttons/primary_button.dart';
import '../../shared/widgets/buttons/accent_button.dart';

/// Widget that displays update notifications and handles the update process
class UpdateNotificationWidget extends StatefulWidget {
  final Widget child;
  final GlobalKey<NavigatorState>? navigatorKey;

  const UpdateNotificationWidget({
    super.key,
    required this.child,
    this.navigatorKey,
  });

  @override
  State<UpdateNotificationWidget> createState() =>
      _UpdateNotificationWidgetState();
}

class _UpdateNotificationWidgetState extends State<UpdateNotificationWidget> {
  late final GitHubUpdateService _updateService;
  late final AppLogger _logger;
  UpdateInfo? _currentUpdate;
  DownloadProgress? _downloadProgress;
  bool _showDialog = false;
  bool _shouldShowDialog = false;

  @override
  void initState() {
    super.initState();
    _updateService = context.read<GitHubUpdateService>();
    _logger = context.read<AppLogger>();

    // Listen for available updates
    _updateService.updateAvailable.listen((update) {
      if (update != null && mounted && !_showDialog) {
        _logger.info('[UpdateWidget] Update available: ${update.version}');
        setState(() {
          _currentUpdate = update;
          // Only show auto-dialog if this version is not ignored
          _shouldShowDialog = !_updateService.isVersionIgnored(update.version);
          _logger.info('[UpdateWidget] Should show dialog: $_shouldShowDialog (ignored: ${_updateService.isVersionIgnored(update.version)})');
        });
      }
    });

    // Listen for download progress
    _updateService.downloadProgress.listen((progress) {
      if (mounted) {
        _logger.debug('[UpdateWidget] Download progress: ${progress.status.name} - ${progress.progressPercentage}');
        setState(() {
          _downloadProgress = progress;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Show dialog from here if flag is set and we have a Navigator
    if (_shouldShowDialog) {
      _shouldShowDialog = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_showDialog) {
          _showUpdateDialog();
        }
      });
    }
  }

  void _showUpdateDialog() {
    if (_currentUpdate == null || _showDialog) return;

    _logger.info('[UpdateWidget] Showing update dialog for version ${_currentUpdate!.version}');

    // Use navigator key context if available, otherwise fall back to widget context
    final dialogContext = widget.navigatorKey?.currentContext ?? context;

    _showDialog = true;
    showDialog(
      context: dialogContext,
      barrierDismissible: false,
      builder: (context) => _UpdateDialog(
        updateInfo: _currentUpdate!,
        downloadProgress: _downloadProgress,
        onDownload: _handleDownload,
        onDismiss: _handleDismiss,
        onInstall: _handleInstall,
      ),
    ).then((_) {
      _logger.info('[UpdateWidget] Update dialog closed');
      _showDialog = false;
    });
  }

  Future<void> _handleDownload() async {
    if (_currentUpdate == null) return;
    _logger.info('[UpdateWidget] Download button clicked');
    await _updateService.downloadUpdate(_currentUpdate!);
  }

  void _handleDismiss() {
    _logger.info('[UpdateWidget] Dismiss button clicked');
    _updateService.dismissUpdate();
    Navigator.of(context).pop();
  }

  Future<void> _handleInstall(String filePath) async {
    _logger.info('[UpdateWidget] Install button clicked - DEPRECATED HANDLER');
    final file = await _updateService.downloadUpdate(_currentUpdate!);
    if (file != null) {
      await _updateService.installUpdate(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class _UpdateDialog extends StatefulWidget {
  final UpdateInfo updateInfo;
  final DownloadProgress? downloadProgress;
  final VoidCallback onDownload;
  final VoidCallback onDismiss;
  final Function(String) onInstall;

  const _UpdateDialog({
    required this.updateInfo,
    required this.downloadProgress,
    required this.onDownload,
    required this.onDismiss,
    required this.onInstall,
  });

  @override
  State<_UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<_UpdateDialog> {
  bool _isDownloading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = widget.downloadProgress;
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Row(
        children: [
          Icon(
            Icons.system_update,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Text(
            l10n.updateDialogTitle,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.updateDialogVersion(widget.updateInfo.version),
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.updateDialogPublished(_formatDate(widget.updateInfo.publishedAt, l10n)),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.updateDialogWhatsNew,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: TKitColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: TKitColors.border),
              ),
              child: Markdown(
                data: widget.updateInfo.releaseNotes,
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
            if (progress != null && progress.isDownloading) ...[
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: progress.progress,
                backgroundColor:
                    theme.colorScheme.surfaceVariant,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    progress.progressPercentage,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  Text(
                    '${progress.bytesReceivedFormatted} / ${progress.totalBytesFormatted}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ],
            if (progress != null && progress.isCompleted) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.updateDialogDownloadComplete,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (progress != null && progress.isFailed) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${l10n.updateDialogDownloadFailed} ${progress.error ?? "Unknown error"}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        if (progress == null || progress.status == DownloadStatus.idle) ...[
          AccentButton(
            text: l10n.updateDialogRemindLater,
            onPressed: widget.onDismiss,
          ),
          const SizedBox(width: 8),
          PrimaryButton(
            text: l10n.updateDialogDownloadUpdate,
            icon: Icons.download,
            onPressed: () {
              setState(() => _isDownloading = true);
              widget.onDownload();
            },
          ),
        ],
        if (progress != null && progress.isDownloading) ...[
          AccentButton(
            text: l10n.updateDialogCancel,
            onPressed: () {
              context.read<GitHubUpdateService>().cancelDownload();
              Navigator.of(context).pop();
            },
          ),
        ],
        if (progress != null && progress.isCompleted) ...[
          AccentButton(
            text: l10n.updateDialogLater,
            onPressed: widget.onDismiss,
          ),
          const SizedBox(width: 8),
          PrimaryButton(
            text: l10n.updateDialogInstallRestart,
            icon: Icons.install_desktop,
            onPressed: () async {
              final logger = context.read<AppLogger>();
              final service = context.read<GitHubUpdateService>();

              logger.info('[UpdateDialog] Install & Restart button clicked');

              // Download will return cached file if already downloaded
              final file = await service.downloadUpdate(widget.updateInfo);
              if (file != null) {
                logger.info('[UpdateDialog] Downloaded file ready: ${file.path}');
                await service.installUpdate(file);
              } else {
                logger.error('[UpdateDialog] Failed to get installer file');
              }
            },
          ),
        ],
      ],
    );
  }

  String _formatDate(DateTime date, AppLocalizations l10n) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return l10n.updateDialogToday;
    } else if (difference.inDays == 1) {
      return l10n.updateDialogYesterday;
    } else if (difference.inDays < 7) {
      return l10n.updateDialogDaysAgo(difference.inDays);
    } else {
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }
  }
}
