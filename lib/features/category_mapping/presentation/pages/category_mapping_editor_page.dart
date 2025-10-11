import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tkit/l10n/app_localizations.dart';
import '../../../../shared/theme/colors.dart';
import '../../../../shared/theme/text_styles.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/dialogs/confirm_dialog.dart';
import '../../../../shared/widgets/dialogs/error_dialog.dart';
import '../../../../shared/widgets/indicators/loading_indicator.dart';
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Header - minimal (matching Auto Switcher)
            Text(
              AppLocalizations.of(context)!.categoryMappingTitle,
              style: TKitTextStyles.heading2.copyWith(
                letterSpacing: 1.2,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              AppLocalizations.of(context)!.categoryMappingSubtitle,
              style: TKitTextStyles.bodySmall.copyWith(
                color: TKitColors.textMuted,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 14),

            // Content
          Expanded(
            child: Consumer<CategoryMappingProvider>(
              builder: (context, provider, child) {
                // Handle success/error messages
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (provider.successMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(provider.successMessage!),
                        backgroundColor: TKitColors.success,
                        behavior: SnackBarBehavior.floating,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                    );
                    provider.clearMessages();
                  } else if (provider.errorMessage != null) {
                    showDialog(
                      context: context,
                      builder: (context) => ErrorDialog(
                        title: AppLocalizations.of(context)!.categoryMappingErrorDialogTitle,
                        message: provider.errorMessage!,
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
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: TKitColors.border),
                        color: TKitColors.surfaceVariant,
                      ),
                      child: Row(
                        children: [
                          _buildStatItem(
                            context,
                            AppLocalizations.of(context)!.categoryMappingStatsTotalMappings,
                            mappings.length.toString(),
                          ),
                          const SizedBox(width: 24),
                          _buildStatItem(
                            context,
                            AppLocalizations.of(context)!.categoryMappingStatsUserDefined,
                            mappings
                                .where((m) => m.manualOverride)
                                .length
                                .toString(),
                          ),
                          const SizedBox(width: 24),
                          _buildStatItem(
                            context,
                            AppLocalizations.of(context)!.categoryMappingStatsPresets,
                            mappings
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
                    const SizedBox(height: 12),

                      // Mappings table
                      Expanded(
                        child: MappingListWidget(
                          mappings: mappings,
                          onDelete: (id) => _handleDelete(context, id),
                          onEdit: (mapping) =>
                              _showEditMappingDialog(context, mapping),
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

  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TKitTextStyles.labelSmall.copyWith(
            color: TKitColors.textMuted,
            fontSize: 10,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: TKitTextStyles.heading2.copyWith(
            color: TKitColors.accent,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: TKitColors.error),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.categoryMappingErrorLoading,
            style: TKitTextStyles.heading3.copyWith(
              color: TKitColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TKitTextStyles.bodyMedium.copyWith(
              color: TKitColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            text: AppLocalizations.of(context)!.categoryMappingRetryButton,
            icon: Icons.refresh,
            onPressed: () {
              context.read<CategoryMappingProvider>().loadMappings();
            },
          ),
        ],
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(
        title: AppLocalizations.of(context)!.categoryMappingDeleteDialogTitle,
        message: AppLocalizations.of(context)!.categoryMappingDeleteDialogMessage,
        confirmText: AppLocalizations.of(context)!.categoryMappingDeleteDialogConfirm,
        cancelText: AppLocalizations.of(context)!.categoryMappingDeleteDialogCancel,
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<CategoryMappingProvider>().deleteMapping(id);
    }
  }
}
