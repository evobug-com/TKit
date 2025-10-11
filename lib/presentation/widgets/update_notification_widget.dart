import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tkit/l10n/app_localizations.dart';
import '../../core/services/updater/github_update_service.dart';
import '../../core/services/updater/models/update_info.dart';
import '../../core/services/updater/models/download_progress.dart';

/// Widget that displays update notifications and handles the update process
class UpdateNotificationWidget extends StatefulWidget {
  final Widget child;

  const UpdateNotificationWidget({
    super.key,
    required this.child,
  });

  @override
  State<UpdateNotificationWidget> createState() =>
      _UpdateNotificationWidgetState();
}

class _UpdateNotificationWidgetState extends State<UpdateNotificationWidget> {
  late final GitHubUpdateService _updateService;
  UpdateInfo? _currentUpdate;
  DownloadProgress? _downloadProgress;
  bool _showDialog = false;

  @override
  void initState() {
    super.initState();
    _updateService = context.read<GitHubUpdateService>();

    // Listen for available updates
    _updateService.updateAvailable.listen((update) {
      if (update != null && mounted && !_showDialog) {
        setState(() {
          _currentUpdate = update;
        });
        _showUpdateDialog();
      }
    });

    // Listen for download progress
    _updateService.downloadProgress.listen((progress) {
      if (mounted) {
        setState(() {
          _downloadProgress = progress;
        });
      }
    });
  }

  void _showUpdateDialog() {
    if (_currentUpdate == null || _showDialog) return;

    _showDialog = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _UpdateDialog(
        updateInfo: _currentUpdate!,
        downloadProgress: _downloadProgress,
        onDownload: _handleDownload,
        onDismiss: _handleDismiss,
        onInstall: _handleInstall,
      ),
    ).then((_) {
      _showDialog = false;
    });
  }

  Future<void> _handleDownload() async {
    if (_currentUpdate == null) return;
    await _updateService.downloadUpdate(_currentUpdate!);
  }

  void _handleDismiss() {
    _updateService.dismissUpdate();
    Navigator.of(context).pop();
  }

  Future<void> _handleInstall(String filePath) async {
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
              child: SingleChildScrollView(
                child: Text(
                  widget.updateInfo.releaseNotes,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.9),
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
          TextButton(
            onPressed: widget.onDismiss,
            child: Text(
              l10n.updateDialogRemindLater,
              style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
            ),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: () {
              setState(() => _isDownloading = true);
              widget.onDownload();
            },
            icon: const Icon(Icons.download),
            label: Text(l10n.updateDialogDownloadUpdate),
          ),
        ],
        if (progress != null && progress.isDownloading) ...[
          FilledButton(
            onPressed: () {
              context.read<GitHubUpdateService>().cancelDownload();
              Navigator.of(context).pop();
            },
            child: Text(l10n.updateDialogCancel),
          ),
        ],
        if (progress != null && progress.isCompleted) ...[
          TextButton(
            onPressed: widget.onDismiss,
            child: Text(
              l10n.updateDialogLater,
              style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
            ),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: () async {
              final service = context.read<GitHubUpdateService>();
              final file = await service.downloadUpdate(widget.updateInfo);
              if (file != null) {
                await service.installUpdate(file);
              }
            },
            icon: const Icon(Icons.install_desktop),
            label: Text(l10n.updateDialogInstallRestart),
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
