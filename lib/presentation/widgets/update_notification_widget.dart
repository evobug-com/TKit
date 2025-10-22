import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:tkit/l10n/app_localizations.dart';
import 'package:tkit/core/services/updater/github_update_service.dart';
import 'package:tkit/core/services/updater/models/update_info.dart';
import 'package:tkit/core/services/updater/models/download_progress.dart';
import 'package:tkit/core/utils/app_logger.dart';
import 'package:tkit/core/providers/providers.dart';
import 'package:tkit/features/settings/presentation/providers/settings_providers.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/text_styles.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/widgets/buttons/primary_button.dart';
import 'package:tkit/shared/widgets/buttons/accent_button.dart';
import 'package:tkit/shared/widgets/layout/island.dart';
import 'package:tkit/shared/widgets/layout/spacer.dart';
import 'package:tkit/shared/widgets/badges/tag.dart';
import 'package:tkit/shared/widgets/badges/badge.dart';
import 'package:tkit/shared/widgets/cards/panel_card.dart';

/// Creates a custom GptMarkdown theme using TKit design tokens with modern visual hierarchy
GptMarkdownThemeData _createMarkdownTheme() {
  return GptMarkdownThemeData(
    brightness: Brightness.dark,

    // Heading styles with modern typography and gradients
    h1: TKitTextStyles.heading1.copyWith(
      color: TKitColors.accentBright,
      fontSize: 22,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      height: 1.3,
    ),
    h2: TKitTextStyles.heading2.copyWith(
      color: TKitColors.accentBright,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.3,
      height: 1.3,
    ),
    h3: TKitTextStyles.heading3.copyWith(
      color: TKitColors.textPrimary,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
      height: 1.3,
    ),
    h4: TKitTextStyles.heading4.copyWith(
      color: TKitColors.accent,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
      height: 1.4,
    ),
    h5: TKitTextStyles.labelMedium.copyWith(
      color: TKitColors.textSecondary,
      letterSpacing: 0.3,
    ),
    h6: TKitTextStyles.labelSmall.copyWith(
      color: TKitColors.textMuted,
      letterSpacing: 0.3,
    ),

    // Link colors - make them stand out with underline
    linkColor: TKitColors.accentBright,
    linkHoverColor: TKitColors.accentHover,

    // Horizontal rule styling - more prominent
    hrLineColor: TKitColors.accent,
    hrLineThickness: 2.0,

    // Highlight/selection color with shadow effect
    highlightColor: TKitColors.surface,
  );
}

/// Custom code block builder with modern styling using TKit components
Widget _buildCodeBlock(
  BuildContext context,
  String name,
  String code,
  bool closed,
) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: TKitSpacing.md),
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: PanelCard(
      padding: const EdgeInsets.all(TKitSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (name.isNotEmpty) ...[
            TKitTag(
              label: name.toUpperCase(),
              variant: TKitTagVariant.info,
              icon: Icons.code,
            ),
            const VSpace.sm(),
          ],
          SelectableText(
            code,
            style: TKitTextStyles.code.copyWith(
              fontSize: 12,
              height: 1.7,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    ),
  );
}

/// Custom unordered list builder using fancy card layout
Widget _buildUnorderedList(BuildContext context, Widget child, dynamic config) {
  return Container(
    margin: const EdgeInsets.only(left: TKitSpacing.sm, bottom: TKitSpacing.sm),
    child: PanelCard(
      padding: const EdgeInsets.symmetric(
        horizontal: TKitSpacing.md,
        vertical: TKitSpacing.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: TKitSpacing.xs, right: TKitSpacing.md),
            child: Icon(
              Icons.check_circle,
              size: 14,
              color: TKitColors.accentBright,
            ),
          ),
          Expanded(
            child: DefaultTextStyle(
              style: TKitTextStyles.bodyMedium.copyWith(
                height: 1.6,
                letterSpacing: 0.1,
              ),
              child: child,
            ),
          ),
        ],
      ),
    ),
  );
}

