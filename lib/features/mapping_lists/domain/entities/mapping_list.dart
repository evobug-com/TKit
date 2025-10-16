import 'package:equatable/equatable.dart';

/// Represents a collection of category mappings.
/// Lists can be Local (user-created), Official (verified by TKit), or Remote (third-party).
class MappingList extends Equatable {
  final String id;
  final String name;
  final String description;
  final MappingListSourceType sourceType;
  final String? sourceUrl;
  final String? submissionHookUrl; // URL for submitting unknown processes
  final bool isEnabled;
  final bool isReadOnly;
  final int mappingCount;
  final DateTime? lastSyncedAt;
  final String? lastSyncError; // Error message from last sync attempt
  final DateTime createdAt;
  final int priority; // Lower number = higher priority in conflict resolution

  const MappingList({
    required this.id,
    required this.name,
    required this.description,
    required this.sourceType,
    this.sourceUrl,
    this.submissionHookUrl,
    required this.isEnabled,
    required this.isReadOnly,
    required this.mappingCount,
    this.lastSyncedAt,
    this.lastSyncError,
    required this.createdAt,
    required this.priority,
  });

  /// Returns true if this list should be synced (has remote source)
  bool get shouldSync => sourceUrl != null && sourceType != MappingListSourceType.local;

  /// Returns true if sync is needed (6 hours passed since last sync)
  bool get needsSync {
    if (!shouldSync) {
      return false;
    }
    if (lastSyncedAt == null) {
      return true;
    }

    final now = DateTime.now();
    final hoursSinceSync = now.difference(lastSyncedAt!).inHours;
    return hoursSinceSync >= 6;
  }

  /// Returns a display-friendly source type string
  String get sourceTypeDisplay {
    switch (sourceType) {
      case MappingListSourceType.local:
        return 'Local';
      case MappingListSourceType.official:
        return 'Official';
      case MappingListSourceType.remote:
        return 'Remote';
    }
  }

  /// Returns a badge color based on source type
  String get sourceTypeBadgeColor {
    switch (sourceType) {
      case MappingListSourceType.local:
        return '#6B6B6B'; // Neutral gray
      case MappingListSourceType.official:
        return '#00AA55'; // Success green
      case MappingListSourceType.remote:
        return '#6B9BD1'; // Info blue
    }
  }

  MappingList copyWith({
    String? id,
    String? name,
    String? description,
    MappingListSourceType? sourceType,
    String? sourceUrl,
    String? submissionHookUrl,
    bool? isEnabled,
    bool? isReadOnly,
    int? mappingCount,
    DateTime? lastSyncedAt,
    String? lastSyncError,
    DateTime? createdAt,
    int? priority,
  }) {
    return MappingList(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      sourceType: sourceType ?? this.sourceType,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      submissionHookUrl: submissionHookUrl ?? this.submissionHookUrl,
      isEnabled: isEnabled ?? this.isEnabled,
      isReadOnly: isReadOnly ?? this.isReadOnly,
      mappingCount: mappingCount ?? this.mappingCount,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      lastSyncError: lastSyncError ?? this.lastSyncError,
      createdAt: createdAt ?? this.createdAt,
      priority: priority ?? this.priority,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        sourceType,
        sourceUrl,
        submissionHookUrl,
        isEnabled,
        isReadOnly,
        mappingCount,
        lastSyncedAt,
        lastSyncError,
        createdAt,
        priority,
      ];
}

enum MappingListSourceType {
  local,    // User-created, not synced
  official, // Official TKit lists from GitHub
  remote,   // Third-party lists from custom URLs
}
