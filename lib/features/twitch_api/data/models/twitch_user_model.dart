import 'package:json_annotation/json_annotation.dart';
import 'package:tkit/features/twitch_api/domain/entities/twitch_user.dart';

part 'twitch_user_model.g.dart';

/// Data model for TwitchUser with JSON serialization
/// Extends the domain entity and adds serialization capabilities
@JsonSerializable()
class TwitchUserModel extends TwitchUser {
  @override
  @JsonKey(name: 'display_name')
  // ignore: overridden_fields
  final String displayName;

  @override
  @JsonKey(name: 'profile_image_url')
  // ignore: overridden_fields
  final String? profileImageUrl;

  @override
  @JsonKey(name: 'broadcaster_type')
  // ignore: overridden_fields
  final String? broadcasterType;

  const TwitchUserModel({
    required super.id,
    required super.login,
    required this.displayName,
    this.profileImageUrl,
    super.email,
    this.broadcasterType,
  }) : super(
         displayName: displayName,
         profileImageUrl: profileImageUrl,
         broadcasterType: broadcasterType,
       );

  /// Create model from domain entity
  factory TwitchUserModel.fromEntity(TwitchUser entity) {
    return TwitchUserModel(
      id: entity.id,
      login: entity.login,
      displayName: entity.displayName,
      profileImageUrl: entity.profileImageUrl,
      email: entity.email,
      broadcasterType: entity.broadcasterType,
    );
  }

  /// Create model from JSON
  factory TwitchUserModel.fromJson(Map<String, dynamic> json) =>
      _$TwitchUserModelFromJson(json);

  /// Convert model to JSON
  Map<String, dynamic> toJson() => _$TwitchUserModelToJson(this);

  /// Convert model to domain entity
  TwitchUser toEntity() {
    return TwitchUser(
      id: id,
      login: login,
      displayName: displayName,
      profileImageUrl: profileImageUrl,
      email: email,
      broadcasterType: broadcasterType,
    );
  }
}
