import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tkit/core/providers/datasource_providers.dart';
import 'package:tkit/core/providers/providers.dart';
import 'package:tkit/features/mapping_lists/data/repositories/mapping_list_repository_impl.dart';
import 'package:tkit/features/mapping_lists/domain/repositories/i_mapping_list_repository.dart';
import 'package:tkit/features/mapping_lists/domain/usecases/get_all_lists_usecase.dart';
import 'package:tkit/features/mapping_lists/domain/usecases/sync_list_usecase.dart';
import 'package:tkit/features/mapping_lists/domain/usecases/import_list_from_url_usecase.dart';
import 'package:tkit/features/mapping_lists/domain/usecases/toggle_list_enabled_usecase.dart';
import 'package:tkit/features/mapping_lists/domain/entities/mapping_list.dart' as entity;

part 'mapping_list_providers.g.dart';

// =============================================================================
// MAPPING LIST REPOSITORY
// =============================================================================

@Riverpod(keepAlive: true)
IMappingListRepository mappingListRepository(Ref ref) {
  final localDataSource = ref.watch(mappingListLocalDataSourceProvider);
  final syncDataSource = ref.watch(mappingListSyncDataSourceProvider);
  final database = ref.watch(appDatabaseProvider);
  final logger = ref.watch(appLoggerProvider);
  return MappingListRepositoryImpl(localDataSource, syncDataSource, database, logger);
}

// =============================================================================
// MAPPING LIST USE CASES
// =============================================================================

@Riverpod(keepAlive: true)
GetAllListsUseCase getAllListsUseCase(Ref ref) {
  final repository = ref.watch(mappingListRepositoryProvider);
  return GetAllListsUseCase(repository);
}

@Riverpod(keepAlive: true)
SyncListUseCase syncListUseCase(Ref ref) {
  final repository = ref.watch(mappingListRepositoryProvider);
  return SyncListUseCase(repository);
}

@Riverpod(keepAlive: true)
ImportListFromUrlUseCase importListFromUrlUseCase(Ref ref) {
  final repository = ref.watch(mappingListRepositoryProvider);
  return ImportListFromUrlUseCase(repository);
}

@Riverpod(keepAlive: true)
ToggleListEnabledUseCase toggleListEnabledUseCase(Ref ref) {
  final repository = ref.watch(mappingListRepositoryProvider);
  return ToggleListEnabledUseCase(repository);
}

// =============================================================================
// MAPPING LIST STATE NOTIFIER
// =============================================================================

@Riverpod(keepAlive: true)
class MappingLists extends _$MappingLists {
  @override
  MappingListState build() {
    return const MappingListState();
  }

  /// Load all lists
  Future<void> loadLists() async {
    state = state.copyWith(isLoading: true);

    final useCase = ref.read(getAllListsUseCaseProvider);
    final result = await useCase();

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (lists) {
        state = state.copyWith(
          isLoading: false,
          lists: lists,
          errorMessage: null,
        );
      },
    );
  }

  /// Sync a list
  Future<void> syncList(int listId) async {
    final useCase = ref.read(syncListUseCaseProvider);
    final result = await useCase(listId.toString());

    result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
      },
      (_) {
        // Reload lists after sync
        loadLists();
      },
    );
  }

  /// Toggle list enabled status
  Future<void> toggleListEnabled(int listId, bool isEnabled) async {
    final useCase = ref.read(toggleListEnabledUseCaseProvider);
    final result = await useCase(listId.toString(), isEnabled);

    result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
      },
      (_) {
        // Reload lists after toggle
        loadLists();
      },
    );
  }
}

// State class for MappingList
class MappingListState {
  final bool isLoading;
  final List<entity.MappingList> lists;
  final String? errorMessage;

  const MappingListState({
    this.isLoading = false,
    this.lists = const [],
    this.errorMessage,
  });

  MappingListState copyWith({
    bool? isLoading,
    List<entity.MappingList>? lists,
    String? errorMessage,
  }) {
    return MappingListState(
      isLoading: isLoading ?? this.isLoading,
      lists: lists ?? this.lists,
      errorMessage: errorMessage,
    );
  }
}
