import 'dart:convert';
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

      // Generate a title for the GitHub issue/PR
      final isIgnored = twitchCategoryId == '-1';
      final title = isIgnored
          ? 'Add ignored process: $processName'
          : 'Add mapping: $processName → $twitchCategoryName';

      // Prepare submission payload
      // Create a markdown body for the GitHub PR with embedded JSON
      final bodyText = StringBuffer();
      bodyText.writeln('## Process Information');
      bodyText.writeln('- **Process Name:** `$processName`');
      bodyText.writeln('- **Twitch Category:** $twitchCategoryName');
      bodyText.writeln('- **Category ID:** `$twitchCategoryId`');
      if (normalizedInstallPath != null) {
        bodyText.writeln('- **Install Path:** `$normalizedInstallPath`');
      }
      if (windowTitle != null) {
        bodyText.writeln('- **Window Title:** $windowTitle');
      }
      bodyText.writeln();
      bodyText.writeln('## Mapping Data');
      bodyText.writeln('```json');

      // Build the JSON object
      // Convert "-1" string to -1 number for ignored processes to match tkit-community-mapping format
      final mappingJson = <String, dynamic>{
        'processName': processName,
        'twitchCategoryId': twitchCategoryId == '-1' ? -1 : twitchCategoryId,
        'twitchCategoryName': twitchCategoryName,
      };

      // Only include normalizedInstallPaths if not null
      if (normalizedInstallPath != null) {
        mappingJson['normalizedInstallPaths'] = [normalizedInstallPath];
      }

      bodyText.writeln(const JsonEncoder.withIndent('  ').convert(mappingJson));
      bodyText.writeln('```');
      bodyText.writeln();
      bodyText.writeln('---');
      bodyText.writeln('*Submitted via TKit Community Mapping*');

      final payload = {'title': title, 'body': bodyText.toString()};

      // Log the payload being sent for debugging
      _logger.info('Submission payload: $payload');
      _logger.debug('Payload type: ${payload.runtimeType}');
      _logger.debug('Submission URL: $submissionUrl');

      final response = await _dio.post<Map<String, dynamic>>(
        submissionUrl,
        data: payload,
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => status! < 500,
        ),
      );

      _logger.debug('Response status: ${response.statusCode}');
      _logger.debug('Response headers: ${response.headers}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        _logger.info('Mapping submitted successfully');

        // Parse response
        final responseData = response.data ?? {};

        // The worker returns 'prUrl' not 'issueUrl'
        final prUrl = responseData['prUrl'] as String?;
        if (prUrl != null) {
          _logger.info('PR created: $prUrl');
        }

        return {
          'isVerification': false, // Always a new submission for this worker
          'issueUrl': prUrl, // Map prUrl to issueUrl for compatibility
          'prNumber': responseData['prNumber'],
          'message': responseData['message'],
        };
      } else {
        _logger.error('Failed to submit mapping: HTTP ${response.statusCode}');
        _logger.error('Response body: ${response.data}');
        throw Exception(
          'Failed to submit mapping: HTTP ${response.statusCode} - ${response.data}',
        );
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
