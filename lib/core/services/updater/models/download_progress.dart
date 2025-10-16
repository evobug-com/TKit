/// Represents the current state of a download
enum DownloadStatus { idle, downloading, completed, failed, cancelled }

/// Information about download progress
class DownloadProgress {
  final DownloadStatus status;
  final int bytesReceived;
  final int totalBytes;
  final double progress; // 0.0 to 1.0
  final String? error;

  DownloadProgress({
    required this.status,
    this.bytesReceived = 0,
    this.totalBytes = 0,
    this.error,
  }) : progress = totalBytes > 0 ? bytesReceived / totalBytes : 0.0;

  DownloadProgress copyWith({
    DownloadStatus? status,
    int? bytesReceived,
    int? totalBytes,
    String? error,
  }) {
    return DownloadProgress(
      status: status ?? this.status,
      bytesReceived: bytesReceived ?? this.bytesReceived,
      totalBytes: totalBytes ?? this.totalBytes,
      error: error ?? this.error,
    );
  }

  bool get isDownloading => status == DownloadStatus.downloading;
  bool get isCompleted => status == DownloadStatus.completed;
  bool get isFailed => status == DownloadStatus.failed;
  bool get isCancelled => status == DownloadStatus.cancelled;

  String get progressPercentage => '${(progress * 100).toStringAsFixed(1)}%';

  String get bytesReceivedFormatted => _formatBytes(bytesReceived);
  String get totalBytesFormatted => _formatBytes(totalBytes);

  static String _formatBytes(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    }
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
