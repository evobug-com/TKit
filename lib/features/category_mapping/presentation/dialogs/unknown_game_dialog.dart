import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tkit/l10n/app_localizations.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/text_styles.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/widgets/layout/spacer.dart';
import 'package:tkit/shared/widgets/buttons/primary_button.dart';
import 'package:tkit/shared/widgets/buttons/accent_button.dart';
import 'package:tkit/shared/widgets/indicators/loading_indicator.dart';
import 'package:tkit/shared/widgets/forms/search_field.dart';
import 'package:tkit/features/twitch_api/domain/entities/twitch_category.dart';
import 'package:tkit/features/twitch_api/presentation/providers/twitch_api_providers.dart';
import 'package:tkit/features/auth/presentation/providers/auth_providers.dart';
import 'package:tkit/features/auth/presentation/states/auth_state.dart';
import 'package:tkit/features/category_mapping/data/utils/path_normalizer.dart';
import 'package:tkit/features/mapping_lists/domain/entities/mapping_list.dart';
import 'package:tkit/features/mapping_lists/presentation/providers/mapping_list_providers.dart';

/// Dialog shown when an unmapped game is detected
///
/// Features a 3-step wizard workflow with vertical stepper:
/// 1. Select Twitch category
/// 2. Choose destination list
/// 3. Review and confirm
class UnknownGameDialog extends ConsumerStatefulWidget {
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
  ConsumerState<UnknownGameDialog> createState() => _UnknownGameDialogState();
}

class _UnknownGameDialogState extends ConsumerState<UnknownGameDialog> with TickerProviderStateMixin {
  final _searchController = TextEditingController();
  var _currentStep = 0;
  TwitchCategory? _selectedCategory;
  MappingList? _selectedList;
  var _showThankYou = false;
  var _isGridView = true;

  static const _searchDebounceDelay = Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    final searchQuery = widget.processName.replaceAll('.exe', '').trim();
    _searchController.text = searchQuery;

