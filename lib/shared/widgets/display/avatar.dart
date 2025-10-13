import 'package:flutter/material.dart';
import '../../theme/colors.dart';

/// Avatar size options
enum AvatarSize {
  small(24),
  medium(32),
  large(40),
  xlarge(56);

  final double size;
  const AvatarSize(this.size);

  double get fontSize {
    switch (this) {
      case AvatarSize.small:
        return 11;
      case AvatarSize.medium:
        return 13;
      case AvatarSize.large:
        return 16;
      case AvatarSize.xlarge:
        return 20;
    }
  }
}

/// Avatar - User profile image/initials display
/// Shows user profile image or falls back to initials
class Avatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final AvatarSize size;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onTap;

  const Avatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = AvatarSize.medium,
    this.backgroundColor,
    this.textColor,
    this.onTap,
  });

  /// Small avatar (24x24)
  const Avatar.small({
    super.key,
    this.imageUrl,
    this.name,
    this.backgroundColor,
    this.textColor,
    this.onTap,
  }) : size = AvatarSize.small;

  /// Medium avatar (32x32) - Default
  const Avatar.medium({
    super.key,
    this.imageUrl,
    this.name,
    this.backgroundColor,
    this.textColor,
    this.onTap,
  }) : size = AvatarSize.medium;

  /// Large avatar (40x40)
  const Avatar.large({
    super.key,
    this.imageUrl,
    this.name,
    this.backgroundColor,
    this.textColor,
    this.onTap,
  }) : size = AvatarSize.large;

  /// Extra large avatar (56x56)
  const Avatar.xlarge({
    super.key,
    this.imageUrl,
    this.name,
    this.backgroundColor,
    this.textColor,
    this.onTap,
  }) : size = AvatarSize.xlarge;

  String _getInitials() {
    if (name == null || name!.isEmpty) return '?';

    final parts = name!.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else {
      return name![0].toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = Container(
      width: size.size,
      height: size.size,
      decoration: BoxDecoration(
        color: backgroundColor ?? TKitColors.surfaceVariant,
        border: Border.all(
          color: TKitColors.border,
          width: 1,
        ),
      ),
      child: imageUrl != null && imageUrl!.isNotEmpty
          ? Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildInitials();
              },
            )
          : _buildInitials(),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        child: content,
      );
    }

    return content;
  }

  Widget _buildInitials() {
    return Center(
      child: Text(
        _getInitials(),
        style: TextStyle(
          fontSize: size.fontSize,
          fontWeight: FontWeight.w600,
          color: textColor ?? TKitColors.textPrimary,
          height: 1.0,
        ),
      ),
    );
  }
}

/// AvatarGroup - Display multiple avatars in a row
class AvatarGroup extends StatelessWidget {
  final List<Avatar> avatars;
  final int maxVisible;
  final double overlap;

  const AvatarGroup({
    super.key,
    required this.avatars,
    this.maxVisible = 5,
    this.overlap = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final visibleAvatars = avatars.take(maxVisible).toList();
    final remaining = avatars.length - maxVisible;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...visibleAvatars.asMap().entries.map((entry) {
          final index = entry.key;
          final avatar = entry.value;

          return Padding(
            padding: EdgeInsets.only(
              left: index > 0 ? overlap : 0,
            ),
            child: avatar,
          );
        }),
        if (remaining > 0)
          Padding(
            padding: EdgeInsets.only(left: overlap),
            child: Avatar(
              name: '+$remaining',
              size: visibleAvatars.isNotEmpty
                  ? visibleAvatars.first.size
                  : AvatarSize.medium,
              backgroundColor: TKitColors.surface,
            ),
          ),
      ],
    );
  }
}
