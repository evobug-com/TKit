import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tkit/core/utils/app_logger.dart';
import 'package:tkit/features/twitch_api/data/datasources/twitch_api_remote_datasource.dart';
import 'package:tkit/features/twitch_api/data/repositories/twitch_api_repository_impl.dart';
import 'package:tkit/features/twitch_api/domain/usecases/search_categories_usecase.dart';
import 'package:tkit/features/twitch_api/presentation/providers/twitch_api_provider.dart';

@GenerateMocks([Dio, AppLogger])
import 'twitch_api_integration_test.mocks.dart';

/// Integration test for the Twitch API feature
/// Tests the complete flow from Provider → UseCase → Repository → DataSource
void main() {
  late TwitchApiProvider provider;
  late SearchCategoriesUseCase searchCategoriesUseCase;
  late TwitchApiRepositoryImpl repository;
  late TwitchApiRemoteDataSource dataSource;
  late MockDio mockDio;
  late MockAppLogger mockLogger;

  setUp(() {
    mockDio = MockDio();
    mockLogger = MockAppLogger();

    // Set up Dio mock options and interceptors BEFORE creating TwitchApiRemoteDataSource
    when(mockDio.options).thenReturn(BaseOptions());
    when(mockDio.interceptors).thenReturn(Interceptors());

    // Build the complete dependency tree
    dataSource = TwitchApiRemoteDataSource(mockDio, mockLogger);
    repository = TwitchApiRepositoryImpl(dataSource, mockLogger);
    searchCategoriesUseCase = SearchCategoriesUseCase(repository);
    provider = TwitchApiProvider(searchCategoriesUseCase, mockLogger);

    // Set up token provider
    dataSource.setTokenProvider(() => 'mock_token_12345');
  });

  tearDown(() {
    provider.dispose();
  });

  group('Twitch API Integration Test', () {
    test('complete category search flow should work end-to-end', () async {
      // Arrange - Mock successful API response
      final mockResponse = Response(
        requestOptions: RequestOptions(path: '/search/categories'),
        statusCode: 200,
        data: {
          'data': [
            {
              'id': '509658',
              'name': 'Just Chatting',
              'boxArtUrl':
                  'https://static-cdn.jtvnw.net/ttv-boxart/{width}x{height}.jpg',
            },
            {
              'id': '27471',
              'name': 'Minecraft',
              'boxArtUrl':
                  'https://static-cdn.jtvnw.net/ttv-boxart/{width}x{height}.jpg',
            },
          ],
        },
      );

      when(
        mockDio.get(any, queryParameters: anyNamed('queryParameters')),
      ).thenAnswer((_) async => mockResponse);

      // Act
      await provider.searchCategories('Just');

      // Assert
      expect(provider.isLoading, false);
      expect(provider.categories.length, 2);
      expect(provider.categories.first.name, 'Just Chatting');
      expect(provider.errorMessage, isNull);
      expect(provider.currentQuery, 'Just');
    });

    test('should handle API errors gracefully', () async {
      // Arrange - Mock API error
      when(
        mockDio.get(any, queryParameters: anyNamed('queryParameters')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/search/categories'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/search/categories'),
            statusCode: 500,
          ),
        ),
      );

      // Act
      await provider.searchCategories('Error');

      // Assert
      expect(provider.isLoading, false);
      expect(provider.categories, isEmpty);
      expect(provider.errorMessage, contains('Server error'));
    });

    test('should handle network timeout', () async {
      // Arrange - Mock network timeout
      when(
        mockDio.get(any, queryParameters: anyNamed('queryParameters')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/search/categories'),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      // Act
      await provider.searchCategories('Timeout');

      // Assert
      expect(provider.isLoading, false);
      expect(provider.categories, isEmpty);
      expect(provider.errorMessage, contains('Network'));
    });

    test('should handle empty results', () async {
      // Arrange - Mock empty API response
      final mockResponse = Response(
        requestOptions: RequestOptions(path: '/search/categories'),
        statusCode: 200,
        data: {'data': []},
      );

      when(
        mockDio.get(any, queryParameters: anyNamed('queryParameters')),
      ).thenAnswer((_) async => mockResponse);

      // Act
      await provider.searchCategories('NonExistent');

      // Assert
      expect(provider.isLoading, false);
      expect(provider.categories.length, 0);
      expect(provider.errorMessage, isNull);
      expect(provider.currentQuery, 'NonExistent');
    });

    test('should validate input before making API call', () async {
      // Act - Empty query
      await provider.searchCategories('');

      // Assert - Should not call API
      expect(provider.categories, isEmpty);
      expect(provider.currentQuery, isEmpty);
      expect(provider.errorMessage, isNull);

      verifyNever(
        mockDio.get(any, queryParameters: anyNamed('queryParameters')),
      );
    });
  });
}
