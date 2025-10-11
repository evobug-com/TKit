import 'package:equatable/equatable.dart';
import '../../domain/entities/process_info.dart';

/// Base class for ProcessDetection states
sealed class ProcessDetectionState extends Equatable {
  const ProcessDetectionState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any detection
final class ProcessDetectionInitial extends ProcessDetectionState {
  const ProcessDetectionInitial();
}

/// State when actively monitoring for process changes
final class ProcessDetectionRunning extends ProcessDetectionState {
  final Duration scanInterval;

  const ProcessDetectionRunning(this.scanInterval);

  @override
  List<Object?> get props => [scanInterval];
}

/// State when monitoring is stopped
final class ProcessDetectionStopped extends ProcessDetectionState {
  const ProcessDetectionStopped();
}

/// State when a process has been detected
final class ProcessDetected extends ProcessDetectionState {
  final ProcessInfo? processInfo;
  final DateTime detectedAt;

  const ProcessDetected(this.processInfo, this.detectedAt);

  @override
  List<Object?> get props => [processInfo, detectedAt];
}

/// State when an error occurs during detection
final class ProcessDetectionError extends ProcessDetectionState {
  final String message;

  const ProcessDetectionError(this.message);

  @override
  List<Object?> get props => [message];
}
