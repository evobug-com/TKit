import 'package:flutter/material.dart';
import 'package:tkit/features/settings/domain/entities/update_channel.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/theme/text_styles.dart';

/// Badge widget that displays the update channel (Alpha/Beta/RC)
/// Only visible for non-stable channels
class ChannelBadge extends StatelessWidget {
  final UpdateChannel channel;

  const ChannelBadge({super.key, required this.channel});

  /// Get badge text for the channel
  String? get _badgeText {
    switch (channel) {
      case UpdateChannel.dev:
        return 'ALPHA';
      case UpdateChannel.beta:
        return 'BETA';
      case UpdateChannel.rc:
        return 'RC';
      case UpdateChannel.stable:
        return null; // No badge for stable
    }
  }

  /// Get badge color for the channel
  Color get _badgeColor {
    switch (channel) {
      case UpdateChannel.dev:
        return TKitColors.warning; // Orange for alpha/dev
      case UpdateChannel.beta:
        return TKitColors.info; // Blue for beta
      case UpdateChannel.rc:
        return TKitColors.textMuted; // Gray for RC
      case UpdateChannel.stable:
        return TKitColors.textMuted; // Not used but needed for exhaustiveness
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = _badgeText;

    // Don't show badge for stable channel
    if (text == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TKitSpacing.sm,
        vertical: TKitSpacing.xs,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: _badgeColor, width: 1),
        borderRadius: BorderRadius.circular(TKitSpacing.xs),
      ),
      child: Text(
        text,
        style: TKitTextStyles.caption.copyWith(
          color: _badgeColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
