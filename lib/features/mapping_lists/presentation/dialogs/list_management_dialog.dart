import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tkit/features/mapping_lists/presentation/providers/mapping_list_provider.dart';
import 'package:tkit/features/mapping_lists/domain/entities/mapping_list.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/text_styles.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/widgets/buttons/primary_button.dart';
import 'package:tkit/shared/widgets/buttons/accent_button.dart';
import 'package:tkit/shared/widgets/layout/island.dart';
import 'package:tkit/shared/widgets/layout/spacer.dart';

/// Dialog for managing mapping lists
class ListManagementDialog extends StatefulWidget {
  const ListManagementDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const ListManagementDialog(),
    );
  }

  @override
  State<ListManagementDialog> createState() => _ListManagementDialogState();
}

class _ListManagementDialogState extends State<ListManagementDialog> {
  @override
  void initState() {
    super.initState();
    // Load lists on dialog open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MappingListProvider>().loadLists();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: TKitColors.surface,
      child: Container(
        width: 800,
        constraints: const BoxConstraints(maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            Expanded(
              child: Consumer<MappingListProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading && provider.lists.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.lists.isEmpty) {
                    return const Center(
                      child: Text('No lists found'),
                    );
                  }

                  return _buildListsView(provider);
                },
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
          HSpace.sm(),
          Text('Manage Lists', style: TKitTextStyles.heading2),
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

  Widget _buildListsView(MappingListProvider provider) {
    return ListView.builder(
      padding: const EdgeInsets.all(TKitSpacing.pagePadding),
      itemCount: provider.lists.length,
      itemBuilder: (context, index) {
        final list = provider.lists[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildListTile(list, provider),
        );
      },
    );
  }

  Widget _buildListTile(MappingList list, MappingListProvider provider) {
    final isSyncing = provider.isListSyncing(list.id);

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
                onChanged: (value) => provider.toggleListEnabled(list.id),
                fillColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.disabled)) {
                    return TKitColors.textDisabled;
                  }
                  return TKitColors.accent;
                }),
              ),
            ),
            HSpace.sm(),

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
                      HSpace.sm(),
                      _buildSourceBadge(list.sourceType),
                      if (list.isReadOnly) ...[
                        HSpace.sm(),
                        _buildReadOnlyBadge(),
                      ],
                    ],
                  ),
                  if (list.description.isNotEmpty) ...[
                    VSpace.xs(),
                    Text(
                      list.description,
                      style: TKitTextStyles.caption.copyWith(
                        color: TKitColors.textMuted,
                      ),
                    ),
                  ],
                  VSpace.xs(),
                  Row(
                    children: [
                      Text(
                        '${list.mappingCount} mappings',
                        style: TKitTextStyles.bodySmall.copyWith(
                          color: TKitColors.textSecondary,
                        ),
                      ),
                      HSpace.md(),
                      if (list.lastSyncError != null)
                        Tooltip(
                          message: list.lastSyncError!,
                          preferBelow: false,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 14,
                                color: TKitColors.error,
                              ),
                              HSpace.xs(),
                              Text(
                                'Sync failed: ${_formatSyncTime(list.lastSyncedAt)}',
                                style: TKitTextStyles.bodySmall.copyWith(
                                  color: TKitColors.error,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Text(
                          'Last synced: ${_formatSyncTime(list.lastSyncedAt)}',
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
              HSpace.sm(),
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
                          onPressed: () => provider.syncList(list.id),
                          tooltip: 'Sync now',
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

  Widget _buildSourceBadge(MappingListSourceType type) {
    Color color;
    String label;

    switch (type) {
      case MappingListSourceType.local:
        color = const Color(0xFF6B6B6B);
        label = 'LOCAL';
        break;
      case MappingListSourceType.official:
        color = TKitColors.info;
        label = 'OFFICIAL';
        break;
      case MappingListSourceType.remote:
        color = TKitColors.warning;
        label = 'REMOTE';
        break;
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

  Widget _buildReadOnlyBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: TKitColors.textMuted.withValues(alpha: 0.1),
        border: Border.all(color: TKitColors.textMuted.withValues(alpha: 0.3)),
      ),
      child: Text(
        'READ-ONLY',
        style: TKitTextStyles.caption.copyWith(
          color: TKitColors.textMuted,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildFooter() {
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
      child: Consumer<MappingListProvider>(
        builder: (context, provider, child) {
          return Row(
            children: [
              PrimaryButton(
                text: 'Import List',
                icon: Icons.add,
                onPressed: () => _showImportDialog(context),
                width: 140,
              ),
              HSpace.md(),
              AccentButton(
                text: 'Sync All',
                icon: Icons.sync,
                onPressed: provider.isLoading ? null : () => provider.syncAllLists(),
                width: 120,
              ),
              const Spacer(),
              AccentButton(
                text: 'Close',
                onPressed: () => Navigator.of(context).pop(),
                width: 100,
              ),
            ],
          );
        },
      ),
    );
  }

  void _showImportDialog(BuildContext context) {
    final nameController = TextEditingController();
    final urlController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: TKitColors.surface,
        title: Text('Import List', style: TKitTextStyles.heading3),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('List URL', style: TKitTextStyles.labelSmall),
              VSpace.sm(),
              TextFormField(
                controller: urlController,
                decoration: const InputDecoration(
                  hintText: 'https://example.com/mappings.json',
                  filled: true,
                  fillColor: TKitColors.background,
                ),
              ),
              VSpace.md(),
              Text('List Name (optional)', style: TKitTextStyles.labelSmall),
              VSpace.xs(),
              Text(
                'If not provided, will use name from JSON file',
                style: TKitTextStyles.caption.copyWith(
                  color: TKitColors.textMuted,
                ),
              ),
              VSpace.sm(),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'My Custom List',
                  filled: true,
                  fillColor: TKitColors.background,
                ),
              ),
              VSpace.md(),
              Text('Description (optional)', style: TKitTextStyles.labelSmall),
              VSpace.xs(),
              Text(
                'If not provided, will use description from JSON file',
                style: TKitTextStyles.caption.copyWith(
                  color: TKitColors.textMuted,
                ),
              ),
              VSpace.sm(),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: 'A collection of game mappings',
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
            text: 'Cancel',
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
          HSpace.sm(),
          PrimaryButton(
            text: 'Import',
            onPressed: () async {
              final url = urlController.text.trim();
              final name = nameController.text.trim();
              final description = descriptionController.text.trim();

              if (url.isEmpty) {
                return;
              }

              Navigator.of(dialogContext).pop();

              final success = await context.read<MappingListProvider>().importListFromUrl(
                    url: url,
                    name: name.isEmpty ? 'Imported List' : name,
                    description: description.isEmpty ? null : description,
                  );

              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('List imported successfully')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  String _formatSyncTime(DateTime? time) {
    if (time == null) {
      return 'never';
    }

    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      // Show days + hours for >= 24 hours
      final days = difference.inDays;
      final hours = difference.inHours % 24;

      if (hours == 0) {
        return '${days}d ago';
      } else {
        return '${days}d ${hours}h ago';
      }
    }
  }
}
