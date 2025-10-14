import 'package:equatable/equatable.dart';

/// Domain entity representing a process-to-category mapping
///
/// This entity maps executable processes (games/applications) to Twitch categories
/// for automatic stream category switching.
///
/// Cache Policy (Twitch Developer Agreement Compliance):
/// - All Twitch-sourced data must be refreshed within 24 hours
/// - `lastApiFetch`: Timestamp of when category data was fetched from Twitch API
/// - `cacheExpiresAt`: Timestamp when this mapping must be refreshed (lastApiFetch + 24h)
/// - `manualOverride`: User-created mappings that never expire (but Twitch data still refreshes)
///
/// Privacy-Preserving Path Tracking:
/// - `normalizedInstallPaths`: List of privacy-safe installation path segments
///   (e.g., ["steamapps/common/dota 2", "epic games/dota 2"])
/// - Only stores game-identifying path segments, never usernames or personal folders
/// - Supports multiple paths for games installed on different platforms
class CategoryMapping extends Equatable {
  final int? id;
  final String processName;

  /// @deprecated Use normalizedInstallPaths instead. Kept for backward compatibility.
  final String? executablePath;

  /// List of normalized, privacy-safe installation path segments.
  /// Multiple paths support the same game on different platforms (Steam, Epic, etc.)
  /// Example: ["steamapps/common/dota 2", "epic games/dota 2"]
  final List<String> normalizedInstallPaths;

  final String twitchCategoryId;
  final String twitchCategoryName;
  final DateTime createdAt;
  final DateTime? lastUsedAt;

  /// When was the Twitch category data last fetched from the API
  final DateTime lastApiFetch;

  /// When does this cache entry expire (must be ≤ 24h from lastApiFetch)
  final DateTime cacheExpiresAt;

  /// True if this mapping was manually created/corrected by the user
  /// Manual overrides persist indefinitely, but their Twitch data still refreshes
  final bool manualOverride;

  /// True if this mapping is enabled and should be used for auto-switching
  /// False if the mapping is disabled/ignored by the user
  final bool isEnabled;

  /// The ID of the mapping list this mapping belongs to
  /// Nullable for backward compatibility with legacy mappings
  final String? listId;

  /// The name of the list this mapping belongs to (for display purposes)
  /// This is populated when loading mappings with list information
  final String? sourceListName;

  /// Whether the source list is read-only
  /// If true, this mapping cannot be edited or deleted
  final bool sourceListIsReadOnly;

  const CategoryMapping({
    this.id,
    required this.processName,
    this.executablePath,
    this.normalizedInstallPaths = const [],
    required this.twitchCategoryId,
    required this.twitchCategoryName,
    required this.createdAt,
    this.lastUsedAt,
    required this.lastApiFetch,
    required this.cacheExpiresAt,
    required this.manualOverride,
    this.isEnabled = true,
    this.listId,
    this.sourceListName,
    this.sourceListIsReadOnly = false,
  });

  CategoryMapping copyWith({
    int? id,
    String? processName,
    String? executablePath,
    List<String>? normalizedInstallPaths,
    String? twitchCategoryId,
    String? twitchCategoryName,
    DateTime? createdAt,
    DateTime? lastUsedAt,
    DateTime? lastApiFetch,
    DateTime? cacheExpiresAt,
    bool? manualOverride,
    bool? isEnabled,
    String? listId,
    String? sourceListName,
    bool? sourceListIsReadOnly,
  }) {
    return CategoryMapping(
      id: id ?? this.id,
      processName: processName ?? this.processName,
      executablePath: executablePath ?? this.executablePath,
      normalizedInstallPaths: normalizedInstallPaths ?? this.normalizedInstallPaths,
      twitchCategoryId: twitchCategoryId ?? this.twitchCategoryId,
      twitchCategoryName: twitchCategoryName ?? this.twitchCategoryName,
      createdAt: createdAt ?? this.createdAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      lastApiFetch: lastApiFetch ?? this.lastApiFetch,
      cacheExpiresAt: cacheExpiresAt ?? this.cacheExpiresAt,
      manualOverride: manualOverride ?? this.manualOverride,
      isEnabled: isEnabled ?? this.isEnabled,
      listId: listId ?? this.listId,
      sourceListName: sourceListName ?? this.sourceListName,
      sourceListIsReadOnly: sourceListIsReadOnly ?? this.sourceListIsReadOnly,
    );
  }

  /// Check if this cache entry has expired
  bool get isCacheExpired => DateTime.now().isAfter(cacheExpiresAt);

  /// Check if this cache entry is expiring soon (within threshold)
  bool isExpiringSoon(Duration threshold) {
    return DateTime.now().add(threshold).isAfter(cacheExpiresAt);
  }

  @override
  List<Object?> get props => [
    id,
    processName,
    executablePath,
    normalizedInstallPaths,
    twitchCategoryId,
    twitchCategoryName,
    createdAt,
    lastUsedAt,
    lastApiFetch,
    cacheExpiresAt,
    manualOverride,
    isEnabled,
    listId,
    sourceListName,
    sourceListIsReadOnly,
  ];
}
