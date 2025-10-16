import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tkit/core/providers/datasource_providers.dart';
import 'package:tkit/core/providers/providers.dart';
import 'package:tkit/features/mapping_lists/data/repositories/mapping_list_repository_impl.dart';
import 'package:tkit/features/mapping_lists/domain/repositories/i_mapping_list_repository.dart';
import 'package:tkit/features/mapping_lists/domain/usecases/get_all_lists_usecase.dart';
import 'package:tkit/features/mapping_lists/domain/usecases/sync_list_usecase.dart';
import 'package:tkit/features/mapping_lists/domain/usecases/import_list_from_url_usecase.dart';
import 'package:tkit/features/mapping_lists/domain/usecases/toggle_list_enabled_usecase.dart';
import 'package:tkit/features/mapping_lists/domain/entities/mapping_list.dart'
    as entity;

export 'package:tkit/features/mapping_lists/domain/usecases/import_list_from_url_usecase.dart'
    show ImportListParams;

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
  return MappingListRepositoryImpl(
    localDataSource,
    syncDataSource,
    database,
    logger,
  );
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

  /// Clear messages
  void clearMessages() {
    state = state.copyWith(errorMessage: null, successMessage: null);
  }

  /// Load all lists
  Future<void> loadLists() async {
    state = state.copyWith(isLoading: true);

    final useCase = ref.read(getAllListsUseCaseProvider);
    final result = await useCase();

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
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
  Future<void> syncList(String listId) async {
    // Mark list as syncing
    final updatedSyncingIds = Set<String>.from(state.syncingListIds)
      ..add(listId);
    state = state.copyWith(syncingListIds: updatedSyncingIds);

    final useCase = ref.read(syncListUseCaseProvider);
    final result = await useCase(listId);

    // Remove from syncing set
    final finalSyncingIds = Set<String>.from(state.syncingListIds)
      ..remove(listId);

    result.fold(
      (failure) {
        state = state.copyWith(
          errorMessage: failure.message,
          syncingListIds: finalSyncingIds,
        );
      },
      (_) {
        state = state.copyWith(
          successMessage: 'List synced successfully',
          syncingListIds: finalSyncingIds,
        );
        // Reload lists after sync
        loadLists();
      },
    );
  }

  /// Toggle list enabled status
  Future<void> toggleListEnabled(String listId) async {
    // Find the current list to toggle its enabled state
    final currentList = state.lists.firstWhere((list) => list.id == listId);
    final newEnabledState = !currentList.isEnabled;

    final useCase = ref.read(toggleListEnabledUseCaseProvider);
    final result = await useCase(listId, isEnabled: newEnabledState);

    result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
      },
      (_) {
        state = state.copyWith(
          successMessage:
              'List ${newEnabledState ? 'enabled' : 'disabled'} successfully',
        );
        // Reload lists after toggle
        loadLists();
      },
    );
  }

  /// Check if a specific list is syncing
  bool isListSyncing(String listId) {
    return state.syncingListIds.contains(listId);
  }

  /// Sync all lists that should sync
  Future<void> syncAllLists() async {
    final listsToSync = state.lists.where((list) => list.shouldSync).toList();

    for (final list in listsToSync) {
      await syncList(list.id);
    }
  }

  /// Import a list from URL
  Future<bool> importListFromUrl({
    required String url,
    required String name,
    String? description,
  }) async {
    state = state.copyWith(isLoading: true);

    final useCase = ref.read(importListFromUrlUseCaseProvider);
    final params = ImportListParams(
      url: url,
      name: name,
      description: description,
    );
    final result = await useCase(params);

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
      },
      (_) {
        state = state.copyWith(
          isLoading: false,
          successMessage: 'List imported successfully',
        );
        // Reload lists after import
        loadLists();
        return true;
      },
    );
  }
}

// State class for MappingList
class MappingListState {
  final bool isLoading;
  final List<entity.MappingList> lists;
  final String? errorMessage;
  final String? successMessage;
  final Set<String> syncingListIds;

  const MappingListState({
    this.isLoading = false,
    this.lists = const [],
    this.errorMessage,
    this.successMessage,
    this.syncingListIds = const {},
  });

  MappingListState copyWith({
    bool? isLoading,
    List<entity.MappingList>? lists,
    String? errorMessage,
    String? successMessage,
    Set<String>? syncingListIds,
  }) {
    return MappingListState(
      isLoading: isLoading ?? this.isLoading,
      lists: lists ?? this.lists,
      errorMessage: errorMessage,
      successMessage: successMessage,
      syncingListIds: syncingListIds ?? this.syncingListIds,
    );
  }
}
