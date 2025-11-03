import 'package:flutter/material.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/theme/text_styles.dart';
import 'package:tkit/shared/widgets/layout/spacer.dart';

/// Tool button for sidebar navigation with bottom border selection indicator
class ToolButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isSelected;

  const ToolButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isSelected ? TKitColors.accent : TKitColors.transparent,
            width: 2,
          ),
        ),
      ),
      child: Material(
        color: TKitColors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: TKitSpacing.lg,
              vertical: TKitSpacing.md,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isSelected
                      ? TKitColors.accent
                      : TKitColors.textSecondary,
                ),
                const HSpace.md(), // Design system: Use HSpace instead of hardcoded values
                Expanded(
                  child: Text(
                    text,
                    style: TKitTextStyles.labelMedium.copyWith(
                      color: isSelected
                          ? TKitColors.textPrimary
                          : TKitColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
