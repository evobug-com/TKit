import 'package:equatable/equatable.dart';
import 'package:tkit/features/auto_switcher/domain/entities/orchestration_status.dart';
import 'package:tkit/features/auto_switcher/domain/entities/update_history.dart';

/// Base class for all Auto Switcher states
sealed class AutoSwitcherState extends Equatable {
  const AutoSwitcherState();

  @override
  List<Object?> get props => [];
}

/// Initial state
final class AutoSwitcherInitial extends AutoSwitcherState {
  const AutoSwitcherInitial();
}

/// Monitoring is active and running
final class MonitoringActive extends AutoSwitcherState {
  final OrchestrationStatus status;

  const MonitoringActive(this.status);

  @override
  List<Object?> get props => [status];
}

/// Monitoring is inactive/stopped
final class MonitoringInactive extends AutoSwitcherState {
  final OrchestrationStatus status;

  const MonitoringInactive(this.status);

  @override
  List<Object?> get props => [status];
}

/// Currently performing an update
final class Updating extends AutoSwitcherState {
  final OrchestrationStatus status;

  const Updating(this.status);

  @override
  List<Object?> get props => [status];
}

/// Update completed successfully
final class UpdateSuccess extends AutoSwitcherState {
  final OrchestrationStatus status;
  final String? message;

  const UpdateSuccess(this.status, {this.message});

  @override
  List<Object?> get props => [status, message];
}

/// Update failed with error
final class UpdateError extends AutoSwitcherState {
  final OrchestrationStatus status;
  final String errorMessage;

  const UpdateError(this.status, this.errorMessage);

  @override
  List<Object?> get props => [status, errorMessage];
}

/// History loaded
final class HistoryLoaded extends AutoSwitcherState {
  final OrchestrationStatus status;
  final List<UpdateHistory> history;

  const HistoryLoaded(this.status, this.history);

  @override
  List<Object?> get props => [status, history];
}

/// Loading state
final class AutoSwitcherLoading extends AutoSwitcherState {
  final OrchestrationStatus status;

  const AutoSwitcherLoading(this.status);

  @override
  List<Object?> get props => [status];
}
