import 'package:dartz/dartz.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/mapping_lists/domain/repositories/i_mapping_list_repository.dart';

/// Use case for toggling a list's enabled state
class ToggleListEnabledUseCase {
  final IMappingListRepository repository;

  ToggleListEnabledUseCase(this.repository);

  Future<Either<Failure, void>> call(String listId, bool isEnabled) async {
    return await repository.toggleListEnabled(listId, isEnabled);
  }
}
