import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:tkit/features/twitch_api/data/models/twitch_category_model.dart';
import 'package:tkit/features/twitch_api/domain/entities/twitch_category.dart';

void main() {
  group('TwitchCategoryModel', () {
    const testModel = TwitchCategoryModel(
      id: '12345',
      name: 'Just Chatting',
      boxArtUrl: 'https://example.com/{width}x{height}.jpg',
    );

    test('should be a subclass of TwitchCategory', () {
      expect(testModel, isA<TwitchCategory>());
    });

    group('fromJson', () {
      test('should deserialize from JSON with all fields', () {
        final json = {
          'id': '12345',
          'name': 'Just Chatting',
          'box_art_url': 'https://example.com/{width}x{height}.jpg',
        };

        final result = TwitchCategoryModel.fromJson(json);

        expect(result.id, '12345');
        expect(result.name, 'Just Chatting');
        expect(result.boxArtUrl, 'https://example.com/{width}x{height}.jpg');
      });

      test('should deserialize from JSON without optional fields', () {
        final json = {'id': '67890', 'name': 'Minecraft'};

        final result = TwitchCategoryModel.fromJson(json);

        expect(result.id, '67890');
        expect(result.name, 'Minecraft');
        expect(result.boxArtUrl, isNull);
      });

      test('should handle actual Twitch API response format', () {
        final jsonString = '''
        {
          "id": "509658",
          "name": "Just Chatting",
          "box_art_url": "https://static-cdn.jtvnw.net/ttv-boxart/509658-{width}x{height}.jpg"
        }
        ''';

        // Note: Twitch API uses snake_case (box_art_url)
        // @JsonKey annotation handles the conversion to camelCase property
        final json = jsonDecode(jsonString);

        final result = TwitchCategoryModel.fromJson(json);

        expect(result.id, '509658');
        expect(result.name, 'Just Chatting');
        expect(result.boxArtUrl, contains('ttv-boxart'));
      });
    });

    group('toJson', () {
      test('should serialize to JSON with all fields', () {
        final json = testModel.toJson();

        expect(json['id'], '12345');
        expect(json['name'], 'Just Chatting');
        expect(json['box_art_url'], 'https://example.com/{width}x{height}.jpg');
      });

      test('should serialize to JSON without optional fields', () {
        const model = TwitchCategoryModel(id: '99999', name: 'Test Category');

        final json = model.toJson();

        expect(json['id'], '99999');
        expect(json['name'], 'Test Category');
        expect(json.containsKey('box_art_url'), true);
        expect(json['box_art_url'], isNull);
      });
    });

    group('fromEntity', () {
      test('should create model from domain entity', () {
        const entity = TwitchCategory(
          id: '11111',
          name: 'League of Legends',
          boxArtUrl: 'https://example.com/art.jpg',
        );

        final model = TwitchCategoryModel.fromEntity(entity);

        expect(model.id, entity.id);
        expect(model.name, entity.name);
        expect(model.boxArtUrl, entity.boxArtUrl);
      });
    });

    group('toEntity', () {
      test('should convert model to domain entity', () {
        final entity = testModel.toEntity();

        expect(entity, isA<TwitchCategory>());
        expect(entity.id, testModel.id);
        expect(entity.name, testModel.name);
        expect(entity.boxArtUrl, testModel.boxArtUrl);
      });
    });

    group('round-trip conversion', () {
      test('should maintain data integrity through JSON round-trip', () {
        final json = testModel.toJson();
        final newModel = TwitchCategoryModel.fromJson(json);

        expect(newModel, testModel);
      });

      test('should maintain data integrity through entity round-trip', () {
        final entity = testModel.toEntity();
        final newModel = TwitchCategoryModel.fromEntity(entity);

        expect(newModel, testModel);
      });
    });
  });
}
