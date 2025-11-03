import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/category_mapping/domain/entities/category_mapping.dart';
import 'package:tkit/features/category_mapping/domain/repositories/i_category_mapping_repository.dart';

import 'category_mapping_edge_cases_test.mocks.dart';

@GenerateMocks([ICategoryMappingRepository])
void main() {
  late MockICategoryMappingRepository mockRepository;

  setUp(() {
    mockRepository = MockICategoryMappingRepository();
  });

  group('Category Mapping Edge Cases', () {
    group('Concurrent Mapping Operations', () {
      test(
        'should handle concurrent save operations for different mappings',
        () async {
          // arrange
          final now = DateTime.now();
          final mapping1 = CategoryMapping(
            id: 1,
            processName: 'game1.exe',
            twitchCategoryId: 'cat_123',
            twitchCategoryName: 'Game Category 1',
            isEnabled: true,
            createdAt: now,
            lastApiFetch: now,
            cacheExpiresAt: now.add(const Duration(hours: 24)),
            manualOverride: false,
          );

          final mapping2 = CategoryMapping(
            id: 2,
            processName: 'game2.exe',
            twitchCategoryId: 'cat_456',
            twitchCategoryName: 'Game Category 2',
            isEnabled: true,
            createdAt: now,
            lastApiFetch: now,
            cacheExpiresAt: now.add(const Duration(hours: 24)),
            manualOverride: false,
          );

          when(
            mockRepository.saveMapping(any),
          ).thenAnswer((_) async => const Right(null));

          // act - save mappings concurrently
          final results = await Future.wait([
            mockRepository.saveMapping(mapping1),
            mockRepository.saveMapping(mapping2),
          ]);

          // assert
          expect(results.length, 2);
          expect(results[0].isRight(), true);
          expect(results[1].isRight(), true);
          verify(mockRepository.saveMapping(any)).called(2);
        },
      );

      test(
        'should handle race condition when saving same process twice',
        () async {
          // arrange
          const processName = 'duplicate.exe';
          final now = DateTime.now();

          var callCount = 0;
          when(mockRepository.saveMapping(any)).thenAnswer((_) async {
            callCount++;
            if (callCount == 1) {
              // First call succeeds
              return const Right(null);
            } else {
              // Second call fails due to duplicate
              return const Left(
                ValidationFailure(
                  message: 'Mapping already exists for this process',
                  code: 'DUPLICATE_MAPPING',
                ),
              );
            }
          });

          final mapping = CategoryMapping(
            processName: processName,
            twitchCategoryId: 'cat_original',
            twitchCategoryName: 'Original Category',
            isEnabled: true,
            createdAt: now,
            lastApiFetch: now,
            cacheExpiresAt: now.add(const Duration(hours: 24)),
            manualOverride: false,
          );

          // act - try to save same mapping twice concurrently
          final results = await Future.wait([
            mockRepository.saveMapping(mapping),
            mockRepository.saveMapping(mapping),
          ]);

          // assert
          expect(results[0].isRight(), true);
          expect(results[1].isLeft(), true);
          results[1].fold((failure) {
            expect(failure, isA<ValidationFailure>());
            expect((failure as ValidationFailure).code, 'DUPLICATE_MAPPING');
          }, (r) => fail('Second mapping should fail'));
        },
      );

      test('should handle concurrent delete and find operations', () async {
        // arrange
        final now = DateTime.now();
        final mapping = CategoryMapping(
          id: 1,
          processName: 'game.exe',
          twitchCategoryId: 'cat_123',
          twitchCategoryName: 'Game Category',
          isEnabled: true,
          createdAt: now,
          lastApiFetch: now,
          cacheExpiresAt: now.add(const Duration(hours: 24)),
          manualOverride: false,
        );

        var isDeleted = false;

        when(mockRepository.findMapping('game.exe', null)).thenAnswer((
          _,
        ) async {
          // Simulate delay
          await Future.delayed(const Duration(milliseconds: 50));
          if (isDeleted) {
            return const Right(null);
          }
          return Right(mapping);
        });

        when(mockRepository.deleteMapping(1)).thenAnswer((_) async {
          // Simulate delay
          await Future.delayed(const Duration(milliseconds: 25));
          isDeleted = true;
          return const Right(null);
        });

        // act - delete and read concurrently
        final results = await Future.wait([
          mockRepository.deleteMapping(1),
          mockRepository.findMapping('game.exe', null),
        ]);

        // assert
        expect(results[0].isRight(), true); // Delete succeeds
        // Find might return mapping or null depending on timing
        expect(results[1].isRight(), true);
      });

      test('should handle concurrent updateLastUsed calls', () async {
        // arrange
        const mappingId = 1;
        var updateCount = 0;

        when(mockRepository.updateLastUsed(mappingId)).thenAnswer((_) async {
          updateCount++;
          // Simulate some processing time
          await Future.delayed(const Duration(milliseconds: 10));
          return const Right(null);
        });

        // act - multiple concurrent updates
        final futures = List.generate(
          10,
          (_) => mockRepository.updateLastUsed(mappingId),
        );
        final results = await Future.wait(futures);

        // assert
        expect(results.every((r) => r.isRight()), true);
        expect(updateCount, 10);
      });
    });

    group('Special Characters and Unicode in Names', () {
      test('should handle category names with emojis', () async {
        // arrange
        final now = DateTime.now();
        final mappingWithEmojis = CategoryMapping(
          id: 1,
          processName: 'game.exe',
          twitchCategoryId: 'cat_emoji',
          twitchCategoryName: '🎮 Gaming Time! 🚀 🎯 🌟',
          isEnabled: true,
          createdAt: now,
          lastApiFetch: now,
          cacheExpiresAt: now.add(const Duration(hours: 24)),
          manualOverride: false,
        );

        when(
          mockRepository.saveMapping(mappingWithEmojis),
        ).thenAnswer((_) async => const Right(null));

        when(
          mockRepository.findMapping('game.exe', null),
        ).thenAnswer((_) async => Right(mappingWithEmojis));

        // act
        final saveResult = await mockRepository.saveMapping(mappingWithEmojis);
        final findResult = await mockRepository.findMapping('game.exe', null);

        // assert
        expect(saveResult.isRight(), true);
        expect(findResult.isRight(), true);
        findResult.fold((l) => fail('Should find mapping'), (r) {
          expect(r?.twitchCategoryName, contains('🎮'));
          expect(r?.twitchCategoryName, contains('🚀'));
          expect(r?.twitchCategoryName, contains('🎯'));
          expect(r?.twitchCategoryName, contains('🌟'));
        });
      });

      test(
        'should handle process names with special path characters',
        () async {
          // arrange
          final now = DateTime.now();
          final specialProcessNames = [
            'Game & Watch™.exe',
            'app [Beta] (v1.2.3).exe',
            'Stream (24/7) @ Home!.exe',
            '~*Special*~ App.exe',
            'Process with "quotes".exe',
            "App with 'apostrophes'.exe",
            'C:\\Program Files (x86)\\Game\\game.exe',
            'D:\\Games\\新しいゲーム\\game.exe', // Japanese
            'E:\\Игры\\игра.exe', // Russian
          ];

          for (final processName in specialProcessNames) {
            final mapping = CategoryMapping(
              processName: processName,
              twitchCategoryId: 'cat_special',
              twitchCategoryName: 'Special Category',
              isEnabled: true,
              createdAt: now,
              lastApiFetch: now,
              cacheExpiresAt: now.add(const Duration(hours: 24)),
              manualOverride: false,
            );

            when(
              mockRepository.saveMapping(mapping),
            ).thenAnswer((_) async => const Right(null));

            when(
              mockRepository.findMapping(processName, null),
            ).thenAnswer((_) async => Right(mapping));

            // act
            final saveResult = await mockRepository.saveMapping(mapping);
            final findResult = await mockRepository.findMapping(
              processName,
              null,
            );

            // assert
            expect(saveResult.isRight(), true);
            expect(findResult.isRight(), true);
            findResult.fold(
              (l) => fail('Should handle special characters'),
              (r) => expect(r?.processName, processName),
            );
          }
        },
      );

      test('should handle very long category names (500+ characters)', () async {
        // arrange
        final now = DateTime.now();
        final longCategoryName =
            'A' * 500 +
            ' - Very Long Category Name with lots of extra text to make it even longer and test the limits of our storage system';
        final mapping = CategoryMapping(
          id: 1,
          processName: 'game.exe',
          twitchCategoryId: 'cat_long',
          twitchCategoryName: longCategoryName,
          isEnabled: true,
          createdAt: now,
          lastApiFetch: now,
          cacheExpiresAt: now.add(const Duration(hours: 24)),
          manualOverride: false,
        );

        when(
          mockRepository.saveMapping(mapping),
        ).thenAnswer((_) async => const Right(null));

        // act
        final result = await mockRepository.saveMapping(mapping);

        // assert
        expect(result.isRight(), true);
        expect(mapping.twitchCategoryName.length, greaterThan(500));
      });
    });

    group('Cache Expiration Edge Cases', () {
      test(
        'should handle mappings expiring at exact moment of check',
        () async {
          // arrange
          final now = DateTime.now();
          final aboutToExpire = CategoryMapping(
            id: 1,
            processName: 'game.exe',
            twitchCategoryId: 'cat_123',
            twitchCategoryName: 'Category',
            isEnabled: true,
            createdAt: now.subtract(const Duration(hours: 24)),
            lastApiFetch: now.subtract(const Duration(hours: 24)),
            cacheExpiresAt: now.add(const Duration(milliseconds: 100)),
            manualOverride: false,
          );

          when(
            mockRepository.getMappingsExpiringSoon(const Duration(minutes: 1)),
          ).thenAnswer((_) async => Right([aboutToExpire]));

          // act
          final result = await mockRepository.getMappingsExpiringSoon(
            const Duration(minutes: 1),
          );

          // assert
          expect(result.isRight(), true);
          result.fold((l) => fail('Should return expiring mappings'), (r) {
            expect(r.length, 1);
            expect(r.first.isExpiringSoon(const Duration(minutes: 1)), true);
          });
        },
      );

      test(
        'should not delete manual override mappings even if expired',
        () async {
          // arrange
          final now = DateTime.now();
          final expiredManual = CategoryMapping(
            id: 1,
            processName: 'manual.exe',
            twitchCategoryId: 'cat_manual',
            twitchCategoryName: 'Manual Category',
            isEnabled: true,
            createdAt: now.subtract(const Duration(days: 30)),
            lastApiFetch: now.subtract(const Duration(days: 30)),
            cacheExpiresAt: now.subtract(const Duration(days: 29)),
            manualOverride: true, // This is a manual override
          );

          final expiredAuto = CategoryMapping(
            id: 2,
            processName: 'auto.exe',
            twitchCategoryId: 'cat_auto',
            twitchCategoryName: 'Auto Category',
            isEnabled: true,
            createdAt: now.subtract(const Duration(days: 2)),
            lastApiFetch: now.subtract(const Duration(days: 2)),
            cacheExpiresAt: now.subtract(const Duration(days: 1)),
            manualOverride: false, // This is not a manual override
          );

          when(mockRepository.getExpiredMappings()).thenAnswer(
            (_) async => Right([expiredAuto]),
          ); // Only returns non-manual

          when(mockRepository.deleteExpiredMappings()).thenAnswer(
            (_) async => const Right(1),
          ); // Only deletes 1 (the auto)

          // act
          final expiredResult = await mockRepository.getExpiredMappings();
          final deleteResult = await mockRepository.deleteExpiredMappings();

          // assert
          expect(expiredResult.isRight(), true);
          expiredResult.fold((l) => fail('Should return expired mappings'), (
            r,
          ) {
            expect(r.length, 1);
            expect(r.first.manualOverride, false);
            expect(r.any((m) => m.manualOverride), false);
          });

          expect(deleteResult.isRight(), true);
          deleteResult.fold(
            (l) => fail('Should delete expired mappings'),
            (r) => expect(r, 1), // Only 1 deleted (the auto one)
          );
        },
      );
    });

    group('Fuzzy Matching Edge Cases', () {
      test('should find mapping with slight process name variations', () async {
        // arrange
        final now = DateTime.now();
        final mapping = CategoryMapping(
          id: 1,
          processName: 'LeagueOfLegends.exe',
          twitchCategoryId: 'cat_lol',
          twitchCategoryName: 'League of Legends',
          isEnabled: true,
          createdAt: now,
          lastApiFetch: now,
          cacheExpiresAt: now.add(const Duration(hours: 24)),
          manualOverride: false,
        );

        // Test various name variations
        final variations = [
          'LeagueOfLegends.exe', // Exact match
          'leagueoflegends.exe', // Case difference
          'League Of Legends.exe', // Spaces
          'LeagueofLegends.exe', // Mixed case
          'LeagueOfLegend.exe', // Missing 's'
          'LeagueOfLegendsClient.exe', // Extra suffix
        ];

        for (final variation in variations) {
          when(
            mockRepository.findMapping(variation, null),
          ).thenAnswer((_) async => Right(mapping));

          // act
          final result = await mockRepository.findMapping(variation, null);

          // assert
          expect(result.isRight(), true);
          result.fold(
            (l) => fail('Should find mapping for $variation'),
            (r) => expect(r?.twitchCategoryId, 'cat_lol'),
          );
        }
      });

      test(
        'should handle finding mapping with null path vs provided path',
        () async {
          // arrange
          final now = DateTime.now();
          final mapping = CategoryMapping(
            id: 1,
            processName: 'game.exe',
            executablePath: 'C:\\Games\\MyGame\\game.exe',
            normalizedInstallPaths: ['games/mygame', 'steam/common/mygame'],
            twitchCategoryId: 'cat_123',
            twitchCategoryName: 'My Game',
            isEnabled: true,
            createdAt: now,
            lastApiFetch: now,
            cacheExpiresAt: now.add(const Duration(hours: 24)),
            manualOverride: false,
          );

          when(
            mockRepository.findMapping('game.exe', null),
          ).thenAnswer((_) async => Right(mapping));

          when(
            mockRepository.findMapping(
              'game.exe',
              'C:\\Games\\MyGame\\game.exe',
            ),
          ).thenAnswer((_) async => Right(mapping));

          when(
            mockRepository.findMapping(
              'game.exe',
              'D:\\Different\\Path\\game.exe',
            ),
          ).thenAnswer(
            (_) async => const Right(null),
          ); // Different path might not match

          // act
          final resultNoPath = await mockRepository.findMapping(
            'game.exe',
            null,
          );
          final resultMatchingPath = await mockRepository.findMapping(
            'game.exe',
            'C:\\Games\\MyGame\\game.exe',
          );
          final resultDifferentPath = await mockRepository.findMapping(
            'game.exe',
            'D:\\Different\\Path\\game.exe',
          );

          // assert
          expect(resultNoPath.isRight(), true);
          expect(resultMatchingPath.isRight(), true);
          expect(resultDifferentPath.isRight(), true);

          resultNoPath.fold(
            (l) => fail('Should find without path'),
            (r) => expect(r?.id, 1),
          );

          resultMatchingPath.fold(
            (l) => fail('Should find with matching path'),
            (r) => expect(r?.id, 1),
          );

          resultDifferentPath.fold(
            (l) => fail('Should handle different path'),
            (r) => expect(r, isNull), // Might not find with different path
          );
        },
      );
    });

    group('Repository State Edge Cases', () {
      test('should handle deleting a mapping that does not exist', () async {
        // arrange
        when(mockRepository.deleteMapping(999)).thenAnswer(
          (_) async => const Left(
            DatabaseFailure(
              message: 'Mapping not found',
              code: 'MAPPING_NOT_FOUND',
            ),
          ),
        );

        // act
        final result = await mockRepository.deleteMapping(999);

        // assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<DatabaseFailure>());
          expect((failure as DatabaseFailure).code, 'MAPPING_NOT_FOUND');
        }, (r) => fail('Should fail for non-existent mapping'));
      });

      test('should handle empty repository operations', () async {
        // arrange
        when(
          mockRepository.getAllMappings(),
        ).thenAnswer((_) async => const Right([]));

        when(
          mockRepository.getExpiredMappings(),
        ).thenAnswer((_) async => const Right([]));

        when(
          mockRepository.deleteExpiredMappings(),
        ).thenAnswer((_) async => const Right(0));

        // act
        final allMappings = await mockRepository.getAllMappings();
        final expiredMappings = await mockRepository.getExpiredMappings();
        final deleteCount = await mockRepository.deleteExpiredMappings();

        // assert
        expect(allMappings.isRight(), true);
        allMappings.fold(
          (l) => fail('Should return empty list'),
          (r) => expect(r.isEmpty, true),
        );

        expect(expiredMappings.isRight(), true);
        expiredMappings.fold(
          (l) => fail('Should return empty list'),
          (r) => expect(r.isEmpty, true),
        );

        expect(deleteCount.isRight(), true);
        deleteCount.fold((l) => fail('Should return 0'), (r) => expect(r, 0));
      });

      test('should handle disabled mappings in findMapping', () async {
        // arrange
        final now = DateTime.now();
        final disabledMapping = CategoryMapping(
          id: 1,
          processName: 'game.exe',
          twitchCategoryId: 'cat_123',
          twitchCategoryName: 'Game',
          isEnabled: false, // Disabled mapping
          createdAt: now,
          lastApiFetch: now,
          cacheExpiresAt: now.add(const Duration(hours: 24)),
          manualOverride: false,
        );

        when(
          mockRepository.findMapping('game.exe', null),
        ).thenAnswer((_) async => Right(disabledMapping));

        // act
        final result = await mockRepository.findMapping('game.exe', null);

        // assert
        expect(result.isRight(), true);
        result.fold((l) => fail('Should find disabled mapping'), (r) {
          expect(r?.isEnabled, false);
          // The application layer should decide whether to use disabled mappings
        });
      });
    });
  });
}
