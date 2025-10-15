import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tkit/core/providers/providers.dart';
import 'package:tkit/features/auth/data/datasources/token_local_datasource.dart';
import 'package:tkit/features/auth/data/datasources/twitch_auth_remote_datasource.dart';
import 'package:tkit/features/auto_switcher/data/datasources/update_history_local_datasource.dart';
import 'package:tkit/features/category_mapping/data/datasources/category_mapping_local_datasource.dart';
import 'package:tkit/features/category_mapping/data/datasources/mapping_importer.dart';
import 'package:tkit/features/category_mapping/data/datasources/memory_cache.dart';
import 'package:tkit/features/category_mapping/data/datasources/unknown_process_datasource.dart';
import 'package:tkit/features/mapping_lists/data/datasources/mapping_list_local_datasource.dart';
import 'package:tkit/features/mapping_lists/data/datasources/mapping_list_sync_datasource.dart';
import 'package:tkit/features/mapping_submission/data/datasources/mapping_submission_datasource.dart';
import 'package:tkit/features/process_detection/data/datasources/process_detection_platform_datasource.dart';
import 'package:tkit/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:tkit/features/twitch_api/data/datasources/twitch_api_remote_datasource.dart';

part 'datasource_providers.g.dart';

// =============================================================================
// DATA SOURCES
// =============================================================================

// Auth datasources
@Riverpod(keepAlive: true)
TokenLocalDataSource tokenLocalDataSource(Ref ref) {
  final storage = ref.watch(secureStorageProvider);
  return TokenLocalDataSource(storage);
}

@Riverpod(keepAlive: true)
TwitchAuthRemoteDataSource twitchAuthRemoteDataSource(
  Ref ref,
) {
  final authDio = ref.watch(authDioProvider);
  return TwitchAuthRemoteDataSource(authDio);
}

// Settings datasource
@Riverpod(keepAlive: true)
Future<SettingsLocalDataSource> settingsLocalDataSource(
  Ref ref,
) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  final logger = ref.watch(appLoggerProvider);
  return SettingsLocalDataSource(prefs, logger);
}

// Category mapping datasources
@Riverpod(keepAlive: true)
CategoryMappingLocalDataSource categoryMappingLocalDataSource(
  Ref ref,
) {
  final database = ref.watch(appDatabaseProvider);
  return CategoryMappingLocalDataSource(database);
}

@Riverpod(keepAlive: true)
UnknownProcessDataSource unknownProcessDataSource(
  Ref ref,
) {
  final database = ref.watch(appDatabaseProvider);
  return UnknownProcessDataSource(database);
}

@Riverpod(keepAlive: true)
MemoryCache memoryCache(Ref ref) {
  return MemoryCache(
    maxSize: 100,
    defaultTtl: const Duration(minutes: 30),
  );
}

// Mapping list datasources
@Riverpod(keepAlive: true)
MappingListLocalDataSource mappingListLocalDataSource(
  Ref ref,
) {
  final database = ref.watch(appDatabaseProvider);
  return MappingListLocalDataSource(database);
}

@Riverpod(keepAlive: true)
MappingListSyncDataSource mappingListSyncDataSource(
  Ref ref,
) {
  final authDio = ref.watch(authDioProvider);
  return MappingListSyncDataSource(authDio);
}

// Mapping submission datasource
@Riverpod(keepAlive: true)
MappingSubmissionDataSource mappingSubmissionDataSource(
  Ref ref,
) {
  final authDio = ref.watch(authDioProvider);
  final logger = ref.watch(appLoggerProvider);
  return MappingSubmissionDataSource(authDio, logger);
}

// Process detection datasource
@Riverpod(keepAlive: true)
ProcessDetectionPlatformDataSource processDetectionPlatformDataSource(
  Ref ref,
) {
  final platformChannel = ref.watch(windowsPlatformChannelProvider);
  final logger = ref.watch(appLoggerProvider);
  return ProcessDetectionPlatformDataSource(platformChannel, logger);
}

// Update history datasource
@Riverpod(keepAlive: true)
UpdateHistoryLocalDataSource updateHistoryLocalDataSource(
  Ref ref,
) {
  final database = ref.watch(appDatabaseProvider);
  return UpdateHistoryLocalDataSource(database);
}

// Twitch API datasource
@Riverpod(keepAlive: true)
TwitchApiRemoteDataSource twitchApiRemoteDataSource(
  Ref ref,
) {
  final apiDio = ref.watch(apiDioProvider);
  final logger = ref.watch(appLoggerProvider);
  return TwitchApiRemoteDataSource(apiDio, logger);
}
