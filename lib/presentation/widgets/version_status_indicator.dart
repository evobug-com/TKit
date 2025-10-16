import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:tkit/core/providers/providers.dart';
import 'package:tkit/l10n/app_localizations.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/presentation/widgets/update_notification_widget.dart';

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
  ConsumerState<VersionStatusIndicator> createState() =>
      _VersionStatusIndicatorState();
}

class _VersionStatusIndicatorState
    extends ConsumerState<VersionStatusIndicator> {
  UpdateCheckStatus _status = UpdateCheckStatus.unknown;
  var _isHovering = false;
  String? _errorMessage;
  var _shouldShowDialog = false; // Flag to show dialog from build
  var _isDialogOpen = false; // Prevent opening dialog twice

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
    updateService.updateAvailable.listen(
      (updateInfo) {
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
      },
      onError: (Object error) {
        if (mounted) {
          setState(() {
            _status = UpdateCheckStatus.unknown;
            // Capture the error message
            _errorMessage = error.toString();
          });
        }
      },
    );
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
    // Prevent opening dialog twice
    if (_isDialogOpen) {
      return;
    }

    final logger = ref.read(appLoggerProvider);
    final updateService = ref.read(githubUpdateServiceProvider);
    final updateInfo = updateService.currentUpdate;

    if (updateInfo == null) {
      logger.warning(
        '[VersionIndicator] Attempted to show update dialog but no update available',
      );
      return;
    }

    logger.info(
      '[VersionIndicator] Showing update dialog for version ${updateInfo.version}',
    );

    // Use navigator key context if available, otherwise fall back to widget context
    final dialogContext = widget.navigatorKey?.currentContext ?? context;

    _isDialogOpen = true;
    showDialog<void>(
      context: dialogContext,
      barrierDismissible: false,
      builder: (context) => UpdateDialog(updateInfo: updateInfo),
    ).then((_) {
      logger.info('[VersionIndicator] Update dialog closed');
      _isDialogOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isClickable = _status == UpdateCheckStatus.updateAvailable;

    return Builder(
      builder: (context) => MouseRegion(
        cursor: isClickable
            ? SystemMouseCursors.click
            : SystemMouseCursors.help,
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: GestureDetector(
          onTap: isClickable ? () => _showUpdateDialog(context) : null,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(_getIcon(), size: 12, color: _getColor()),
              if (_isHovering)
                Positioned(
                  bottom: 16,
                  right: -8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
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
                      style: const TextStyle(color: Colors.white, fontSize: 11),
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
