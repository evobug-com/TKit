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
    return Island.comfortable(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header - minimal
          Text(l10n.autoSwitcherStatusHeader, style: TKitTextStyles.labelSmall.copyWith(
            letterSpacing: 1.2,
          )),
          const VSpace.sm(),

          // Current Process
          _buildStatusItem(
            context,
            label: l10n.autoSwitcherStatusCurrentProcess,
            value: status?.currentProcess ?? l10n.autoSwitcherStatusNone,
            valueColor: status?.currentProcess != null
                ? TKitColors.textPrimary
                : TKitColors.textMuted,
          ),

          const VSpace.sm(),

          // Matched Category
          _buildStatusItem(
            context,
            label: l10n.autoSwitcherStatusMatchedCategory,
            value: status?.matchedCategory ?? l10n.autoSwitcherStatusNone,
            valueColor: status?.matchedCategory != null
                ? TKitColors.textPrimary
                : TKitColors.textMuted,
          ),

          const VSpace.sm(),

          // Last Update Time
          _buildStatusItem(
            context,
            label: l10n.autoSwitcherStatusLastUpdate,
            value: status?.lastUpdateTime != null
                ? _formatTimestamp(status!.lastUpdateTime!)
                : l10n.autoSwitcherStatusNever,
            valueColor: TKitColors.textSecondary,
          ),

          const VSpace.sm(),

          // Update Status
          _buildUpdateStatus(context),

          const VSpace.sm(),

          // Orchestration State
          _buildOrchestrationState(context),
        ],
      ),
    );
  }

  Widget _buildStatusItem(
    BuildContext context, {
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TKitTextStyles.caption.copyWith(
            color: TKitColors.textMuted,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: TKitSpacing.headerGap),
        Text(
          value,
          style: TKitTextStyles.bodySmall.copyWith(
            color: valueColor ?? TKitColors.textPrimary,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildUpdateStatus(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bool? lastSuccess = status?.lastUpdateSuccess;
    if (lastSuccess == null) {
      return _buildStatusItem(
        context,
        label: l10n.autoSwitcherStatusUpdateStatus,
        value: l10n.autoSwitcherStatusNoUpdatesYet,
        valueColor: TKitColors.textMuted,
      );
    }

    final indicator = lastSuccess
        ? UpdateStatusType.success
        : UpdateStatusType.error;
    final statusText = lastSuccess ? l10n.autoSwitcherStatusSuccess : l10n.autoSwitcherStatusFailed;
    final statusColor = lastSuccess ? TKitColors.success : TKitColors.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.autoSwitcherStatusUpdateStatus,
          style: TKitTextStyles.caption.copyWith(
            color: TKitColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        const VSpace.xs(),
        Row(
          children: [
            UpdateStatusIndicator(status: indicator),
            const HSpace.sm(),
            Text(
              statusText,
              style: TKitTextStyles.body.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        if (!lastSuccess && status?.errorMessage != null) ...[
          const VSpace.xs(),
          Text(
            status!.errorMessage!,
            style: TKitTextStyles.caption.copyWith(color: TKitColors.error),
          ),
        ],
      ],
    );
  }

  Widget _buildOrchestrationState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return IslandVariant.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.autoSwitcherStatusSystemState,
            style: TKitTextStyles.caption.copyWith(
              color: TKitColors.textMuted,
              letterSpacing: 0.8,
            ),
          ),
          const VSpace.sm(),
          Row(
            children: [
              UpdateStatusIndicator(status: _getOrchestrationStatusIndicator()),
              const HSpace.sm(),
              Text(
                _getOrchestrationStateText(context),
                style: TKitTextStyles.bodySmall.copyWith(
                  color: _getOrchestrationStateColor(),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
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
    if (status == null) return l10n.autoSwitcherStatusNotInitialized;
    switch (status!.state) {
      case OrchestrationState.idle:
        return l10n.autoSwitcherStatusIdle;
      case OrchestrationState.detectingProcess:
        return l10n.autoSwitcherStatusDetectingProcess;
      case OrchestrationState.searchingMapping:
        return l10n.autoSwitcherStatusSearchingMapping;
      case OrchestrationState.updatingCategory:
        return l10n.autoSwitcherStatusUpdatingCategory;
      case OrchestrationState.waitingDebounce:
        return l10n.autoSwitcherStatusWaitingDebounce;
      case OrchestrationState.error:
        return l10n.autoSwitcherStatusError;
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
