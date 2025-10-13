import 'package:json_annotation/json_annotation.dart';
import 'package:tkit/features/auth/domain/entities/twitch_user.dart';

part 'twitch_user_model.g.dart';

/// Data model for TwitchUser with JSON serialization
/// Extends the domain entity and adds serialization capabilities
@JsonSerializable()
class TwitchUserModel extends TwitchUser {
  const TwitchUserModel({
    required super.id,
    required super.login,
    required super.displayName,
    super.profileImageUrl,
    super.email,
  });

  /// Create model from domain entity
  factory TwitchUserModel.fromEntity(TwitchUser user) {
    return TwitchUserModel(
      id: user.id,
      login: user.login,
      displayName: user.displayName,
      profileImageUrl: user.profileImageUrl,
      email: user.email,
    );
  }

  /// Create model from JSON map
  factory TwitchUserModel.fromJson(Map<String, dynamic> json) =>
      _$TwitchUserModelFromJson(json);

  /// Create model from Twitch API user response
  /// Handles Twitch Helix API response format
  factory TwitchUserModel.fromApiResponse(Map<String, dynamic> json) {
    return TwitchUserModel(
      id: json['id'] as String,
      login: json['login'] as String,
      displayName: json['display_name'] as String,
      profileImageUrl: json['profile_image_url'] as String?,
      email: json['email'] as String?,
    );
  }

  /// Convert model to JSON map
  Map<String, dynamic> toJson() => _$TwitchUserModelToJson(this);

  /// Convert to domain entity
  TwitchUser toEntity() {
    return TwitchUser(
      id: id,
      login: login,
      displayName: displayName,
      profileImageUrl: profileImageUrl,
      email: email,
    );
  }

  /// Create a copy with updated fields
  TwitchUserModel copyWith({
    String? id,
    String? login,
    String? displayName,
    String? profileImageUrl,
    String? email,
  }) {
    return TwitchUserModel(
      id: id ?? this.id,
      login: login ?? this.login,
      displayName: displayName ?? this.displayName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      email: email ?? this.email,
    );
  }
}
