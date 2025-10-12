import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../theme/spacing.dart';
import 'island.dart';

/// Section - A titled group of content with optional island wrapper
/// Use this for grouping related content on a page
class Section extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> children;
  final bool wrapped;
  final EdgeInsets? padding;

  const Section({
    super.key,
    required this.title,
    this.subtitle,
    required this.children,
    this.wrapped = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildChildren(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: TKitTextStyles.labelSmall.copyWith(
            letterSpacing: 0.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: TKitSpacing.xs),
          Text(
            subtitle!,
            style: TKitTextStyles.bodySmall.copyWith(
              color: TKitColors.textMuted,
            ),
          ),
        ],
        const SizedBox(height: TKitSpacing.gap),
        if (wrapped)
          Island(
            padding: padding ?? const EdgeInsets.all(TKitSpacing.cardPadding),
            child: content,
          )
        else
          content,
      ],
    );
  }

  List<Widget> _buildChildren() {
    final result = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      result.add(children[i]);
      if (i < children.length - 1) {
        result.add(const SizedBox(height: TKitSpacing.gap));
      }
    }
    return result;
  }
}
