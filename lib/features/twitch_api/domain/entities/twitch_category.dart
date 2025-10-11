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
    return boxArtUrl!
        .replaceAll('{width}', width.toString())
        .replaceAll('{height}', height.toString());
  }
}
