import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tkit/l10n/app_localizations.dart';
import '../../../../shared/theme/colors.dart';
import '../../../../shared/theme/spacing.dart';
import '../../../../shared/widgets/layout/page_header.dart';
import '../../../../shared/widgets/layout/island.dart';
import '../../../../shared/widgets/layout/stat_item.dart';
import '../../../../shared/widgets/layout/empty_state.dart';
import '../../../../shared/widgets/layout/spacer.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/dialogs/confirm_dialog.dart';
import '../../../../shared/widgets/dialogs/error_dialog.dart';
import '../../../../shared/widgets/indicators/loading_indicator.dart';
import '../../../../shared/widgets/feedback/toast.dart';
import '../../domain/entities/category_mapping.dart';
import '../providers/category_mapping_provider.dart';
import '../widgets/add_mapping_dialog.dart';
import '../widgets/mapping_list_widget.dart';

/// Page for managing category mappings
///
/// Displays a DataTable with all mappings and allows CRUD operations
@RoutePage()
class CategoryMappingEditorPage extends StatelessWidget {
  const CategoryMappingEditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the provider from context and load mappings
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryMappingProvider>().loadMappings();
    });

    return const _CategoryMappingEditorContent();
  }
}

class _CategoryMappingEditorContent extends StatelessWidget {
  const _CategoryMappingEditorContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TKitColors.background,
      body: Padding(
        padding: const EdgeInsets.all(TKitSpacing.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Header
            PageHeader(
              title: AppLocalizations.of(context)!.categoryMappingTitle,
              subtitle: AppLocalizations.of(context)!.categoryMappingSubtitle,
            ),
            const VSpace.lg(),

            // Content
          Expanded(
            child: Consumer<CategoryMappingProvider>(
              builder: (context, provider, child) {
                // Capture localizations and messages before the callback
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
                            label: AppLocalizations.of(context)!.categoryMappingStatsTotalMappings,
                            value: mappings.length.toString(),
                            valueColor: TKitColors.accent,
                          ),
                          const HSpace.xxl(),
                          StatItem(
                            label: AppLocalizations.of(context)!.categoryMappingStatsUserDefined,
                            value: mappings
                                .where((m) => m.manualOverride)
                                .length
                                .toString(),
                          ),
                          const HSpace.xxl(),
                          StatItem(
                            label: AppLocalizations.of(context)!.categoryMappingStatsPresets,
                            value: mappings
                                .where((m) => !m.manualOverride)
                                .length
                                .toString(),
                          ),
                          const Spacer(),
                          PrimaryButton(
                            text: AppLocalizations.of(context)!.categoryMappingAddMappingButton,
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
                          onEdit: (mapping) =>
                              _showEditMappingDialog(context, mapping),
                          onToggleEnabled: (mapping) {
                            context.read<CategoryMappingProvider>().toggleEnabled(mapping);
                          },
                        ),
                      ),
                    ],
                  );
              },
            ),
          ),
        ],
        ),
      ),
    );
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
}