/// Custom ordered list builder using fancy card layout with badge numbers
Widget _buildOrderedList(
  BuildContext context,
  String no,
  Widget child,
  dynamic config,
) {
  return Container(
    margin: const EdgeInsets.only(left: TKitSpacing.sm, bottom: TKitSpacing.sm),
    child: PanelCard(
      padding: const EdgeInsets.symmetric(
        horizontal: TKitSpacing.md,
        vertical: TKitSpacing.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: TKitSpacing.xs, right: TKitSpacing.md),
            child: TKitBadge(text: no, variant: TKitBadgeVariant.info),
          ),
          Expanded(
            child: DefaultTextStyle(
              style: TKitTextStyles.bodyMedium.copyWith(
                height: 1.6,
                letterSpacing: 0.1,
              ),
              child: child,
            ),
          ),
        ],
      ),
    ),
  );
}

/// Custom inline code/highlight builder using tag-style design
Widget _buildHighlight(BuildContext context, String text, TextStyle style) {
  return TKitTag(
    label: text,
    variant: TKitTagVariant.info,
    icon: Icons.code_rounded,
  );
}

/// Widget that displays update notifications and handles the update process
class UpdateNotificationWidget extends ConsumerStatefulWidget {
  final Widget child;
  final GlobalKey<NavigatorState>? navigatorKey;

  const UpdateNotificationWidget({
    super.key,
    required this.child,
    this.navigatorKey,
  });

  @override
  ConsumerState<UpdateNotificationWidget> createState() =>
      _UpdateNotificationWidgetState();
}

