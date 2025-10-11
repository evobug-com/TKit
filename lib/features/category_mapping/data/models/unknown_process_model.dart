import 'package:drift/drift.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/unknown_process.dart';

part 'unknown_process_model.g.dart';

/// Data model for UnknownProcess with JSON serialization
///
/// This model extends the domain entity and provides JSON serialization
/// capabilities and conversion to/from Drift database entities.
@JsonSerializable()
class UnknownProcessModel extends UnknownProcess {
  const UnknownProcessModel({
    super.id,
    required super.executableName,
    super.windowTitle,
    required super.firstDetected,
    required super.occurrenceCount,
    required super.resolved,
  });

  /// Create from domain entity
  factory UnknownProcessModel.fromEntity(UnknownProcess entity) {
    return UnknownProcessModel(
      id: entity.id,
      executableName: entity.executableName,
      windowTitle: entity.windowTitle,
      firstDetected: entity.firstDetected,
      occurrenceCount: entity.occurrenceCount,
      resolved: entity.resolved,
    );
  }

  /// Create from Drift database entity
  factory UnknownProcessModel.fromDbEntity(UnknownProcessEntity dbEntity) {
    return UnknownProcessModel(
      id: dbEntity.id,
      executableName: dbEntity.executableName,
      windowTitle: dbEntity.windowTitle,
      firstDetected: dbEntity.firstDetected,
      occurrenceCount: dbEntity.occurrenceCount,
      resolved: dbEntity.resolved,
    );
  }

  /// Create from JSON
  factory UnknownProcessModel.fromJson(Map<String, dynamic> json) =>
      _$UnknownProcessModelFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$UnknownProcessModelToJson(this);

  /// Convert to domain entity
  UnknownProcess toEntity() {
    return UnknownProcess(
      id: id,
      executableName: executableName,
      windowTitle: windowTitle,
      firstDetected: firstDetected,
      occurrenceCount: occurrenceCount,
      resolved: resolved,
    );
  }

  /// Convert to Drift companion for insert/update
  UnknownProcessesCompanion toCompanion() {
    return UnknownProcessesCompanion.insert(
      id: id != null ? Value(id!) : const Value.absent(),
      executableName: executableName,
      windowTitle: Value(windowTitle),
      firstDetected: Value(firstDetected),
      occurrenceCount: Value(occurrenceCount),
      resolved: Value(resolved),
    );
  }
}
