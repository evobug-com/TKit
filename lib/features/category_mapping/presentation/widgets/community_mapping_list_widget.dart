import 'package:flutter/material.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/text_styles.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/widgets/layout/spacer.dart';
import 'package:tkit/features/community_mappings/domain/entities/community_mapping.dart';

/// Widget to display the list of community mappings in a DataTable
class CommunityMappingListWidget extends StatelessWidget {
  final List<CommunityMapping> mappings;
  final Function(CommunityMapping mapping) onAdopt;

  const CommunityMappingListWidget({
    super.key,
    required this.mappings,
    required this.onAdopt,
  });

  @override
  Widget build(BuildContext context) {
    if (mappings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_download,
              size: 48,
              color: TKitColors.textMuted,
            ),
            const VSpace.md(),
            Text(
              'No community mappings available',
              style: TKitTextStyles.bodyMedium.copyWith(
                color: TKitColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const VSpace.sm(),
            Text(
              'Community mappings are synced from GitHub',
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
            columns: const [
              DataColumn(label: Text('Process Name')),
              DataColumn(label: Text('Category')),
              DataColumn(label: Text('Verifications')),
              DataColumn(label: Text('Last Verified')),
              DataColumn(label: Text('Actions')),
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
                          'ID: ${mapping.twitchCategoryId}',
                          style: TKitTextStyles.bodySmall.copyWith(
                            color: TKitColors.textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TKitSpacing.sm,
                        vertical: TKitSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: TKitColors.accent.withValues(alpha: 0.1),
                        border: Border.all(color: TKitColors.accent),
                      ),
                      child: Text(
                        mapping.verificationCount.toString(),
                        style: TKitTextStyles.caption.copyWith(
                          color: TKitColors.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      mapping.lastVerified != null
                          ? _formatDate(mapping.lastVerified!)
                          : 'Never',
                      style: TKitTextStyles.bodySmall.copyWith(
                        fontSize: 12,
                        color: mapping.lastVerified != null
                            ? TKitColors.textSecondary
                            : TKitColors.textMuted,
                      ),
                    ),
                  ),
                  DataCell(
                    ElevatedButton.icon(
                      icon: const Icon(Icons.download, size: 14),
                      label: const Text('Adopt'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TKitColors.accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: TKitSpacing.md,
                          vertical: TKitSpacing.sm,
                        ),
                        textStyle: TKitTextStyles.labelMedium.copyWith(
                          fontSize: 12,
                        ),
                      ),
                      onPressed: () => onAdopt(mapping),
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
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
