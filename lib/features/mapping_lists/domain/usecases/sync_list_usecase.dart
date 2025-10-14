import 'package:dartz/dartz.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/mapping_lists/domain/repositories/i_mapping_list_repository.dart';

/// Use case for syncing a single list from its remote source
class SyncListUseCase {
  final IMappingListRepository repository;

  SyncListUseCase(this.repository);

  Future<Either<Failure, void>> call(String listId) async {
    return await repository.syncList(listId);
  }
}
