import 'package:flutter/material.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/text_styles.dart';
import 'package:tkit/shared/theme/spacing.dart';

/// Standard page header with title and optional subtitle
/// Use this at the top of every page for consistency
class PageHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;

  const PageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TKitTextStyles.heading4,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: TKitSpacing.xs),
                Text(
                  subtitle!,
                  style: TKitTextStyles.bodyMedium.copyWith(
                    color: TKitColors.textMuted,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: TKitSpacing.lg),
          trailing!,
        ],
      ],
    );
  }
}
