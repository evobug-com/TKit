import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/core/utils/app_logger.dart';
import 'package:tkit/features/twitch_api/domain/entities/twitch_category.dart';
import 'package:tkit/features/twitch_api/domain/usecases/search_categories_usecase.dart';
import 'package:tkit/features/twitch_api/presentation/providers/twitch_api_provider.dart';

import 'twitch_api_provider_test.mocks.dart';

@GenerateMocks([SearchCategoriesUseCase, AppLogger])
void main() {
  late TwitchApiProvider provider;
  late MockSearchCategoriesUseCase mockSearchCategoriesUseCase;
  late MockAppLogger mockLogger;

  setUp(() {
    mockSearchCategoriesUseCase = MockSearchCategoriesUseCase();
    mockLogger = MockAppLogger();
    provider = TwitchApiProvider(mockSearchCategoriesUseCase, mockLogger);
  });

  tearDown(() {
    provider.dispose();
  });

  group('TwitchApiProvider', () {
    const tQuery = 'League of Legends';
    const tCategories = [
      TwitchCategory(id: '1', name: 'League of Legends', boxArtUrl: 'url1'),
      TwitchCategory(id: '2', name: 'Legends of Runeterra', boxArtUrl: 'url2'),
    ];

    test('initial state should be correct', () {
      expect(provider.isLoading, false);
      expect(provider.categories, isEmpty);
      expect(provider.errorMessage, isNull);
      expect(provider.currentQuery, isEmpty);
      expect(provider.hasSearched, false);
    });

    group('searchCategories', () {
      test('should update state correctly when search succeeds', () async {
        when(
          mockSearchCategoriesUseCase(any, first: anyNamed('first')),
        ).thenAnswer((_) async => const Right(tCategories));

        await provider.searchCategories(tQuery);

        expect(provider.isLoading, false);
        expect(provider.categories, tCategories);
        expect(provider.errorMessage, isNull);
        expect(provider.currentQuery, tQuery);
        expect(provider.hasSearched, true);
        verify(mockSearchCategoriesUseCase(tQuery, first: 20)).called(1);
      });

      test('should update state correctly when search fails', () async {
        when(
          mockSearchCategoriesUseCase(any, first: anyNamed('first')),
        ).thenAnswer(
          (_) async =>
              const Left(ServerFailure(message: 'Server error', code: '500')),
        );

        await provider.searchCategories(tQuery);

        expect(provider.isLoading, false);
        expect(provider.categories, isEmpty);
        expect(provider.errorMessage, 'Server error');
        expect(provider.currentQuery, tQuery);
      });

      test('should clear state when query is empty', () async {
        await provider.searchCategories('');

        expect(provider.isLoading, false);
        expect(provider.categories, isEmpty);
        expect(provider.errorMessage, isNull);
        expect(provider.currentQuery, isEmpty);
        verifyNever(
          mockSearchCategoriesUseCase(any, first: anyNamed('first')),
        );
      });

      test('should clear state when query is only whitespace', () async {
        await provider.searchCategories('   ');

        expect(provider.isLoading, false);
        expect(provider.categories, isEmpty);
        expect(provider.errorMessage, isNull);
        expect(provider.currentQuery, isEmpty);
        verifyNever(
          mockSearchCategoriesUseCase(any, first: anyNamed('first')),
        );
      });

      test('should use custom maxResults when provided', () async {
        when(
          mockSearchCategoriesUseCase(any, first: anyNamed('first')),
        ).thenAnswer((_) async => const Right(tCategories));

        await provider.searchCategories(tQuery, maxResults: 50);

        verify(mockSearchCategoriesUseCase(tQuery, first: 50)).called(1);
      });

      test('should handle empty list when no categories found', () async {
        when(
          mockSearchCategoriesUseCase(any, first: anyNamed('first')),
        ).thenAnswer((_) async => const Right([]));

        await provider.searchCategories(tQuery);

        expect(provider.isLoading, false);
        expect(provider.categories, isEmpty);
        expect(provider.errorMessage, isNull);
        expect(provider.currentQuery, tQuery);
      });

      test('should handle NetworkFailure', () async {
        when(
          mockSearchCategoriesUseCase(any, first: anyNamed('first')),
        ).thenAnswer(
          (_) async => const Left(NetworkFailure(message: 'Network timeout')),
        );

        await provider.searchCategories(tQuery);

        expect(provider.isLoading, false);
        expect(provider.categories, isEmpty);
        expect(provider.errorMessage, 'Network timeout');
        expect(provider.currentQuery, tQuery);
      });

      test('should handle AuthFailure', () async {
        when(
          mockSearchCategoriesUseCase(any, first: anyNamed('first')),
        ).thenAnswer(
          (_) async => const Left(
            AuthFailure(message: 'Not authenticated', code: '401'),
          ),
        );

        await provider.searchCategories(tQuery);

        expect(provider.isLoading, false);
        expect(provider.categories, isEmpty);
        expect(provider.errorMessage, 'Not authenticated');
        expect(provider.currentQuery, tQuery);
      });

      test('should handle ValidationFailure', () async {
        when(
          mockSearchCategoriesUseCase(any, first: anyNamed('first')),
        ).thenAnswer(
          (_) async => const Left(
            ValidationFailure(message: 'Invalid query', code: 'INVALID'),
          ),
        );

        await provider.searchCategories(tQuery);

        expect(provider.isLoading, false);
        expect(provider.categories, isEmpty);
        expect(provider.errorMessage, 'Invalid query');
        expect(provider.currentQuery, tQuery);
      });
    });

    group('clearSearch', () {
      test('should clear all state', () async {
        when(
          mockSearchCategoriesUseCase(any, first: anyNamed('first')),
        ).thenAnswer((_) async => const Right(tCategories));
        await provider.searchCategories(tQuery);

        provider.clearSearch();

        expect(provider.isLoading, false);
        expect(provider.categories, isEmpty);
        expect(provider.errorMessage, isNull);
        expect(provider.currentQuery, isEmpty);
        expect(provider.hasSearched, false);
      });

      test('should clear previous search results', () async {
        when(
          mockSearchCategoriesUseCase(any, first: anyNamed('first')),
        ).thenAnswer((_) async => const Right(tCategories));

        await provider.searchCategories(tQuery);
        expect(provider.categories, tCategories);

        provider.clearSearch();
        expect(provider.categories, isEmpty);
        expect(provider.currentQuery, isEmpty);
      });
    });

    group('state transitions', () {
      test('should handle multiple consecutive searches', () async {
        when(
          mockSearchCategoriesUseCase(any, first: anyNamed('first')),
        ).thenAnswer((_) async => const Right(tCategories));

        await provider.searchCategories('League');
        await provider.searchCategories('Dota');

        verify(mockSearchCategoriesUseCase('League', first: 20)).called(1);
        verify(mockSearchCategoriesUseCase('Dota', first: 20)).called(1);
      });

      test('should transition from error to success on retry', () async {
        when(
          mockSearchCategoriesUseCase(any, first: anyNamed('first')),
        ).thenAnswer(
          (_) async => const Left(NetworkFailure(message: 'Network error')),
        );

        await provider.searchCategories(tQuery);
        expect(provider.errorMessage, 'Network error');

        // Change mock to return success
        when(
          mockSearchCategoriesUseCase(any, first: anyNamed('first')),
        ).thenAnswer((_) async => const Right(tCategories));

        await provider.searchCategories(tQuery);
        expect(provider.errorMessage, isNull);
        expect(provider.categories, tCategories);
      });
    });

    group('listener notifications', () {
      test('should notify listeners on search', () async {
        when(
          mockSearchCategoriesUseCase(any, first: anyNamed('first')),
        ).thenAnswer((_) async => const Right(tCategories));

        var notificationCount = 0;
        provider.addListener(() => notificationCount++);

        await provider.searchCategories(tQuery);

        expect(notificationCount, 2); // Once for loading, once for loaded
      });

      test('should notify listeners on clear', () {
        var notificationCount = 0;
        provider.addListener(() => notificationCount++);

        provider.clearSearch();

        expect(notificationCount, 1);
      });
    });
  });
}
