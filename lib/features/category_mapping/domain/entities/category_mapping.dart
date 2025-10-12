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
class CategoryMapping extends Equatable {
  final int? id;
  final String processName;
  final String? executablePath;
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

  const CategoryMapping({
    this.id,
    required this.processName,
    this.executablePath,
    required this.twitchCategoryId,
    required this.twitchCategoryName,
    required this.createdAt,
    this.lastUsedAt,
    required this.lastApiFetch,
    required this.cacheExpiresAt,
    required this.manualOverride,
    this.isEnabled = true,
  });

  CategoryMapping copyWith({
    int? id,
    String? processName,
    String? executablePath,
    String? twitchCategoryId,
    String? twitchCategoryName,
    DateTime? createdAt,
    DateTime? lastUsedAt,
    DateTime? lastApiFetch,
    DateTime? cacheExpiresAt,
    bool? manualOverride,
    bool? isEnabled,
  }) {
    return CategoryMapping(
      id: id ?? this.id,
      processName: processName ?? this.processName,
      executablePath: executablePath ?? this.executablePath,
      twitchCategoryId: twitchCategoryId ?? this.twitchCategoryId,
      twitchCategoryName: twitchCategoryName ?? this.twitchCategoryName,
      createdAt: createdAt ?? this.createdAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      lastApiFetch: lastApiFetch ?? this.lastApiFetch,
      cacheExpiresAt: cacheExpiresAt ?? this.cacheExpiresAt,
      manualOverride: manualOverride ?? this.manualOverride,
      isEnabled: isEnabled ?? this.isEnabled,
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
    twitchCategoryId,
    twitchCategoryName,
    createdAt,
    lastUsedAt,
    lastApiFetch,
    cacheExpiresAt,
    manualOverride,
    isEnabled,
  ];
}
