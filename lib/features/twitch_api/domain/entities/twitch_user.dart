import 'package:equatable/equatable.dart';

/// Domain entity representing a Twitch user
/// This is shared between Auth and Twitch API modules
class TwitchUser extends Equatable {
  /// Twitch user ID
  final String id;

  /// Login name (username)
  final String login;

  /// Display name (can contain special characters/capitalization)
  final String displayName;

  /// URL to profile image
  final String? profileImageUrl;

  /// Email address (requires user:read:email scope)
  final String? email;

  /// Broadcaster type (partner, affiliate, or empty string)
  final String? broadcasterType;

  const TwitchUser({
    required this.id,
    required this.login,
    required this.displayName,
    this.profileImageUrl,
    this.email,
    this.broadcasterType,
  });

  @override
  List<Object?> get props => [
    id,
    login,
    displayName,
    profileImageUrl,
    email,
    broadcasterType,
  ];

  @override
  String toString() =>
      'TwitchUser(id: $id, login: $login, displayName: $displayName)';
}
