import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:tkit/core/utils/app_logger.dart';
import 'package:tkit/features/mapping_lists/domain/entities/mapping_list_item.dart';

/// Metadata and mappings fetched from a remote list
class RemoteListData {
  final String? name;
  final String? description;
  final bool isReadOnly;
  final String? submissionHookUrl;
  final List<MappingListItem> mappings;

  RemoteListData({
    this.name,
    this.description,
    this.isReadOnly = true,
    this.submissionHookUrl,
    required this.mappings,
  });
}

/// Remote data source for syncing mapping lists from URLs
class MappingListSyncDataSource {
  final Dio _dio;
  final _logger = AppLogger();

  MappingListSyncDataSource(this._dio);

  /// Fetch mappings and metadata from a remote URL
  /// Returns list data with metadata and mapping items parsed from JSON
  Future<RemoteListData> fetchListFromUrl(String url) async {
    try {
      _logger.info('Fetching list from: $url');
      final response = await _dio.get(
        url,
        options: Options(
          responseType: ResponseType.json,
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode != 200) {
        _logger.error('Failed to fetch list from $url: HTTP ${response.statusCode}');
        throw Exception('Failed to fetch list from $url: HTTP ${response.statusCode}');
      }

      var data = response.data;

      // If data is a String, manually decode it as JSON
      if (data is String) {
        try {
          data = jsonDecode(data);
        } catch (e) {
          throw Exception('Failed to parse JSON response: $e');
        }
      }

      // Handle both array format and object format with metadata
      List<dynamic> mappingsJson;
      String? name;
      String? description;
      bool isReadOnly = true; // Default to readonly
      String? submissionHookUrl;

      if (data is List) {
        // Simple array format: just mappings, no metadata
        mappingsJson = data;
      } else if (data is Map) {
        // Object format with metadata
        mappingsJson = data['mappings'] as List? ?? [];
        name = data['name'] as String?;
        description = data['description'] as String?;
        isReadOnly = data['isReadOnly'] as bool? ?? data['readonly'] as bool? ?? true;
        submissionHookUrl = data['submissionHookUrl'] as String? ?? data['submissionHook'] as String?;
      } else {
        // Debug: log the actual data type and structure
        final dataType = data.runtimeType;
        final dataPreview = data.toString().substring(0, data.toString().length > 200 ? 200 : data.toString().length);
        throw Exception('Invalid list format: Expected array or object with "mappings" field. Got type: $dataType. Preview: $dataPreview');
      }

      final mappings = mappingsJson.map((json) => _parseMappingItem(json)).toList();

      return RemoteListData(
        name: name,
        description: description,
        isReadOnly: isReadOnly,
        submissionHookUrl: submissionHookUrl,
        mappings: mappings,
      );
    } on DioException catch (e, stackTrace) {
      _logger.error('Network error fetching list', e, stackTrace);
      throw Exception('Network error fetching list: ${e.message}');
    } catch (e, stackTrace) {
      _logger.error('Error parsing list', e, stackTrace);
      throw Exception('Error parsing list: $e');
    }
  }

  /// Parse a single mapping item from JSON
  MappingListItem _parseMappingItem(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw Exception('Invalid mapping format: Expected object');
    }

    return MappingListItem(
      processName: json['processName'] as String,
      normalizedInstallPaths: _parseInstallPaths(json['normalizedInstallPaths']),
      twitchCategoryId: json['twitchCategoryId'].toString(),
      twitchCategoryName: json['twitchCategoryName'] as String,
      verificationCount: json['verificationCount'] as int? ?? 1,
      category: json['category'] as String?,
    );
  }

  /// Parse installation paths from various formats
  List<String> _parseInstallPaths(dynamic paths) {
    if (paths == null) return [];

    if (paths is List) {
      return paths.map((e) => e.toString()).toList();
    }

    if (paths is String) {
      // Handle comma-separated string
      return paths.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    }

    return [];
  }

  /// Validate that a URL returns valid list data without fully parsing it
  Future<bool> validateListUrl(String url) async {
    try {
      final response = await _dio.head(url);
      return response.statusCode == 200;
    } catch (e, stackTrace) {
      _logger.error('Failed to validate list URL', e, stackTrace);
      return false;
    }
  }
}
