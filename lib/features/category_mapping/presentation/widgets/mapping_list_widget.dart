import 'package:flutter/material.dart';
import 'package:tkit/l10n/app_localizations.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/text_styles.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/widgets/layout/spacer.dart';
import 'package:tkit/features/category_mapping/domain/entities/category_mapping.dart';

/// Widget to display the list of category mappings in a DataTable
class MappingListWidget extends StatelessWidget {
  final List<CategoryMapping> mappings;
  final Function(int id) onDelete;
  final Function(CategoryMapping mapping) onEdit;
  final Function(CategoryMapping mapping)? onToggleEnabled;

  const MappingListWidget({
    super.key,
    required this.mappings,
    required this.onDelete,
    required this.onEdit,
    this.onToggleEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (mappings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category_outlined,
              size: 48,
              color: TKitColors.textMuted,
            ),
            const VSpace.md(),
            Text(
              l10n.categoryMappingListEmpty,
              style: TKitTextStyles.bodyMedium.copyWith(
                color: TKitColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const VSpace.sm(),
            Text(
              l10n.categoryMappingListEmptySubtitle,
              style: TKitTextStyles.bodySmall.copyWith(
                color: TKitColors.textMuted,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: TKitColors.border),
        color: TKitColors.surface,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          width: double.infinity,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(TKitColors.surfaceVariant),
            dataRowColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.hovered)) {
                return TKitColors.surfaceVariant;
              }
              return TKitColors.surface;
            }),
            border: TableBorder.symmetric(
              inside: const BorderSide(color: TKitColors.border),
            ),
            headingTextStyle: TKitTextStyles.labelLarge.copyWith(
              color: TKitColors.textPrimary,
              fontSize: 12,
              letterSpacing: 0.5,
            ),
            dataTextStyle: TKitTextStyles.bodyMedium.copyWith(
              color: TKitColors.textSecondary,
              fontSize: 13,
            ),
            headingRowHeight: 48,
            dataRowMinHeight: 52,
            dataRowMaxHeight: 64,
            columnSpacing: 24,
            horizontalMargin: TKitSpacing.md,
            columns: [
              DataColumn(label: Text(l10n.categoryMappingListColumnProcessName)),
              DataColumn(label: Text(l10n.categoryMappingListColumnCategory)),
              DataColumn(label: Text(l10n.categoryMappingListColumnLastUsed)),
              DataColumn(label: Text(l10n.categoryMappingListColumnType)),
              const DataColumn(label: Text('Enabled')),
              DataColumn(label: Text(l10n.categoryMappingListColumnActions)),
            ],
            rows: mappings.map((mapping) {
              return DataRow(
                cells: [
                  DataCell(
                    Text(
                      mapping.processName,
                      style: TKitTextStyles.code.copyWith(
                        color: TKitColors.textPrimary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  DataCell(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mapping.twitchCategoryName,
                          style: TKitTextStyles.bodyMedium.copyWith(
                            color: TKitColors.textPrimary,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          l10n.categoryMappingListCategoryId(mapping.twitchCategoryId),
                          style: TKitTextStyles.bodySmall.copyWith(
                            color: TKitColors.textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  DataCell(
                    Text(
                      mapping.lastUsedAt != null
                          ? _formatDate(context, mapping.lastUsedAt!)
                          : l10n.categoryMappingListNever,
                      style: TKitTextStyles.bodySmall.copyWith(
                        fontSize: 12,
                        color: mapping.lastUsedAt != null
                            ? TKitColors.textSecondary
                            : TKitColors.textMuted,
                      ),
                    ),
                  ),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TKitSpacing.sm,
                        vertical: TKitSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: mapping.manualOverride
                            ? TKitColors.accent.withValues(alpha: 0.2)
                            : TKitColors.surfaceVariant,
                        border: Border.all(
                          color: mapping.manualOverride
                              ? TKitColors.accent
                              : TKitColors.border,
                        ),
                      ),
                      child: Text(
                        mapping.manualOverride ? l10n.categoryMappingListTypeUser : l10n.categoryMappingListTypePreset,
                        style: TKitTextStyles.caption.copyWith(
                          color: mapping.manualOverride
                              ? TKitColors.accent
                              : TKitColors.textMuted,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    Checkbox(
                      value: mapping.isEnabled,
                      onChanged: onToggleEnabled != null
                          ? (_) => onToggleEnabled!(mapping)
                          : null,
                      activeColor: TKitColors.accent,
                      side: const BorderSide(color: TKitColors.border),
                    ),
                  ),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, size: 16),
                          color: TKitColors.textSecondary,
                          hoverColor: TKitColors.accent.withValues(alpha: 0.2),
                          onPressed: () => onEdit(mapping),
                          tooltip: l10n.categoryMappingListEditTooltip,
                          padding: const EdgeInsets.all(TKitSpacing.sm),
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 16),
                          color: TKitColors.textSecondary,
                          hoverColor: TKitColors.error.withValues(alpha: 0.2),
                          onPressed: () => onDelete(mapping.id!),
                          tooltip: l10n.categoryMappingListDeleteTooltip,
                          padding: const EdgeInsets.all(TKitSpacing.sm),
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime date) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return l10n.categoryMappingListJustNow;
        }
        return l10n.categoryMappingListMinutesAgo(difference.inMinutes);
      }
      return l10n.categoryMappingListHoursAgo(difference.inHours);
    } else if (difference.inDays < 7) {
      return l10n.categoryMappingListDaysAgo(difference.inDays);
    } else {
      // Format as MMM d, yyyy manually
      const months = [
        '',
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[date.month]} ${date.day}, ${date.year}';
    }
  }
}
