import 'dart:async';
import 'package:tkit/features/process_detection/domain/entities/process_info.dart';

/// Mock process detector for testing
///
/// Allows simulating process changes without platform channels
class MockProcessDetector {
  final StreamController<ProcessInfo?> _processController =
      StreamController<ProcessInfo?>.broadcast();

  Stream<ProcessInfo?> get processStream => _processController.stream;

  /// Simulate a process being focused
  void simulateProcess(String processName, {
    String? executablePath,
    String? windowTitle,
  }) {
    final processInfo = ProcessInfo(
      processName: processName,
      executablePath: executablePath,
      windowTitle: windowTitle,
    );
    _processController.add(processInfo);
  }

  /// Simulate no process focused
  void simulateNoProcess() {
    _processController.add(null);
  }

  /// Simulate HelloWorld.exe being focused
  void simulateHelloWorld() {
    simulateProcess(
      'HelloWorld.exe',
      executablePath: 'C:\\Program Files\\HelloWorld\\HelloWorld.exe',
      windowTitle: 'Hello World Application',
    );
  }

  void dispose() {
    _processController.close();
  }
}
