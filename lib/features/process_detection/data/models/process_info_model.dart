import 'package:json_annotation/json_annotation.dart';
import 'package:tkit/features/process_detection/domain/entities/process_info.dart';

part 'process_info_model.g.dart';

/// Data model for ProcessInfo with JSON serialization
@JsonSerializable()
class ProcessInfoModel extends ProcessInfo {
  const ProcessInfoModel({
    required super.processName,
    required super.pid,
    required super.windowTitle,
    super.executablePath,
  });

  /// Create from JSON (from platform channel)
  factory ProcessInfoModel.fromJson(Map<String, dynamic> json) =>
      _$ProcessInfoModelFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$ProcessInfoModelToJson(this);

  /// Create from domain entity
  factory ProcessInfoModel.fromEntity(ProcessInfo entity) {
    return ProcessInfoModel(
      processName: entity.processName,
      pid: entity.pid,
      windowTitle: entity.windowTitle,
      executablePath: entity.executablePath,
    );
  }

  /// Convert to domain entity (already is one, but explicit method for clarity)
  ProcessInfo toEntity() => this;
}
