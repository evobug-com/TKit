import 'package:flutter/material.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/theme/text_styles.dart';
import 'package:tkit/shared/widgets/layout/spacer.dart';

/// Status card for displaying orchestration state and information
class StatusCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const StatusCard({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TKitColors.surface,
        border: Border.all(color: TKitColors.border, width: 1),
        borderRadius: BorderRadius.circular(0), // Sharp corners
      ),
      child: Material(
        color: TKitColors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: padding ?? const EdgeInsets.all(TKitSpacing.lg), // Design system: Use TKitSpacing
            child: Row(
              children: [
                if (leading != null) ...[leading!, const HSpace.md()],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(title, style: TKitTextStyles.labelLarge),
                      if (subtitle != null) ...[
                        const VSpace.xs(),
                        Text(
                          subtitle!,
                          style: TKitTextStyles.bodySmall.copyWith(
                            color: TKitColors.textMuted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[const HSpace.md(), trailing!],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
