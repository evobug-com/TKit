import 'dart:async';
import 'package:flutter/services.dart';
import 'package:local_notifier/local_notifier.dart';
import 'package:tkit/core/utils/app_logger.dart';

/// Callback for handling notification actions
typedef NotificationActionCallback =
    Future<void> Function({
      required String processName,
      String? executablePath,
    });

/// Service for managing local notifications using local_notifier
class NotificationService {
  final AppLogger _logger;
  var _isInitialized = false;
  NotificationActionCallback? onMissingCategoryClick;

  NotificationService(this._logger);

  /// Initialize the notification service
  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    try {
      await localNotifier.setup(
        appName: 'TKit',
        shortcutPolicy: ShortcutPolicy.requireCreate,
      );
      _isInitialized = true;
      _logger.info('Notification service initialized');
    } on PlatformException catch (e, stackTrace) {
      _logger.error(
        'Platform error during notification service initialization: ${e.message}',
        e,
        stackTrace,
      );
      // Don't rethrow - notifications are not critical for app functionality
    } on TimeoutException catch (e, stackTrace) {
      _logger.error(
        'Timeout during notification service initialization',
        e,
        stackTrace,
      );
    } catch (e, stackTrace) {
      _logger.error(
        'Unexpected error during notification service initialization',
        e,
        stackTrace,
      );
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
            ).timeout(
              const Duration(seconds: 10),
              onTimeout: () {
                _logger.warning(
                  'Notification click handler timed out for: $processName',
                );
              },
            );
          } catch (e, stackTrace) {
            _logger.error(
              'Failed to handle notification click for: $processName',
              e,
              stackTrace,
            );
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
            ).timeout(
              const Duration(seconds: 10),
              onTimeout: () {
                _logger.warning(
                  'Notification action handler timed out for: $processName',
                );
              },
            );
          } catch (e, stackTrace) {
            _logger.error(
              'Failed to handle notification action for: $processName',
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
    } on PlatformException catch (e, stackTrace) {
      _logger.error(
        'Platform error showing notification for: $processName - ${e.message}',
        e,
        stackTrace,
      );
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to show notification for: $processName',
        e,
        stackTrace,
      );
    }
  }

  /// Show a notification for successful category update
  Future<void> showCategoryUpdateNotification({
    required String processName,
    required String categoryName,
  }) async {
    if (!_isInitialized) {
      _logger.debug(
        'Notification service not initialized, skipping category update notification',
      );
      return;
    }

    try {
      final notification = LocalNotification(
        title: 'Category Updated',
        body: 'Switched to "$categoryName" for $processName',
      );

      await notification.show();
      _logger.info('Showed category update notification: $categoryName');
    } on PlatformException catch (e, stackTrace) {
      _logger.error(
        'Platform error showing category update notification: ${e.message}',
        e,
        stackTrace,
      );
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to show category update notification',
        e,
        stackTrace,
      );
    }
  }

  /// Show a notification for errors
  Future<void> showErrorNotification({
    required String title,
    required String message,
  }) async {
    if (!_isInitialized) {
      _logger.debug(
        'Notification service not initialized, skipping error notification: $title',
      );
      return;
    }

    try {
      final notification = LocalNotification(title: title, body: message);

      await notification.show();
      _logger.info('Showed error notification: $title');
    } on PlatformException catch (e, stackTrace) {
      _logger.error(
        'Platform error showing error notification "$title": ${e.message}',
        e,
        stackTrace,
      );
    } catch (e, stackTrace) {
      _logger.error(
        'Failed to show error notification "$title"',
        e,
        stackTrace,
      );
    }
  }

  /// Dispose and cleanup
  Future<void> dispose() async {
    // local_notifier doesn't require explicit cleanup
    _isInitialized = false;
  }
}
