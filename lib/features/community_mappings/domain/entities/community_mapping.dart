import 'package:equatable/equatable.dart';

/// Domain entity representing a community-sourced game mapping
///
/// These mappings are crowdsourced from TKit users and stored in
/// a GitHub repository for everyone to benefit from.
///
/// Privacy-Preserving Path Tracking:
/// - normalizedInstallPaths: List of common installation paths from the community
///   (e.g., ["steamapps/common/dota 2", "epic games/dota 2"])
class CommunityMapping extends Equatable {
  final int? id;
  final String processName;

  /// List of normalized, privacy-safe installation paths from community reports
  final List<String> normalizedInstallPaths;

  final String twitchCategoryId;
  final String twitchCategoryName;
  final int verificationCount;
  final DateTime? lastVerified;
  final String source; // 'community', 'verified', etc.
  final DateTime syncedAt;

  const CommunityMapping({
    this.id,
    required this.processName,
    this.normalizedInstallPaths = const [],
    required this.twitchCategoryId,
    required this.twitchCategoryName,
    this.verificationCount = 1,
    this.lastVerified,
    this.source = 'community',
    required this.syncedAt,
  });

  /// Create from database entity
  factory CommunityMapping.fromDbEntity(dynamic entity) {
    // Parse normalizedInstallPaths from database (stored as JSON string)
    List<String> paths = [];
    if (entity.normalizedInstallPaths != null &&
        entity.normalizedInstallPaths is String) {
      try {
        final decoded = (entity.normalizedInstallPaths as String);
        // Simple parse of JSON array string
        if (decoded.isNotEmpty) {
          // Remove brackets and quotes, split by comma
          paths = decoded
              .replaceAll('[', '')
              .replaceAll(']', '')
              .replaceAll('"', '')
              .split(',')
              .where((s) => s.trim().isNotEmpty)
              .map((s) => s.trim())
              .toList();
        }
      } catch (e) {
        paths = [];
      }
    }

    return CommunityMapping(
      id: entity.id as int?,
      processName: entity.processName as String,
      normalizedInstallPaths: paths,
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
    // Parse normalizedInstallPaths from JSON
    List<String> paths = [];
    if (json['normalizedInstallPaths'] != null) {
      if (json['normalizedInstallPaths'] is List) {
        paths = (json['normalizedInstallPaths'] as List)
            .map((e) => e.toString())
            .toList();
      }
    }

    return CommunityMapping(
      processName: json['processName'] as String,
      normalizedInstallPaths: paths,
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
      if (normalizedInstallPaths.isNotEmpty)
        'normalizedInstallPaths': normalizedInstallPaths,
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
        normalizedInstallPaths,
        twitchCategoryId,
        twitchCategoryName,
        verificationCount,
        lastVerified,
        source,
        syncedAt,
      ];
}
