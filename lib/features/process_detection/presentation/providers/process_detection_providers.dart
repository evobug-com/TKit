import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tkit/core/providers/datasource_providers.dart';
import 'package:tkit/core/providers/providers.dart';
import 'package:tkit/features/process_detection/data/repositories/process_detection_repository_impl.dart';
import 'package:tkit/features/process_detection/domain/repositories/i_process_detection_repository.dart';
import 'package:tkit/features/process_detection/domain/usecases/get_focused_process_usecase.dart';
import 'package:tkit/features/process_detection/domain/usecases/watch_process_changes_usecase.dart';

part 'process_detection_providers.g.dart';

// =============================================================================
// PROCESS DETECTION REPOSITORY
// =============================================================================

@Riverpod(keepAlive: true)
IProcessDetectionRepository processDetectionRepository(Ref ref) {
  final dataSource = ref.watch(processDetectionPlatformDataSourceProvider);
  final logger = ref.watch(appLoggerProvider);
  return ProcessDetectionRepositoryImpl(dataSource, logger);
}

// =============================================================================
// PROCESS DETECTION USE CASES
// =============================================================================

@Riverpod(keepAlive: true)
GetFocusedProcessUseCase getFocusedProcessUseCase(Ref ref) {
  final repository = ref.watch(processDetectionRepositoryProvider);
  return GetFocusedProcessUseCase(repository);
}

@Riverpod(keepAlive: true)
WatchProcessChangesUseCase watchProcessChangesUseCase(Ref ref) {
  final repository = ref.watch(processDetectionRepositoryProvider);
  return WatchProcessChangesUseCase(repository);
}
