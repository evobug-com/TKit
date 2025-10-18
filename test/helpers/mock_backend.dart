import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

/// Mock backend for integration tests
///
/// Usage:
/// ```dart
/// final dio = Dio();
/// final mockBackend = MockBackend(dio);
///
/// // Define responses
/// mockBackend
///   .onPost('/submit')
///   .reply(200, {'prUrl': 'https://github.com/test/pr/123'});
///
/// // Use dio normally - requests will be intercepted
/// ```
class MockBackend {
  final DioAdapter _adapter;

  MockBackend(Dio dio) : _adapter = DioAdapter(dio: dio) {
    dio.httpClientAdapter = _adapter;
  }

  DioAdapter get adapter => _adapter;

  /// Mock a GET request
  MockBackendRequest onGet(String path) {
    return MockBackendRequest(_adapter, 'GET', path);
  }

  /// Mock a POST request
  MockBackendRequest onPost(String path) {
    return MockBackendRequest(_adapter, 'POST', path);
  }

  /// Mock a PATCH request
  MockBackendRequest onPatch(String path) {
    return MockBackendRequest(_adapter, 'PATCH', path);
  }

  /// Mock a DELETE request
  MockBackendRequest onDelete(String path) {
    return MockBackendRequest(_adapter, 'DELETE', path);
  }
}

/// Fluent API for setting up mock responses
class MockBackendRequest {
  final DioAdapter _adapter;
  final String _method;
  final String _path;
  Map<String, dynamic>? _queryParameters;
  dynamic _requestData;

  MockBackendRequest(this._adapter, this._method, this._path);

  /// Match specific query parameters
  MockBackendRequest withQueryParameters(Map<String, dynamic> params) {
    _queryParameters = params;
    return this;
  }

  /// Match specific request body
  MockBackendRequest withData(dynamic data) {
    _requestData = data;
    return this;
  }

  /// Reply with status code and data
  void reply(int statusCode, dynamic data) {
    switch (_method) {
      case 'GET':
        _adapter.onGet(
          _path,
          (server) => server.reply(
            statusCode,
            data,
            delay: const Duration(milliseconds: 100),
          ),
          queryParameters: _queryParameters,
        );
      case 'POST':
        _adapter.onPost(
          _path,
          (server) => server.reply(
            statusCode,
            data,
            delay: const Duration(milliseconds: 100),
          ),
          queryParameters: _queryParameters,
          data: _requestData,
        );
      case 'PATCH':
        _adapter.onPatch(
          _path,
          (server) => server.reply(
            statusCode,
            data,
            delay: const Duration(milliseconds: 100),
          ),
          queryParameters: _queryParameters,
          data: _requestData,
        );
      case 'DELETE':
        _adapter.onDelete(
          _path,
          (server) => server.reply(
            statusCode,
            data,
            delay: const Duration(milliseconds: 100),
          ),
          queryParameters: _queryParameters,
        );
    }
  }

  /// Reply with an error
  void replyError(int statusCode, dynamic errorData) {
    reply(statusCode, errorData);
  }

  /// Reply with a network timeout
  void replyTimeout() {
    switch (_method) {
      case 'GET':
        _adapter.onGet(
          _path,
          (server) => server.throws(
            408,
            DioException(
              type: DioExceptionType.connectionTimeout,
              requestOptions: RequestOptions(path: _path),
            ),
          ),
          queryParameters: _queryParameters,
        );
      case 'POST':
        _adapter.onPost(
          _path,
          (server) => server.throws(
            408,
            DioException(
              type: DioExceptionType.connectionTimeout,
              requestOptions: RequestOptions(path: _path),
            ),
          ),
          queryParameters: _queryParameters,
        );
      case 'PATCH':
        _adapter.onPatch(
          _path,
          (server) => server.throws(
            408,
            DioException(
              type: DioExceptionType.connectionTimeout,
              requestOptions: RequestOptions(path: _path),
            ),
          ),
          queryParameters: _queryParameters,
        );
      case 'DELETE':
        _adapter.onDelete(
          _path,
          (server) => server.throws(
            408,
            DioException(
              type: DioExceptionType.connectionTimeout,
              requestOptions: RequestOptions(path: _path),
            ),
          ),
          queryParameters: _queryParameters,
        );
    }
  }
}

/// Pre-defined mock responses for common scenarios
class MockResponses {
  /// Successful mapping submission
  static Map<String, dynamic> mappingSubmissionSuccess({
    String prUrl = 'https://github.com/test/pr/123',
    int prNumber = 123,
  }) {
    return {
      'prUrl': prUrl,
      'prNumber': prNumber,
      'message': 'PR created successfully',
    };
  }

  /// Twitch category search results
  static Map<String, dynamic> twitchSearchCategories(
    List<Map<String, String>> categories,
  ) {
    return {
      'data': categories
          .map(
            (cat) => {
              'id': cat['id'],
              'name': cat['name'],
              'box_art_url':
                  cat['box_art_url'] ??
                  'https://static-cdn.jtvnw.net/ttv-boxart/{width}x{height}.jpg',
            },
          )
          .toList(),
    };
  }

  /// Twitch user data
  static Map<String, dynamic> twitchUserData({
    String id = '123456',
    String login = 'testuser',
    String displayName = 'TestUser',
  }) {
    return {
      'data': [
        {
          'id': id,
          'login': login,
          'display_name': displayName,
          'profile_image_url': 'https://example.com/avatar.png',
          'email': 'test@example.com',
          'broadcaster_type': 'affiliate',
        },
      ],
    };
  }

  /// Twitch category by ID
  static Map<String, dynamic> twitchCategoryById({
    String id = '12345',
    String name = 'Test Game',
  }) {
    return {
      'data': [
        {
          'id': id,
          'name': name,
          'box_art_url':
              'https://static-cdn.jtvnw.net/ttv-boxart/{width}x{height}.jpg',
        },
      ],
    };
  }

  /// Error response
  static Map<String, dynamic> error(String message, {int status = 400}) {
    return {'error': message, 'status': status, 'message': message};
  }
}
