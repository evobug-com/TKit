import 'package:flutter/widgets.dart';
import 'package:tkit/l10n/app_localizations.dart';

/// Fallback behavior when no category mapping is found
enum FallbackBehavior {
  /// Do nothing - keep current category
  doNothing,

  /// Switch to "Just Chatting" category
  justChatting,

  /// Switch to a custom category specified by user
  custom;

  /// Convert enum to string for storage
  String toJson() => name;

  /// Convert string to enum from storage
  static FallbackBehavior fromJson(String value) {
    return FallbackBehavior.values.firstWhere(
      (e) => e.name == value,
      orElse: () => FallbackBehavior.doNothing,
    );
  }

  /// Get display name for UI
  String get displayName {
    switch (this) {
      case FallbackBehavior.doNothing:
        return 'Do Nothing';
      case FallbackBehavior.justChatting:
        return 'Just Chatting';
      case FallbackBehavior.custom:
        return 'Custom Category';
    }
  }
}

/// Extension for localized FallbackBehavior strings
extension FallbackBehaviorLocalization on FallbackBehavior {
  /// Get localized display name
  String localizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case FallbackBehavior.doNothing:
        return l10n.fallbackBehaviorDoNothing;
      case FallbackBehavior.justChatting:
        return l10n.fallbackBehaviorJustChatting;
      case FallbackBehavior.custom:
        return l10n.fallbackBehaviorCustom;
    }
  }
}
