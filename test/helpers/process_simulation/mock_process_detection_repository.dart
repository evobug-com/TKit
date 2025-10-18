import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/process_detection/domain/entities/process_info.dart';
import 'package:tkit/features/process_detection/domain/repositories/i_process_detection_repository.dart';

/// Mock implementation of IProcessDetectionRepository for testing
/// Allows tests to simulate process changes without platform channels
class MockProcessDetectionRepository implements IProcessDetectionRepository {
  final StreamController<ProcessInfo?> _processController =
      StreamController<ProcessInfo?>.broadcast();

  ProcessInfo? _currentProcess;
  int _nextPid = 1000; // Start PIDs from 1000 for test processes

  @override
  Future<Either<Failure, ProcessInfo?>> getFocusedProcess() async {
    return Right(_currentProcess);
  }

  @override
  Stream<ProcessInfo?> watchProcessChanges(Duration scanInterval) {
    return _processController.stream;
  }

  @override
  Future<Either<Failure, bool>> isAvailable() async {
    return const Right(true);
  }

  /// For testing: simulate a process being focused
  void simulateProcess(
    String processName, {
    String? executablePath,
    String? windowTitle,
    int? pid,
  }) {
    _currentProcess = ProcessInfo(
      processName: processName,
      pid: pid ?? _nextPid++,
      executablePath: executablePath,
      windowTitle: windowTitle ?? processName.replaceAll('.exe', ''),
    );
    _processController.add(_currentProcess);
  }

  /// For testing: simulate no process (window unfocused)
  void simulateNoProcess() {
    _currentProcess = null;
    _processController.add(null);
  }

  /// For testing: simulate HelloWorld.exe
  void simulateHelloWorld() {
    simulateProcess(
      'HelloWorld.exe',
      executablePath: 'C:\\Program Files\\HelloWorld\\HelloWorld.exe',
      windowTitle: 'Hello World Application',
    );
  }

  /// For testing: simulate GameTwo.exe
  void simulateGameTwo() {
    simulateProcess(
      'GameTwo.exe',
      executablePath: 'C:\\Games\\GameTwo\\GameTwo.exe',
      windowTitle: 'Game Two',
    );
  }

  /// Clean up resources
  void dispose() {
    _processController.close();
  }
}
