import 'dart:convert';
import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:tkit/l10n/app_localizations.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/theme/text_styles.dart';
import 'package:tkit/shared/widgets/layout/page_header.dart';
import 'package:tkit/shared/widgets/layout/island.dart';
import 'package:tkit/shared/widgets/layout/stat_item.dart';
import 'package:tkit/shared/widgets/layout/empty_state.dart';
import 'package:tkit/shared/widgets/layout/spacer.dart';
import 'package:tkit/shared/widgets/buttons/primary_button.dart';
import 'package:tkit/shared/widgets/buttons/accent_button.dart';
import 'package:tkit/shared/widgets/dialogs/confirm_dialog.dart';
import 'package:tkit/shared/widgets/dialogs/error_dialog.dart';
import 'package:tkit/shared/widgets/indicators/loading_indicator.dart';
import 'package:tkit/shared/widgets/feedback/toast.dart';
import 'package:tkit/features/category_mapping/domain/entities/category_mapping.dart';
import 'package:tkit/features/category_mapping/presentation/providers/category_mapping_provider.dart';
import 'package:tkit/features/category_mapping/presentation/widgets/add_mapping_dialog.dart';
import 'package:tkit/features/category_mapping/presentation/widgets/mapping_list_widget.dart';
import 'package:tkit/features/mapping_lists/presentation/dialogs/list_management_dialog.dart';
import 'package:tkit/features/mapping_lists/presentation/providers/mapping_list_provider.dart';

/// Page for managing category mappings
///
/// Displays unified view of all mappings from enabled lists
@RoutePage()
class CategoryMappingEditorPage extends StatefulWidget {
  const CategoryMappingEditorPage({super.key});

  @override
  State<CategoryMappingEditorPage> createState() =>
      _CategoryMappingEditorPageState();
}

class _CategoryMappingEditorPageState extends State<CategoryMappingEditorPage> {
  MappingListProvider? _listProvider;
  CategoryMappingProvider? _mappingProvider;

