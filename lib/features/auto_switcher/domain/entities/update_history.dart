import 'package:equatable/equatable.dart';

/// Represents a historical record of a category update attempt
/// This tracks all updates (both successful and failed) for debugging and analysis
class UpdateHistory extends Equatable {
  /// Unique identifier for this history record
  final int? id;

  /// Name of the process that triggered the update
  final String processName;

  /// Twitch category ID that was updated to
  final String categoryId;

  /// Human-readable category name
  final String categoryName;

  /// Whether the update was successful
  final bool success;

  /// Error message if the update failed
  final String? errorMessage;

  /// Timestamp when the update was attempted
  final DateTime updatedAt;

  const UpdateHistory({
    this.id,
    required this.processName,
    required this.categoryId,
    required this.categoryName,
    required this.success,
    this.errorMessage,
    required this.updatedAt,
  });

  /// Create a successful update history entry
  factory UpdateHistory.success({
    required String processName,
    required String categoryId,
    required String categoryName,
  }) {
    return UpdateHistory(
      processName: processName,
      categoryId: categoryId,
      categoryName: categoryName,
      success: true,
      updatedAt: DateTime.now(),
    );
  }

  /// Create a failed update history entry
  factory UpdateHistory.failure({
    required String processName,
    required String categoryId,
    required String categoryName,
    required String errorMessage,
  }) {
    return UpdateHistory(
      processName: processName,
      categoryId: categoryId,
      categoryName: categoryName,
      success: false,
      errorMessage: errorMessage,
      updatedAt: DateTime.now(),
    );
  }

  /// Create a copy with updated values
  UpdateHistory copyWith({
    int? id,
    String? processName,
    String? categoryId,
    String? categoryName,
    bool? success,
    String? errorMessage,
    DateTime? updatedAt,
  }) {
    return UpdateHistory(
      id: id ?? this.id,
      processName: processName ?? this.processName,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      success: success ?? this.success,
      errorMessage: errorMessage ?? this.errorMessage,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    processName,
    categoryId,
    categoryName,
    success,
    errorMessage,
    updatedAt,
  ];

  @override
  String toString() {
    return 'UpdateHistory(id: $id, process: $processName, category: $categoryName, '
        'success: $success, time: $updatedAt)';
  }
}
