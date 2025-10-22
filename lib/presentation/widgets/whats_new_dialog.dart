import 'package:flutter/material.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:tkit/l10n/app_localizations.dart';
import 'package:tkit/core/services/updater/models/update_info.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/text_styles.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/widgets/buttons/primary_button.dart';
import 'package:tkit/shared/widgets/layout/island.dart';
import 'package:tkit/shared/widgets/layout/spacer.dart';

/// Dialog shown after app update to display what's new
class WhatsNewDialog extends StatelessWidget {
  final UpdateInfo updateInfo;
  final VoidCallback onClose;

  const WhatsNewDialog({
    super.key,
    required this.updateInfo,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Container(
        width: 700,
        constraints: const BoxConstraints(maxHeight: 600),
        padding: const EdgeInsets.all(TKitSpacing.md),
        child: Island.standard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(TKitSpacing.sm),
                    decoration: BoxDecoration(
                      color: TKitColors.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(TKitSpacing.xs),
                    ),
                    child: const Icon(
                      Icons.celebration_rounded,
                      color: TKitColors.accent,
                      size: 24,
                    ),
                  ),
                  const HSpace.md(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.whatsNewWelcome(updateInfo.version),
                          style: TKitTextStyles.heading2,
                        ),
                        const VSpace.xs(),
                        Text(
                          l10n.whatsNewSubtitle,
                          style: TKitTextStyles.caption.copyWith(
                            color: TKitColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TKitSpacing.sm,
                      vertical: TKitSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: TKitColors.success.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(TKitSpacing.xs),
                    ),
                    child: Text(
                      l10n.whatsNewTag,
                      style: TKitTextStyles.labelSmall.copyWith(
                        color: TKitColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const VSpace.lg(),
              const Divider(color: TKitColors.border, height: 1),
              const VSpace.lg(),

              // Changelog
              Expanded(
                child: GptMarkdownTheme(
                  gptThemeData: _createMarkdownTheme(),
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(TKitSpacing.md),
                      decoration: BoxDecoration(
                        color: TKitColors.surfaceVariant.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(TKitSpacing.xs),
                      ),
                      child: GptMarkdown(
                        updateInfo.releaseNotes,
                        style: TKitTextStyles.bodyMedium.copyWith(
                          height: 1.6,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const VSpace.lg(),

              // Action button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: PrimaryButton(
                      text: l10n.whatsNewGotIt,
                      onPressed: onClose,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  GptMarkdownThemeData _createMarkdownTheme() {
    return GptMarkdownThemeData(
      brightness: Brightness.dark,
      h1: TKitTextStyles.heading1.copyWith(
        color: TKitColors.accentBright,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
      h2: TKitTextStyles.heading2.copyWith(
        color: TKitColors.accentBright,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      h3: TKitTextStyles.heading3.copyWith(
        color: TKitColors.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      linkColor: TKitColors.accentBright,
      linkHoverColor: TKitColors.accentHover,
      hrLineColor: TKitColors.accent,
      hrLineThickness: 2.0,
      highlightColor: TKitColors.surface,
    );
  }
}
