import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/category_mapping/domain/repositories/i_category_mapping_repository.dart';
import 'package:tkit/features/category_mapping/domain/usecases/update_last_used_usecase.dart';

@GenerateMocks([ICategoryMappingRepository])
import 'update_last_used_usecase_test.mocks.dart';

void main() {
  late UpdateLastUsedUseCase useCase;
  late MockICategoryMappingRepository mockRepository;

  setUp(() {
    mockRepository = MockICategoryMappingRepository();
    useCase = UpdateLastUsedUseCase(mockRepository);
  });

  group('UpdateLastUsedUseCase', () {
    const testId = 1;

    test('should update last used timestamp through repository', () async {
      // arrange
      when(
        mockRepository.updateLastUsed(any),
      ).thenAnswer((_) async => const Right(null));

      // act
      final result = await useCase(testId);

      // assert
      expect(result, const Right(null));
      verify(mockRepository.updateLastUsed(testId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return validation failure when ID is zero', () async {
      // act
      final result = await useCase(0);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(
          failure,
          const ValidationFailure(message: 'Invalid mapping ID'),
        ),
        (_) => fail('Should return failure'),
      );
      verifyNever(mockRepository.updateLastUsed(any));
    });

    test('should return validation failure when ID is negative', () async {
      // act
      final result = await useCase(-1);

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(
          failure,
          const ValidationFailure(message: 'Invalid mapping ID'),
        ),
        (_) => fail('Should return failure'),
      );
      verifyNever(mockRepository.updateLastUsed(any));
    });

    test('should return failure when repository fails', () async {
      // arrange
      const failure = CacheFailure(message: 'Database error');
      when(
        mockRepository.updateLastUsed(any),
      ).thenAnswer((_) async => const Left(failure));

      // act
      final result = await useCase(testId);

      // assert
      expect(result, const Left(failure));
      verify(mockRepository.updateLastUsed(testId));
    });
  });
}
