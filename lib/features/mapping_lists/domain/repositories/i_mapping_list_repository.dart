import 'package:dartz/dartz.dart';
import 'package:tkit/core/errors/failure.dart';
import 'package:tkit/features/mapping_lists/domain/entities/mapping_list.dart';

/// Repository interface for mapping lists
abstract class IMappingListRepository {
  /// Get all mapping lists
  Future<Either<Failure, List<MappingList>>> getAllLists();

  /// Get enabled mapping lists
  Future<Either<Failure, List<MappingList>>> getEnabledLists();

  /// Get mapping list by ID
  Future<Either<Failure, MappingList>> getListById(String id);

  /// Create a new mapping list
  Future<Either<Failure, void>> createList(MappingList list);

  /// Update an existing mapping list
  Future<Either<Failure, void>> updateList(MappingList list);

  /// Delete a mapping list
  Future<Either<Failure, void>> deleteList(String id, {bool deleteMappings});

  /// Toggle list enabled state
  Future<Either<Failure, void>> toggleListEnabled(String id, {required bool isEnabled});

  /// Sync a list from its remote URL
  Future<Either<Failure, void>> syncList(String listId);

  /// Sync all lists that need syncing
  Future<Either<Failure, int>> syncAllLists();

  /// Import list from URL
  /// Metadata like isReadOnly and submissionHookUrl will be read from the JSON file
  Future<Either<Failure, MappingList>> importListFromUrl({
    required String url,
    required String name,
    String? description,
  });

  /// Validate that a URL returns valid list data
  Future<Either<Failure, bool>> validateListUrl(String url);
}
