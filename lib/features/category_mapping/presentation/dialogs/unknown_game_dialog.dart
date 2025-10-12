import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tkit/l10n/app_localizations.dart';
import '../../../../shared/theme/colors.dart';
import '../../../../shared/theme/text_styles.dart';
import '../../../../shared/theme/spacing.dart';
import '../../../../shared/widgets/layout/spacer.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/buttons/accent_button.dart';
import '../../../../shared/widgets/indicators/loading_indicator.dart';
import '../../../../shared/widgets/forms/search_field.dart';
import '../../../twitch_api/domain/entities/twitch_category.dart';
import '../../../twitch_api/presentation/providers/twitch_api_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/states/auth_state.dart';

/// Dialog shown when an unmapped game is detected
///
/// Allows user to search and select a Twitch category, then
/// optionally contribute the mapping to the community.
class UnknownGameDialog extends StatefulWidget {
  final String processName;
  final String? executablePath;
  final String? windowTitle;

  const UnknownGameDialog({
    super.key,
    required this.processName,
    this.executablePath,
    this.windowTitle,
  });

  @override
  State<UnknownGameDialog> createState() => _UnknownGameDialogState();
}

class _UnknownGameDialogState extends State<UnknownGameDialog> {
  final _searchController = TextEditingController();
  TwitchCategory? _selectedCategory;
  bool _contributeToCommunity = true; // Default: ON
  bool _saveLocally = true;

