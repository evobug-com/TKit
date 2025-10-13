import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:tkit/core/errors/exceptions.dart';
import 'package:tkit/core/network/network_config.dart';
import 'package:tkit/core/utils/app_logger.dart';

/// Data source for syncing community mappings from GitHub
///
/// Downloads the crowdsourced mappings.json file from the GitHub repository
/// and provides it to the repository for database updates.
class CommunitySyncDataSource {
  final Dio dio;
  final AppLogger logger;

  // GitHub repository URL for community mappings
  static const _mappingsUrl =
      'https://raw.githubusercontent.com/evobug-com/tkit-community-mapping/refs/heads/main/mappings.json';

  // Cache duration before fetching new data
  static const _cacheDuration = Duration(hours: 6);

  DateTime? _lastSyncTime;

  CommunitySyncDataSource({
    required this.dio,
    required this.logger,
  });

  /// Check if sync is needed based on cache duration
  bool shouldSync() {
    if (_lastSyncTime == null) return true;
    return DateTime.now().difference(_lastSyncTime!) > _cacheDuration;
  }

  /// Fetch community mappings from GitHub
  ///
  /// Returns a map containing:
  /// - version: String
  /// - lastUpdated: String (ISO date)
  /// - mappings: List\<Map\<String, dynamic>>
  ///
  /// Throws [NetworkException] on connection errors
  /// Throws [ServerException] on HTTP errors
  Future<Map<String, dynamic>> fetchMappings() async {
    try {
      logger.info('Fetching community mappings from GitHub');

      final response = await dio.get(
        _mappingsUrl,
        options: Options(
          responseType: ResponseType.plain,
          receiveTimeout: NetworkConfig.standardTimeout,
          sendTimeout: NetworkConfig.standardTimeout,
        ),
      );

      if (response.statusCode != 200) {
        throw ServerException(
          message: 'Unable to download community mappings. Please try again later.',
          code: response.statusCode.toString(),
          technicalDetails: 'HTTP ${response.statusCode}',
        );
      }

      final data = json.decode(response.data as String) as Map<String, dynamic>;

      // Validate response structure
      if (!data.containsKey('mappings') || data['mappings'] is! List) {
        throw ServerException(
          message: 'Community mappings data is invalid. This will be fixed in the next update.',
          code: 'INVALID_DATA',
          technicalDetails: 'Missing or invalid mappings field',
        );
      }

      _lastSyncTime = DateTime.now();

      final mappings = data['mappings'] as List;
      logger.info('Fetched ${mappings.length} community mappings');

      return data;
    } on DioException catch (e) {
      logger.error('Network error fetching community mappings', e);
      throw NetworkException(
        message: 'Unable to download community mappings. Please check your internet connection.',
        originalError: e,
        technicalDetails: 'Network error: ${e.message}',
      );
    } on FormatException catch (e) {
      logger.error('JSON parse error', e);
      throw ServerException(
        message: 'Community mappings data is corrupted. This will be fixed in the next update.',
        code: 'PARSE_ERROR',
        originalError: e,
        technicalDetails: 'JSON parse error: ${e.message}',
      );
    } catch (e) {
      logger.error('Unexpected error fetching mappings', e);
      throw ServerException(
        message: 'Unable to fetch community mappings. Please try again later.',
        code: 'UNKNOWN',
        originalError: e,
        technicalDetails: e.toString(),
      );
    }
  }

  /// Get last sync time
  DateTime? get lastSyncTime => _lastSyncTime;

  /// Force reset sync time to trigger fresh sync
  void resetSyncTime() {
    _lastSyncTime = null;
  }
}
