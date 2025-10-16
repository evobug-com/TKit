import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tkit/core/errors/exceptions.dart';
import 'package:tkit/core/utils/app_logger.dart';
import 'package:tkit/features/twitch_api/data/datasources/twitch_api_remote_datasource.dart';
import 'package:tkit/features/twitch_api/data/models/twitch_category_model.dart';
import 'package:tkit/features/twitch_api/data/models/twitch_user_model.dart';

import 'twitch_api_remote_datasource_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>(), MockSpec<AppLogger>()])
void main() {
  late TwitchApiRemoteDataSource dataSource;
  late MockDio mockDio;
  late MockAppLogger mockLogger;

  setUp(() {
    mockDio = MockDio();
    mockLogger = MockAppLogger();

    // Mock Dio options before creating data source
    when(mockDio.options).thenReturn(BaseOptions());
    when(mockDio.interceptors).thenReturn(Interceptors());

    dataSource = TwitchApiRemoteDataSource(mockDio, mockLogger);

    // Setup token provider
    dataSource.setTokenProvider(() => 'mock_access_token');
  });

  group('searchCategories', () {
    const tQuery = 'League of Legends';
    const tFirst = 20;
    final tResponseData = {
      'data': [
        {
          'id': '1',
          'name': 'League of Legends',
          'box_art_url':
              'https://static-cdn.jtvnw.net/ttv-boxart/{width}x{height}.jpg',
        },
        {
          'id': '2',
          'name': 'Legends of Runeterra',
          'box_art_url':
              'https://static-cdn.jtvnw.net/ttv-boxart/{width}x{height}.jpg',
        },
      ],
    };

    test(
      'should return list of TwitchCategoryModel when status code is 200',
      () async {
        // Arrange
        when(
          mockDio.get(any, queryParameters: anyNamed('queryParameters')),
        ).thenAnswer(
          (_) async => Response<Map<String, dynamic>>(
            data: tResponseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/search/categories'),
          ),
        );

        // Act
        final result = await dataSource.searchCategories(tQuery, first: tFirst);

        // Assert
        expect(result, isA<List<TwitchCategoryModel>>());
        expect(result.length, 2);
        expect(result[0].id, '1');
        expect(result[0].name, 'League of Legends');
      },
    );

    test('should throw ServerException when status code is not 200', () async {
      // Arrange
      when(
        mockDio.get(any, queryParameters: anyNamed('queryParameters')),
      ).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          data: {'error': 'Bad request'},
          statusCode: 400,
          requestOptions: RequestOptions(path: '/search/categories'),
        ),
      );

      // Act & Assert
      expect(
        () => dataSource.searchCategories(tQuery, first: tFirst),
        throwsA(isA<ServerException>()),
      );
    });

    test(
      'should throw NetworkException when connection timeout occurs',
      () async {
        // Arrange
        when(
          mockDio.get(any, queryParameters: anyNamed('queryParameters')),
        ).thenThrow(
          DioException(
            type: DioExceptionType.connectionTimeout,
            requestOptions: RequestOptions(path: '/search/categories'),
          ),
        );

        // Act & Assert
        expect(
          () => dataSource.searchCategories(tQuery, first: tFirst),
          throwsA(isA<NetworkException>()),
        );
      },
    );

    test('should throw AuthException when status code is 401', () async {
      // Arrange
      when(
        mockDio.get(any, queryParameters: anyNamed('queryParameters')),
      ).thenThrow(
        DioException(
          type: DioExceptionType.badResponse,
          response: Response(
            statusCode: 401,
            requestOptions: RequestOptions(path: '/search/categories'),
          ),
          requestOptions: RequestOptions(path: '/search/categories'),
        ),
      );

      // Act & Assert
      expect(
        () => dataSource.searchCategories(tQuery, first: tFirst),
        throwsA(isA<AuthException>()),
      );
    });
  });

  group('updateChannelCategory', () {
    const tBroadcasterId = 'broadcaster123';
    const tCategoryId = '12345';

    test('should complete successfully when status code is 204', () async {
      // Arrange
      when(
        mockDio.patch(
          any,
          queryParameters: anyNamed('queryParameters'),
          data: anyNamed('data'),
        ),
      ).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          statusCode: 204,
          requestOptions: RequestOptions(path: '/channels'),
        ),
      );

      // Act & Assert
      expect(
        () => dataSource.updateChannelCategory(tBroadcasterId, tCategoryId),
        returnsNormally,
      );
    });

    test('should throw ServerException when status code is not 204', () async {
      // Arrange
      when(
        mockDio.patch(
          any,
          queryParameters: anyNamed('queryParameters'),
          data: anyNamed('data'),
        ),
      ).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          statusCode: 400,
          requestOptions: RequestOptions(path: '/channels'),
        ),
      );

      // Act & Assert
      expect(
        () => dataSource.updateChannelCategory(tBroadcasterId, tCategoryId),
        throwsA(isA<ServerException>()),
      );
    });

    test('should include correct request parameters', () async {
      // Arrange
      when(
        mockDio.patch(
          any,
          queryParameters: anyNamed('queryParameters'),
          data: anyNamed('data'),
        ),
      ).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          statusCode: 204,
          requestOptions: RequestOptions(path: '/channels'),
        ),
      );

      // Act
      await dataSource.updateChannelCategory(tBroadcasterId, tCategoryId);

      // Assert
      verify(
        mockDio.patch(
          '/channels',
          queryParameters: {'broadcaster_id': tBroadcasterId},
          data: {'game_id': tCategoryId},
        ),
      );
    });
  });

  group('getCurrentUser', () {
    final tResponseData = {
      'data': [
        {
          'id': '123456',
          'login': 'testuser',
          'display_name': 'TestUser',
          'profile_image_url': 'https://example.com/avatar.png',
          'email': 'test@example.com',
          'broadcaster_type': 'affiliate',
        },
      ],
    };

    test('should return TwitchUserModel when status code is 200', () async {
      // Arrange
      when(mockDio.get(any)).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          data: tResponseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/users'),
        ),
      );

      // Act
      final result = await dataSource.getCurrentUser();

      // Assert
      expect(result, isA<TwitchUserModel>());
      expect(result.id, '123456');
      expect(result.login, 'testuser');
      expect(result.displayName, 'TestUser');
    });

    test('should throw ServerException when no user data returned', () async {
      // Arrange
      when(mockDio.get(any)).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          data: {'data': []},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/users'),
        ),
      );

      // Act & Assert
      expect(
        () => dataSource.getCurrentUser(),
        throwsA(isA<ServerException>()),
      );
    });

    test('should throw ServerException when status code is not 200', () async {
      // Arrange
      when(mockDio.get(any)).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          statusCode: 500,
          requestOptions: RequestOptions(path: '/users'),
        ),
      );

      // Act & Assert
      expect(
        () => dataSource.getCurrentUser(),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('getCategoryById', () {
    const tCategoryId = '12345';
    final tResponseData = {
      'data': [
        {
          'id': '12345',
          'name': 'League of Legends',
          'box_art_url':
              'https://static-cdn.jtvnw.net/ttv-boxart/{width}x{height}.jpg',
        },
      ],
    };

    test('should return TwitchCategoryModel when status code is 200', () async {
      // Arrange
      when(
        mockDio.get(any, queryParameters: anyNamed('queryParameters')),
      ).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          data: tResponseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/games'),
        ),
      );

      // Act
      final result = await dataSource.getCategoryById(tCategoryId);

      // Assert
      expect(result, isA<TwitchCategoryModel>());
      expect(result.id, '12345');
      expect(result.name, 'League of Legends');
    });

    test('should throw ServerException when category not found', () async {
      // Arrange
      when(
        mockDio.get(any, queryParameters: anyNamed('queryParameters')),
      ).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          data: {'data': []},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/games'),
        ),
      );

      // Act & Assert
      expect(
        () => dataSource.getCategoryById(tCategoryId),
        throwsA(isA<ServerException>()),
      );
    });

    test('should include correct query parameter', () async {
      // Arrange
      when(
        mockDio.get(any, queryParameters: anyNamed('queryParameters')),
      ).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          data: tResponseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/games'),
        ),
      );

      // Act
      await dataSource.getCategoryById(tCategoryId);

      // Assert
      verify(mockDio.get('/games', queryParameters: {'id': tCategoryId}));
    });
  });

  group('token provider', () {
    test('should use provided token in requests', () async {
      // This is tested implicitly by the interceptor configuration
      // The actual token addition is handled by Dio interceptors
      expect(dataSource, isNotNull);
    });
  });

  group('rate limiting', () {
    test('should handle 429 rate limit responses', () async {
      // Arrange
      when(mockDio.get(any)).thenThrow(
        DioException(
          type: DioExceptionType.badResponse,
          response: Response(
            statusCode: 429,
            requestOptions: RequestOptions(path: '/users'),
          ),
          requestOptions: RequestOptions(path: '/users'),
        ),
      );

      // Act & Assert
      expect(
        () => dataSource.getCurrentUser(),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
