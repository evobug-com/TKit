import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tkit/l10n/app_localizations.dart';
import '../../../../shared/theme/colors.dart';
import '../../../../shared/theme/text_styles.dart';
import '../../domain/entities/orchestration_status.dart';
import 'update_status_indicator.dart';

/// Status dashboard widget for Auto Switcher
/// Displays current process, matched category, last update time, and status
class StatusDashboard extends StatelessWidget {
  final OrchestrationStatus? status;

  const StatusDashboard({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.borderSubtle, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header - minimal
          Text(l10n.autoSwitcherStatusHeader, style: AppTextStyles.heading3.copyWith(
            letterSpacing: 1.2,
            fontSize: 11,
          )),
          const SizedBox(height: 12),

          // Current Process
          _buildStatusItem(
            context,
            label: l10n.autoSwitcherStatusCurrentProcess,
            value: status?.currentProcess ?? l10n.autoSwitcherStatusNone,
            valueColor: status?.currentProcess != null
                ? AppColors.textPrimary
                : AppColors.textMuted,
          ),

          const SizedBox(height: 12),

          // Matched Category
          _buildStatusItem(
            context,
            label: l10n.autoSwitcherStatusMatchedCategory,
            value: status?.matchedCategory ?? l10n.autoSwitcherStatusNone,
            valueColor: status?.matchedCategory != null
                ? AppColors.textPrimary
                : AppColors.textMuted,
          ),

          const SizedBox(height: 12),

          // Last Update Time
          _buildStatusItem(
            context,
            label: l10n.autoSwitcherStatusLastUpdate,
            value: status?.lastUpdateTime != null
                ? _formatTimestamp(status!.lastUpdateTime!)
                : l10n.autoSwitcherStatusNever,
            valueColor: AppColors.textSecondary,
          ),

          const SizedBox(height: 12),

          // Update Status
          _buildUpdateStatus(context),

          const SizedBox(height: 16),

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
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textMuted,
            letterSpacing: 0.8,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: AppTextStyles.bodySmall.copyWith(
            color: valueColor ?? AppColors.textPrimary,
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
        valueColor: AppColors.textMuted,
      );
    }

    final indicator = lastSuccess
        ? UpdateStatusType.success
        : UpdateStatusType.error;
    final statusText = lastSuccess ? l10n.autoSwitcherStatusSuccess : l10n.autoSwitcherStatusFailed;
    final statusColor = lastSuccess ? AppColors.success : AppColors.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.autoSwitcherStatusUpdateStatus,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            UpdateStatusIndicator(status: indicator),
            const SizedBox(width: 8),
            Text(
              statusText,
              style: AppTextStyles.body.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        if (!lastSuccess && status?.errorMessage != null) ...[
          const SizedBox(height: 4),
          Text(
            status!.errorMessage!,
            style: AppTextStyles.caption.copyWith(color: AppColors.error),
          ),
        ],
      ],
    );
  }

  Widget _buildOrchestrationState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        border: Border.all(color: AppColors.borderSubtle, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.autoSwitcherStatusSystemState,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textMuted,
              letterSpacing: 0.8,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              UpdateStatusIndicator(status: _getOrchestrationStatusIndicator()),
              const SizedBox(width: 6),
              Text(
                _getOrchestrationStateText(context),
                style: AppTextStyles.bodySmall.copyWith(
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
    if (status == null) return AppColors.textMuted;
    switch (status!.state) {
      case OrchestrationState.idle:
        return AppColors.textMuted;
      case OrchestrationState.error:
        return AppColors.error;
      case OrchestrationState.updatingCategory:
        return AppColors.accent;
      default:
        return AppColors.textSecondary;
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
