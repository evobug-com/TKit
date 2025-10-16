import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tkit/features/mapping_lists/presentation/providers/mapping_list_providers.dart';
import 'package:tkit/features/mapping_lists/domain/entities/mapping_list.dart';
import 'package:tkit/l10n/app_localizations.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/text_styles.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/widgets/buttons/primary_button.dart';
import 'package:tkit/shared/widgets/buttons/accent_button.dart';
import 'package:tkit/shared/widgets/layout/island.dart';
import 'package:tkit/shared/widgets/layout/spacer.dart';

/// Dialog for managing mapping lists
class ListManagementDialog extends ConsumerStatefulWidget {
  const ListManagementDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const ListManagementDialog(),
    );
  }

  @override
  ConsumerState<ListManagementDialog> createState() => _ListManagementDialogState();
}

class _ListManagementDialogState extends ConsumerState<ListManagementDialog> {
  @override
  void initState() {
    super.initState();
    // Load lists on dialog open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mappingListsProvider.notifier).loadLists();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(mappingListsProvider);

    return Dialog(
      backgroundColor: TKitColors.surface,
      child: Container(
        width: 800,
        constraints: const BoxConstraints(maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(l10n),
            Expanded(
              child: () {
                if (state.isLoading && state.lists.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.lists.isEmpty) {
                  return Center(
                    child: Text(l10n.listManagementEmptyState),
                  );
                }

                return _buildListsView(l10n, state);
              }(),
            ),
            _buildFooter(l10n, state),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(TKitSpacing.pagePadding),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: TKitColors.border,
            width: 1,
          ),
        ),
        color: TKitColors.surfaceVariant,
      ),
      child: Row(
        children: [
          const Icon(Icons.list_alt, size: 20, color: TKitColors.accent),
          const HSpace.sm(),
          Text(l10n.listManagementTitle, style: TKitTextStyles.heading2),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: () => Navigator.of(context).pop(),
            color: TKitColors.textMuted,
            hoverColor: TKitColors.accentHover.withValues(alpha: 0.1),
          ),
        ],
      ),
    );
  }

  Widget _buildListsView(AppLocalizations l10n, MappingListState state) {
    return ListView.builder(
      padding: const EdgeInsets.all(TKitSpacing.pagePadding),
      itemCount: state.lists.length,
      itemBuilder: (context, index) {
        final list = state.lists[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildListTile(l10n, list, state),
        );
      },
    );
  }

  Widget _buildListTile(AppLocalizations l10n, MappingList list, MappingListState state) {
    final isSyncing = state.syncingListIds.contains(list.id);

    return IslandVariant.standard(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Checkbox for enabled/disabled
            SizedBox(
              width: 40,
              child: Checkbox(
                value: list.isEnabled,
                onChanged: (value) => ref.read(mappingListsProvider.notifier).toggleListEnabled(list.id),
                fillColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.disabled)) {
                    return TKitColors.textDisabled;
                  }
                  return TKitColors.accent;
                }),
              ),
            ),
            const HSpace.sm(),

            // List info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        list.name,
                        style: TKitTextStyles.labelMedium,
                      ),
                      const HSpace.sm(),
                      _buildSourceBadge(l10n, list.sourceType),
                      if (list.isReadOnly) ...[
                        const HSpace.sm(),
                        _buildReadOnlyBadge(l10n),
                      ],
                    ],
                  ),
                  if (list.description.isNotEmpty) ...[
                    const VSpace.xs(),
                    Text(
                      list.description,
                      style: TKitTextStyles.caption.copyWith(
                        color: TKitColors.textMuted,
                      ),
                    ),
                  ],
                  const VSpace.xs(),
                  Row(
                    children: [
                      Text(
                        l10n.listManagementMappingsCount(list.mappingCount),
                        style: TKitTextStyles.bodySmall.copyWith(
                          color: TKitColors.textSecondary,
                        ),
                      ),
                      const HSpace.md(),
                      if (list.lastSyncError != null)
                        Tooltip(
                          message: list.lastSyncError!,
                          preferBelow: false,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 14,
                                color: TKitColors.error,
                              ),
                              const HSpace.xs(),
                              Text(
                                '${l10n.listManagementSyncFailed} ${_formatSyncTime(l10n, list.lastSyncedAt)}',
                                style: TKitTextStyles.bodySmall.copyWith(
                                  color: TKitColors.error,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Text(
                          '${l10n.listManagementLastSynced} ${_formatSyncTime(l10n, list.lastSyncedAt)}',
                          style: TKitTextStyles.bodySmall.copyWith(
                            color: TKitColors.textMuted,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Actions
            if (list.shouldSync) ...[
              const HSpace.sm(),
              SizedBox(
                width: 40,
                child: Center(
                  child: isSyncing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : IconButton(
                          icon: const Icon(Icons.sync, size: 18),
                          onPressed: () => ref.read(mappingListsProvider.notifier).syncList(list.id),
                          tooltip: l10n.listManagementSyncNow,
                          color: TKitColors.accent,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSourceBadge(AppLocalizations l10n, MappingListSourceType type) {
    Color color;
    String label;

    switch (type) {
      case MappingListSourceType.local:
        color = const Color(0xFF6B6B6B);
        label = l10n.listManagementBadgeLocal;
      case MappingListSourceType.official:
        color = TKitColors.info;
        label = l10n.listManagementBadgeOfficial;
      case MappingListSourceType.remote:
        color = TKitColors.warning;
        label = l10n.listManagementBadgeRemote;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TKitTextStyles.caption.copyWith(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildReadOnlyBadge(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: TKitColors.textMuted.withValues(alpha: 0.1),
        border: Border.all(color: TKitColors.textMuted.withValues(alpha: 0.3)),
      ),
      child: Text(
        l10n.listManagementBadgeReadOnly,
        style: TKitTextStyles.caption.copyWith(
          color: TKitColors.textMuted,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildFooter(AppLocalizations l10n, MappingListState state) {
    return Container(
      padding: const EdgeInsets.all(TKitSpacing.pagePadding),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: TKitColors.border,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          PrimaryButton(
            text: l10n.listManagementButtonImport,
            icon: Icons.add,
            onPressed: () => _showImportDialog(context, l10n),
            width: 140,
          ),
          const HSpace.md(),
          AccentButton(
            text: l10n.listManagementButtonSyncAll,
            icon: Icons.sync,
            onPressed: state.isLoading ? null : () => ref.read(mappingListsProvider.notifier).syncAllLists(),
            width: 120,
          ),
          const Spacer(),
          AccentButton(
            text: l10n.listManagementButtonClose,
            onPressed: () => Navigator.of(context).pop(),
            width: 100,
          ),
        ],
      ),
    );
  }

  void _showImportDialog(BuildContext context, AppLocalizations l10n) {
    final nameController = TextEditingController();
    final urlController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: TKitColors.surface,
        title: Text(l10n.listManagementImportTitle, style: TKitTextStyles.heading3),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.listManagementImportUrl, style: TKitTextStyles.labelSmall),
              const VSpace.sm(),
              TextFormField(
                controller: urlController,
                decoration: InputDecoration(
                  hintText: l10n.listManagementImportUrlPlaceholder,
                  filled: true,
                  fillColor: TKitColors.background,
                ),
              ),
              const VSpace.md(),
              Text(l10n.listManagementImportName, style: TKitTextStyles.labelSmall),
              const VSpace.xs(),
              Text(
                l10n.listManagementImportNameHelper,
                style: TKitTextStyles.caption.copyWith(
                  color: TKitColors.textMuted,
                ),
              ),
              const VSpace.sm(),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: l10n.listManagementImportNamePlaceholder,
                  filled: true,
                  fillColor: TKitColors.background,
                ),
              ),
              const VSpace.md(),
              Text(l10n.listManagementImportDescription, style: TKitTextStyles.labelSmall),
              const VSpace.xs(),
              Text(
                l10n.listManagementImportDescriptionHelper,
                style: TKitTextStyles.caption.copyWith(
                  color: TKitColors.textMuted,
                ),
              ),
              const VSpace.sm(),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: l10n.listManagementImportDescriptionPlaceholder,
                  filled: true,
                  fillColor: TKitColors.background,
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          AccentButton(
            text: l10n.listManagementButtonCancel,
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
          const HSpace.sm(),
          PrimaryButton(
            text: l10n.listManagementButtonImportConfirm,
            onPressed: () async {
              final url = urlController.text.trim();
              final name = nameController.text.trim();
              final description = descriptionController.text.trim();

              if (url.isEmpty) {
                return;
              }

              Navigator.of(dialogContext).pop();

              final success = await ref.read(mappingListsProvider.notifier).importListFromUrl(
                    url: url,
                    name: name.isEmpty ? l10n.listManagementDefaultName : name,
                    description: description.isEmpty ? null : description,
                  );

              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.listManagementImportSuccess)),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  String _formatSyncTime(AppLocalizations l10n, DateTime? time) {
    if (time == null) {
      return l10n.listManagementSyncNever;
    }

    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return l10n.listManagementSyncJustNow;
    } else if (difference.inHours < 1) {
      return l10n.listManagementSyncMinutesAgo(difference.inMinutes);
    } else if (difference.inHours < 24) {
      return l10n.listManagementSyncHoursAgo(difference.inHours);
    } else {
      // Show days + hours for >= 24 hours
      final days = difference.inDays;
      final hours = difference.inHours % 24;

      if (hours == 0) {
        return l10n.listManagementSyncDaysAgo(days);
      } else {
        return l10n.listManagementSyncDaysHoursAgo(days, hours);
      }
    }
  }
}
