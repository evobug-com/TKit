import 'package:equatable/equatable.dart';

/// Domain entity representing an unknown process
///
/// Tracks processes that don't have category mappings yet.
/// This helps identify gaps in the mapping database and allows
/// users to contribute mappings for community benefit.
class UnknownProcess extends Equatable {
  final int? id;
  final String executableName;
  final String? windowTitle;
  final DateTime firstDetected;
  final int occurrenceCount;
  final bool resolved;

  const UnknownProcess({
    this.id,
    required this.executableName,
    this.windowTitle,
    required this.firstDetected,
    required this.occurrenceCount,
    required this.resolved,
  });

  UnknownProcess copyWith({
    int? id,
    String? executableName,
    String? windowTitle,
    DateTime? firstDetected,
    int? occurrenceCount,
    bool? resolved,
  }) {
    return UnknownProcess(
      id: id ?? this.id,
      executableName: executableName ?? this.executableName,
      windowTitle: windowTitle ?? this.windowTitle,
      firstDetected: firstDetected ?? this.firstDetected,
      occurrenceCount: occurrenceCount ?? this.occurrenceCount,
      resolved: resolved ?? this.resolved,
    );
  }

  @override
  List<Object?> get props => [
    id,
    executableName,
    windowTitle,
    firstDetected,
    occurrenceCount,
    resolved,
  ];
}
