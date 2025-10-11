import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/app_logger.dart';

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

  /// Submit a new mapping or verification via GitHub Pull Request
  ///
  /// Checks for existing mappings/submissions and creates either:
  /// - New mapping submission PR
  /// - Verification PR for existing mapping
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
    bool isExistingMapping = false,
    int? existingVerificationCount,
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

      // Determine if this is a verification or new submission
      final isVerification = isExistingMapping;

      final issueBody = isVerification
          ? _buildVerificationIssueBody(
              processName: processName,
              twitchCategoryId: twitchCategoryId,
              twitchCategoryName: twitchCategoryName,
              currentVerificationCount: existingVerificationCount ?? 1,
              windowTitle: windowTitle,
            )
          : _buildIssueBody(
              processName: processName,
              twitchCategoryId: twitchCategoryId,
              twitchCategoryName: twitchCategoryName,
              windowTitle: windowTitle,
            );

      final issueTitle = isVerification
          ? 'Verification: $processName → $twitchCategoryName'
          : 'New mapping: $processName → $twitchCategoryName';

      final labels = isVerification
          ? ['verification', 'auto-generated']
          : ['mapping-submission', 'auto-generated'];

      // Call Cloudflare Worker API instead of GitHub directly
      final response = await dio.post(
        AppConfig.communityApiUrl,
        data: json.encode({
          'title': issueTitle,
          'body': issueBody,
          'labels': labels,
          'isVerification': isVerification,
        }),
        options: Options(
          headers: {'Content-Type': 'application/json'},
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        ),
      );

      // API returns 201 for success
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        return {
          'success': data['success'] ?? true,
          'isVerification': data['isVerification'] ?? isVerification,
          'prUrl': data['prUrl'] ?? data['issueUrl'], // Support both old and new API
          'prNumber': data['prNumber'] ?? data['issueNumber'],
          'message':
              data['message'] ??
              (isVerification
                  ? 'Thank you for verifying this mapping!'
                  : 'Thank you for contributing a new mapping!'),
        };
      } else {
        throw ServerException(
          message: 'Failed to create pull request: HTTP ${response.statusCode}',
          code: response.statusCode.toString(),
        );
      }
    } on DioException catch (e) {
      logger.error('Network error submitting mapping', e);

      // Handle specific HTTP error codes
      if (e.response?.statusCode == 429 || e.response?.statusCode == 403) {
        throw ServerException(
          message: 'Rate limit exceeded. Please try again later.',
          code: 'RATE_LIMIT',
        );
      }

      if (e.response?.statusCode == 400) {
        final errorData = e.response?.data;
        final errorMessage = errorData is Map
            ? errorData['error'] ?? 'Invalid submission'
            : 'Invalid submission';
        throw ServerException(
          message: errorMessage,
          code: 'INVALID_SUBMISSION',
        );
      }

      if (e.response?.statusCode == 500) {
        throw ServerException(
          message: 'Server error. Please try again later.',
          code: 'SERVER_ERROR',
        );
      }

      throw NetworkException(message: 'Failed to submit mapping: ${e.message}');
    } catch (e) {
      logger.error('Unexpected error submitting mapping', e);
      throw ServerException(
        message: 'Failed to submit mapping: $e',
        code: 'UNKNOWN',
      );
    }
  }

  /// Build the issue body with structured mapping data
  String _buildIssueBody({
    required String processName,
    required String twitchCategoryId,
    required String twitchCategoryName,
    String? windowTitle,
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

    buffer.writeln();
    buffer.writeln('### JSON for mappings.json');
    buffer.writeln();
    buffer.writeln('```json');
    buffer.writeln('{');
    buffer.writeln('  "processName": "$processName",');
    buffer.writeln('  "twitchCategoryId": "$twitchCategoryId",');
    buffer.writeln('  "twitchCategoryName": "$twitchCategoryName",');
    buffer.writeln('  "verificationCount": 1,');
    buffer.writeln(
      '  "lastVerified": "${DateTime.now().toIso8601String().split('T')[0]}"',
    );
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

  /// Build the verification issue body
  String _buildVerificationIssueBody({
    required String processName,
    required String twitchCategoryId,
    required String twitchCategoryName,
    required int currentVerificationCount,
    String? windowTitle,
  }) {
    final buffer = StringBuffer();

    buffer.writeln('## Mapping Verification');
    buffer.writeln();
    buffer.writeln('A user has verified an existing game mapping in TKit.');
    buffer.writeln();
    buffer.writeln('### Mapping Details');
    buffer.writeln();
    buffer.writeln('**Process Name:** `$processName`');
    buffer.writeln('**Twitch Category:** $twitchCategoryName');
    buffer.writeln('**Category ID:** `$twitchCategoryId`');
    buffer.writeln('**Current Verification Count:** $currentVerificationCount');
    buffer.writeln(
      '**New Verification Count:** ${currentVerificationCount + 1}',
    );

    if (windowTitle != null && windowTitle.isNotEmpty) {
      buffer.writeln('**Window Title:** $windowTitle');
    }

    buffer.writeln();
    buffer.writeln('### Action Required');
    buffer.writeln();
    buffer.writeln(
      '- [ ] Increment `verificationCount` to ${currentVerificationCount + 1}',
    );
    buffer.writeln(
      '- [ ] Update `lastVerified` to ${DateTime.now().toIso8601String().split('T')[0]}',
    );
    buffer.writeln('- [ ] Close this issue');
    buffer.writeln();
    buffer.writeln('### Updated JSON');
    buffer.writeln();
    buffer.writeln('```json');
    buffer.writeln('{');
    buffer.writeln('  "processName": "$processName",');
    buffer.writeln('  "twitchCategoryId": "$twitchCategoryId",');
    buffer.writeln('  "twitchCategoryName": "$twitchCategoryName",');
    buffer.writeln('  "verificationCount": ${currentVerificationCount + 1},');
    buffer.writeln(
      '  "lastVerified": "${DateTime.now().toIso8601String().split('T')[0]}"',
    );
    buffer.writeln('}');
    buffer.writeln('```');
    buffer.writeln();
    buffer.writeln('---');
    buffer.writeln();
    buffer.writeln('**Client Version:** ${AppConfig.appVersion}');
    buffer.writeln('**Submitted:** ${DateTime.now().toIso8601String()}');
    buffer.writeln();
    buffer.writeln(
      '🤖 *This verification was automatically generated by TKit*',
    );

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
        options: Options(receiveTimeout: const Duration(seconds: 10)),
      );
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      logger.warning('Community API availability check failed', e);
      return false;
    }
  }
}
