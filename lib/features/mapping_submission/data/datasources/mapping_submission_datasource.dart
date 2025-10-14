import 'package:dio/dio.dart';
import 'package:tkit/core/utils/app_logger.dart';

/// Data source for submitting mapping contributions to remote endpoints
class MappingSubmissionDataSource {
  final Dio _dio;
  final AppLogger _logger;

  MappingSubmissionDataSource(this._dio, this._logger);

  /// Submit a mapping to a remote submission endpoint
  ///
  /// Returns a map with submission details:
  /// - 'isVerification': bool - whether this was a verification of existing mapping
  /// - 'issueUrl': String? - URL to the created issue/PR if applicable
  Future<Map<String, dynamic>> submitMapping({
    required String submissionUrl,
    required String processName,
    required String twitchCategoryId,
    required String twitchCategoryName,
    String? windowTitle,
    String? normalizedInstallPath,
  }) async {
    try {
      _logger.info('Submitting mapping to: $submissionUrl');

      // Prepare submission payload
      final payload = {
        'processName': processName,
        'twitchCategoryId': twitchCategoryId,
        'twitchCategoryName': twitchCategoryName,
        if (windowTitle != null) 'windowTitle': windowTitle,
        if (normalizedInstallPath != null) 'normalizedInstallPath': normalizedInstallPath,
      };

      final response = await _dio.post(
        submissionUrl,
        data: payload,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _logger.info('Mapping submitted successfully');

        // Parse response
        final responseData = response.data as Map<String, dynamic>? ?? {};

        return {
          'isVerification': responseData['isVerification'] as bool? ?? false,
          'issueUrl': responseData['issueUrl'] as String?,
        };
      } else {
        _logger.error('Failed to submit mapping: HTTP ${response.statusCode}');
        throw Exception('Failed to submit mapping: HTTP ${response.statusCode}');
      }
    } on DioException catch (e, stackTrace) {
      _logger.error('Network error submitting mapping', e, stackTrace);
      throw Exception('Network error submitting mapping: ${e.message}');
    } catch (e, stackTrace) {
      _logger.error('Error submitting mapping', e, stackTrace);
      throw Exception('Error submitting mapping: $e');
    }
  }
}
