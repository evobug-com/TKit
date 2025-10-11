import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/core/utils/app_logger.dart';
import 'package:tkit/features/twitch_api/domain/entities/twitch_category.dart';
import 'package:tkit/features/twitch_api/domain/usecases/search_categories_usecase.dart';
import 'package:tkit/features/twitch_api/presentation/providers/twitch_api_provider.dart';

@GenerateMocks([SearchCategoriesUseCase, AppLogger])
import 'twitch_api_provider_test.mocks.dart';

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

  const testCategories = [
    TwitchCategory(id: '1', name: 'Just Chatting'),
    TwitchCategory(id: '2', name: 'Just Dancing'),
  ];

  group('TwitchApiProvider', () {
    test('initial state should be correct', () {
      expect(provider.isLoading, false);
      expect(provider.categories, isEmpty);
      expect(provider.errorMessage, isNull);
      expect(provider.currentQuery, isEmpty);
      expect(provider.hasSearched, false);
    });

    group('searchCategories', () {
      const testQuery = 'Just Chatting';

      test('should update state correctly when search is successful', () async {
        when(
          mockSearchCategoriesUseCase(any, first: anyNamed('first')),
        ).thenAnswer((_) async => const Right(testCategories));

        var notificationCount = 0;
        provider.addListener(() => notificationCount++);

        await provider.searchCategories(testQuery);

        expect(provider.isLoading, false);
        expect(provider.categories, testCategories);
        expect(provider.errorMessage, isNull);
        expect(provider.currentQuery, testQuery);
        expect(provider.hasSearched, true);
        expect(notificationCount, 2); // Once for loading, once for loaded
        verify(mockSearchCategoriesUseCase(testQuery, first: 20)).called(1);
      });

      test('should update state correctly with custom maxResults', () async {
        when(
          mockSearchCategoriesUseCase(any, first: anyNamed('first')),
        ).thenAnswer((_) async => const Right(testCategories));

        await provider.searchCategories(testQuery, maxResults: 50);

        expect(provider.isLoading, false);
        expect(provider.categories, testCategories);
        expect(provider.currentQuery, testQuery);
        verify(mockSearchCategoriesUseCase(testQuery, first: 50)).called(1);
      });

      test('should update state correctly when search fails', () async {
        when(
          mockSearchCategoriesUseCase(any, first: anyNamed('first')),
        ).thenAnswer(
          (_) async => const Left(ServerFailure(message: 'Server error')),
        );

        await provider.searchCategories(testQuery);

        expect(provider.isLoading, false);
        expect(provider.categories, isEmpty);
        expect(provider.errorMessage, 'Server error');
        expect(provider.currentQuery, testQuery);
        verify(mockSearchCategoriesUseCase(testQuery, first: 20)).called(1);
      });

      test('should update state correctly when network fails', () async {
        when(
          mockSearchCategoriesUseCase(any, first: anyNamed('first')),
        ).thenAnswer(
          (_) async => const Left(NetworkFailure(message: 'No internet')),
        );

        await provider.searchCategories(testQuery);

        expect(provider.isLoading, false);
        expect(provider.categories, isEmpty);
        expect(provider.errorMessage, 'No internet');
        expect(provider.currentQuery, testQuery);
      });

      test('should clear state when query is empty', () async {
        // First set some state
        when(
          mockSearchCategoriesUseCase(any, first: anyNamed('first')),
        ).thenAnswer((_) async => const Right(testCategories));
        await provider.searchCategories(testQuery);

        // Now search with empty query
        await provider.searchCategories('');

        expect(provider.isLoading, false);
        expect(provider.categories, isEmpty);
        expect(provider.errorMessage, isNull);
        expect(provider.currentQuery, isEmpty);
        verifyNever(mockSearchCategoriesUseCase('', first: anyNamed('first')));
      });

      test('should clear state when query is only whitespace', () async {
        // First set some state
        when(
          mockSearchCategoriesUseCase(any, first: anyNamed('first')),
        ).thenAnswer((_) async => const Right(testCategories));
        await provider.searchCategories(testQuery);

        // Now search with whitespace query
        await provider.searchCategories('   ');

        expect(provider.isLoading, false);
        expect(provider.categories, isEmpty);
        expect(provider.errorMessage, isNull);
        expect(provider.currentQuery, isEmpty);
      });

      test('should handle empty list when no categories found', () async {
        when(
          mockSearchCategoriesUseCase(any, first: anyNamed('first')),
        ).thenAnswer((_) async => const Right([]));

        await provider.searchCategories('nonexistent');

        expect(provider.isLoading, false);
        expect(provider.categories, isEmpty);
        expect(provider.errorMessage, isNull);
        expect(provider.currentQuery, 'nonexistent');
      });
    });

    group('clearSearch', () {
      test('should clear all state', () async {
        // First set some state
        when(
          mockSearchCategoriesUseCase(any, first: anyNamed('first')),
        ).thenAnswer((_) async => const Right(testCategories));
        await provider.searchCategories('test');

        // Now clear
        provider.clearSearch();

        expect(provider.isLoading, false);
        expect(provider.categories, isEmpty);
        expect(provider.errorMessage, isNull);
        expect(provider.currentQuery, isEmpty);
        expect(provider.hasSearched, false);
      });

      test('should notify listeners when cleared', () {
        var notificationCount = 0;
        provider.addListener(() => notificationCount++);

        provider.clearSearch();

        expect(notificationCount, 1);
      });
    });
  });
}
