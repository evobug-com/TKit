import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/community_mapping.dart';

/// Repository interface for community mappings
abstract class ICommunityMappingsRepository {
  /// Sync community mappings from GitHub
  ///
  /// Downloads the latest mappings from the community repository
  /// and updates the local database.
  ///
  /// Returns the number of mappings synced or a Failure
  Future<Either<Failure, int>> syncMappings();

  /// Submit a new mapping or verification to the community
  ///
  /// Checks for duplicates and creates either:
  /// - A new mapping submission issue
  /// - A verification issue for existing mapping
  ///
  /// Returns a map with submission details including:
  /// - success: bool
  /// - isVerification: bool
  /// - issueUrl: String?
  /// - issueNumber: int?
  /// - message: String
  Future<Either<Failure, Map<String, dynamic>>> submitMapping({
    required String processName,
    required String twitchCategoryId,
    required String twitchCategoryName,
    String? windowTitle,
    String? normalizedInstallPath,
  });

  /// Find a community mapping by process name
  Future<Either<Failure, CommunityMapping?>> findMapping(String processName);

  /// Get all community mappings
  Future<Either<Failure, List<CommunityMapping>>> getAllMappings();

  /// Check if sync is needed
  bool shouldSync();

  /// Get last sync time
  DateTime? getLastSyncTime();

  /// Force reset sync time
  void resetSyncTime();
}
