import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:tkit/l10n/app_localizations.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/theme/text_styles.dart';
import 'package:tkit/shared/widgets/layout/empty_state.dart';
import 'package:tkit/shared/widgets/layout/spacer.dart';
import 'package:tkit/shared/widgets/buttons/primary_button.dart';
import 'package:tkit/shared/widgets/buttons/accent_button.dart';
import 'package:tkit/shared/widgets/dialogs/confirm_dialog.dart';
import 'package:tkit/shared/widgets/dialogs/error_dialog.dart';
import 'package:tkit/shared/widgets/indicators/loading_indicator.dart';
import 'package:tkit/shared/widgets/feedback/toast.dart';
import 'package:tkit/features/category_mapping/domain/entities/category_mapping.dart';
import 'package:tkit/features/category_mapping/presentation/providers/category_mapping_providers.dart';
import 'package:tkit/features/category_mapping/presentation/widgets/add_mapping_dialog.dart';
import 'package:tkit/features/category_mapping/presentation/widgets/mapping_list_widget.dart';
import 'package:tkit/features/mapping_lists/presentation/dialogs/list_management_dialog.dart';
import 'package:tkit/features/mapping_lists/presentation/providers/mapping_list_providers.dart';

/// Page for managing category mappings
///
/// Displays unified view of all mappings from enabled lists
@RoutePage()
class CategoryMappingEditorPage extends ConsumerStatefulWidget {
  const CategoryMappingEditorPage({super.key});

  @override
  ConsumerState<CategoryMappingEditorPage> createState() =>
      _CategoryMappingEditorPageState();
}

