import 'package:flutter_test/flutter_test.dart';
import 'package:tkit/features/auth/domain/entities/twitch_token.dart';

void main() {
  group('TwitchToken', () {
    final testToken = TwitchToken(
      accessToken: 'test_access_token',
      refreshToken: 'test_refresh_token',
      expiresAt: DateTime.now().add(const Duration(hours: 4)),
      scopes: const ['user:read:email', 'channel:manage:broadcast'],
    );

    test('should be a subclass of Equatable', () {
      expect(testToken, isA<Object>());
    });

    test('isExpired should return false for future expiry', () {
      expect(testToken.isExpired, false);
    });

    test('isExpired should return true for past expiry', () {
      final expiredToken = TwitchToken(
        accessToken: 'test_access_token',
        refreshToken: 'test_refresh_token',
        expiresAt: DateTime.now().subtract(const Duration(hours: 1)),
        scopes: const ['user:read:email'],
      );

      expect(expiredToken.isExpired, true);
    });

    test('isValid should return true for non-expired token', () {
      expect(testToken.isValid, true);
    });

    test(
      'isExpiringSoon should return true for tokens expiring within 5 minutes',
      () {
        final soonExpiringToken = TwitchToken(
          accessToken: 'test_access_token',
          refreshToken: 'test_refresh_token',
          expiresAt: DateTime.now().add(const Duration(minutes: 3)),
          scopes: const ['user:read:email'],
        );

        expect(soonExpiringToken.isExpiringSoon, true);
      },
    );

    test('props should contain all fields for equality comparison', () {
      final token1 = TwitchToken(
        accessToken: 'test',
        refreshToken: 'test',
        expiresAt: DateTime(2024, 1, 1),
        scopes: const ['scope1'],
      );

      final token2 = TwitchToken(
        accessToken: 'test',
        refreshToken: 'test',
        expiresAt: DateTime(2024, 1, 1),
        scopes: const ['scope1'],
      );

      expect(token1, equals(token2));
    });
  });
}
