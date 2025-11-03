import 'package:flutter/material.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/theme/text_styles.dart';
import 'package:tkit/shared/widgets/layout/spacer.dart';

/// Outlined button with accent color border
class AccentButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double? height;
  final IconData? icon;

  const AccentButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.height,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height ?? 32,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: TKitColors.accent,
          disabledForegroundColor: TKitColors.textDisabled,
          side: BorderSide(
            color: onPressed == null
                ? TKitColors.borderLight
                : TKitColors.accent,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0), // Sharp corners
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: TKitSpacing.lg,
            vertical: 0,
          ),
          minimumSize: const Size(0, 32),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: isLoading
            ? const SizedBox(
                width: TKitSpacing.md + 2,
                height: TKitSpacing.md + 2,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(TKitColors.accent),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: TKitSpacing.md + 2),
                    const HSpace.xs(), // Design system: Use HSpace instead of hardcoded values
                  ],
                  Flexible(
                    child: Text(
                      text,
                      style: TKitTextStyles.buttonSmall.copyWith(
                        color: onPressed == null
                            ? TKitColors.textDisabled
                            : TKitColors.accent,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