  static const _searchDebounceDelay = Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    // Pre-fill search with process name (remove .exe)
    final searchQuery = widget.processName.replaceAll('.exe', '').trim();
    _searchController.text = searchQuery;
    // Trigger initial search after delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (searchQuery.isNotEmpty) {
        final authProvider = context.read<AuthProvider>();
        if (authProvider.state is Authenticated) {
          context.read<TwitchApiProvider>().searchCategories(searchQuery);
        } else {
          context.read<TwitchApiProvider>().setError(
            'Please authenticate with Twitch to search for categories',
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: TKitColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Container(
        width: 700,
        constraints: const BoxConstraints(maxHeight: 700),
        decoration: BoxDecoration(
          border: Border.all(color: TKitColors.border),
          color: TKitColors.surface,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            Expanded(child: _buildContent(context)),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(TKitSpacing.xxl),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: TKitColors.border)),
        color: TKitColors.surfaceVariant,
      ),
      child: Row(
        children: [
          const Icon(Icons.help_outline, color: TKitColors.accent, size: 24),
          const HSpace.md(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.unknownGameDialogTitle, style: TKitTextStyles.heading3),
                const VSpace.xs(),
                Text(
                  l10n.unknownGameDialogSubtitle(widget.processName),
                  style: TKitTextStyles.bodySmall.copyWith(
                    color: TKitColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            color: TKitColors.textSecondary,
            onPressed: () => Navigator.of(context).pop(),
            tooltip: l10n.unknownGameDialogClose,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(TKitSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Search field
          Text(
            l10n.unknownGameDialogSearchLabel,
            style: TKitTextStyles.labelSmall.copyWith(
              color: TKitColors.textSecondary,
              letterSpacing: 1.0,
            ),
          ),
          const VSpace.sm(),
          SearchField(
            controller: _searchController,
            hintText: l10n.unknownGameDialogSearchHint,
            autofocus: true,
            debounceDuration: _searchDebounceDelay,
            onSearch: (value) {
              if (value.trim().isNotEmpty) {
                final authProvider = context.read<AuthProvider>();
                if (authProvider.state is Authenticated) {
                  context.read<TwitchApiProvider>().searchCategories(value);
                } else {
                  context.read<TwitchApiProvider>().setError(
                    'Please authenticate with Twitch to search for categories',
                  );
                }
              }
            },
          ),
          const VSpace.xl(),

          // Results
          Expanded(child: _buildSearchResults(context)),
          const VSpace.xl(),

          // Options
          Container(
            padding: const EdgeInsets.all(TKitSpacing.lg),
            decoration: BoxDecoration(
              border: Border.all(color: TKitColors.border),
              color: TKitColors.background,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.unknownGameDialogOptionsHeader,
                  style: TKitTextStyles.labelSmall.copyWith(
                    color: TKitColors.textSecondary,
                    letterSpacing: 1.0,
                  ),
                ),
                const VSpace.md(),
                CheckboxListTile(
                  value: _saveLocally,
                  onChanged: (value) =>
                      setState(() => _saveLocally = value ?? true),
                  title: Text(
                    l10n.unknownGameDialogSaveLocallyLabel,
                    style: TKitTextStyles.bodyMedium,
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: TKitColors.accent,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
                CheckboxListTile(
                  value: _contributeToCommunity,
                  onChanged: (value) =>
                      setState(() => _contributeToCommunity = value ?? true),
                  title: Text(
                    l10n.unknownGameDialogContributeLabel,
                    style: TKitTextStyles.bodyMedium,
                  ),
                  subtitle: Text(
                    l10n.unknownGameDialogContributeSubtitle,
                    style: TKitTextStyles.caption.copyWith(
                      color: TKitColors.textMuted,
                    ),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: TKitColors.accent,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context) {
    return Consumer<TwitchApiProvider>(
      builder: (context, provider, child) {
        final l10n = AppLocalizations.of(context)!;

        if (provider.isLoading) {
          return const Center(child: LoadingIndicator());
        }

        if (provider.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: TKitColors.error,
                ),
                const VSpace.md(),
                Text(
                  l10n.unknownGameDialogSearchError,
                  style: TKitTextStyles.bodyMedium.copyWith(
                    color: TKitColors.textPrimary,
                  ),
                ),
                const VSpace.xs(),
                Text(
                  provider.errorMessage!,
                  style: TKitTextStyles.bodySmall.copyWith(
                    color: TKitColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        if (!provider.hasSearched) {
          return Center(
            child: Text(
              l10n.unknownGameDialogSearchPrompt,
              style: TKitTextStyles.bodyMedium.copyWith(
                color: TKitColors.textMuted,
              ),
            ),
          );
        }

        if (provider.categories.isEmpty) {
          return Center(
            child: Text(
              l10n.unknownGameDialogNoResults,
              style: TKitTextStyles.bodyMedium.copyWith(
                color: TKitColors.textMuted,
              ),
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: TKitColors.border),
            color: TKitColors.background,
          ),
          child: ListView.builder(
            itemCount: provider.categories.length,
            itemBuilder: (context, index) {
              final category = provider.categories[index];
              final isSelected = _selectedCategory?.id == category.id;

              return InkWell(
                onTap: () => setState(() => _selectedCategory = category),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TKitSpacing.lg,
                    vertical: TKitSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? TKitColors.accent.withOpacity(0.1)
                        : Colors.transparent,
                    border: Border(
                      bottom: BorderSide(
                        color: TKitColors.border.withOpacity(0.3),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: isSelected
                            ? TKitColors.accent
                            : TKitColors.textMuted,
                        size: 20,
                      ),
                      const HSpace.md(),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category.name,
                              style: TKitTextStyles.bodyMedium.copyWith(
                                color: isSelected
                                    ? TKitColors.accent
                                    : TKitColors.textPrimary,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            const SizedBox(height: TKitSpacing.headerGap),
                            Text(
                              'ID: ${category.id}',
                              style: TKitTextStyles.caption.copyWith(
                                color: TKitColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFooter(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(TKitSpacing.xxl),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: TKitColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Ignore button on the left
          AccentButton(
            text: l10n.unknownGameDialogIgnore,
            onPressed: () => Navigator.of(context).pop({'ignore': true}),
            width: 120,
          ),
          // Skip and Save buttons on the right
          Row(
            children: [
              AccentButton(
                text: l10n.unknownGameDialogSkip,
                onPressed: () => Navigator.of(context).pop(),
                width: 120,
              ),
              const HSpace.md(),
              PrimaryButton(
                text: l10n.unknownGameDialogSave,
                icon: Icons.check,
                onPressed: _selectedCategory != null ? _handleSave : null,
                width: 120,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleSave() {
    if (_selectedCategory == null) return;

    // Create mapping result
    final result = {
      'category': _selectedCategory!,
      'saveLocally': _saveLocally,
      'contributeToCommunity': _contributeToCommunity,
      'processName': widget.processName,
      'executablePath': widget.executablePath,
      'windowTitle': widget.windowTitle,
    };

    Navigator.of(context).pop(result);
  }
}