  @override
  void initState() {
    super.initState();

    // Load mappings and lists
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mappingProvider = context.read<CategoryMappingProvider>();
      _listProvider = context.read<MappingListProvider>();

      _mappingProvider!.loadMappings();
      _listProvider!.loadLists();

      // Listen to list changes and reload mappings
      _listProvider!.addListener(_onListsChanged);
    });
  }

  @override
  void dispose() {
    _listProvider?.removeListener(_onListsChanged);
    super.dispose();
  }

  void _onListsChanged() {
    // Reload mappings when lists change (e.g., when toggled)
    if (mounted && _mappingProvider != null) {
      _mappingProvider!.loadMappings();
    }
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

            // Unified mappings view
            Expanded(
              child: _buildMappingsView(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMappingsView(BuildContext context) {
    return Consumer2<CategoryMappingProvider, MappingListProvider>(
      builder: (context, mappingProvider, listProvider, child) {
        final l10n = AppLocalizations.of(context)!;
        final errorMsg = mappingProvider.errorMessage;
        final successMsg = mappingProvider.successMessage;

        // Handle success/error messages from mapping provider
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (successMsg != null) {
            Toast.success(context, successMsg);
            mappingProvider.clearMessages();
          } else if (errorMsg != null) {
            showDialog(
              context: context,
              builder: (dialogContext) => ErrorDialog(
                title: l10n.categoryMappingErrorDialogTitle,
                message: errorMsg,
              ),
            );
            mappingProvider.clearMessages();
          }

          // Handle messages from list provider
          if (listProvider.successMessage != null) {
            Toast.success(context, listProvider.successMessage!);
            listProvider.clearMessages();
          } else if (listProvider.errorMessage != null) {
            Toast.error(context, listProvider.errorMessage!);
            listProvider.clearMessages();
          }
        });

        // Only show full loading indicator on initial load (when there are no mappings)
        if (mappingProvider.isLoading && mappingProvider.mappings.isEmpty) {
          return const Center(child: LoadingIndicator());
        }

        if (mappingProvider.errorMessage != null && mappingProvider.mappings.isEmpty) {
          return _buildErrorView(context, mappingProvider.errorMessage!);
        }

        final mappings = mappingProvider.mappings;
        final enabledLists = listProvider.lists.where((l) => l.isEnabled).length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Stats bar with actions
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
                    label: 'Active Lists',
                    value: enabledLists.toString(),
                  ),
                  const HSpace.xxl(),
                  StatItem(
                    label: l10n.categoryMappingStatsUserDefined,
                    value: mappings.where((m) => m.manualOverride).length.toString(),
                  ),
                  const Spacer(),
                  AccentButton(
                    text: 'View Lists',
                    icon: Icons.list_alt,
                    onPressed: () => ListManagementDialog.show(context),
                    width: 140,
                  ),
                  const HSpace.md(),
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
                onBulkDelete: (ids) => _handleBulkDelete(context, ids),
                onBulkExport: (mappings) => _handleBulkExport(context, mappings),
                onBulkToggleEnabled: (ids, enabled) =>
                    _handleBulkToggleEnabled(context, ids, enabled),
                onBulkRestore: (mappings) => _handleBulkRestore(context, mappings),
                onSourceTap: (listId) => _handleSourceTap(context, listId),
              ),
            ),
          ],
        );
      },
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

  Future<void> _handleBulkDelete(BuildContext context, List<int> ids) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => ConfirmDialog(
        title: 'Delete Multiple Mappings',
        message:
            'Are you sure you want to delete ${ids.length} mapping${ids.length > 1 ? 's' : ''}? This action cannot be undone.',
        confirmText: l10n.categoryMappingDeleteDialogConfirm,
        cancelText: l10n.categoryMappingDeleteDialogCancel,
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<CategoryMappingProvider>().bulkDelete(ids);
    }
  }

  Future<void> _handleBulkExport(
    BuildContext context,
    List<CategoryMapping> mappings,
  ) async {
    try {
      // Let user choose where to save the file
      final result = await FilePicker.platform.saveFile(
        dialogTitle: 'Export Mappings',
        fileName: 'my-mappings.json',
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null) {
        // User cancelled
        return;
      }

      // Convert mappings to community format
      final exportData = {
        'version': '1.0',
        'lastUpdated': DateTime.now().toIso8601String(),
        'mappings': mappings.map((mapping) {
          return {
            'processName': mapping.processName,
            'twitchCategoryId': mapping.twitchCategoryId,
            'twitchCategoryName': mapping.twitchCategoryName,
            'verificationCount': 1,
            'lastVerified': mapping.lastUsedAt?.toIso8601String() ??
                             mapping.createdAt.toIso8601String(),
            'source': mapping.manualOverride ? 'user' : 'preset',
          };
        }).toList(),
      };

      // Write to file
      final file = File(result);
      await file.writeAsString(
        const JsonEncoder.withIndent('  ').convert(exportData),
      );

      if (context.mounted) {
        Toast.successWithWidget(
          context,
          duration: const Duration(seconds: 6),
          content: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'Exported ${mappings.length} mapping${mappings.length > 1 ? 's' : ''} to ',
                style: TKitTextStyles.bodyMedium.copyWith(
                  color: TKitColors.textPrimary,
                ),
              ),
              InkWell(
                onTap: () async {
                  // Open file location in Explorer (Windows)
                  await Process.run(
                    'explorer',
                    ['/select,', file.path],
                    runInShell: true,
                  );
                },
                child: Text(
                  file.path,
                  style: TKitTextStyles.bodyMedium.copyWith(
                    color: TKitColors.textPrimary,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (dialogContext) => ErrorDialog(
            title: 'Export Failed',
            message: e.toString(),
          ),
        );
      }
    }
  }

  Future<void> _handleBulkToggleEnabled(
    BuildContext context,
    List<int> ids,
    bool enabled,
  ) async {
    context.read<CategoryMappingProvider>().bulkToggleEnabled(ids, enabled);
  }

  Future<void> _handleBulkRestore(
    BuildContext context,
    List<CategoryMapping> mappings,
  ) async {
    context.read<CategoryMappingProvider>().bulkRestore(mappings);
  }

  void _handleSourceTap(BuildContext context, String? listId) {
    // Open the list management dialog
    ListManagementDialog.show(context);
  }
}
