import 'package:equatable/equatable.dart';

/// Domain entity representing a Twitch OAuth token
/// Pure Dart class with no external dependencies
class TwitchToken extends Equatable {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;
  final List<String> scopes;

  const TwitchToken({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    required this.scopes,
  });

  /// Check if the token is expired
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Check if the token is about to expire (within 5 minutes)
  bool get isExpiringSoon {
    final fiveMinutesFromNow = DateTime.now().add(const Duration(minutes: 5));
    return fiveMinutesFromNow.isAfter(expiresAt);
  }

  /// Check if the token is valid (not expired)
  bool get isValid => !isExpired;

  @override
  List<Object?> get props => [accessToken, refreshToken, expiresAt, scopes];

  @override
  String toString() =>
      'TwitchToken(accessToken: ${accessToken.substring(0, 10)}..., '
      'expiresAt: $expiresAt, scopes: $scopes)';
}
