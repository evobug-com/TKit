import 'package:dartz/dartz.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/community_mappings/domain/repositories/i_community_mappings_repository.dart';

/// Use case for syncing community mappings from GitHub
///
/// Downloads the latest crowdsourced game mappings and updates
/// the local database. Should be called on app startup and periodically.
class SyncCommunityMappingsUseCase {
  final ICommunityMappingsRepository repository;

  SyncCommunityMappingsUseCase(this.repository);

  /// Execute the use case
  ///
  /// [forceSync] - Force sync even if cache is fresh
  ///
  /// Returns the number of mappings synced or Failure
  Future<Either<Failure, int>> call({bool forceSync = false}) async {
    // Check if sync is needed
    if (!forceSync && !repository.shouldSync()) {
      return const Right(0); // Cache is still fresh
    }

    return await repository.syncMappings();
  }

  /// Check if sync is needed
  bool shouldSync() {
    return repository.shouldSync();
  }

  /// Get last sync time
  DateTime? getLastSyncTime() {
    return repository.getLastSyncTime();
  }
}
