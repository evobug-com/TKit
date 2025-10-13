import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tkit/l10n/app_localizations.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/widgets/layout/page_header.dart';
import 'package:tkit/shared/widgets/layout/island.dart';
import 'package:tkit/shared/widgets/layout/stat_item.dart';
import 'package:tkit/shared/widgets/layout/empty_state.dart';
import 'package:tkit/shared/widgets/layout/spacer.dart';
import 'package:tkit/shared/widgets/buttons/primary_button.dart';
import 'package:tkit/shared/widgets/dialogs/confirm_dialog.dart';
import 'package:tkit/shared/widgets/dialogs/error_dialog.dart';
import 'package:tkit/shared/widgets/indicators/loading_indicator.dart';
import 'package:tkit/shared/widgets/feedback/toast.dart';
import 'package:tkit/features/community_mappings/domain/repositories/i_community_mappings_repository.dart';
import 'package:tkit/features/community_mappings/domain/entities/community_mapping.dart';
import 'package:tkit/features/category_mapping/domain/entities/category_mapping.dart';
import 'package:tkit/features/category_mapping/presentation/providers/category_mapping_provider.dart';
import 'package:tkit/features/category_mapping/presentation/widgets/add_mapping_dialog.dart';
import 'package:tkit/features/category_mapping/presentation/widgets/mapping_list_widget.dart';
import 'package:tkit/features/category_mapping/presentation/widgets/community_mapping_list_widget.dart';

/// Page for managing category mappings
///
/// Displays tabs for Custom and Community mappings
@RoutePage()
class CategoryMappingEditorPage extends StatefulWidget {
  const CategoryMappingEditorPage({super.key});

  @override
  State<CategoryMappingEditorPage> createState() =>
      _CategoryMappingEditorPageState();
}

