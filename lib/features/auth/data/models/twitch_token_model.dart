import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/twitch_token.dart';

part 'twitch_token_model.g.dart';

/// Data model for TwitchToken with JSON serialization
/// Extends the domain entity and adds serialization capabilities
@JsonSerializable()
class TwitchTokenModel extends TwitchToken {
  const TwitchTokenModel({
    required super.accessToken,
    required super.refreshToken,
    required super.expiresAt,
    required super.scopes,
  });

  /// Create model from domain entity
  factory TwitchTokenModel.fromEntity(TwitchToken token) {
    return TwitchTokenModel(
      accessToken: token.accessToken,
      refreshToken: token.refreshToken,
      expiresAt: token.expiresAt,
      scopes: token.scopes,
    );
  }

  /// Create model from JSON map
  factory TwitchTokenModel.fromJson(Map<String, dynamic> json) =>
      _$TwitchTokenModelFromJson(json);

  /// Create model from OAuth token response
  /// Twitch returns expires_in (seconds), we convert to expiresAt (DateTime)
  factory TwitchTokenModel.fromTokenResponse(Map<String, dynamic> json) {
    final expiresIn = json['expires_in'] as int;
    final expiresAt = DateTime.now().add(Duration(seconds: expiresIn));

    // Handle scope - can be String (space-separated) or List
    final scopeField = json['scope'];
    final List<String> scopes;
    if (scopeField is String) {
      // Implicit flow returns space-separated string
      scopes = scopeField.isNotEmpty ? scopeField.split(' ') : [];
    } else if (scopeField is List) {
      // Device code flow returns list of strings
      scopes = scopeField.cast<String>();
    } else {
      scopes = [];
    }

    return TwitchTokenModel(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      expiresAt: expiresAt,
      scopes: scopes,
    );
  }

  /// Convert model to JSON map
  Map<String, dynamic> toJson() => _$TwitchTokenModelToJson(this);

  /// Convert to domain entity
  TwitchToken toEntity() {
    return TwitchToken(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: expiresAt,
      scopes: scopes,
    );
  }

  /// Create a copy with updated fields
  TwitchTokenModel copyWith({
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
    List<String>? scopes,
  }) {
    return TwitchTokenModel(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
      scopes: scopes ?? this.scopes,
    );
  }
}
