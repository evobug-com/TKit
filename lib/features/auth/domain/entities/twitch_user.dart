import 'package:equatable/equatable.dart';

/// Domain entity representing a Twitch user
/// Pure Dart class with no external dependencies
class TwitchUser extends Equatable {
  final String id;
  final String login;
  final String displayName;
  final String? profileImageUrl;
  final String? email;

  const TwitchUser({
    required this.id,
    required this.login,
    required this.displayName,
    this.profileImageUrl,
    this.email,
  });

  @override
  List<Object?> get props => [id, login, displayName, profileImageUrl, email];

  @override
  String toString() =>
      'TwitchUser(id: $id, login: $login, displayName: $displayName)';
}
