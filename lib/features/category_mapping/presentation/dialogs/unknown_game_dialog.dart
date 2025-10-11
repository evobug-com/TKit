import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tkit/l10n/app_localizations.dart';
import '../../../../shared/theme/colors.dart';
import '../../../../shared/theme/text_styles.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/buttons/accent_button.dart';
import '../../../../shared/widgets/indicators/loading_indicator.dart';
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
  Timer? _debounceTimer;

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
        _performSearch(searchQuery);
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  /// Perform search with debouncing
  void _performSearch(String query) {
    // Cancel previous timer
    _debounceTimer?.cancel();

    // Check auth status first
    final authProvider = context.read<AuthProvider>();
    if (authProvider.state is! Authenticated) {
      // Not authenticated, show error
      context.read<TwitchApiProvider>().setError(
        'Please authenticate with Twitch to search for categories',
      );
      return;
    }

    // Start new timer
    _debounceTimer = Timer(_searchDebounceDelay, () {
      if (query.trim().isNotEmpty) {
        context.read<TwitchApiProvider>().searchCategories(query);
      }
    });
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
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: TKitColors.border)),
        color: TKitColors.surfaceVariant,
      ),
      child: Row(
        children: [
          const Icon(Icons.help_outline, color: TKitColors.accent, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.unknownGameDialogTitle, style: TKitTextStyles.heading3),
                const SizedBox(height: 4),
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
      padding: const EdgeInsets.all(24),
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
          const SizedBox(height: 8),
          TextField(
            controller: _searchController,
            autofocus: true,
            style: TKitTextStyles.bodyMedium.copyWith(
              color: TKitColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: l10n.unknownGameDialogSearchHint,
              hintStyle: TKitTextStyles.bodyMedium.copyWith(
                color: TKitColors.textMuted,
              ),
              prefixIcon: const Icon(Icons.search, color: TKitColors.accent),
              filled: true,
              fillColor: TKitColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: const BorderSide(color: TKitColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: const BorderSide(color: TKitColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: const BorderSide(
                  color: TKitColors.accent,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            onChanged: (value) {
              _performSearch(value);
            },
            onSubmitted: (value) {
              // Cancel debounce and search immediately
              _debounceTimer?.cancel();
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
          const SizedBox(height: 20),

          // Results
          Expanded(child: _buildSearchResults(context)),
          const SizedBox(height: 20),

          // Options
          Container(
            padding: const EdgeInsets.all(16),
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
                const SizedBox(height: 12),
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
                const SizedBox(height: 12),
                Text(
                  l10n.unknownGameDialogSearchError,
                  style: TKitTextStyles.bodyMedium.copyWith(
                    color: TKitColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
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
                    horizontal: 16,
                    vertical: 12,
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
                      const SizedBox(width: 12),
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
                            const SizedBox(height: 2),
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
      padding: const EdgeInsets.all(24),
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
              const SizedBox(width: 12),
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
