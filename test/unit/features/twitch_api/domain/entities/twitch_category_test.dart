import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tkit/features/twitch_api/domain/entities/twitch_category.dart';

void main() {
  group('TwitchCategory', () {
    const testCategory = TwitchCategory(
      id: '12345',
      name: 'Just Chatting',
      boxArtUrl: 'https://static-cdn.jtvnw.net/ttv-boxart/{width}x{height}.jpg',
    );

    test('should be an Equatable', () {
      expect(testCategory, isA<Equatable>());
    });

    test('should have correct properties', () {
      expect(testCategory.id, '12345');
      expect(testCategory.name, 'Just Chatting');
      expect(testCategory.boxArtUrl, contains('{width}'));
    });

    test('should be equal when properties are the same', () {
      const category1 = TwitchCategory(
        id: '12345',
        name: 'Just Chatting',
        boxArtUrl: 'url',
      );
      const category2 = TwitchCategory(
        id: '12345',
        name: 'Just Chatting',
        boxArtUrl: 'url',
      );
      expect(category1, category2);
    });

    test('should not be equal when properties differ', () {
      const category1 = TwitchCategory(id: '1', name: 'Name1');
      const category2 = TwitchCategory(id: '2', name: 'Name2');
      expect(category1, isNot(category2));
    });

    test('getBoxArtUrl should format URL with default dimensions', () {
      final url = testCategory.getBoxArtUrl();
      expect(url, 'https://static-cdn.jtvnw.net/ttv-boxart/285x380.jpg');
    });

    test('getBoxArtUrl should format URL with custom dimensions', () {
      final url = testCategory.getBoxArtUrl(width: 100, height: 150);
      expect(url, 'https://static-cdn.jtvnw.net/ttv-boxart/100x150.jpg');
    });

    test('getBoxArtUrl should return null when boxArtUrl is null', () {
      const categoryWithoutArt = TwitchCategory(id: '1', name: 'Test');
      expect(categoryWithoutArt.getBoxArtUrl(), isNull);
    });

    test('toString should return formatted string', () {
      expect(
        testCategory.toString(),
        'TwitchCategory(id: 12345, name: Just Chatting)',
      );
    });
  });
}
