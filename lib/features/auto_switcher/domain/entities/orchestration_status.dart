import 'package:equatable/equatable.dart';

/// Orchestration status for the Auto Switcher feature
/// Tracks the current state of the automated category switching process
enum OrchestrationState {
  /// System is idle, not monitoring
  idle,

  /// Currently detecting the focused process
  detectingProcess,

  /// Searching for a category mapping
  searchingMapping,

  /// Updating Twitch channel category
  updatingCategory,

  /// Waiting for debounce period to complete
  waitingDebounce,

  /// Error occurred during orchestration
  error,
}

/// Represents the current status of the auto-switcher orchestration
class OrchestrationStatus extends Equatable {
  /// Current state of the orchestration
  final OrchestrationState state;

  /// Current process being detected (if any)
  final String? currentProcess;

  /// Matched category name (if any)
  final String? matchedCategory;

  /// Category ID being updated to (if any)
  final String? categoryId;

  /// Timestamp of last update attempt
  final DateTime? lastUpdateTime;

  /// Success status of last update
  final bool? lastUpdateSuccess;

  /// Error message if state is error
  final String? errorMessage;

  /// Whether monitoring is currently active
  final bool isMonitoring;

  const OrchestrationStatus({
    required this.state,
    this.currentProcess,
    this.matchedCategory,
    this.categoryId,
    this.lastUpdateTime,
    this.lastUpdateSuccess,
    this.errorMessage,
    required this.isMonitoring,
  });

  /// Create an idle status
  factory OrchestrationStatus.idle() {
    return const OrchestrationStatus(
      state: OrchestrationState.idle,
      isMonitoring: false,
    );
  }

  /// Create a monitoring status
  factory OrchestrationStatus.monitoring() {
    return const OrchestrationStatus(
      state: OrchestrationState.detectingProcess,
      isMonitoring: true,
    );
  }

  /// Create an error status
  factory OrchestrationStatus.error(String message) {
    return OrchestrationStatus(
      state: OrchestrationState.error,
      errorMessage: message,
      isMonitoring: false,
    );
  }

  /// Create a copy with updated values
  OrchestrationStatus copyWith({
    OrchestrationState? state,
    String? currentProcess,
    String? matchedCategory,
    String? categoryId,
    DateTime? lastUpdateTime,
    bool? lastUpdateSuccess,
    String? errorMessage,
    bool? isMonitoring,
  }) {
    return OrchestrationStatus(
      state: state ?? this.state,
      currentProcess: currentProcess ?? this.currentProcess,
      matchedCategory: matchedCategory ?? this.matchedCategory,
      categoryId: categoryId ?? this.categoryId,
      lastUpdateTime: lastUpdateTime ?? this.lastUpdateTime,
      lastUpdateSuccess: lastUpdateSuccess ?? this.lastUpdateSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      isMonitoring: isMonitoring ?? this.isMonitoring,
    );
  }

  @override
  List<Object?> get props => [
    state,
    currentProcess,
    matchedCategory,
    categoryId,
    lastUpdateTime,
    lastUpdateSuccess,
    errorMessage,
    isMonitoring,
  ];

  @override
  String toString() {
    return 'OrchestrationStatus(state: $state, process: $currentProcess, '
        'category: $matchedCategory, monitoring: $isMonitoring)';
  }
}
