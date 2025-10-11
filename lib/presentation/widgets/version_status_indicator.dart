import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import '../../core/services/updater/github_update_service.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/theme/colors.dart';

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
  const VersionStatusIndicator({super.key});

  @override
  State<VersionStatusIndicator> createState() => _VersionStatusIndicatorState();
}

class _VersionStatusIndicatorState extends State<VersionStatusIndicator> {
  UpdateCheckStatus _status = UpdateCheckStatus.unknown;
  bool _isHovering = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkInitializationStatus();
    _listenToUpdates();
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

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.help,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
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
                  _getTooltip(context),
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
    );
  }
}
