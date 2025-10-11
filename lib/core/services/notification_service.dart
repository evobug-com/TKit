import 'package:local_notifier/local_notifier.dart';
import '../utils/app_logger.dart';

/// Callback for handling notification actions
typedef NotificationActionCallback =
    Future<void> Function({
      required String processName,
      String? executablePath,
    });

/// Service for managing local notifications using local_notifier
class NotificationService {
  final AppLogger _logger;
  bool _isInitialized = false;
  NotificationActionCallback? onMissingCategoryClick;

  NotificationService(this._logger);

  /// Initialize the notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await localNotifier.setup(
        appName: 'TKit Flutter',
        shortcutPolicy: ShortcutPolicy.requireCreate,
      );
      _isInitialized = true;
      _logger.info('Notification service initialized');
    } catch (e, stackTrace) {
      _logger.error('Failed to initialize notification service', e, stackTrace);
    }
  }

  /// Show a notification for a missing category mapping
  Future<void> showMissingCategoryNotification({
    required String processName,
    String? executablePath,
  }) async {
    if (!_isInitialized) {
      _logger.warning(
        'Notification service not initialized, skipping notification',
      );
      return;
    }

    try {
      final notification = LocalNotification(
        title: 'Category Mapping Not Found',
        body: 'No Twitch category found for: $processName',
        actions: [LocalNotificationAction(text: 'Assign Category')],
      );

      notification.onClick = () async {
        _logger.debug(
          'User clicked on missing category notification for: $processName',
        );
        if (onMissingCategoryClick != null) {
          try {
            await onMissingCategoryClick!(
              processName: processName,
              executablePath: executablePath,
            );
          } catch (e, stackTrace) {
            _logger.error('Failed to handle notification click', e, stackTrace);
          }
        } else {
          _logger.warning('No notification click handler registered');
        }
      };

      notification.onClickAction = (actionIndex) async {
        _logger.debug(
          'User clicked action $actionIndex on notification for: $processName',
        );
        if (actionIndex == 0 && onMissingCategoryClick != null) {
          try {
            await onMissingCategoryClick!(
              processName: processName,
              executablePath: executablePath,
            );
          } catch (e, stackTrace) {
            _logger.error(
              'Failed to handle notification action',
              e,
              stackTrace,
            );
          }
        } else {
          _logger.warning('No notification click handler registered');
        }
      };

      await notification.show();
      _logger.info('Showed missing category notification for: $processName');
    } catch (e, stackTrace) {
      _logger.error('Failed to show notification', e, stackTrace);
    }
  }

  /// Show a notification for successful category update
  Future<void> showCategoryUpdateNotification({
    required String processName,
    required String categoryName,
  }) async {
    if (!_isInitialized) return;

    try {
      final notification = LocalNotification(
        title: 'Category Updated',
        body: 'Switched to "$categoryName" for $processName',
      );

      await notification.show();
      _logger.info('Showed category update notification');
    } catch (e, stackTrace) {
      _logger.error('Failed to show notification', e, stackTrace);
    }
  }

  /// Show a notification for errors
  Future<void> showErrorNotification({
    required String title,
    required String message,
  }) async {
    if (!_isInitialized) return;

    try {
      final notification = LocalNotification(title: title, body: message);

      await notification.show();
      _logger.info('Showed error notification: $title');
    } catch (e, stackTrace) {
      _logger.error('Failed to show notification', e, stackTrace);
    }
  }

  /// Dispose and cleanup
  Future<void> dispose() async {
    // local_notifier doesn't require explicit cleanup
    _isInitialized = false;
  }
}