class _CategoryMappingEditorPageState extends ConsumerState<CategoryMappingEditorPage> {
  @override
  void initState() {
    super.initState();

    // Load mappings and lists
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoryMappingsProvider.notifier).loadMappings();
      ref.read(mappingListsProvider.notifier).loadLists();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TKitColors.background,
      body: Padding(
        padding: const EdgeInsets.all(TKitSpacing.pagePadding),
        child: _buildMappingsView(context),
      ),
    );
  }

  Widget _buildMappingsView(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mappingState = ref.watch(categoryMappingsProvider);
    final listState = ref.watch(mappingListsProvider);

    final errorMsg = mappingState.errorMessage;
    final successMsg = mappingState.successMessage;

    // Handle success/error messages from mapping provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (successMsg != null) {
        Toast.success(context, successMsg);
        ref.read(categoryMappingsProvider.notifier).clearMessages();
      } else if (errorMsg != null) {
        showDialog<void>(
          context: context,
          builder: (dialogContext) => ErrorDialog(
            title: l10n.categoryMappingErrorDialogTitle,
            message: errorMsg,
          ),
        );
        ref.read(categoryMappingsProvider.notifier).clearMessages();
      }

      // Handle messages from list provider
      if (listState.successMessage != null) {
        Toast.success(context, listState.successMessage!);
        ref.read(mappingListsProvider.notifier).clearMessages();
      } else if (listState.errorMessage != null) {
        Toast.error(context, listState.errorMessage!);
        ref.read(mappingListsProvider.notifier).clearMessages();
      }
    });

    // Only show full loading indicator on initial load (when there are no mappings)
    if (mappingState.isLoading && mappingState.mappings.isEmpty) {
      return const Center(child: LoadingIndicator());
    }

    if (mappingState.errorMessage != null && mappingState.mappings.isEmpty) {
      return _buildErrorView(context, mappingState.errorMessage!);
    }

    final mappings = mappingState.mappings;
    final enabledLists = listState.lists.where((l) => l.isEnabled).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Summary card - conversational style
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.mappingEditorSummary(
                      mappings.length,
                      mappings.length != 1 ? 's' : '',
                      enabledLists,
                      enabledLists != 1 ? 's' : '',
                    ),
                    style: TKitTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const VSpace.xs(),
                  Text(
                    l10n.mappingEditorBreakdown(
                      mappings.where((m) => m.manualOverride).length,
                      mappings.where((m) => !m.manualOverride).length,
                    ),
                    style: TKitTextStyles.bodySmall.copyWith(
                      color: TKitColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const HSpace.xl(),
            AccentButton(
              text: l10n.mappingEditorButtonLists,
              icon: Icons.list_alt,
              onPressed: () => ListManagementDialog.show(context),
            ),
            const HSpace.md(),
            PrimaryButton(
              text: l10n.mappingEditorButtonAdd,
              icon: Icons.add,
              onPressed: () => _showAddMappingDialog(context),
            ),
          ],
        ),
        const VSpace.lg(),

        // Mappings table
        Expanded(
          child: MappingListWidget(
            mappings: mappings,
            onDelete: (id) => _handleDelete(context, id),
            onEdit: (mapping) => _showEditMappingDialog(context, mapping),
            onToggleEnabled: (mapping) {
              ref.read(categoryMappingsProvider.notifier).toggleEnabled(mapping);
            },
            onBulkDelete: (ids) => _handleBulkDelete(context, ids),
            onBulkExport: (mappings) => _handleBulkExport(context, mappings),
            onBulkToggleEnabled: (ids, {required enabled}) =>
                _handleBulkToggleEnabled(context, ids, enabled: enabled),
            onBulkRestore: (mappings) => _handleBulkRestore(context, mappings),
            onSourceTap: (listId) => _handleSourceTap(context, listId),
          ),
        ),
      ],
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
          ref.read(categoryMappingsProvider.notifier).loadMappings();
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
      unawaited(ref.read(categoryMappingsProvider.notifier).addMapping(result));
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
      unawaited(ref.read(categoryMappingsProvider.notifier).updateMapping(result));
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
      unawaited(ref.read(categoryMappingsProvider.notifier).deleteMapping(id));
    }
  }

  Future<void> _handleBulkDelete(BuildContext context, List<int> ids) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => ConfirmDialog(
        title: l10n.mappingEditorDeleteTitle,
        message: l10n.mappingEditorDeleteMessage(
          ids.length,
          ids.length > 1 ? 's' : '',
        ),
        confirmText: l10n.categoryMappingDeleteDialogConfirm,
        cancelText: l10n.categoryMappingDeleteDialogCancel,
      ),
    );

    if (confirmed == true && context.mounted) {
      unawaited(ref.read(categoryMappingsProvider.notifier).bulkDelete(ids));
    }
  }

  Future<void> _handleBulkExport(
    BuildContext context,
    List<CategoryMapping> mappings,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      // Let user choose where to save the file
      final result = await FilePicker.platform.saveFile(
        dialogTitle: l10n.mappingEditorExportTitle,
        fileName: l10n.mappingEditorExportFilename,
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
        final l10n = AppLocalizations.of(context)!;
        Toast.successWithWidget(
          context,
          duration: const Duration(seconds: 6),
          content: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                '${l10n.mappingEditorExportSuccess(mappings.length, mappings.length > 1 ? 's' : '')} ',
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
        final l10n = AppLocalizations.of(context)!;
        unawaited(
          showDialog<void>(
            context: context,
            builder: (dialogContext) => ErrorDialog(
              title: l10n.mappingEditorExportFailed,
              message: e.toString(),
            ),
          ),
        );
      }
    }
  }

  Future<void> _handleBulkToggleEnabled(
    BuildContext context,
    List<int> ids, {
    required bool enabled,
  }) async {
    unawaited(
      ref.read(categoryMappingsProvider.notifier).bulkToggleEnabled(ids, enabled: enabled),
    );
  }

  Future<void> _handleBulkRestore(
    BuildContext context,
    List<CategoryMapping> mappings,
  ) async {
    unawaited(
      ref.read(categoryMappingsProvider.notifier).bulkRestore(mappings),
    );
  }

  void _handleSourceTap(BuildContext context, String? listId) {
    // Open the list management dialog
    ListManagementDialog.show(context);
  }
}
