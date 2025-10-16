import 'package:dartz/dartz.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/mapping_lists/domain/entities/mapping_list.dart';
import 'package:tkit/features/mapping_lists/domain/repositories/i_mapping_list_repository.dart';

/// Parameters for importing a list from URL
/// Metadata like isReadOnly and submissionHookUrl will be read from the JSON file
class ImportListParams {
  final String url;
  final String name;
  final String? description;

  ImportListParams({required this.url, required this.name, this.description});
}

/// Use case for importing a new list from a URL
class ImportListFromUrlUseCase {
  final IMappingListRepository repository;

  ImportListFromUrlUseCase(this.repository);

  Future<Either<Failure, MappingList>> call(ImportListParams params) async {
    return await repository.importListFromUrl(
      url: params.url,
      name: params.name,
      description: params.description,
    );
  }
}
