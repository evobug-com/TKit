import 'package:equatable/equatable.dart';

/// Represents information about a Windows process
class ProcessInfo extends Equatable {
  final String processName;
  final int pid;
  final String windowTitle;
  final String? executablePath;

  const ProcessInfo({
    required this.processName,
    required this.pid,
    required this.windowTitle,
    this.executablePath,
  });

  /// Create an empty/null process info
  static const ProcessInfo empty = ProcessInfo(
    processName: '',
    pid: 0,
    windowTitle: '',
    executablePath: null,
  );

  /// Check if this is an empty process
  bool get isEmpty => processName.isEmpty && pid == 0;

  /// Get a normalized process name (lowercase, no extension)
  String get normalizedName {
    return processName
        .toLowerCase()
        .replaceAll('.exe', '')
        .replaceAll(' ', '')
        .replaceAll('-', '');
  }

  @override
  List<Object?> get props => [processName, pid, windowTitle, executablePath];

  @override
  String toString() {
    return 'ProcessInfo(processName: $processName, pid: $pid, windowTitle: $windowTitle, executablePath: $executablePath)';
  }
}
