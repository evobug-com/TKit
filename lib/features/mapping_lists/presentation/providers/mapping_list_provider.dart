import 'package:flutter/foundation.dart';
import 'package:tkit/features/mapping_lists/domain/entities/mapping_list.dart';
import 'package:tkit/features/mapping_lists/domain/usecases/get_all_lists_usecase.dart';
import 'package:tkit/features/mapping_lists/domain/usecases/sync_list_usecase.dart';
import 'package:tkit/features/mapping_lists/domain/usecases/import_list_from_url_usecase.dart';
import 'package:tkit/features/mapping_lists/domain/usecases/toggle_list_enabled_usecase.dart';

/// Provider for managing mapping lists state
class MappingListProvider extends ChangeNotifier {
  final GetAllListsUseCase _getAllListsUseCase;
  final SyncListUseCase _syncListUseCase;
  final ImportListFromUrlUseCase _importListFromUrlUseCase;
  final ToggleListEnabledUseCase _toggleListEnabledUseCase;

  MappingListProvider({
    required GetAllListsUseCase getAllListsUseCase,
    required SyncListUseCase syncListUseCase,
    required ImportListFromUrlUseCase importListFromUrlUseCase,
    required ToggleListEnabledUseCase toggleListEnabledUseCase,
  })  : _getAllListsUseCase = getAllListsUseCase,
        _syncListUseCase = syncListUseCase,
        _importListFromUrlUseCase = importListFromUrlUseCase,
        _toggleListEnabledUseCase = toggleListEnabledUseCase;

  // State
  List<MappingList> _lists = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  // Currently syncing list IDs
  final Set<String> _syncingLists = {};

  // Getters
  List<MappingList> get lists => _lists;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  bool isListSyncing(String listId) => _syncingLists.contains(listId);

  /// Load all mapping lists
  Future<void> loadLists() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _getAllListsUseCase();

    result.fold(
      (failure) {
        _errorMessage = _getFailureMessage(failure);
        _isLoading = false;
        notifyListeners();
      },
      (lists) {
        _lists = lists;
        _isLoading = false;
        notifyListeners();

        // Auto-sync lists that have never been synced
        _autoSyncNewLists();
      },
    );
  }

  /// Automatically sync lists that have a URL but have never been synced
  Future<void> _autoSyncNewLists() async {
    final newLists = _lists.where((list) =>
      list.sourceUrl != null &&
      list.lastSyncedAt == null &&
      list.mappingCount == 0
    ).toList();

    if (newLists.isEmpty) return;

    // Sync each new list in the background
    for (final list in newLists) {
      _syncingLists.add(list.id);
      final result = await _syncListUseCase(list.id);
      _syncingLists.remove(list.id);

      result.fold(
        (failure) {
          // Silent failure for auto-sync, user can manually retry
        },
        (_) {
          // Success, reload to show updated counts
        },
      );
    }

    // Reload lists once after all auto-syncs complete
    if (newLists.isNotEmpty) {
      final reloadResult = await _getAllListsUseCase();
      reloadResult.fold(
        (failure) {},
        (lists) {
          _lists = lists;
          notifyListeners();
        },
      );
    }
  }

  /// Toggle list enabled state
  Future<void> toggleListEnabled(String listId) async {
    final list = _lists.firstWhere((l) => l.id == listId);
    final newState = !list.isEnabled;

    // Optimistic update
    final index = _lists.indexWhere((l) => l.id == listId);
    _lists[index] = list.copyWith(isEnabled: newState);
    notifyListeners();

    final result = await _toggleListEnabledUseCase(listId, newState);

    result.fold(
      (failure) {
        // Revert on failure
        _lists[index] = list;
        _errorMessage = _getFailureMessage(failure);
        notifyListeners();
      },
      (_) {
        _successMessage = 'List ${newState ? "enabled" : "disabled"} successfully';
        notifyListeners();
      },
    );
  }

  /// Sync a single list
  Future<void> syncList(String listId) async {
    final list = _lists.firstWhere((l) => l.id == listId);

    _syncingLists.add(listId);
    _errorMessage = null;
    notifyListeners();

    final result = await _syncListUseCase(listId);

    _syncingLists.remove(listId);

    result.fold(
      (failure) {
        _errorMessage = 'Failed to sync ${list.name}: ${_getFailureMessage(failure)}';
        notifyListeners();
      },
      (_) {
        _successMessage = '${list.name} synced successfully';
        // Reload lists to get updated mapping counts and sync timestamps
        loadLists();
      },
    );
  }

  /// Sync all lists that need syncing
  Future<void> syncAllLists() async {
    final listsToSync = _lists.where((list) => list.needsSync).toList();

    if (listsToSync.isEmpty) {
      _successMessage = 'All lists are up to date';
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    int successCount = 0;
    for (final list in listsToSync) {
      final result = await _syncListUseCase(list.id);
      result.fold(
        (failure) {
          // Continue syncing other lists on failure
        },
        (_) => successCount++,
      );
    }

    _isLoading = false;

    if (successCount == listsToSync.length) {
      _successMessage = 'All lists synced successfully';
    } else if (successCount > 0) {
      _successMessage = 'Synced $successCount of ${listsToSync.length} lists';
    } else {
      _errorMessage = 'Failed to sync lists';
    }

    // Reload lists
    await loadLists();
  }

  /// Import a list from URL
  /// Metadata (name, description, readonly, hook) will be read from the JSON file
  Future<bool> importListFromUrl({
    required String url,
    required String name,
    String? description,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _importListFromUrlUseCase(
      ImportListParams(
        url: url,
        name: name,
        description: description,
      ),
    );

    _isLoading = false;

    return result.fold(
      (failure) {
        _errorMessage = _getFailureMessage(failure);
        notifyListeners();
        return false;
      },
      (list) {
        _successMessage = 'List imported successfully: ${list.name}';
        // Reload lists
        loadLists();
        return true;
      },
    );
  }

  /// Clear messages
  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  /// Get user-friendly failure message
  String _getFailureMessage(dynamic failure) {
    return failure.toString().replaceFirst('CacheFailure: ', '')
        .replaceFirst('NetworkFailure: ', '')
        .replaceFirst('ServerFailure: ', '');
  }
}
