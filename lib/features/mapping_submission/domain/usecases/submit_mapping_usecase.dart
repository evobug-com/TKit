import 'package:dartz/dartz.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/mapping_submission/data/datasources/mapping_submission_datasource.dart';

/// Use case for submitting mapping contributions
class SubmitMappingUseCase {
  final MappingSubmissionDataSource _dataSource;

  SubmitMappingUseCase(this._dataSource);

  /// Submit a mapping contribution to a remote endpoint
  ///
  /// Parameters:
  /// - [submissionUrl]: The URL to submit to (from mapping list's submissionHookUrl)
  /// - [processName]: Name of the process
  /// - [twitchCategoryId]: Twitch category ID
  /// - [twitchCategoryName]: Twitch category name
  /// - [windowTitle]: Optional window title
  /// - [normalizedInstallPath]: Optional normalized installation path
  ///
  /// Returns either a Failure or a map with submission details
  Future<Either<Failure, Map<String, dynamic>>> call({
    required String submissionUrl,
    required String processName,
    required String twitchCategoryId,
    required String twitchCategoryName,
    String? windowTitle,
    String? normalizedInstallPath,
  }) async {
    try {
      final result = await _dataSource.submitMapping(
        submissionUrl: submissionUrl,
        processName: processName,
        twitchCategoryId: twitchCategoryId,
        twitchCategoryName: twitchCategoryName,
        windowTitle: windowTitle,
        normalizedInstallPath: normalizedInstallPath,
      );

      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
