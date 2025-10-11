import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:tkit/features/auth/data/models/twitch_token_model.dart';
import 'package:tkit/features/auth/domain/entities/twitch_token.dart';

void main() {
  group('TwitchTokenModel', () {
    final tTokenModel = TwitchTokenModel(
      accessToken: 'test_access_token',
      refreshToken: 'test_refresh_token',
      expiresAt: DateTime.parse('2025-12-31T23:59:59.000Z'),
      scopes: ['channel:manage:broadcast', 'user:read:email'],
    );

    test('should be a subclass of TwitchToken entity', () {
      expect(tTokenModel, isA<TwitchToken>());
    });

    group('fromJson', () {
      test('should return a valid model from JSON', () {
        // Arrange
        final json = {
          'accessToken': 'test_access_token',
          'refreshToken': 'test_refresh_token',
          'expiresAt': '2025-12-31T23:59:59.000Z',
          'scopes': ['channel:manage:broadcast', 'user:read:email'],
        };

        // Act
        final result = TwitchTokenModel.fromJson(json);

        // Assert
        expect(result.accessToken, 'test_access_token');
        expect(result.refreshToken, 'test_refresh_token');
        expect(result.expiresAt, DateTime.parse('2025-12-31T23:59:59.000Z'));
        expect(result.scopes, ['channel:manage:broadcast', 'user:read:email']);
      });
    });

    group('fromTokenResponse', () {
      test('should return a valid model from OAuth token response', () {
        // Arrange
        final json = {
          'access_token': 'oauth_access_token',
          'refresh_token': 'oauth_refresh_token',
          'expires_in': 14400, // 4 hours in seconds
          'scope': 'channel:manage:broadcast user:read:email',
        };

        // Act
        final result = TwitchTokenModel.fromTokenResponse(json);

        // Assert
        expect(result.accessToken, 'oauth_access_token');
        expect(result.refreshToken, 'oauth_refresh_token');
        expect(result.scopes, ['channel:manage:broadcast', 'user:read:email']);
        expect(result.expiresAt.isAfter(DateTime.now()), true);
      });

      test('should handle empty scopes string', () {
        // Arrange
        final json = {
          'access_token': 'oauth_access_token',
          'refresh_token': 'oauth_refresh_token',
          'expires_in': 14400,
          'scope': '',
        };

        // Act
        final result = TwitchTokenModel.fromTokenResponse(json);

        // Assert
        expect(result.scopes, ['']);
      });

      test('should handle null scopes', () {
        // Arrange
        final json = {
          'access_token': 'oauth_access_token',
          'refresh_token': 'oauth_refresh_token',
          'expires_in': 14400,
        };

        // Act
        final result = TwitchTokenModel.fromTokenResponse(json);

        // Assert
        expect(result.scopes, []);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () {
        // Act
        final result = tTokenModel.toJson();

        // Assert
        expect(result, {
          'accessToken': 'test_access_token',
          'refreshToken': 'test_refresh_token',
          'expiresAt': '2025-12-31T23:59:59.000Z',
          'scopes': ['channel:manage:broadcast', 'user:read:email'],
        });
      });
    });

    group('toEntity', () {
      test('should return a TwitchToken entity with the same properties', () {
        // Act
        final result = tTokenModel.toEntity();

        // Assert
        expect(result, isA<TwitchToken>());
        expect(result.accessToken, tTokenModel.accessToken);
        expect(result.refreshToken, tTokenModel.refreshToken);
        expect(result.expiresAt, tTokenModel.expiresAt);
        expect(result.scopes, tTokenModel.scopes);
      });
    });

    group('fromEntity', () {
      test('should create a model from an entity', () {
        // Arrange
        final entity = TwitchToken(
          accessToken: 'entity_access_token',
          refreshToken: 'entity_refresh_token',
          expiresAt: DateTime.parse('2025-12-31T23:59:59.000Z'),
          scopes: ['channel:manage:broadcast'],
        );

        // Act
        final result = TwitchTokenModel.fromEntity(entity);

        // Assert
        expect(result, isA<TwitchTokenModel>());
        expect(result.accessToken, entity.accessToken);
        expect(result.refreshToken, entity.refreshToken);
        expect(result.expiresAt, entity.expiresAt);
        expect(result.scopes, entity.scopes);
      });
    });

    group('copyWith', () {
      test('should return a copy with updated accessToken', () {
        // Act
        final result = tTokenModel.copyWith(accessToken: 'new_access_token');

        // Assert
        expect(result.accessToken, 'new_access_token');
        expect(result.refreshToken, tTokenModel.refreshToken);
        expect(result.expiresAt, tTokenModel.expiresAt);
        expect(result.scopes, tTokenModel.scopes);
      });

      test('should return a copy with updated expiresAt', () {
        // Arrange
        final newExpiresAt = DateTime.parse('2026-01-01T00:00:00.000Z');

        // Act
        final result = tTokenModel.copyWith(expiresAt: newExpiresAt);

        // Assert
        expect(result.expiresAt, newExpiresAt);
        expect(result.accessToken, tTokenModel.accessToken);
      });

      test('should return identical copy when no fields updated', () {
        // Act
        final result = tTokenModel.copyWith();

        // Assert
        expect(result.accessToken, tTokenModel.accessToken);
        expect(result.refreshToken, tTokenModel.refreshToken);
        expect(result.expiresAt, tTokenModel.expiresAt);
        expect(result.scopes, tTokenModel.scopes);
      });
    });

    group('JSON serialization round-trip', () {
      test('should serialize and deserialize correctly', () {
        // Arrange
        final json = tTokenModel.toJson();
        final jsonString = jsonEncode(json);

        // Act
        final decodedJson = jsonDecode(jsonString);
        final result = TwitchTokenModel.fromJson(decodedJson);

        // Assert
        expect(result.accessToken, tTokenModel.accessToken);
        expect(result.refreshToken, tTokenModel.refreshToken);
        expect(result.expiresAt, tTokenModel.expiresAt);
        expect(result.scopes, tTokenModel.scopes);
      });
    });
  });
}