class _CategoryMappingEditorPageState extends State<CategoryMappingEditorPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<CommunityMapping> _communityMappings = [];
  bool _loadingCommunity = false;
  String? _communityError;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Load custom mappings
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryMappingProvider>().loadMappings();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadCommunityMappings() async {
    if (_loadingCommunity) return;

    setState(() {
      _loadingCommunity = true;
      _communityError = null;
    });

    final repo = context.read<ICommunityMappingsRepository>();
    final result = await repo.getAllMappings();

    result.fold(
      (failure) {
        setState(() {
          _communityError = failure.message;
          _loadingCommunity = false;
        });
      },
      (mappings) {
        setState(() {
          _communityMappings = mappings;
          _loadingCommunity = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: TKitColors.background,
      body: Padding(
        padding: const EdgeInsets.all(TKitSpacing.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Header
            PageHeader(
              title: l10n.categoryMappingTitle,
              subtitle: l10n.categoryMappingSubtitle,
            ),
            const VSpace.lg(),

            // Tab Bar
            Container(
              decoration: BoxDecoration(
                color: TKitColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: TKitColors.border),
              ),
              child: TabBar(
                controller: _tabController,
                onTap: (index) {
                  if (index == 1 && _communityMappings.isEmpty) {
                    _loadCommunityMappings();
                  }
                },
                indicator: BoxDecoration(
                  color: TKitColors.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: TKitColors.textPrimary,
                unselectedLabelColor: TKitColors.textMuted,
                tabs: const [
                  Tab(text: 'Custom Mappings'),
                  Tab(text: 'Community Mappings'),
                ],
              ),
            ),
            const VSpace.md(),

            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildCustomMappingsTab(context),
                  _buildCommunityMappingsTab(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomMappingsTab(BuildContext context) {
    return Consumer<CategoryMappingProvider>(
      builder: (context, provider, child) {
        final l10n = AppLocalizations.of(context)!;
        final errorMsg = provider.errorMessage;
        final successMsg = provider.successMessage;

        // Handle success/error messages
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (successMsg != null) {
            Toast.success(context, successMsg);
            provider.clearMessages();
          } else if (errorMsg != null) {
            showDialog(
              context: context,
              builder: (dialogContext) => ErrorDialog(
                title: l10n.categoryMappingErrorDialogTitle,
                message: errorMsg,
              ),
            );
            provider.clearMessages();
          }
        });

        if (provider.isLoading) {
          return const Center(child: LoadingIndicator());
        }

        if (provider.errorMessage != null && provider.mappings.isEmpty) {
          return _buildErrorView(context, provider.errorMessage!);
        }

        final mappings = provider.mappings;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Stats bar with Add button
            IslandVariant.standard(
              child: Row(
                children: [
                  StatItem(
                    label: l10n.categoryMappingStatsTotalMappings,
                    value: mappings.length.toString(),
                    valueColor: TKitColors.accent,
                  ),
                  const HSpace.xxl(),
                  StatItem(
                    label: l10n.categoryMappingStatsUserDefined,
                    value:
                        mappings.where((m) => m.manualOverride).length.toString(),
                  ),
                  const HSpace.xxl(),
                  StatItem(
                    label: l10n.categoryMappingStatsPresets,
                    value: mappings
                        .where((m) => !m.manualOverride)
                        .length
                        .toString(),
                  ),
                  const Spacer(),
                  PrimaryButton(
                    text: l10n.categoryMappingAddMappingButton,
                    icon: Icons.add,
                    onPressed: () => _showAddMappingDialog(context),
                    width: 180,
                  ),
                ],
              ),
            ),
            const VSpace.md(),

            // Mappings table
            Expanded(
              child: MappingListWidget(
                mappings: mappings,
                onDelete: (id) => _handleDelete(context, id),
                onEdit: (mapping) => _showEditMappingDialog(context, mapping),
                onToggleEnabled: (mapping) {
                  context.read<CategoryMappingProvider>().toggleEnabled(mapping);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCommunityMappingsTab(BuildContext context) {
    if (_loadingCommunity) {
      return const Center(child: LoadingIndicator());
    }

    if (_communityError != null) {
      return EmptyState(
        icon: Icons.error_outline,
        message: 'Failed to load community mappings',
        subtitle: _communityError,
        action: PrimaryButton(
          text: 'Retry',
          icon: Icons.refresh,
          onPressed: _loadCommunityMappings,
        ),
      );
    }

    if (_communityMappings.isEmpty) {
      return EmptyState(
        icon: Icons.cloud_download,
        message: 'No community mappings available',
        subtitle: 'Community mappings are synced from GitHub',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Stats bar
        IslandVariant.standard(
          child: Row(
            children: [
              StatItem(
                label: 'Total Community Mappings',
                value: _communityMappings.length.toString(),
                valueColor: TKitColors.accent,
              ),
              const HSpace.xxl(),
              StatItem(
                label: 'Last Synced',
                value: _formatLastSync(
                    context.read<ICommunityMappingsRepository>().getLastSyncTime()),
              ),
            ],
          ),
        ),
        const VSpace.md(),

        // Community mappings list
        Expanded(
          child: CommunityMappingListWidget(
            mappings: _communityMappings,
            onAdopt: (mapping) => _handleAdoptMapping(context, mapping),
          ),
        ),
      ],
    );
  }

  String _formatLastSync(DateTime? lastSync) {
    if (lastSync == null) return 'Never';
    final diff = DateTime.now().difference(lastSync);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return EmptyState(
      icon: Icons.error_outline,
      message: AppLocalizations.of(context)!.categoryMappingErrorLoading,
      subtitle: message,
      action: PrimaryButton(
        text: AppLocalizations.of(context)!.categoryMappingRetryButton,
        icon: Icons.refresh,
        onPressed: () {
          context.read<CategoryMappingProvider>().loadMappings();
        },
      ),
    );
  }

  Future<void> _showAddMappingDialog(BuildContext context) async {
    final result = await showDialog<CategoryMapping>(
      context: context,
      builder: (context) => const AddMappingDialog(),
    );

    if (result != null && context.mounted) {
      context.read<CategoryMappingProvider>().addMapping(result);
    }
  }

  Future<void> _showEditMappingDialog(
    BuildContext context,
    CategoryMapping mapping,
  ) async {
    final result = await showDialog<CategoryMapping>(
      context: context,
      builder: (context) => AddMappingDialog(mapping: mapping),
    );

    if (result != null && context.mounted) {
      context.read<CategoryMappingProvider>().updateMapping(result);
    }
  }

  Future<void> _handleDelete(BuildContext context, int id) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => ConfirmDialog(
        title: l10n.categoryMappingDeleteDialogTitle,
        message: l10n.categoryMappingDeleteDialogMessage,
        confirmText: l10n.categoryMappingDeleteDialogConfirm,
        cancelText: l10n.categoryMappingDeleteDialogCancel,
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<CategoryMappingProvider>().deleteMapping(id);
    }
  }

  Future<void> _handleAdoptMapping(
    BuildContext context,
    CommunityMapping communityMapping,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => ConfirmDialog(
        title: 'Adopt Community Mapping',
        message:
            'Add "${communityMapping.processName} → ${communityMapping.twitchCategoryName}" to your personal mappings?',
        confirmText: 'Adopt',
        cancelText: 'Cancel',
      ),
    );

    if (confirmed == true && context.mounted) {
      final mapping = CategoryMapping(
        processName: communityMapping.processName,
        twitchCategoryId: communityMapping.twitchCategoryId,
        twitchCategoryName: communityMapping.twitchCategoryName,
        createdAt: DateTime.now(),
        lastApiFetch: DateTime.now(),
        cacheExpiresAt: DateTime.now().add(const Duration(hours: 24)),
        manualOverride: true,
      );

      context.read<CategoryMappingProvider>().addMapping(mapping);
      Toast.success(context, 'Community mapping adopted successfully!');
    }
  }
}
