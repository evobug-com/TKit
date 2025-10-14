import 'package:dartz/dartz.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/mapping_lists/domain/entities/mapping_list.dart';
import 'package:tkit/features/mapping_lists/domain/repositories/i_mapping_list_repository.dart';

/// Use case for getting all mapping lists
class GetAllListsUseCase {
  final IMappingListRepository repository;

  GetAllListsUseCase(this.repository);

  Future<Either<Failure, List<MappingList>>> call() async {
    return await repository.getAllLists();
  }
}
