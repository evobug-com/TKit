import 'package:dartz/dartz.dart';
import 'package:tkit/core/database/app_database.dart';
import 'package:tkit/core/errors/exceptions.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/core/utils/app_logger.dart';
import 'package:tkit/features/community_mappings/domain/entities/community_mapping.dart';
import 'package:tkit/features/community_mappings/domain/repositories/i_community_mappings_repository.dart';
import 'package:tkit/features/community_mappings/data/datasources/community_sync_datasource.dart';
import 'package:tkit/features/community_mappings/data/datasources/mapping_submission_datasource.dart';

/// Implementation of the community mappings repository
///
/// Coordinates between the sync datasource, submission datasource,
/// and local database for community mapping management.
class CommunityMappingsRepositoryImpl implements ICommunityMappingsRepository {
  final CommunitySyncDataSource syncDataSource;
  final MappingSubmissionDataSource submissionDataSource;
  final AppDatabase database;
  final AppLogger logger;

  CommunityMappingsRepositoryImpl({
    required this.syncDataSource,
    required this.submissionDataSource,
    required this.database,
    required this.logger,
  });

  @override
  Future<Either<Failure, int>> syncMappings() async {
    try {
      logger.info('Syncing community mappings from GitHub');

      // Fetch mappings from GitHub
      final data = await syncDataSource.fetchMappings();
      final mappings = data['mappings'] as List;

      // Convert to map format for database
      final mappingsData = mappings
          .cast<Map<String, dynamic>>()
          .map(
            (m) => {
              'processName': m['processName'] as String,
              'twitchCategoryId': m['twitchCategoryId'] as String,
              'twitchCategoryName': m['twitchCategoryName'] as String,
              'verificationCount': m['verificationCount'] as int? ?? 1,
              'lastVerified': m['lastVerified'] as String?,
              'source': m['source'] as String? ?? 'community',
            },
          )
          .toList();

      // Upsert to database
      await database.upsertCommunityMappings(mappingsData);

      logger.info('Successfully synced ${mappings.length} community mappings');
      return Right(mappings.length);
    } on NetworkException catch (e) {
      logger.error('Network error syncing mappings', e);
      return Left(NetworkFailure(message: e.message, originalError: e));
    } on ServerException catch (e) {
      logger.error('Server error syncing mappings', e);
      return Left(
        ServerFailure(message: e.message, code: e.code, originalError: e),
      );
    } catch (e) {
      logger.error('Unknown error syncing mappings', e);
      return Left(
        UnknownFailure(
          message: 'Failed to sync community mappings: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> submitMapping({
    required String processName,
    required String twitchCategoryId,
    required String twitchCategoryName,
    String? windowTitle,
    String? normalizedInstallPath,
    String? submissionUrl,
  }) async {
    try {
      logger.info('Checking for existing mapping before submission: $processName');

      // First check local database
      final localMapping = await database.getCommunityMapping(processName);

      if (localMapping != null && localMapping.twitchCategoryId == twitchCategoryId) {
        logger.info('Mapping already exists locally and matches');
        return Right({
          'success': false,
          'alreadyExists': true,
          'message': 'This mapping already exists in your local database.',
        });
      }

      // Check remote mappings to avoid duplicate submissions
      logger.info('Checking remote mappings for duplicates');
      try {
        final remoteData = await syncDataSource.fetchMappings();
        final remoteMappings = remoteData['mappings'] as List;

        final existingMapping = remoteMappings.firstWhere(
          (m) => (m as Map<String, dynamic>)['processName'] == processName,
          orElse: () => null,
        );

        if (existingMapping != null) {
          final existingCategoryId = existingMapping['twitchCategoryId'] as String;

          if (existingCategoryId == twitchCategoryId) {
            logger.info('Mapping already exists in remote repository with same category');
            return Right({
              'success': false,
              'alreadyExists': true,
              'message': 'This mapping already exists! Syncing to update your local database...',
              'shouldSync': true,
            });
          } else {
            logger.warning(
              'Process exists with different category: existing=$existingCategoryId, new=$twitchCategoryId',
            );
            // Different category - could be a different game with same process name
            // Allow submission but log it
          }
        }
      } catch (e) {
        logger.warning('Could not check remote mappings, proceeding with submission: $e');
        // If we can't check remote, proceed with submission anyway
      }

      logger.info('Submitting new mapping for: $processName');

      final result = await submissionDataSource.submitMapping(
        processName: processName,
        twitchCategoryId: twitchCategoryId,
        twitchCategoryName: twitchCategoryName,
        windowTitle: windowTitle,
        normalizedInstallPath: normalizedInstallPath,
        submissionUrl: submissionUrl,
      );

      return Right(result);
    } on NetworkException catch (e) {
      logger.error('Network error submitting mapping', e);
      return Left(NetworkFailure(message: e.message, originalError: e));
    } on ServerException catch (e) {
      logger.error('Server error submitting mapping', e);
      return Left(
        ServerFailure(message: e.message, code: e.code, originalError: e),
      );
    } catch (e) {
      logger.error('Unknown error submitting mapping', e);
      return Left(
        UnknownFailure(
          message: 'Failed to submit mapping: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, CommunityMapping?>> findMapping(
    String processName,
  ) async {
    try {
      final entity = await database.getCommunityMapping(processName);
      if (entity == null) {
        return const Right(null);
      }

      final mapping = CommunityMapping.fromDbEntity(entity);
      return Right(mapping);
    } catch (e) {
      logger.error('Error finding community mapping', e);
      return Left(
        CacheFailure(
          message: 'Failed to find community mapping: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<CommunityMapping>>> getAllMappings() async {
    try {
      final entities = await database.getAllCommunityMappings();
      final mappings = entities
          .map((e) => CommunityMapping.fromDbEntity(e))
          .toList();
      return Right(mappings);
    } catch (e) {
      logger.error('Error getting all community mappings', e);
      return Left(
        CacheFailure(
          message: 'Failed to get community mappings: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }

  @override
  bool shouldSync() {
    return syncDataSource.shouldSync();
  }

  @override
  DateTime? getLastSyncTime() {
    return syncDataSource.lastSyncTime;
  }

  @override
  void resetSyncTime() {
    syncDataSource.resetSyncTime();
  }
}
