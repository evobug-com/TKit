import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/twitch_api/domain/repositories/i_twitch_api_repository.dart';
import 'package:tkit/features/twitch_api/domain/usecases/update_channel_category_usecase.dart';

@GenerateMocks([ITwitchApiRepository])
import 'update_channel_category_usecase_test.mocks.dart';

void main() {
  late UpdateChannelCategoryUseCase usecase;
  late MockITwitchApiRepository mockRepository;

  setUp(() {
    mockRepository = MockITwitchApiRepository();
    usecase = UpdateChannelCategoryUseCase(mockRepository);
  });

  const testCategoryId = '12345';

  group('UpdateChannelCategoryUseCase', () {
    test(
      'should call repository.updateChannelCategory when successful',
      () async {
        // Arrange
        when(
          mockRepository.updateChannelCategory(any),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await usecase(testCategoryId);

        // Assert
        expect(result, const Right(null));
        verify(mockRepository.updateChannelCategory(testCategoryId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('should return ValidationFailure when category ID is empty', () async {
      // Act
      final result = await usecase('');

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, 'Category ID cannot be empty');
        expect(failure.code, 'EMPTY_CATEGORY_ID');
      }, (_) => fail('Should return Left'));
      verifyZeroInteractions(mockRepository);
    });

    test(
      'should return ValidationFailure when category ID is only whitespace',
      () async {
        // Act
        final result = await usecase('   ');

        // Assert
        expect(result.isLeft(), true);
        verifyZeroInteractions(mockRepository);
      },
    );

    test('should trim whitespace from category ID', () async {
      // Arrange
      when(
        mockRepository.updateChannelCategory(any),
      ).thenAnswer((_) async => const Right(null));

      // Act
      await usecase('  12345  ');

      // Assert
      verify(mockRepository.updateChannelCategory('12345')).called(1);
    });

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      const serverFailure = ServerFailure(message: 'Server error');
      when(
        mockRepository.updateChannelCategory(any),
      ).thenAnswer((_) async => const Left(serverFailure));

      // Act
      final result = await usecase(testCategoryId);

      // Assert
      expect(result, const Left(serverFailure));
      verify(mockRepository.updateChannelCategory(testCategoryId)).called(1);
    });

    test('should return AuthFailure when not authenticated', () async {
      // Arrange
      const authFailure = AuthFailure(message: 'Not authenticated');
      when(
        mockRepository.updateChannelCategory(any),
      ).thenAnswer((_) async => const Left(authFailure));

      // Act
      final result = await usecase(testCategoryId);

      // Assert
      expect(result, const Left(authFailure));
    });
  });
}
