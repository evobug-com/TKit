import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tkit/l10n/app_localizations.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/text_styles.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/widgets/layout/spacer.dart';
import 'package:tkit/shared/widgets/layout/island.dart';
import 'package:tkit/features/auto_switcher/domain/entities/orchestration_status.dart';
import 'package:tkit/features/auto_switcher/presentation/widgets/update_status_indicator.dart';

/// Status dashboard widget for Auto Switcher
/// Displays current process, matched category, last update time, and status
class StatusDashboard extends StatelessWidget {
  final OrchestrationStatus? status;

  const StatusDashboard({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Island.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // System State - Most prominent
          _buildOrchestrationState(context),

          const VSpace.lg(),

          // Status grid - 2x2 layout for compact display
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildStatusItem(
                  context,
                  label: l10n.autoSwitcherStatusCurrentProcess,
                  value: status?.currentProcess ?? l10n.autoSwitcherStatusNone,
                  valueColor: status?.currentProcess != null
                      ? TKitColors.textPrimary
                      : TKitColors.textMuted,
                  icon: Icons.play_circle_outline,
                ),
              ),
              const HSpace.lg(),
              Expanded(
                child: _buildStatusItem(
                  context,
                  label: l10n.autoSwitcherStatusMatchedCategory,
                  value: status?.matchedCategory ?? l10n.autoSwitcherStatusNone,
                  valueColor: status?.matchedCategory != null
                      ? TKitColors.textPrimary
                      : TKitColors.textMuted,
                  icon: Icons.category_outlined,
                ),
              ),
            ],
          ),

          const VSpace.md(),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildStatusItem(
                  context,
                  label: l10n.autoSwitcherStatusLastUpdate,
                  value: status?.lastUpdateTime != null
                      ? _formatTimestamp(status!.lastUpdateTime!)
                      : l10n.autoSwitcherStatusNever,
                  valueColor: TKitColors.textSecondary,
                  icon: Icons.schedule,
                ),
              ),
              const HSpace.lg(),
              Expanded(
                child: _buildUpdateStatusCompact(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem(
    BuildContext context, {
    required String label,
    required String value,
    Color? valueColor,
    IconData? icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: 16,
            color: TKitColors.textMuted,
          ),
          const HSpace.sm(),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TKitTextStyles.caption.copyWith(
                  color: TKitColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: TKitSpacing.headerGap),
              Text(
                value,
                style: TKitTextStyles.bodyMedium.copyWith(
                  color: valueColor ?? TKitColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUpdateStatusCompact(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bool? lastSuccess = status?.lastUpdateSuccess;
    if (lastSuccess == null) {
      return _buildStatusItem(
        context,
        label: l10n.autoSwitcherStatusUpdateStatus,
        value: l10n.autoSwitcherStatusNoUpdatesYet,
        valueColor: TKitColors.textMuted,
        icon: Icons.update,
      );
    }

    final indicator = lastSuccess
        ? UpdateStatusType.success
        : UpdateStatusType.error;
    final statusText = lastSuccess ? l10n.autoSwitcherStatusSuccess : l10n.autoSwitcherStatusFailed;
    final statusColor = lastSuccess ? TKitColors.success : TKitColors.error;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.update,
          size: 16,
          color: TKitColors.textMuted,
        ),
        const HSpace.sm(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.autoSwitcherStatusUpdateStatus,
                style: TKitTextStyles.caption.copyWith(
                  color: TKitColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: TKitSpacing.headerGap),
              Row(
                children: [
                  UpdateStatusIndicator(status: indicator),
                  const HSpace.xs(),
                  Expanded(
                    child: Text(
                      statusText,
                      style: TKitTextStyles.bodyMedium.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (!lastSuccess && status?.errorMessage != null) ...[
                const VSpace.xs(),
                Text(
                  status!.errorMessage!,
                  style: TKitTextStyles.caption.copyWith(color: TKitColors.error),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrchestrationState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return IslandVariant.standard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(TKitSpacing.sm),
            decoration: BoxDecoration(
              color: _getOrchestrationStateColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: UpdateStatusIndicator(
              status: _getOrchestrationStatusIndicator(),
            ),
          ),
          const HSpace.md(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Activity',
                  style: TKitTextStyles.caption.copyWith(
                    color: TKitColors.textMuted,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: TKitSpacing.headerGap),
                Text(
                  _getOrchestrationStateText(context),
                  style: TKitTextStyles.labelLarge.copyWith(
                    color: _getOrchestrationStateColor(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  UpdateStatusType _getOrchestrationStatusIndicator() {
    if (status == null) return UpdateStatusType.idle;
    switch (status!.state) {
      case OrchestrationState.idle:
        return UpdateStatusType.idle;
      case OrchestrationState.error:
        return UpdateStatusType.error;
      case OrchestrationState.updatingCategory:
        return UpdateStatusType.updating;
      default:
        return UpdateStatusType.success;
    }
  }

  String _getOrchestrationStateText(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (status == null) return 'Not started';
    switch (status!.state) {
      case OrchestrationState.idle:
        return 'Ready';
      case OrchestrationState.detectingProcess:
        return 'Checking active app';
      case OrchestrationState.searchingMapping:
        return 'Finding category';
      case OrchestrationState.updatingCategory:
        return 'Updating category';
      case OrchestrationState.waitingDebounce:
        return 'Waiting for confirmation';
      case OrchestrationState.error:
        return 'Error occurred';
    }
  }

  Color _getOrchestrationStateColor() {
    if (status == null) return TKitColors.textMuted;
    switch (status!.state) {
      case OrchestrationState.idle:
        return TKitColors.textMuted;
      case OrchestrationState.error:
        return TKitColors.error;
      case OrchestrationState.updatingCategory:
        return TKitColors.accent;
      default:
        return TKitColors.textSecondary;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return DateFormat('MMM d, HH:mm').format(timestamp);
    }
  }
}
