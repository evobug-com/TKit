import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:tkit/core/config/app_config.dart';
import 'package:tkit/core/errors/exceptions.dart';
import 'package:tkit/core/network/network_config.dart';
import 'package:tkit/core/utils/app_logger.dart';

/// Data source for submitting new mappings via GitHub Pull Requests
///
/// Creates GitHub PRs with structured mapping data that can be
/// reviewed and merged into the community mappings repository.
class MappingSubmissionDataSource {
  final Dio dio;
  final AppLogger logger;

  // GitHub API configuration (used by Cloudflare Worker)
  // Repository details are now configured in worker's wrangler.toml

  MappingSubmissionDataSource({required this.dio, required this.logger});

  /// Submit a new mapping via GitHub Pull Request
  ///
  /// Creates a PR with the mapping data for review and approval.
  ///
  /// Returns a map with submission result details
  ///
  /// Throws [NetworkException] on connection errors
  /// Throws [ServerException] on HTTP errors
  Future<Map<String, dynamic>> submitMapping({
    required String processName,
    required String twitchCategoryId,
    required String twitchCategoryName,
    String? windowTitle,
    String? normalizedInstallPath,
    String? submissionUrl,
    String category = 'game', // 'game' or 'program'
  }) async {
    // Check if community API is enabled
    if (!AppConfig.useCommunityApi) {
      throw ServerException(
        message:
            'Community API not configured. Please deploy the Cloudflare Worker '
            'and update AppConfig.useCommunityApi to true. '
            'See cloudflare-worker/README.md for instructions.',
        code: 'API_NOT_CONFIGURED',
      );
    }

    try {
      logger.info('Submitting mapping: $processName → $twitchCategoryName');

      final issueBody = _buildIssueBody(
        processName: processName,
        twitchCategoryId: twitchCategoryId,
        twitchCategoryName: twitchCategoryName,
        windowTitle: windowTitle,
        normalizedInstallPath: normalizedInstallPath,
      );

      final issueTitle = 'New mapping: $processName → $twitchCategoryName';
      final labels = ['mapping-submission', 'auto-generated'];

      // Call Cloudflare Worker API instead of GitHub directly
      // Use custom submission URL if provided, otherwise use default
      final baseApiUrl = submissionUrl ?? AppConfig.communityApiUrl;
      final apiUrl = '$baseApiUrl?category=$category';
      final response = await dio.post(
        apiUrl,
        data: json.encode({
          'title': issueTitle,
          'body': issueBody,
          'labels': labels,
          'processName': processName,
          'twitchCategoryId': twitchCategoryId,
          'twitchCategoryName': twitchCategoryName,
          if (normalizedInstallPath != null) 'normalizedInstallPath': normalizedInstallPath,
        }),
        options: Options(
          headers: {'Content-Type': 'application/json'},
          receiveTimeout: NetworkConfig.standardTimeout,
          sendTimeout: NetworkConfig.standardTimeout,
        ),
      );

      // API returns 201 for success
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        return {
          'success': data['success'] ?? true,
          'prUrl': data['prUrl'] ?? data['issueUrl'], // Support both old and new API
          'prNumber': data['prNumber'] ?? data['issueNumber'],
          'message': data['message'] ?? 'Thank you for contributing a new mapping!',
        };
      } else {
        throw ServerException(
          message: 'Unable to submit mapping. Please try again later.',
          code: response.statusCode.toString(),
          technicalDetails: 'HTTP ${response.statusCode}',
        );
      }
    } on DioException catch (e, stackTrace) {
      logger.error('Network error submitting mapping', e, stackTrace);

      // Handle specific HTTP error codes
      if (e.response?.statusCode == 429 || e.response?.statusCode == 403) {
        throw ServerException(
          message: 'Too many submissions. Please wait a few minutes and try again.',
          code: 'RATE_LIMIT',
          originalError: e,
          technicalDetails: 'HTTP ${e.response?.statusCode}',
        );
      }

      if (e.response?.statusCode == 400) {
        final errorData = e.response?.data;
        final errorMessage = errorData is Map
            ? errorData['error'] ?? 'Invalid submission data'
            : 'Invalid submission data';
        throw ServerException(
          message: 'Unable to submit mapping: $errorMessage',
          code: 'INVALID_SUBMISSION',
          originalError: e,
          technicalDetails: 'HTTP 400',
        );
      }

      if (e.response?.statusCode == 500) {
        throw ServerException(
          message: 'The submission server is temporarily unavailable. Please try again later.',
          code: 'SERVER_ERROR',
          originalError: e,
          technicalDetails: 'HTTP 500',
        );
      }

      throw NetworkException(
        message: 'Unable to connect to the submission server. Please check your internet connection.',
        originalError: e,
        technicalDetails: 'Network error: ${e.message}',
      );
    } catch (e, stackTrace) {
      logger.error('Unexpected error submitting mapping', e, stackTrace);
      throw ServerException(
        message: 'Unable to submit mapping. Please try again later.',
        code: 'UNKNOWN',
        originalError: e,
        technicalDetails: e.toString(),
      );
    }
  }

  /// Build the issue body with structured mapping data
  String _buildIssueBody({
    required String processName,
    required String twitchCategoryId,
    required String twitchCategoryName,
    String? windowTitle,
    String? normalizedInstallPath,
  }) {
    final buffer = StringBuffer();

    buffer.writeln('## Mapping Submission');
    buffer.writeln();
    buffer.writeln('A new game mapping has been submitted from TKit.');
    buffer.writeln();
    buffer.writeln('### Mapping Details');
    buffer.writeln();
    buffer.writeln('**Process Name:** `$processName`');
    buffer.writeln('**Twitch Category:** $twitchCategoryName');
    buffer.writeln('**Category ID:** `$twitchCategoryId`');

    if (windowTitle != null && windowTitle.isNotEmpty) {
      buffer.writeln('**Window Title:** $windowTitle');
    }

    if (normalizedInstallPath != null && normalizedInstallPath.isNotEmpty) {
      buffer.writeln('**Installation Path:** `$normalizedInstallPath`');
    }

    buffer.writeln();
    buffer.writeln('### JSON for mappings.json');
    buffer.writeln();
    buffer.writeln('```json');
    buffer.writeln('{');
    buffer.writeln('  "processName": "$processName",');
    if (normalizedInstallPath != null && normalizedInstallPath.isNotEmpty) {
      buffer.writeln('  "normalizedInstallPaths": ["$normalizedInstallPath"],');
    }
    buffer.writeln('  "twitchCategoryId": "$twitchCategoryId",');
    buffer.writeln('  "twitchCategoryName": "$twitchCategoryName"');
    buffer.writeln('}');
    buffer.writeln('```');
    buffer.writeln();
    buffer.writeln('---');
    buffer.writeln();
    buffer.writeln('**Client Version:** ${AppConfig.appVersion}');
    buffer.writeln('**Submitted:** ${DateTime.now().toIso8601String()}');
    buffer.writeln();
    buffer.writeln('🤖 *This issue was automatically generated by TKit*');

    return buffer.toString();
  }

  /// Check if Community API is available (for testing connectivity)
  Future<bool> checkApiAvailability() async {
    if (!AppConfig.useCommunityApi) {
      return false;
    }

    try {
      // Use HEAD request for lightweight connectivity check
      final response = await dio.head(
        AppConfig.communityApiUrl,
        options: Options(receiveTimeout: NetworkConfig.quickTimeout),
      );
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e, stackTrace) {
      logger.warning('Community API availability check failed', e);
      return false;
    }
  }
}
