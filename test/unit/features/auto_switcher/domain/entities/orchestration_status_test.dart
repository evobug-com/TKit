import 'package:flutter_test/flutter_test.dart';
import 'package:tkit/features/auto_switcher/domain/entities/orchestration_status.dart';

void main() {
  group('OrchestrationStatus', () {
    test('should create idle status', () {
      // Act
      final status = OrchestrationStatus.idle();

      // Assert
      expect(status.state, OrchestrationState.idle);
      expect(status.isMonitoring, false);
      expect(status.currentProcess, null);
      expect(status.matchedCategory, null);
    });

    test('should create monitoring status', () {
      // Act
      final status = OrchestrationStatus.monitoring();

      // Assert
      expect(status.state, OrchestrationState.detectingProcess);
      expect(status.isMonitoring, true);
    });

    test('should create error status', () {
      // Arrange
      const errorMessage = 'Test error';

      // Act
      final status = OrchestrationStatus.error(errorMessage);

      // Assert
      expect(status.state, OrchestrationState.error);
      expect(status.errorMessage, errorMessage);
      expect(status.isMonitoring, false);
    });

    test('should copyWith correctly', () {
      // Arrange
      final original = OrchestrationStatus.monitoring();

      // Act
      final updated = original.copyWith(
        state: OrchestrationState.searchingMapping,
        currentProcess: 'test.exe',
      );

      // Assert
      expect(updated.state, OrchestrationState.searchingMapping);
      expect(updated.currentProcess, 'test.exe');
      expect(updated.isMonitoring, true); // Unchanged
    });

    test('should support equality comparison', () {
      // Arrange
      final status1 = OrchestrationStatus.idle();
      final status2 = OrchestrationStatus.idle();

      // Assert
      expect(status1, status2);
      expect(status1.hashCode, status2.hashCode);
    });
  });
}
