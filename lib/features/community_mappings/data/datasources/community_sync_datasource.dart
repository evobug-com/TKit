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

  // GitHub repository URLs for community mappings
  static const _mappingsUrl =
      'https://raw.githubusercontent.com/evobug-com/tkit-community-mapping/refs/heads/main/mappings.json';
  static const _programsUrl =
      'https://raw.githubusercontent.com/evobug-com/tkit-community-mapping/refs/heads/main/programs.json';

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

  /// Fetch community mappings from GitHub (both games and programs)
  ///
  /// Returns a map containing:
  /// - version: String
  /// - lastUpdated: String (ISO date)
  /// - mappings: List\<Map\<String, dynamic>> (combined games + programs)
  ///
  /// Throws [NetworkException] on connection errors
  /// Throws [ServerException] on HTTP errors
  Future<Map<String, dynamic>> fetchMappings() async {
    try {
      logger.info('Fetching community mappings (games + programs) from GitHub');

      // Fetch both mappings.json and programs.json concurrently
      final results = await Future.wait([
        _fetchJsonFile(_mappingsUrl, 'games'),
        _fetchJsonFile(_programsUrl, 'programs'),
      ]);

      final gamesData = results[0];
      final programsData = results[1];

      // Merge both mappings lists with proper type casting
      final gamesList = (gamesData['mappings'] as List)
          .map((e) => e as Map<String, dynamic>)
          .toList();
      final programsList = (programsData['mappings'] as List)
          .map((e) => e as Map<String, dynamic>)
          .toList();

      final allMappings = <Map<String, dynamic>>[
        ...gamesList,
        ...programsList,
      ];

      _lastSyncTime = DateTime.now();

      logger.info(
        'Fetched ${gamesList.length} games and ${programsList.length} programs '
        '(${allMappings.length} total mappings)',
      );

      // Return merged data with latest version/timestamp
      return {
        'version': gamesData['version'] ?? programsData['version'] ?? '1.0',
        'lastUpdated': gamesData['lastUpdated'] ?? programsData['lastUpdated'],
        'mappings': allMappings,
      };
    } catch (e) {
      // If we fail, it will be caught by the existing error handlers
      rethrow;
    }
  }

  /// Fetch a single JSON file from GitHub
  ///
  /// [url] - The URL to fetch
  /// [type] - Type description for logging ('games' or 'programs')
  ///
  /// Returns the parsed JSON data
  Future<Map<String, dynamic>> _fetchJsonFile(String url, String type) async {
    try {
      logger.debug('Fetching $type from: $url');

      final response = await dio.get(
        url,
        options: Options(
          responseType: ResponseType.plain,
          receiveTimeout: NetworkConfig.standardTimeout,
          sendTimeout: NetworkConfig.standardTimeout,
          validateStatus: (status) => true, // Accept all status codes, handle manually
        ),
      );

      if (response.statusCode != 200) {
        // For programs.json, if it doesn't exist yet, return empty data
        if (url == _programsUrl && response.statusCode == 404) {
          logger.warning('programs.json not found (404), returning empty list');
          return {
            'version': '1.0',
            'mappings': <Map<String, dynamic>>[],
          };
        }

        throw ServerException(
          message: 'Unable to download community $type. Please try again later.',
          code: response.statusCode.toString(),
          technicalDetails: 'HTTP ${response.statusCode}',
        );
      }

      final data = json.decode(response.data as String) as Map<String, dynamic>;

      // Validate response structure - expect 'mappings' field
      if (!data.containsKey('mappings')) {
        final availableKeys = data.keys.join(', ');
        logger.error('Missing mappings field. Available keys: $availableKeys');
        throw ServerException(
          message: 'Community $type data is invalid. This will be fixed in the next update.',
          code: 'INVALID_DATA',
          technicalDetails: 'Missing "mappings" field. Available keys: $availableKeys',
        );
      }

      if (data['mappings'] is! List) {
        final actualType = data['mappings'].runtimeType;
        logger.error('Invalid mappings field type: $actualType');
        throw ServerException(
          message: 'Community $type data is invalid. This will be fixed in the next update.',
          code: 'INVALID_DATA',
          technicalDetails: 'Expected "mappings" to be a List, but got $actualType',
        );
      }

      final mappings = data['mappings'] as List;
      logger.debug('Fetched ${mappings.length} $type');

      return data;
    } on DioException catch (e, stackTrace) {
      logger.error('Network error fetching community mappings', e, stackTrace);
      throw NetworkException(
        message: 'Unable to download community mappings. Please check your internet connection.',
        originalError: e,
        technicalDetails: 'Network error: ${e.message}',
      );
    } on FormatException catch (e, stackTrace) {
      logger.error('JSON parse error', e, stackTrace);
      throw ServerException(
        message: 'Community mappings data is corrupted. This will be fixed in the next update.',
        code: 'PARSE_ERROR',
        originalError: e,
        technicalDetails: 'JSON parse error: ${e.message}',
      );
    } catch (e, stackTrace) {
      logger.error('Unexpected error fetching mappings', e, stackTrace);
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