    // Load saved view preference
    _loadViewPreference();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mappingListsProvider.notifier).loadLists();

      if (searchQuery.isNotEmpty) {
        final authState = ref.read(authProvider);
        if (authState is Authenticated) {
          ref.read(twitchApiProvider.notifier).searchCategories(searchQuery);
        }
      }
    });
  }

  Future<void> _loadViewPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIsGridView = prefs.getBool('unknown_game_dialog_grid_view') ?? true;
    if (mounted) {
      setState(() {
        _isGridView = savedIsGridView;
      });
    }
  }

  Future<void> _saveViewPreference(bool isGridView) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('unknown_game_dialog_grid_view', isGridView);
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
      child: Stack(
        children: [
          Container(
            width: 850,
            height: 700,
            decoration: BoxDecoration(
              border: Border.all(color: TKitColors.border),
              color: TKitColors.surface,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildVerticalStepper(context),
                      Container(
                        width: 1,
                        color: TKitColors.border,
                      ),
                      Expanded(child: _buildStepContent(context)),
                    ],
                  ),
                ),
                _buildFooter(context),
              ],
            ),
          ),
          if (_showThankYou) _buildThankYouOverlay(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final normalizedPath = widget.executablePath != null
        ? PathNormalizer.extractGamePath(widget.executablePath!)
        : null;
    final hasSelectedCategory = _selectedCategory != null;

    return Container(
      padding: const EdgeInsets.all(TKitSpacing.xl),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: TKitColors.border)),
        color: TKitColors.surfaceVariant,
      ),
      child: Row(
        children: [
          // Icon or game box art
          if (hasSelectedCategory && _selectedCategory!.id == '-1')
            // Ignore option selected
            Container(
              width: 52,
              height: 70,
              decoration: BoxDecoration(
                border: Border.all(color: TKitColors.error, width: 2),
                color: TKitColors.error.withValues(alpha: 0.1),
              ),
              child: const Icon(
                Icons.block,
                color: TKitColors.error,
                size: 32,
              ),
            )
          else if (hasSelectedCategory && _selectedCategory!.boxArtUrl != null)
            Container(
              width: 52,
              height: 70,
              decoration: BoxDecoration(
                border: Border.all(color: TKitColors.accent, width: 2),
                color: TKitColors.surfaceVariant,
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Low-res thumbnail
                  Image.network(
                    _selectedCategory!.boxArtUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.videogame_asset,
                        color: TKitColors.textMuted,
                        size: 24,
                      );
                    },
                  ),
                  // High-res overlay
                  Image.network(
                    _selectedCategory!.getBoxArtUrl(width: 156, height: 210) ?? '',
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox.shrink();
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return AnimatedOpacity(
                          opacity: 1.0,
                          duration: const Duration(milliseconds: 300),
                          child: child,
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(TKitSpacing.md),
              decoration: BoxDecoration(
                color: TKitColors.accent.withValues(alpha: 0.1),
                border: Border.all(color: TKitColors.accent),
              ),
              child: const Icon(
                Icons.help_outline,
                color: TKitColors.accent,
                size: 28,
              ),
            ),
          const HSpace.lg(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasSelectedCategory ? _selectedCategory!.name : l10n.unknownGameDialogTitle,
                  style: TKitTextStyles.heading2,
                ),
                const VSpace.xs(),
                Text(
                  widget.processName,
                  style: TKitTextStyles.bodyMedium.copyWith(
                    color: TKitColors.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (normalizedPath != null) ...[
                  const VSpace.xs(),
                  Text(
                    normalizedPath,
                    style: TKitTextStyles.caption.copyWith(
                      color: TKitColors.textSecondary,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            color: TKitColors.textSecondary,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalStepper(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: 200,
      color: TKitColors.background,
      padding: const EdgeInsets.all(TKitSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildVerticalStepItem(
            stepNumber: 1,
            label: l10n.unknownGameDialogStepCategory,
            description: l10n.unknownGameDialogCategoryHeader,
            isActive: _currentStep == 0,
            isCompleted: _currentStep > 0,
            showConnector: true,
          ),
          _buildVerticalStepItem(
            stepNumber: 2,
            label: l10n.unknownGameDialogStepDestination,
            description: l10n.unknownGameDialogListHeader,
            isActive: _currentStep == 1,
            isCompleted: _currentStep > 1,
            showConnector: true,
          ),
          _buildVerticalStepItem(
            stepNumber: 3,
            label: l10n.unknownGameDialogStepConfirm,
            description: l10n.unknownGameDialogConfirmHeader,
            isActive: _currentStep == 2,
            isCompleted: false,
            showConnector: false,
            isDisabled: _selectedList?.submissionHookUrl == null,
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalStepItem({
    required int stepNumber,
    required String label,
    required String description,
    required bool isActive,
    required bool isCompleted,
    required bool showConnector,
    bool isDisabled = false,
  }) {
    Color color;
    if (isDisabled) {
      color = TKitColors.textMuted.withValues(alpha: 0.5);
    } else if (isCompleted) {
      color = TKitColors.success;
    } else if (isActive) {
      color = TKitColors.accent;
    } else {
      color = TKitColors.textMuted;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isCompleted || isActive
                        ? color.withValues(alpha: 0.1)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: color,
                      width: 2,
                      strokeAlign: isDisabled ? BorderSide.strokeAlignCenter : BorderSide.strokeAlignInside,
                    ),
                  ),
                  child: isDisabled
                      ? Icon(Icons.remove, color: color, size: 18)
                      : isCompleted
                          ? Icon(Icons.check, color: color, size: 18)
                          : Text(
                              stepNumber.toString(),
                              style: TKitTextStyles.bodyMedium.copyWith(
                                color: color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                ),
                if (showConnector)
                  Container(
                    width: 2,
                    height: 40,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: isCompleted ? TKitColors.success : TKitColors.border,
                  ),
              ],
            ),
            const HSpace.md(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TKitTextStyles.labelSmall.copyWith(
                      color: color,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                      letterSpacing: 0.5,
                      decoration: isDisabled ? TextDecoration.lineThrough : null,
                      decorationColor: color,
                    ),
                  ),
                  const VSpace.xs(),
                  Text(
                    description,
                    style: TKitTextStyles.caption.copyWith(
                      color: isDisabled ? color : TKitColors.textSecondary,
                      fontSize: 11,
                      decoration: isDisabled ? TextDecoration.lineThrough : null,
                      decorationColor: color,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        if (showConnector) const SizedBox(height: 4),
      ],
    );
  }

  Widget _buildStepContent(BuildContext context) {
    switch (_currentStep) {
      case 0:
        return _buildCategoryStep(context);
      case 1:
        return _buildDestinationStep(context);
      case 2:
        return _buildConfirmStep(context);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildCategoryStep(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(TKitSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.unknownGameDialogCategoryDescription,
            style: TKitTextStyles.bodySmall.copyWith(
              color: TKitColors.textSecondary,
            ),
          ),
          const VSpace.lg(),
          Row(
            children: [
              Expanded(
                child: SearchField(
                  controller: _searchController,
                  hintText: l10n.unknownGameDialogSearchHint,
                  autofocus: true,
                  debounceDuration: _searchDebounceDelay,
                  onSearch: (value) {
                    if (value.trim().isNotEmpty) {
                      final authState = ref.read(authProvider);
                      if (authState is Authenticated) {
                        ref.read(twitchApiProvider.notifier).searchCategories(value);
                      }
                    }
                  },
                ),
              ),
              const HSpace.md(),
              // View mode toggle
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: TKitColors.border),
                  color: TKitColors.background,
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() => _isGridView = true);
                        _saveViewPreference(true);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(TKitSpacing.sm),
                        decoration: BoxDecoration(
                          color: _isGridView ? TKitColors.accent.withValues(alpha: 0.1) : Colors.transparent,
                          border: const Border(
                            right: BorderSide(color: TKitColors.border),
                          ),
                        ),
                        child: Icon(
                          Icons.grid_view,
                          size: 20,
                          color: _isGridView ? TKitColors.accent : TKitColors.textMuted,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() => _isGridView = false);
                        _saveViewPreference(false);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(TKitSpacing.sm),
                        decoration: BoxDecoration(
                          color: !_isGridView ? TKitColors.accent.withValues(alpha: 0.1) : Colors.transparent,
                        ),
                        child: Icon(
                          Icons.view_list,
                          size: 20,
                          color: !_isGridView ? TKitColors.accent : TKitColors.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const VSpace.lg(),
          Expanded(child: _buildCategoryResults(context)),
        ],
      ),
    );
  }

  Widget _buildCategoryResults(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final l10n = AppLocalizations.of(context)!;
        final twitchApiState = ref.watch(twitchApiProvider);

        if (twitchApiState.isLoading) {
          return const Center(child: LoadingIndicator());
        }

        if (twitchApiState.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: TKitColors.error),
                const VSpace.md(),
                Text(
                  l10n.unknownGameDialogSearchError,
                  style: TKitTextStyles.bodyMedium,
                ),
                const VSpace.xs(),
                Text(
                  twitchApiState.errorMessage!,
                  style: TKitTextStyles.caption.copyWith(color: TKitColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        if (!twitchApiState.hasSearched) {
          return Center(
            child: Text(
              l10n.unknownGameDialogSearchPrompt,
              style: TKitTextStyles.bodyMedium.copyWith(color: TKitColors.textMuted),
            ),
          );
        }

        // Add "Ignore" option as first item
        const ignoreCategory = TwitchCategory(id: '-1', name: 'Ignore Process');
        final categoriesWithIgnore = [ignoreCategory, ...twitchApiState.categories];

        return _isGridView ? _buildGridView(categoriesWithIgnore) : _buildListView(categoriesWithIgnore);
      },
    );
  }

  Widget _buildGridView(List<TwitchCategory> categories) {
    return GridView.builder(
      padding: const EdgeInsets.all(TKitSpacing.sm),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
        crossAxisSpacing: TKitSpacing.md,
        mainAxisSpacing: TKitSpacing.md,
      ),
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: true,
      cacheExtent: 200,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final isSelected = _selectedCategory?.id == category.id;
        final isIgnoreOption = category.id == '-1';

        return InkWell(
              onTap: () => setState(() => _selectedCategory = category),
              child: Container(
                decoration: BoxDecoration(
                  color: TKitColors.background,
                  border: Border.all(
                    color: isSelected
                        ? (isIgnoreOption ? TKitColors.error : TKitColors.accent)
                        : (isIgnoreOption ? TKitColors.error.withValues(alpha: 0.3) : TKitColors.border),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Box art image
                    Expanded(
                      child: Stack(
                        children: [
                          // Image or placeholder
                          if (isIgnoreOption)
                            Container(
                              color: TKitColors.error.withValues(alpha: 0.1),
                              child: const Center(
                                child: Icon(
                                  Icons.block,
                                  color: TKitColors.error,
                                  size: 64,
                                ),
                              ),
                            )
                          else if (category.boxArtUrl != null)
                            Stack(
                              fit: StackFit.expand,
                              children: [
                                // Low-res thumbnail (loads instantly)
                                Image.network(
                                  category.boxArtUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: TKitColors.surfaceVariant,
                                      child: const Center(
                                        child: Icon(
                                          Icons.videogame_asset,
                                          color: TKitColors.textMuted,
                                          size: 48,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                // High-res image (fades in when loaded)
                                Image.network(
                                  category.getBoxArtUrl(width: 600, height: 800) ?? '',
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.high,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const SizedBox.shrink();
                                  },
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      // High-res loaded, fade it in
                                      return AnimatedOpacity(
                                        opacity: 1.0,
                                        duration: const Duration(milliseconds: 300),
                                        child: child,
                                      );
                                    }
                                    // Still loading high-res, show nothing (low-res visible underneath)
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ],
                            )
                          else
                            Container(
                              color: TKitColors.surfaceVariant,
                              child: const Center(
                                child: Icon(
                                  Icons.videogame_asset,
                                  color: TKitColors.textMuted,
                                  size: 48,
                                ),
                              ),
                            ),
                          // Selection indicator overlay
                          if (isSelected)
                            Positioned(
                              top: TKitSpacing.xs,
                              right: TKitSpacing.xs,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: TKitColors.accent,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Game info
                    Container(
                      padding: const EdgeInsets.all(TKitSpacing.sm),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isIgnoreOption ? TKitColors.error.withValues(alpha: 0.1) : TKitColors.accent.withValues(alpha: 0.1))
                            : TKitColors.surfaceVariant,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.name,
                            style: TKitTextStyles.bodySmall.copyWith(
                              color: isSelected
                                  ? (isIgnoreOption ? TKitColors.error : TKitColors.accent)
                                  : (isIgnoreOption ? TKitColors.error : TKitColors.textPrimary),
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (!isIgnoreOption) ...[
                            const VSpace.xs(),
                            Text(
                              'ID: ${category.id}',
                              style: TKitTextStyles.caption.copyWith(
                                color: TKitColors.textMuted,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
      },
    );
  }

  Widget _buildListView(List<TwitchCategory> categories) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: TKitColors.border),
      ),
      child: ListView.builder(
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: true,
        cacheExtent: 200,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory?.id == category.id;
          final isIgnoreOption = category.id == '-1';

          return InkWell(
            onTap: () => setState(() => _selectedCategory = category),
            child: Container(
              padding: const EdgeInsets.all(TKitSpacing.md),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isIgnoreOption ? TKitColors.error.withValues(alpha: 0.1) : TKitColors.accent.withValues(alpha: 0.1))
                    : Colors.transparent,
                border: Border(
                  bottom: BorderSide(color: TKitColors.border.withValues(alpha: 0.3)),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: isSelected
                        ? (isIgnoreOption ? TKitColors.error : TKitColors.accent)
                        : TKitColors.textMuted,
                    size: 24,
                  ),
                  const HSpace.md(),
                  // Small box art thumbnail
                  if (isIgnoreOption)
                    Container(
                      width: 40,
                      height: 53,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? TKitColors.error : TKitColors.error.withValues(alpha: 0.3),
                          width: isSelected ? 2 : 1,
                        ),
                        color: TKitColors.error.withValues(alpha: 0.1),
                      ),
                      child: const Icon(
                        Icons.block,
                        color: TKitColors.error,
                        size: 24,
                      ),
                    )
                  else if (category.boxArtUrl != null)
                    Container(
                      width: 40,
                      height: 53,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? TKitColors.accent : TKitColors.border,
                          width: isSelected ? 2 : 1,
                        ),
                        color: TKitColors.surfaceVariant,
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Low-res thumbnail
                          Image.network(
                            category.boxArtUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.videogame_asset,
                                color: TKitColors.textMuted,
                                size: 20,
                              );
                            },
                          ),
                          // High-res overlay
                          Image.network(
                            category.getBoxArtUrl(width: 120, height: 160) ?? '',
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                            errorBuilder: (context, error, stackTrace) {
                              return const SizedBox.shrink();
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return AnimatedOpacity(
                                  opacity: 1.0,
                                  duration: const Duration(milliseconds: 300),
                                  child: child,
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      width: 40,
                      height: 53,
                      decoration: BoxDecoration(
                        border: Border.all(color: TKitColors.border),
                        color: TKitColors.surfaceVariant,
                      ),
                      child: const Icon(
                        Icons.videogame_asset,
                        color: TKitColors.textMuted,
                        size: 20,
                      ),
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
                                ? (isIgnoreOption ? TKitColors.error : TKitColors.accent)
                                : (isIgnoreOption ? TKitColors.error : TKitColors.textPrimary),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        if (!isIgnoreOption) ...[
                          const VSpace.xs(),
                          Text(
                            'ID: ${category.id}',
                            style: TKitTextStyles.caption.copyWith(color: TKitColors.textMuted),
                          ),
                        ],
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
  }

  Widget _buildDestinationStep(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasSubmissionHook = _selectedList?.submissionHookUrl != null;

    return Container(
      padding: const EdgeInsets.all(TKitSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.unknownGameDialogListDescription,
            style: TKitTextStyles.bodySmall.copyWith(
              color: TKitColors.textSecondary,
            ),
          ),
          const VSpace.lg(),
          Expanded(child: _buildListSelection(context)),
          if (hasSubmissionHook) ...[
            const VSpace.md(),
            _buildSubmissionInfoBox(context),
          ],
        ],
      ),
    );
  }

  Widget _buildSubmissionInfoBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TKitSpacing.md),
      decoration: BoxDecoration(
        color: TKitColors.accent.withValues(alpha: 0.1),
        border: Border.all(color: TKitColors.accent),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 20, color: TKitColors.accent),
          const HSpace.md(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Submission Required',
                  style: TKitTextStyles.bodySmall.copyWith(
                    color: TKitColors.accent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const VSpace.xs(),
                Text(
                  'This mapping will be saved locally and submitted to the list owner for approval. Once approved and synced, your local copy will be automatically replaced.',
                  style: TKitTextStyles.caption.copyWith(
                    color: TKitColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListSelection(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final l10n = AppLocalizations.of(context)!;
        final mappingListState = ref.watch(mappingListsProvider);

        if (mappingListState.isLoading) {
          return const Center(child: LoadingIndicator());
        }

        if (mappingListState.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: TKitColors.error),
                const VSpace.md(),
                const Text('Error loading lists', style: TKitTextStyles.bodyMedium),
                const VSpace.xs(),
                Text(
                  mappingListState.errorMessage!,
                  style: TKitTextStyles.caption.copyWith(color: TKitColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        final localLists = mappingListState.lists
            .where((list) =>
                !list.isReadOnly &&
                list.isEnabled &&
                list.sourceType == MappingListSourceType.local)
            .toList();

        final submissionLists = mappingListState.lists
            .where((list) =>
                list.isEnabled &&
                list.submissionHookUrl != null &&
                list.sourceType != MappingListSourceType.local)
            .toList();

        if (localLists.isEmpty && submissionLists.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.folder_off_outlined, size: 48, color: TKitColors.textMuted),
                const VSpace.md(),
                Text(
                  l10n.unknownGameDialogNoWritableLists,
                  style: TKitTextStyles.bodyMedium.copyWith(color: TKitColors.textPrimary),
                  textAlign: TextAlign.center,
                ),
                const VSpace.xs(),
                Text(
                  l10n.unknownGameDialogNoWritableListsHint,
                  style: TKitTextStyles.caption.copyWith(color: TKitColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView(
          children: [
            if (submissionLists.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: TKitSpacing.xs),
                child: Row(
                  children: [
                    const Icon(Icons.cloud_upload_outlined, size: 16, color: TKitColors.textSecondary),
                    const HSpace.xs(),
                    Text(
                      'LISTS',
                      style: TKitTextStyles.labelSmall.copyWith(
                        color: TKitColors.textSecondary,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              const VSpace.xs(),
              ...submissionLists.map((list) => _buildListTile(list)),
              const VSpace.md(),
            ],
            if (localLists.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: TKitSpacing.xs),
                child: Row(
                  children: [
                    const Icon(Icons.laptop_outlined, size: 16, color: TKitColors.textSecondary),
                    const HSpace.xs(),
                    Text(
                      l10n.unknownGameDialogLocalListsHeader,
                      style: TKitTextStyles.labelSmall.copyWith(
                        color: TKitColors.textSecondary,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              const VSpace.xs(),
              ...localLists.map((list) => _buildListTile(list)),
            ],
          ],
        );
      },
    );
  }

  Widget _buildListTile(MappingList list) {
    final isSelected = _selectedList?.id == list.id;
    final hasSubmission = list.submissionHookUrl != null;

    return InkWell(
      onTap: () => setState(() => _selectedList = list),
      child: Container(
        margin: const EdgeInsets.only(bottom: TKitSpacing.sm),
        padding: const EdgeInsets.all(TKitSpacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? TKitColors.accent.withValues(alpha: 0.1)
              : TKitColors.background,
          border: Border.all(
            color: isSelected ? TKitColors.accent : TKitColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelected ? TKitColors.accent : TKitColors.textMuted,
              size: 22,
            ),
            const HSpace.md(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          list.name,
                          style: TKitTextStyles.bodyMedium.copyWith(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            color: isSelected ? TKitColors.accent : TKitColors.textPrimary,
                          ),
                        ),
                      ),
                      const HSpace.xs(),
                      _buildSourceBadge(list),
                    ],
                  ),
                  if (list.description.isNotEmpty) ...[
                    const VSpace.xs(),
                    Text(
                      list.description,
                      style: TKitTextStyles.caption.copyWith(color: TKitColors.textSecondary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const VSpace.xs(),
                  Row(
                    children: [
                      Text(
                        '${list.mappingCount} mappings',
                        style: TKitTextStyles.caption.copyWith(color: TKitColors.textMuted),
                      ),
                      if (hasSubmission) ...[
                        const HSpace.sm(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: TKitSpacing.xs,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: TKitColors.accent.withValues(alpha: 0.1),
                            border: Border.all(color: TKitColors.accent),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.laptop, size: 9, color: TKitColors.accent),
                              const SizedBox(width: 2),
                              const Icon(Icons.arrow_forward, size: 8, color: TKitColors.accent),
                              const SizedBox(width: 2),
                              const Icon(Icons.check_circle, size: 9, color: TKitColors.accent),
                              const HSpace.xs(),
                              Text(
                                'STAGED',
                                style: TKitTextStyles.caption.copyWith(
                                  color: TKitColors.accent,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceBadge(MappingList list) {
    final color = Color(int.parse(list.sourceTypeBadgeColor.replaceFirst('#', '0xFF')));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: TKitSpacing.xs, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color),
      ),
      child: Text(
        list.sourceTypeDisplay.toUpperCase(),
        style: TKitTextStyles.caption.copyWith(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildConfirmStep(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasSubmission = _selectedList?.submissionHookUrl != null;
    final isIgnored = _selectedCategory!.id == '-1';

    return Container(
      padding: const EdgeInsets.all(TKitSpacing.xl),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.unknownGameDialogConfirmDescription,
              style: TKitTextStyles.bodySmall.copyWith(color: TKitColors.textSecondary),
            ),
            const VSpace.lg(),

            // Selected Game/Category
            _buildConfirmSection(
              title: isIgnored ? 'IGNORED PROCESS' : l10n.unknownGameDialogConfirmCategory,
              icon: isIgnored ? Icons.block : Icons.videogame_asset,
              iconColor: isIgnored ? TKitColors.error : TKitColors.accent,
              child: Row(
                children: [
                  // Thumbnail
                  if (isIgnored)
                    Container(
                      width: 60,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: TKitColors.error, width: 2),
                        color: TKitColors.error.withValues(alpha: 0.1),
                      ),
                      child: const Icon(Icons.block, color: TKitColors.error, size: 32),
                    )
                  else if (_selectedCategory!.boxArtUrl != null)
                    Container(
                      width: 60,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: TKitColors.accent, width: 2),
                        color: TKitColors.surfaceVariant,
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            _selectedCategory!.boxArtUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const Icon(Icons.videogame_asset),
                          ),
                          Image.network(
                            _selectedCategory!.getBoxArtUrl(width: 180, height: 240) ?? '',
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const SizedBox.shrink(),
                            loadingBuilder: (_, child, progress) {
                              if (progress == null) {
                                return AnimatedOpacity(
                                  opacity: 1.0,
                                  duration: const Duration(milliseconds: 300),
                                  child: child,
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ],
                      ),
                    ),
                  const HSpace.md(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedCategory!.name,
                          style: TKitTextStyles.heading3.copyWith(
                            color: isIgnored ? TKitColors.error : TKitColors.textPrimary,
                          ),
                        ),
                        const VSpace.xs(),
                        Text(
                          widget.processName,
                          style: TKitTextStyles.bodySmall.copyWith(
                            color: TKitColors.textSecondary,
                            fontFamily: 'monospace',
                          ),
                        ),
                        if (!isIgnored) ...[
                          const VSpace.xs(),
                          Text(
                            'ID: ${_selectedCategory!.id}',
                            style: TKitTextStyles.caption.copyWith(color: TKitColors.textMuted),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const VSpace.lg(),

            // What Happens Next
            _buildWorkflowCard(context, hasSubmission: hasSubmission, isIgnored: isIgnored),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmSection({
    required String title,
    required IconData icon,
    required Widget child,
    Color? iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(TKitSpacing.md),
      decoration: BoxDecoration(
        border: Border.all(color: TKitColors.border),
        color: TKitColors.background,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: iconColor ?? TKitColors.accent),
              const HSpace.xs(),
              Text(
                title,
                style: TKitTextStyles.labelSmall.copyWith(
                  color: TKitColors.textSecondary,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const VSpace.sm(),
          child,
        ],
      ),
    );
  }


  Widget _buildWorkflowCard(BuildContext context, {required bool hasSubmission, required bool isIgnored}) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: hasSubmission ? TKitColors.accent.withValues(alpha: 0.05) : TKitColors.surfaceVariant,
        border: Border.all(color: hasSubmission ? TKitColors.accent : TKitColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(TKitSpacing.md),
            decoration: BoxDecoration(
              color: hasSubmission ? TKitColors.accent.withValues(alpha: 0.1) : TKitColors.background,
              border: Border(bottom: BorderSide(color: hasSubmission ? TKitColors.accent : TKitColors.border)),
            ),
            child: Row(
              children: [
                Icon(
                  hasSubmission ? Icons.cloud_upload_outlined : Icons.save_outlined,
                  size: 20,
                  color: hasSubmission ? TKitColors.accent : TKitColors.textSecondary,
                ),
                const HSpace.sm(),
                Text(
                  hasSubmission ? 'Submission Workflow' : 'What Happens Next',
                  style: TKitTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: hasSubmission ? TKitColors.accent : TKitColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(TKitSpacing.md),
            child: hasSubmission
                ? _buildSubmissionWorkflow(context, l10n)
                : _buildLocalSaveInfo(context, isIgnored),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmissionWorkflow(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildWorkflowStep(
          number: '1',
          icon: Icons.save,
          title: 'Saved locally to My Custom Mappings',
          description: 'Stored on your device first, so the mapping works immediately',
          color: TKitColors.accent,
        ),
        const VSpace.sm(),
        _buildWorkflowArrow(),
        const VSpace.sm(),
        _buildWorkflowStep(
          number: '2',
          icon: Icons.cloud_upload,
          title: 'Submitted to ${_selectedList!.name}',
          description: 'Automatically sent to the list owner for review and approval',
          color: TKitColors.warning,
        ),
        const VSpace.sm(),
        _buildWorkflowArrow(),
        const VSpace.sm(),
        _buildWorkflowStep(
          number: '3',
          icon: Icons.swap_horiz,
          title: 'Local copy replaced when approved',
          description: 'Once accepted and synced, your local copy is removed and replaced with the official version from ${_selectedList!.name}',
          color: TKitColors.success,
        ),
      ],
    );
  }

  Widget _buildLocalSaveInfo(BuildContext context, bool isIgnored) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(TKitSpacing.xs),
              decoration: BoxDecoration(
                color: TKitColors.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: TKitColors.success, size: 16),
            ),
            const HSpace.md(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Saved to ${_selectedList!.name}',
                    style: TKitTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: TKitColors.textPrimary,
                    ),
                  ),
                  const VSpace.xs(),
                  Text(
                    isIgnored
                        ? 'This process will be ignored and won\'t trigger notifications'
                        : 'Your mapping is saved locally and will work immediately',
                    style: TKitTextStyles.bodySmall.copyWith(
                      color: TKitColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const VSpace.md(),
        Container(
          padding: const EdgeInsets.all(TKitSpacing.sm),
          decoration: BoxDecoration(
            color: TKitColors.background,
            border: Border.all(color: TKitColors.border),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, size: 14, color: TKitColors.textMuted),
              const HSpace.sm(),
              Expanded(
                child: Text(
                  'This mapping is private and only stored on your device',
                  style: TKitTextStyles.caption.copyWith(
                    color: TKitColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWorkflowStep({
    required String number,
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Text(
            number,
            style: TKitTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ),
        const HSpace.sm(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 12, color: color),
                  const HSpace.xs(),
                  Expanded(
                    child: Text(
                      title,
                      style: TKitTextStyles.caption.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
              const VSpace.xs(),
              Text(
                description,
                style: TKitTextStyles.caption.copyWith(
                  color: TKitColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWorkflowArrow() {
    return const Padding(
      padding: EdgeInsets.only(left: 10),
      child: Icon(Icons.arrow_downward, size: 14, color: TKitColors.textMuted),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final canProceed = _currentStep == 0
        ? _selectedCategory != null
        : _currentStep == 1
            ? _selectedList != null
            : true;

    final hasSubmissionHook = _selectedList?.submissionHookUrl != null;
    final shouldShowConfirmStep = hasSubmissionHook;

    return Container(
      padding: const EdgeInsets.all(TKitSpacing.xl),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: TKitColors.border)),
        color: TKitColors.surfaceVariant,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_currentStep > 0)
            AccentButton(
              text: l10n.unknownGameDialogBack,
              onPressed: () => setState(() => _currentStep--),
              width: 120,
            ),
          if (_currentStep > 0) const HSpace.md(),
          if (_currentStep < 2)
            PrimaryButton(
              text: _currentStep == 1 && !shouldShowConfirmStep
                  ? l10n.unknownGameDialogSave
                  : l10n.unknownGameDialogNext,
              icon: _currentStep == 1 && !shouldShowConfirmStep
                  ? Icons.check
                  : Icons.arrow_forward,
              onPressed: canProceed
                  ? () {
                      if (_currentStep == 1 && !shouldShowConfirmStep) {
                        // Skip step 3 and save directly
                        _handleSave();
                      } else {
                        setState(() => _currentStep++);
                      }
                    }
                  : null,
              width: 120,
            )
          else
            PrimaryButton(
              text: l10n.unknownGameDialogSave,
              icon: Icons.check,
              onPressed: _handleSave,
              width: 120,
            ),
        ],
      ),
    );
  }

  Widget _buildThankYouOverlay(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: _skipThankYou,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOut,
        builder: (context, value, child) {
          return Container(
          width: 850,
          height: 700,
          color: TKitColors.surface.withValues(alpha: 0.95 * value),
          child: Stack(
            children: [
              // Floating hearts
              ...List.generate(12, (index) {
                final offset = index * 30.0;
                final xPosition = 100.0 + (index * 60.0);
                return _buildFloatingHeart(
                  xPosition: xPosition,
                  delay: offset,
                  value: value,
                );
              }),
              // Center content
              Center(
                child: Transform.scale(
                  scale: value,
                  child: Opacity(
                    opacity: value,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Big heart icon
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.pink.withValues(alpha: 0.1),
                          ),
                          child: const Icon(
                            Icons.favorite,
                            size: 60,
                            color: Colors.pink,
                          ),
                        ),
                        const VSpace.xl(),
                        Text(
                          l10n.unknownGameDialogThankYouTitle,
                          style: TKitTextStyles.heading1.copyWith(
                            color: TKitColors.accent,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const VSpace.md(),
                        Text(
                          l10n.unknownGameDialogThankYouMessage,
                          style: TKitTextStyles.bodyLarge.copyWith(
                            color: TKitColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      ),
    );
  }

  Widget _buildFloatingHeart({
    required double xPosition,
    required double delay,
    required double value,
  }) {
    return Positioned(
      left: xPosition,
      bottom: -50 + (700 * value) - delay,
      child: Opacity(
        opacity: (1.0 - value).clamp(0.0, 1.0),
        child: Transform.rotate(
          angle: (xPosition / 100) * 0.5,
          child: Icon(
            Icons.favorite,
            size: 20 + (xPosition % 20),
            color: Colors.pink.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }

  Map<String, dynamic>? _pendingResult;

  Future<void> _handleSave() async {
    if (_selectedCategory == null || _selectedList == null) {
      return;
    }

    final hasSubmissionHook = _selectedList!.submissionHookUrl != null;

    final normalizedPath = widget.executablePath != null
        ? PathNormalizer.extractGamePath(widget.executablePath!)
        : null;

    // If submitting to community, always save to local list first (as per workflow)
    // Only use the selected list ID if it's a direct local save (no submission)
    final targetListId = hasSubmissionHook ? 'my-custom-mappings' : _selectedList!.id;

    final result = {
      'category': _selectedCategory!,
      'saveLocally': true,
      'contributeToCommunity': hasSubmissionHook,
      'submissionUrl': _selectedList!.submissionHookUrl,
      'processName': widget.processName,
      'executablePath': widget.executablePath,
      'normalizedInstallPath': normalizedPath,
      'windowTitle': widget.windowTitle,
      'isEnabled': true, // Always enabled - ignore logic handled by categoryId == '-1'
      'listId': targetListId,
    };

    // Show thank you animation for community submissions
    if (hasSubmissionHook) {
      setState(() {
        _showThankYou = true;
        _pendingResult = result;
      });

      // Wait for animation to play (5 seconds total) or until user clicks to skip
      await Future<void>.delayed(const Duration(milliseconds: 5000));

      // If still showing thank you (not skipped), close now
      if (mounted && _showThankYou) {
        Navigator.of(context).pop(result);
      }
    } else {
      // No animation, close immediately
      if (mounted) {
        Navigator.of(context).pop(result);
      }
    }
  }

  void _skipThankYou() {
    if (_pendingResult != null && mounted) {
      setState(() => _showThankYou = false);
      Navigator.of(context).pop(_pendingResult);
    }
  }
}
