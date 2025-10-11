import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/widgets.dart';
import '../../../../l10n/app_localizations.dart';

/// Update channel preference for application updates
@JsonEnum(valueField: 'value')
enum UpdateChannel {
  /// Stable releases only (default)
  stable('stable'),

  /// Release candidates (pre-release versions)
  rc('rc'),

  /// Beta releases (less stable, more features)
  beta('beta'),

  /// Development releases (bleeding edge, least stable)
  dev('dev');

  const UpdateChannel(this.value);

  final String value;

  /// Get display name for UI
  String get displayName {
    switch (this) {
      case UpdateChannel.stable:
        return 'Stable';
      case UpdateChannel.rc:
        return 'Release Candidate';
      case UpdateChannel.beta:
        return 'Beta';
      case UpdateChannel.dev:
        return 'Development';
    }
  }

  /// Get description for each channel
  String get description {
    switch (this) {
      case UpdateChannel.stable:
        return 'Recommended for most users. Only stable releases.';
      case UpdateChannel.rc:
        return 'Stable features with final testing before stable release.';
      case UpdateChannel.beta:
        return 'New features that are mostly stable. May have bugs.';
      case UpdateChannel.dev:
        return 'Bleeding edge features. Expect bugs and instability.';
    }
  }

  /// Check if this channel should accept a given version
  /// Stable: only stable versions (no suffix)
  /// RC: stable + rc versions
  /// Beta: stable + rc + beta versions
  /// Dev: all versions including dev, alpha
  bool acceptsVersion(String version) {
    // Stable accepts only versions without suffixes
    if (this == UpdateChannel.stable) {
      return !version.contains('-');
    }

    // RC accepts stable and rc
    if (this == UpdateChannel.rc) {
      return !version.contains('-') ||
          version.contains('-rc');
    }

    // Beta accepts stable, rc, and beta
    if (this == UpdateChannel.beta) {
      return !version.contains('-') ||
          version.contains('-rc') ||
          version.contains('-beta');
    }

    // Dev accepts everything
    return true;
  }

  /// Parse from string value
  static UpdateChannel fromString(String value) {
    return UpdateChannel.values.firstWhere(
      (channel) => channel.value == value,
      orElse: () => UpdateChannel.stable,
    );
  }
}

/// Extension for localized UpdateChannel strings
extension UpdateChannelLocalization on UpdateChannel {
  /// Get localized display name
  String localizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case UpdateChannel.stable:
        return l10n.updateChannelStable;
      case UpdateChannel.rc:
        return l10n.updateChannelRc;
      case UpdateChannel.beta:
        return l10n.updateChannelBeta;
      case UpdateChannel.dev:
        return l10n.updateChannelDev;
    }
  }

  /// Get localized description
  String localizedDescription(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case UpdateChannel.stable:
        return l10n.updateChannelStableDesc;
      case UpdateChannel.rc:
        return l10n.updateChannelRcDesc;
      case UpdateChannel.beta:
        return l10n.updateChannelBetaDesc;
      case UpdateChannel.dev:
        return l10n.updateChannelDevDesc;
    }
  }
}
