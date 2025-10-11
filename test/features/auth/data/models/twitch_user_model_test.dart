import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:tkit/features/auth/data/models/twitch_user_model.dart';
import 'package:tkit/features/auth/domain/entities/twitch_user.dart';

void main() {
  group('TwitchUserModel', () {
    const tUserModel = TwitchUserModel(
      id: '123456',
      login: 'testuser',
      displayName: 'TestUser',
      profileImageUrl: 'https://example.com/avatar.png',
      email: 'test@example.com',
    );

    test('should be a subclass of TwitchUser entity', () {
      expect(tUserModel, isA<TwitchUser>());
    });

    group('fromJson', () {
      test('should return a valid model from JSON', () {
        // Arrange
        final json = {
          'id': '123456',
          'login': 'testuser',
          'displayName': 'TestUser',
          'profileImageUrl': 'https://example.com/avatar.png',
          'email': 'test@example.com',
        };

        // Act
        final result = TwitchUserModel.fromJson(json);

        // Assert
        expect(result.id, '123456');
        expect(result.login, 'testuser');
        expect(result.displayName, 'TestUser');
        expect(result.profileImageUrl, 'https://example.com/avatar.png');
        expect(result.email, 'test@example.com');
      });

      test('should handle null optional fields', () {
        // Arrange
        final json = {
          'id': '123456',
          'login': 'testuser',
          'displayName': 'TestUser',
        };

        // Act
        final result = TwitchUserModel.fromJson(json);

        // Assert
        expect(result.id, '123456');
        expect(result.login, 'testuser');
        expect(result.displayName, 'TestUser');
        expect(result.profileImageUrl, null);
        expect(result.email, null);
      });
    });

    group('fromApiResponse', () {
      test('should return a valid model from Twitch API response', () {
        // Arrange
        final json = {
          'id': '123456',
          'login': 'testuser',
          'display_name': 'TestUser',
          'profile_image_url': 'https://example.com/avatar.png',
          'email': 'test@example.com',
        };

        // Act
        final result = TwitchUserModel.fromApiResponse(json);

        // Assert
        expect(result.id, '123456');
        expect(result.login, 'testuser');
        expect(result.displayName, 'TestUser');
        expect(result.profileImageUrl, 'https://example.com/avatar.png');
        expect(result.email, 'test@example.com');
      });

      test('should handle null optional fields from API response', () {
        // Arrange
        final json = {
          'id': '123456',
          'login': 'testuser',
          'display_name': 'TestUser',
        };

        // Act
        final result = TwitchUserModel.fromApiResponse(json);

        // Assert
        expect(result.profileImageUrl, null);
        expect(result.email, null);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () {
        // Act
        final result = tUserModel.toJson();

        // Assert
        expect(result, {
          'id': '123456',
          'login': 'testuser',
          'displayName': 'TestUser',
          'profileImageUrl': 'https://example.com/avatar.png',
          'email': 'test@example.com',
        });
      });

      test('should include null values in JSON', () {
        // Arrange
        const modelWithNulls = TwitchUserModel(
          id: '123456',
          login: 'testuser',
          displayName: 'TestUser',
        );

        // Act
        final result = modelWithNulls.toJson();

        // Assert
        expect(result['profileImageUrl'], null);
        expect(result['email'], null);
      });
    });

    group('toEntity', () {
      test('should return a TwitchUser entity with the same properties', () {
        // Act
        final result = tUserModel.toEntity();

        // Assert
        expect(result, isA<TwitchUser>());
        expect(result.id, tUserModel.id);
        expect(result.login, tUserModel.login);
        expect(result.displayName, tUserModel.displayName);
        expect(result.profileImageUrl, tUserModel.profileImageUrl);
        expect(result.email, tUserModel.email);
      });
    });

    group('fromEntity', () {
      test('should create a model from an entity', () {
        // Arrange
        const entity = TwitchUser(
          id: '789012',
          login: 'anotheruser',
          displayName: 'AnotherUser',
          profileImageUrl: 'https://example.com/other.png',
        );

        // Act
        final result = TwitchUserModel.fromEntity(entity);

        // Assert
        expect(result, isA<TwitchUserModel>());
        expect(result.id, entity.id);
        expect(result.login, entity.login);
        expect(result.displayName, entity.displayName);
        expect(result.profileImageUrl, entity.profileImageUrl);
        expect(result.email, entity.email);
      });
    });

    group('copyWith', () {
      test('should return a copy with updated displayName', () {
        // Act
        final result = tUserModel.copyWith(displayName: 'NewDisplayName');

        // Assert
        expect(result.displayName, 'NewDisplayName');
        expect(result.id, tUserModel.id);
        expect(result.login, tUserModel.login);
      });

      test('should return a copy with updated profileImageUrl', () {
        // Act
        final result = tUserModel.copyWith(
          profileImageUrl: 'https://example.com/new_avatar.png',
        );

        // Assert
        expect(result.profileImageUrl, 'https://example.com/new_avatar.png');
        expect(result.id, tUserModel.id);
      });

      test('should return identical copy when no fields updated', () {
        // Act
        final result = tUserModel.copyWith();

        // Assert
        expect(result.id, tUserModel.id);
        expect(result.login, tUserModel.login);
        expect(result.displayName, tUserModel.displayName);
        expect(result.profileImageUrl, tUserModel.profileImageUrl);
        expect(result.email, tUserModel.email);
      });
    });

    group('JSON serialization round-trip', () {
      test('should serialize and deserialize correctly', () {
        // Arrange
        final json = tUserModel.toJson();
        final jsonString = jsonEncode(json);

        // Act
        final decodedJson = jsonDecode(jsonString);
        final result = TwitchUserModel.fromJson(decodedJson);

        // Assert
        expect(result.id, tUserModel.id);
        expect(result.login, tUserModel.login);
        expect(result.displayName, tUserModel.displayName);
        expect(result.profileImageUrl, tUserModel.profileImageUrl);
        expect(result.email, tUserModel.email);
      });
    });
  });
}
