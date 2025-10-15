import 'package:equatable/equatable.dart';

/// Domain entity representing a Twitch category (game/stream category)
/// This is a pure Dart class with no external dependencies
class TwitchCategory extends Equatable {
  /// Unique identifier for the category
  final String id;

  /// Display name of the category
  final String name;

  /// URL to the category's box art image
  /// Formatted as template: {width}x{height} placeholders
  final String? boxArtUrl;

  const TwitchCategory({required this.id, required this.name, this.boxArtUrl});

  @override
  List<Object?> get props => [id, name, boxArtUrl];

  @override
  String toString() => 'TwitchCategory(id: $id, name: $name)';

  /// Get formatted box art URL with specific dimensions
  String? getBoxArtUrl({int width = 285, int height = 380}) {
    if (boxArtUrl == null) return null;

    // Handle both template format and hardcoded dimensions
    String url = boxArtUrl!;

    // If URL has {width}x{height} placeholders, replace them
    if (url.contains('{width}') && url.contains('{height}')) {
      return url
          .replaceAll('{width}', width.toString())
          .replaceAll('{height}', height.toString());
    }

    // Otherwise, strip existing dimensions (e.g., "52x72.jpg") and replace with desired size
    // Pattern: anything ending in "{digits}x{digits}.jpg"
    final regex = RegExp(r'-\d+x\d+\.jpg$');
    if (regex.hasMatch(url)) {
      return url.replaceAll(regex, '-${width}x$height.jpg');
    }

    // Fallback: return original URL if format is unknown
    return url;
  }
}