class _UpdateNotificationWidgetState
    extends ConsumerState<UpdateNotificationWidget> {
  late final GitHubUpdateService _updateService;
  late final AppLogger _logger;
  UpdateInfo? _currentUpdate;
  var _showDialog = false;

  @override
  void initState() {
    super.initState();
    _updateService = ref.read(githubUpdateServiceProvider);
    _logger = ref.read(appLoggerProvider);

    // Listen for available updates
    _updateService.updateAvailable.listen((update) {
      if (update != null && mounted && !_showDialog) {
        _logger.info('[UpdateWidget] Update available: ${update.version}');
        final shouldShow = !_updateService.isVersionIgnored(update.version);
        _logger.info(
          '[UpdateWidget] Should show dialog: $shouldShow (ignored: ${_updateService.isVersionIgnored(update.version)})',
        );

        setState(() {
          _currentUpdate = update;
        });

        // Show dialog immediately if not ignored
        // Auto-download will be triggered from the dialog if auto-install is enabled
        if (shouldShow) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && !_showDialog && _currentUpdate != null) {
              _showUpdateDialog();
            }
          });
        }
      }
    });
  }

  void _showUpdateDialog() {
    // Prevent opening dialog twice (singleton behavior)
    if (_currentUpdate == null || _showDialog) {
      return;
    }

    _logger.info(
      '[UpdateWidget] Showing update dialog for version ${_currentUpdate!.version}',
    );

    // Use navigator key context if available, otherwise fall back to widget context
    final dialogContext = widget.navigatorKey?.currentContext ?? context;

    _showDialog = true;
    showDialog<void>(
      context: dialogContext,
      barrierDismissible: false,
      builder: (context) => _UpdateDialog(
        updateInfo: _currentUpdate!,
        onDownload: _handleDownload,
        onDismiss: _handleDismiss,
        onIgnore: _handleIgnore,
        onInstall: _handleInstall,
      ),
    ).then((_) {
      _logger.info('[UpdateWidget] Update dialog closed');
      _showDialog = false;
    });
  }

  Future<void> _handleDownload() async {
    if (_currentUpdate == null) {
      return;
    }
    _logger.info('[UpdateWidget] Download button clicked');
    await _updateService.downloadUpdate(_currentUpdate!);
  }

  void _handleDismiss(BuildContext dialogContext) {
    _logger.info('[UpdateWidget] Dismiss/Postpone button clicked');
    // Don't call dismissUpdate() - we want to keep the bell notification visible
    // Just close the dialog
    Navigator.of(dialogContext).pop();
  }

  Future<void> _handleIgnore(BuildContext dialogContext) async {
    _logger.info('[UpdateWidget] Ignore button clicked');
    await _updateService.ignoreUpdate();
    if (dialogContext.mounted) {
      Navigator.of(dialogContext).pop();
    }
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

/// Public update dialog that can be reused across the app
class UpdateDialog extends ConsumerStatefulWidget {
  final UpdateInfo updateInfo;
  final VoidCallback? onDownload;
  final void Function(BuildContext)? onDismiss;
  final void Function(BuildContext)? onIgnore;
  final void Function(String)? onInstall;

  const UpdateDialog({
    super.key,
    required this.updateInfo,
    this.onDownload,
    this.onDismiss,
    this.onIgnore,
    this.onInstall,
  });

  @override
  ConsumerState<UpdateDialog> createState() => _UpdateDialogState();
}

// Private wrapper for internal use with required callbacks
class _UpdateDialog extends UpdateDialog {
  const _UpdateDialog({
    required super.updateInfo,
    required VoidCallback super.onDownload,
    required void Function(BuildContext) super.onDismiss,
    required void Function(BuildContext) super.onIgnore,
    required void Function(String) super.onInstall,
  });
}

class _UpdateDialogState extends ConsumerState<UpdateDialog> {
  DownloadProgress? _progress;
  late final AppLogger _logger;

  @override
  void initState() {
    super.initState();

    _logger = ref.read(appLoggerProvider);

    // Check if update is already downloaded
    final service = ref.read(githubUpdateServiceProvider);
    if (service.isUpdateDownloaded) {
      _logger.info('[UpdateDialog] Update already downloaded');
      _progress = DownloadProgress(
        status: DownloadStatus.completed,
        bytesReceived: widget.updateInfo.fileSize,
        totalBytes: widget.updateInfo.fileSize,
      );

      // If already downloaded, check if we should auto-install
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final getSettingsUseCase = await ref.read(
          getSettingsUseCaseProvider.future,
        );
        final result = await getSettingsUseCase();

        await result.fold(
          (_) async {
            _logger.warning('[UpdateDialog] Failed to load settings for auto-install (already downloaded)');
          },
          (settings) async {
            _logger.info('[UpdateDialog] Auto-install setting (already downloaded): ${settings.autoInstallUpdates}');
            if (settings.autoInstallUpdates && service.downloadedFile != null) {
              _logger.info('[UpdateDialog] Starting auto-install (update was already downloaded)...');
              // Wait a moment to let UI update
              await Future<void>.delayed(const Duration(milliseconds: 500));

              // Auto-install the update
              await service.installUpdate(service.downloadedFile!);
            } else if (!settings.autoInstallUpdates) {
              _logger.info('[UpdateDialog] Auto-install disabled, waiting for user action');
            }
          },
        );
      });
    }

    // Listen to download progress stream
    service.downloadProgress.listen((progress) async {
      if (mounted) {
        setState(() {
          _progress = progress;
        });

        // Auto-install when download completes if enabled in settings
        if (progress.status == DownloadStatus.completed) {
          _logger.info('[UpdateDialog] Download completed, checking auto-install settings');
          final getSettingsUseCase = await ref.read(
            getSettingsUseCaseProvider.future,
          );
          final result = await getSettingsUseCase();

          await result.fold(
            (_) async {
              _logger.warning('[UpdateDialog] Failed to load settings for auto-install');
            },
            (settings) async {
              _logger.info('[UpdateDialog] Auto-install setting: ${settings.autoInstallUpdates}');
              if (settings.autoInstallUpdates && service.downloadedFile != null) {
                _logger.info('[UpdateDialog] Starting auto-install...');
                // Wait a moment to let UI update
                await Future<void>.delayed(const Duration(milliseconds: 500));

                // Auto-install the update
                await service.installUpdate(service.downloadedFile!);
              } else if (!settings.autoInstallUpdates) {
                _logger.info('[UpdateDialog] Auto-install disabled, waiting for user action');
              } else {
                _logger.warning('[UpdateDialog] Downloaded file not found');
              }
            },
          );
        }
      }
    });

    // Auto-start download if auto-install is enabled and update not already downloaded
    if (!service.isUpdateDownloaded) {
      _logger.info('[UpdateDialog] Checking auto-download settings...');
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final getSettingsUseCase = await ref.read(
          getSettingsUseCaseProvider.future,
        );
        final result = await getSettingsUseCase();

        await result.fold(
          (_) async {
            _logger.warning('[UpdateDialog] Failed to load settings for auto-download');
          },
          (settings) async {
            _logger.info('[UpdateDialog] Auto-install setting: ${settings.autoInstallUpdates}');
            if (settings.autoInstallUpdates) {
              _logger.info('[UpdateDialog] Starting auto-download...');
              // Auto-download when dialog opens
              await service.downloadUpdate(widget.updateInfo);
            } else {
              _logger.info('[UpdateDialog] Auto-install disabled, waiting for user to click download');
            }
          },
        );
      });
    }
  }

  // Default handlers if not provided
  Future<void> _handleDownload() async {
    await ref
        .read(githubUpdateServiceProvider)
        .downloadUpdate(widget.updateInfo);
  }

  void _handleDismiss(BuildContext dialogContext) {
    // Just close the dialog - keep the bell notification visible
    Navigator.of(dialogContext).pop();
  }

  Future<void> _handleIgnore(BuildContext dialogContext) async {
    // Ignore this version - bell stays visible but dialog won't auto-show again
    await ref.read(githubUpdateServiceProvider).ignoreUpdate();
    if (dialogContext.mounted) {
      Navigator.of(dialogContext).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = _progress;
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Container(
        width: 850,
        constraints: const BoxConstraints(maxHeight: 550),
        padding: const EdgeInsets.all(TKitSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left Island - Update Available
            SizedBox(
              width: 280,
              child: Island.standard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Row(
                      children: [
                        const Icon(
                          Icons.system_update_rounded,
                          color: TKitColors.accent,
                          size: 16,
                        ),
                        const HSpace.sm(),
                        Text(
                          l10n.updateDialogTitle,
                          style: TKitTextStyles.heading3,
                        ),
                      ],
                    ),
                    const VSpace.md(),
                    const Divider(color: TKitColors.border, height: 1),
                    const VSpace.md(),

                    // Content
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Version
                            Text(
                              l10n.updateDialogVersionLabel,
                              style: TKitTextStyles.labelSmall.copyWith(
                                color: TKitColors.textMuted,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const VSpace.xs(),
                            Text(
                              widget.updateInfo.version,
                              style: TKitTextStyles.heading1.copyWith(
                                color: TKitColors.accent,
                              ),
                            ),
                            const VSpace.md(),
                            const Divider(color: TKitColors.border, height: 1),
                            const VSpace.md(),

                            // Download Size
                            _buildInfoRow(
                              Icons.download_rounded,
                              l10n.updateDialogSize,
                              _formatBytes(widget.updateInfo.fileSize),
                            ),
                            const VSpace.md(),

                            // Published Date
                            _buildInfoRow(
                              Icons.calendar_today,
                              l10n.updateDialogPublishedLabel,
                              _formatDate(widget.updateInfo.publishedAt, l10n),
                            ),
                            const VSpace.md(),

                            // Download Progress
                            if (progress != null && progress.isDownloading) ...[
                              const Divider(
                                color: TKitColors.border,
                                height: 1,
                              ),
                              const VSpace.md(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    l10n.updateDialogDownloading,
                                    style: TKitTextStyles.labelMedium,
                                  ),
                                  Text(
                                    progress.progressPercentage,
                                    style: TKitTextStyles.heading3.copyWith(
                                      color: TKitColors.accent,
                                    ),
                                  ),
                                ],
                              ),
                              const VSpace.sm(),
                              LinearProgressIndicator(
                                value: progress.progress,
                                minHeight: TKitSpacing.xs,
                                backgroundColor: TKitColors.surfaceVariant,
                                color: TKitColors.accent,
                              ),
                              const VSpace.xs(),
                              Text(
                                '${progress.bytesReceivedFormatted} / ${progress.totalBytesFormatted}',
                                style: TKitTextStyles.bodySmall,
                              ),
                              const VSpace.md(),
                            ],

                            // Success State
                            if (progress != null && progress.isCompleted) ...[
                              const Divider(
                                color: TKitColors.border,
                                height: 1,
                              ),
                              const VSpace.md(),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    color: TKitColors.success,
                                    size: 18,
                                  ),
                                  const HSpace.sm(),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          l10n.updateDialogReadyToInstall,
                                          style: TKitTextStyles.labelMedium,
                                        ),
                                        Text(
                                          l10n.updateDialogClickInstallRestart,
                                          style: TKitTextStyles.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const VSpace.md(),
                            ],

                            // Error State
                            if (progress != null && progress.isFailed) ...[
                              const Divider(
                                color: TKitColors.border,
                                height: 1,
                              ),
                              const VSpace.md(),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.error_rounded,
                                    color: TKitColors.error,
                                    size: 18,
                                  ),
                                  const HSpace.sm(),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          l10n.updateDialogDownloadFailedTitle,
                                          style: TKitTextStyles.labelMedium
                                              .copyWith(
                                                color: TKitColors.error,
                                              ),
                                        ),
                                        if (progress.error != null)
                                          Text(
                                            progress.error!,
                                            style: TKitTextStyles.bodySmall,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const VSpace.md(),
                            ],
                          ],
                        ),
                      ),
                    ),

                    // Action Buttons
                    const Divider(color: TKitColors.border, height: 1),
                    const VSpace.md(),
                    if (progress == null ||
                        progress.status == DownloadStatus.idle) ...[
                      PrimaryButton(
                        text: l10n.updateDialogDownloadUpdate,
                        icon: Icons.download_rounded,
                        width: double.infinity,
                        onPressed: widget.onDownload ?? _handleDownload,
                      ),
                      const VSpace.sm(),
                      Row(
                        children: [
                          Expanded(
                            child: Tooltip(
                              message: l10n.updateDialogNeverShowTooltip,
                              child: AccentButton(
                                text: l10n.updateDialogIgnoreButton,
                                onPressed: () {
                                  if (widget.onIgnore != null) {
                                    widget.onIgnore!(context);
                                  } else {
                                    _handleIgnore(context);
                                  }
                                },
                              ),
                            ),
                          ),
                          const HSpace.sm(),
                          Expanded(
                            child: Tooltip(
                              message: l10n.updateDialogRemindTooltip,
                              child: AccentButton(
                                text: l10n.updateDialogPostpone,
                                onPressed: () {
                                  if (widget.onDismiss != null) {
                                    widget.onDismiss!(context);
                                  } else {
                                    _handleDismiss(context);
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else if (progress.isDownloading) ...[
                      AccentButton(
                        text: l10n.updateDialogCancel,
                        width: double.infinity,
                        onPressed: () {
                          ref
                              .read(githubUpdateServiceProvider)
                              .cancelDownload();
                          Navigator.of(context).pop();
                        },
                      ),
                    ] else if (progress.isCompleted) ...[
                      PrimaryButton(
                        text: l10n.updateDialogInstallRestart,
                        icon: Icons.restart_alt_rounded,
                        width: double.infinity,
                        onPressed: () async {
                          final logger = ref.read(appLoggerProvider);
                          final service = ref.read(githubUpdateServiceProvider);

                          logger.info(
                            '[UpdateDialog] Install & Restart button clicked',
                          );

                          // Use cached file if available, otherwise download
                          final file =
                              service.downloadedFile ??
                              await service.downloadUpdate(widget.updateInfo);
                          if (file != null) {
                            logger.info(
                              '[UpdateDialog] Installer file ready: ${file.path}',
                            );
                            await service.installUpdate(file);
                          } else {
                            logger.error(
                              '[UpdateDialog] Failed to get installer file',
                            );
                          }
                        },
                      ),
                      const VSpace.sm(),
                      AccentButton(
                        text: l10n.updateDialogLater,
                        width: double.infinity,
                        onPressed: () {
                          if (widget.onDismiss != null) {
                            widget.onDismiss!(context);
                          } else {
                            _handleDismiss(context);
                          }
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const HSpace.md(),

            // Right Island - What's New
            Expanded(
              child: Island.standard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Text(
                      l10n.updateDialogWhatsNew,
                      style: TKitTextStyles.heading3,
                    ),
                    const VSpace.md(),
                    const Divider(color: TKitColors.border, height: 1),
                    const VSpace.md(),

                    // Release Notes Content
                    Expanded(
                      child: GptMarkdownTheme(
                        gptThemeData: _createMarkdownTheme(),
                        child: widget.updateInfo.versionChangelogs.isEmpty
                            ? SingleChildScrollView(
                                child: GptMarkdown(
                                  widget.updateInfo.releaseNotes,
                                  style: TKitTextStyles.bodyMedium.copyWith(
                                    height: 1.6,
                                    letterSpacing: 0.1,
                                  ),
                                  codeBuilder: _buildCodeBlock,
                                  unOrderedListBuilder: _buildUnorderedList,
                                  orderedListBuilder: _buildOrderedList,
                                  highlightBuilder: _buildHighlight,
                                ),
                              )
                            : ListView.separated(
                                itemCount:
                                    widget.updateInfo.versionChangelogs.length,
                                // Performance: No state preservation needed for changelog entries
                                addAutomaticKeepAlives: false,
                                separatorBuilder: (context, index) =>
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: TKitSpacing.md,
                                      ),
                                      child: Divider(
                                        color: TKitColors.border,
                                        height: 1,
                                      ),
                                    ),
                                itemBuilder: (context, index) {
                                  final changelog = widget
                                      .updateInfo
                                      .versionChangelogs[index];
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: TKitSpacing.xs,
                                              vertical: TKitSpacing.xs / 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: TKitColors.surfaceVariant,
                                              border: Border.all(
                                                color: TKitColors.border,
                                              ),
                                              borderRadius: BorderRadius.circular(TKitSpacing.xs),
                                            ),
                                            child: Text(
                                              changelog.version,
                                              style: TKitTextStyles.labelSmall
                                                  .copyWith(
                                                    color: TKitColors.accent,
                                                  ),
                                            ),
                                          ),
                                          const HSpace.sm(),
                                          Text(
                                            _formatDate(
                                              changelog.publishedAt,
                                              l10n,
                                            ),
                                            style: TKitTextStyles.bodySmall,
                                          ),
                                        ],
                                      ),
                                      const VSpace.sm(),
                                      GptMarkdown(
                                        changelog.notes,
                                        style: TKitTextStyles.bodyMedium
                                            .copyWith(
                                              height: 1.6,
                                              letterSpacing: 0.1,
                                            ),
                                        codeBuilder: _buildCodeBlock,
                                        unOrderedListBuilder:
                                            _buildUnorderedList,
                                        orderedListBuilder: _buildOrderedList,
                                        highlightBuilder: _buildHighlight,
                                      ),
                                    ],
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: TKitColors.textMuted),
        const HSpace.sm(),
        Text(label, style: TKitTextStyles.bodySmall),
        const Spacer(),
        Text(
          value,
          style: TKitTextStyles.labelMedium.copyWith(
            color: TKitColors.textPrimary,
          ),
        ),
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

  String _formatBytes(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    }
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
