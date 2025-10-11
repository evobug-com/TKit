import 'package:equatable/equatable.dart';

/// Domain entity representing a community-sourced game mapping
///
/// These mappings are crowdsourced from TKit users and stored in
/// a GitHub repository for everyone to benefit from.
class CommunityMapping extends Equatable {
  final int? id;
  final String processName;
  final String twitchCategoryId;
  final String twitchCategoryName;
  final int verificationCount;
  final DateTime? lastVerified;
  final String source; // 'community', 'verified', etc.
  final DateTime syncedAt;

  const CommunityMapping({
    this.id,
    required this.processName,
    required this.twitchCategoryId,
    required this.twitchCategoryName,
    this.verificationCount = 1,
    this.lastVerified,
    this.source = 'community',
    required this.syncedAt,
  });

  /// Create from database entity
  factory CommunityMapping.fromDbEntity(dynamic entity) {
    return CommunityMapping(
      id: entity.id as int?,
      processName: entity.processName as String,
      twitchCategoryId: entity.twitchCategoryId as String,
      twitchCategoryName: entity.twitchCategoryName as String,
      verificationCount: entity.verificationCount as int? ?? 1,
      lastVerified: entity.lastVerified as DateTime?,
      source: entity.source as String? ?? 'community',
      syncedAt: entity.syncedAt as DateTime,
    );
  }

  /// Create from JSON (for GitHub sync)
  factory CommunityMapping.fromJson(Map<String, dynamic> json) {
    return CommunityMapping(
      processName: json['processName'] as String,
      twitchCategoryId: json['twitchCategoryId'] as String,
      twitchCategoryName: json['twitchCategoryName'] as String,
      verificationCount: json['verificationCount'] as int? ?? 1,
      lastVerified: json['lastVerified'] != null
          ? DateTime.parse(json['lastVerified'] as String)
          : null,
      source: json['source'] as String? ?? 'community',
      syncedAt: DateTime.now(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'processName': processName,
      'twitchCategoryId': twitchCategoryId,
      'twitchCategoryName': twitchCategoryName,
      'verificationCount': verificationCount,
      if (lastVerified != null)
        'lastVerified': lastVerified!.toIso8601String().split('T')[0],
      'source': source,
    };
  }

  @override
  List<Object?> get props => [
        id,
        processName,
        twitchCategoryId,
        twitchCategoryName,
        verificationCount,
        lastVerified,
        source,
        syncedAt,
      ];
}
