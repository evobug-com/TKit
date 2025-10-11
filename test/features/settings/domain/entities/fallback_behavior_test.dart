import 'package:flutter_test/flutter_test.dart';
import 'package:tkit/features/settings/domain/entities/fallback_behavior.dart';

void main() {
  group('FallbackBehavior', () {
    test('should convert to JSON string', () {
      expect(FallbackBehavior.doNothing.toJson(), 'doNothing');
      expect(FallbackBehavior.justChatting.toJson(), 'justChatting');
      expect(FallbackBehavior.custom.toJson(), 'custom');
    });

    test('should convert from JSON string', () {
      expect(
        FallbackBehavior.fromJson('doNothing'),
        FallbackBehavior.doNothing,
      );
      expect(
        FallbackBehavior.fromJson('justChatting'),
        FallbackBehavior.justChatting,
      );
      expect(FallbackBehavior.fromJson('custom'), FallbackBehavior.custom);
    });

    test('should return default for invalid JSON string', () {
      expect(FallbackBehavior.fromJson('invalid'), FallbackBehavior.doNothing);
    });

    test('should have correct display names', () {
      expect(FallbackBehavior.doNothing.displayName, 'Do Nothing');
      expect(FallbackBehavior.justChatting.displayName, 'Just Chatting');
      expect(FallbackBehavior.custom.displayName, 'Custom Category');
    });
  });
}
