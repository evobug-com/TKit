import 'package:tkit/features/category_mapping/domain/entities/category_mapping.dart';

/// In-memory cache for category mappings with TTL support
///
/// Provides fast lookup for recently accessed mappings to minimize
/// database queries during active gameplay sessions.
///
/// Features:
/// - Time-to-live (TTL) expiration
/// - LRU eviction when cache is full
/// - Cache hit/miss metrics
class MemoryCache {
  final int maxSize;
  final Duration defaultTtl;

  final Map<String, _CacheEntry> _cache = {};
  final Map<String, DateTime> _accessTimes = {};

  var _hitCount = 0;
  var _missCount = 0;

  MemoryCache({
    this.maxSize = 100,
    this.defaultTtl = const Duration(minutes: 30),
  });

  /// Get a mapping from cache by process name
  ///
  /// Returns null if not found or expired
  CategoryMapping? get(String processName) {
    final entry = _cache[processName];

    if (entry == null) {
      _missCount++;
      return null;
    }

    // Check if expired
    if (DateTime.now().isAfter(entry.expiresAt)) {
      _cache.remove(processName);
      _accessTimes.remove(processName);
      _missCount++;
      return null;
    }

    // Update access time for LRU
    _accessTimes[processName] = DateTime.now();
    _hitCount++;
    return entry.mapping;
  }

  /// Put a mapping into cache
  ///
  /// If cache is full, evicts least recently used entry
  void put(String processName, CategoryMapping mapping, {Duration? ttl}) {
    // Evict if cache is full
    if (_cache.length >= maxSize) {
      _evictLeastRecentlyUsed();
    }

    final expiresAt = DateTime.now().add(ttl ?? defaultTtl);
    _cache[processName] = _CacheEntry(mapping, expiresAt);
    _accessTimes[processName] = DateTime.now();
  }

  /// Remove a mapping from cache
  void remove(String processName) {
    _cache.remove(processName);
    _accessTimes.remove(processName);
  }

  /// Clear all cache entries
  void clear() {
    _cache.clear();
    _accessTimes.clear();
  }

  /// Clear expired entries
  void clearExpired() {
    final now = DateTime.now();
    final expiredKeys = _cache.entries
        .where((entry) => now.isAfter(entry.value.expiresAt))
        .map((entry) => entry.key)
        .toList();

    for (final key in expiredKeys) {
      _cache.remove(key);
      _accessTimes.remove(key);
    }
  }

  /// Evict least recently used entry
  void _evictLeastRecentlyUsed() {
    if (_accessTimes.isEmpty) {
      return;
    }

    // Find entry with oldest access time
    String? oldestKey;
    DateTime? oldestTime;

    for (final entry in _accessTimes.entries) {
      if (oldestTime == null || entry.value.isBefore(oldestTime)) {
        oldestKey = entry.key;
        oldestTime = entry.value;
      }
    }

    if (oldestKey != null) {
      _cache.remove(oldestKey);
      _accessTimes.remove(oldestKey);
    }
  }

  /// Get cache size
  int get size => _cache.length;

  /// Get cache hit rate (0.0 to 1.0)
  double get hitRate {
    final total = _hitCount + _missCount;
    if (total == 0) {
      return 0.0;
    }
    return _hitCount / total;
  }

  /// Get cache statistics
  CacheStats get stats => CacheStats(
        size: size,
        maxSize: maxSize,
        hitCount: _hitCount,
        missCount: _missCount,
        hitRate: hitRate,
      );

  /// Reset statistics
  void resetStats() {
    _hitCount = 0;
    _missCount = 0;
  }
}

/// Cache entry with expiration time
class _CacheEntry {
  final CategoryMapping mapping;
  final DateTime expiresAt;

  _CacheEntry(this.mapping, this.expiresAt);
}

/// Cache statistics
class CacheStats {
  final int size;
  final int maxSize;
  final int hitCount;
  final int missCount;
  final double hitRate;

  CacheStats({
    required this.size,
    required this.maxSize,
    required this.hitCount,
    required this.missCount,
    required this.hitRate,
  });

  @override
  String toString() {
    return 'CacheStats(size: $size/$maxSize, hits: $hitCount, misses: $missCount, hit rate: ${(hitRate * 100).toStringAsFixed(1)}%)';
  }
}
