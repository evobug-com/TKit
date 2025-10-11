import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/twitch_category.dart';

part 'twitch_category_model.g.dart';

/// Data model for TwitchCategory with JSON serialization
/// Extends the domain entity and adds serialization capabilities
@JsonSerializable()
class TwitchCategoryModel extends TwitchCategory {
  @override
  @JsonKey(name: 'box_art_url')
  final String? boxArtUrl;

  const TwitchCategoryModel({
    required super.id,
    required super.name,
    this.boxArtUrl,
  }) : super(boxArtUrl: boxArtUrl);

  /// Create model from domain entity
  factory TwitchCategoryModel.fromEntity(TwitchCategory entity) {
    return TwitchCategoryModel(
      id: entity.id,
      name: entity.name,
      boxArtUrl: entity.boxArtUrl,
    );
  }

  /// Create model from JSON
  factory TwitchCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$TwitchCategoryModelFromJson(json);

  /// Convert model to JSON
  Map<String, dynamic> toJson() => _$TwitchCategoryModelToJson(this);

  /// Convert model to domain entity
  TwitchCategory toEntity() {
    return TwitchCategory(id: id, name: name, boxArtUrl: boxArtUrl);
  }
}
