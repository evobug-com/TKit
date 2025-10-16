import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tkit/core/errors/exceptions.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/core/utils/app_logger.dart';
import 'package:tkit/features/twitch_api/data/datasources/twitch_api_remote_datasource.dart';
import 'package:tkit/features/twitch_api/data/models/twitch_category_model.dart';
import 'package:tkit/features/twitch_api/data/models/twitch_user_model.dart';
import 'package:tkit/features/twitch_api/data/repositories/twitch_api_repository_impl.dart';
import 'package:tkit/features/twitch_api/domain/entities/twitch_category.dart';
import 'package:tkit/features/twitch_api/domain/entities/twitch_user.dart';

import 'twitch_api_repository_impl_test.mocks.dart';

@GenerateMocks([TwitchApiRemoteDataSource, AppLogger])
void main() {
  late TwitchApiRepositoryImpl repository;
  late MockTwitchApiRemoteDataSource mockRemoteDataSource;
  late MockAppLogger mockLogger;

  setUp(() {
    mockRemoteDataSource = MockTwitchApiRemoteDataSource();
    mockLogger = MockAppLogger();
    repository = TwitchApiRepositoryImpl(mockRemoteDataSource, mockLogger);
  });

  group('searchCategories', () {
    const tQuery = 'League of Legends';
    const tFirst = 20;
    const tCategoryModels = [
      TwitchCategoryModel(
        id: '1',
        name: 'League of Legends',
        boxArtUrl: 'url1',
      ),
      TwitchCategoryModel(
        id: '2',
        name: 'Legends of Runeterra',
        boxArtUrl: 'url2',
      ),
    ];
    const List<TwitchCategory> tCategories = tCategoryModels;

    test(
      'should return list of categories when remote data source succeeds',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.searchCategories(any, first: anyNamed('first')),
        ).thenAnswer((_) async => tCategoryModels);

        // Act
        final result = await repository.searchCategories(tQuery, first: tFirst);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should return Right'),
          (categories) {
            expect(categories.length, tCategories.length);
            for (var i = 0; i < categories.length; i++) {
              expect(categories[i].id, tCategories[i].id);
              expect(categories[i].name, tCategories[i].name);
              expect(categories[i].boxArtUrl, tCategories[i].boxArtUrl);
            }
          },
        );
        verify(mockRemoteDataSource.searchCategories(tQuery, first: tFirst));
      },
    );

    test(
      'should return ServerFailure when ServerException is thrown',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.searchCategories(any, first: anyNamed('first')),
        ).thenThrow(
          const ServerException(message: 'Server error', code: '500'),
        );

        // Act
        final result = await repository.searchCategories(tQuery, first: tFirst);

        // Assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, 'Server error');
        }, (_) => fail('Should return failure'));
      },
    );

    test(
      'should return NetworkFailure when NetworkException is thrown',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.searchCategories(any, first: anyNamed('first')),
        ).thenThrow(const NetworkException(message: 'Network timeout'));

        // Act
        final result = await repository.searchCategories(tQuery, first: tFirst);

        // Assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<NetworkFailure>());
          expect(failure.message, 'Network timeout');
        }, (_) => fail('Should return failure'));
      },
    );

    test('should return AuthFailure when AuthException is thrown', () async {
      // Arrange
      when(
        mockRemoteDataSource.searchCategories(any, first: anyNamed('first')),
      ).thenThrow(const AuthException(message: 'Token expired', code: '401'));

      // Act
      final result = await repository.searchCategories(tQuery, first: tFirst);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<AuthFailure>());
        expect(failure.message, 'Token expired');
      }, (_) => fail('Should return failure'));
    });

    test(
      'should return UnknownFailure when unknown exception is thrown',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.searchCategories(any, first: anyNamed('first')),
        ).thenThrow(Exception('Unknown error'));

        // Act
        final result = await repository.searchCategories(tQuery, first: tFirst);

        // Assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<UnknownFailure>());
          expect(failure.message, contains('Failed to search categories'));
        }, (_) => fail('Should return failure'));
      },
    );

    test('should return empty list when no categories found', () async {
      // Arrange
      when(
        mockRemoteDataSource.searchCategories(any, first: anyNamed('first')),
      ).thenAnswer((_) async => []);

      // Act
      final result = await repository.searchCategories(tQuery, first: tFirst);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return Right'),
        (categories) => expect(categories, isEmpty),
      );
    });
  });

  group('updateChannelCategory', () {
    const tCategoryId = '12345';
    const tUserModel = TwitchUserModel(
      id: 'broadcaster123',
      login: 'testuser',
      displayName: 'TestUser',
    );

    test(
      'should update channel category when user fetch and update succeed',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.getCurrentUser(),
        ).thenAnswer((_) async => tUserModel);
        when(
          mockRemoteDataSource.updateChannelCategory(any, any),
        ).thenAnswer((_) async => {});

        // Act
        final result = await repository.updateChannelCategory(tCategoryId);

        // Assert
        expect(result, const Right(null));
        verify(mockRemoteDataSource.getCurrentUser());
        verify(
          mockRemoteDataSource.updateChannelCategory(
            'broadcaster123',
            tCategoryId,
          ),
        );
      },
    );

    test('should return failure when getCurrentUser fails', () async {
      // Arrange
      when(mockRemoteDataSource.getCurrentUser()).thenThrow(
        const ServerException(message: 'Failed to get user', code: '500'),
      );

      // Act
      final result = await repository.updateChannelCategory(tCategoryId);

      // Assert
      expect(result.isLeft(), true);
      verify(mockRemoteDataSource.getCurrentUser());
      verifyNever(mockRemoteDataSource.updateChannelCategory(any, any));
    });

    test('should return ServerFailure when update fails', () async {
      // Arrange
      when(
        mockRemoteDataSource.getCurrentUser(),
      ).thenAnswer((_) async => tUserModel);
      when(
        mockRemoteDataSource.updateChannelCategory(any, any),
      ).thenThrow(const ServerException(message: 'Update failed', code: '500'));

      // Act
      final result = await repository.updateChannelCategory(tCategoryId);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<ServerFailure>());
        expect(failure.message, 'Update failed');
      }, (_) => fail('Should return failure'));
    });

    test('should return AuthFailure when not authenticated', () async {
      // Arrange
      when(mockRemoteDataSource.getCurrentUser()).thenThrow(
        const AuthException(message: 'Not authenticated', code: '401'),
      );

      // Act
      final result = await repository.updateChannelCategory(tCategoryId);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<AuthFailure>());
      }, (_) => fail('Should return failure'));
    });
  });

  group('getCurrentUser', () {
    const tUserModel = TwitchUserModel(
      id: '123456',
      login: 'testuser',
      displayName: 'TestUser',
      profileImageUrl: 'https://example.com/avatar.png',
      email: 'test@example.com',
      broadcasterType: 'affiliate',
    );
    const TwitchUser tUser = tUserModel;

    test('should return TwitchUser when remote data source succeeds', () async {
      // Arrange
      when(
        mockRemoteDataSource.getCurrentUser(),
      ).thenAnswer((_) async => tUserModel);

      // Act
      final result = await repository.getCurrentUser();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return Right'),
        (user) {
          expect(user.id, tUser.id);
          expect(user.login, tUser.login);
          expect(user.displayName, tUser.displayName);
        },
      );
      verify(mockRemoteDataSource.getCurrentUser());
    });

    test(
      'should cache user data and return from cache on subsequent calls',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.getCurrentUser(),
        ).thenAnswer((_) async => tUserModel);

        // Act - First call should fetch from API
        final result1 = await repository.getCurrentUser();
        // Act - Second call should return from cache
        final result2 = await repository.getCurrentUser();

        // Assert
        expect(result1.isRight(), true);
        result1.fold(
          (_) => fail('Should return Right'),
          (user) {
            expect(user.id, tUser.id);
            expect(user.login, tUser.login);
            expect(user.displayName, tUser.displayName);
          },
        );
        expect(result2.isRight(), true);
        result2.fold(
          (_) => fail('Should return Right'),
          (user) {
            expect(user.id, tUser.id);
            expect(user.login, tUser.login);
            expect(user.displayName, tUser.displayName);
          },
        );
        // Should only call remote data source once
        verify(mockRemoteDataSource.getCurrentUser()).called(1);
      },
    );

    test('should refresh cache after cache duration expires', () async {
      // Arrange
      when(
        mockRemoteDataSource.getCurrentUser(),
      ).thenAnswer((_) async => tUserModel);

      // Act - First call
      await repository.getCurrentUser();

      // Simulate cache expiration by clearing cache
      repository.clearCache();

      // Second call after cache clear
      await repository.getCurrentUser();

      // Assert - Should call API twice
      verify(mockRemoteDataSource.getCurrentUser()).called(2);
    });

    test(
      'should return ServerFailure when ServerException is thrown',
      () async {
        // Arrange
        when(mockRemoteDataSource.getCurrentUser()).thenThrow(
          const ServerException(message: 'Server error', code: '500'),
        );

        // Act
        final result = await repository.getCurrentUser();

        // Assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, 'Server error');
        }, (_) => fail('Should return failure'));
      },
    );

    test(
      'should return NetworkFailure when NetworkException is thrown',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.getCurrentUser(),
        ).thenThrow(const NetworkException(message: 'Network error'));

        // Act
        final result = await repository.getCurrentUser();

        // Assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<NetworkFailure>());
        }, (_) => fail('Should return failure'));
      },
    );
  });

  group('getCategoryById', () {
    const tCategoryId = '12345';
    const tCategoryModel = TwitchCategoryModel(
      id: '12345',
      name: 'League of Legends',
      boxArtUrl: 'https://static-cdn.jtvnw.net/ttv-boxart/{width}x{height}.jpg',
    );
    const TwitchCategory tCategory = tCategoryModel;

    test(
      'should return TwitchCategory when remote data source succeeds',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.getCategoryById(any),
        ).thenAnswer((_) async => tCategoryModel);

        // Act
        final result = await repository.getCategoryById(tCategoryId);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should return Right'),
          (category) {
            expect(category.id, tCategory.id);
            expect(category.name, tCategory.name);
            expect(category.boxArtUrl, tCategory.boxArtUrl);
          },
        );
        verify(mockRemoteDataSource.getCategoryById(tCategoryId));
      },
    );

    test(
      'should return ServerFailure when ServerException is thrown',
      () async {
        // Arrange
        when(mockRemoteDataSource.getCategoryById(any)).thenThrow(
          const ServerException(message: 'Category not found', code: '404'),
        );

        // Act
        final result = await repository.getCategoryById(tCategoryId);

        // Assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, 'Category not found');
        }, (_) => fail('Should return failure'));
      },
    );

    test(
      'should return NetworkFailure when NetworkException is thrown',
      () async {
        // Arrange
        when(
          mockRemoteDataSource.getCategoryById(any),
        ).thenThrow(const NetworkException(message: 'Network timeout'));

        // Act
        final result = await repository.getCategoryById(tCategoryId);

        // Assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<NetworkFailure>());
        }, (_) => fail('Should return failure'));
      },
    );
  });

  group('clearCache', () {
    test('should clear user cache', () async {
      // Arrange
      const tUserModel = TwitchUserModel(
        id: '123456',
        login: 'testuser',
        displayName: 'TestUser',
      );
      when(
        mockRemoteDataSource.getCurrentUser(),
      ).thenAnswer((_) async => tUserModel);

      // Act - First call to populate cache
      await repository.getCurrentUser();
      // Clear cache
      repository.clearCache();
      // Second call after cache clear
      await repository.getCurrentUser();

      // Assert - Should fetch from API twice
      verify(mockRemoteDataSource.getCurrentUser()).called(2);
    });
  });
}
