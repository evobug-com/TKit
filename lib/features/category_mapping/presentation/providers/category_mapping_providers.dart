import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tkit/core/providers/datasource_providers.dart';
import 'package:tkit/features/category_mapping/data/repositories/category_mapping_repository_impl.dart';
import 'package:tkit/features/category_mapping/domain/repositories/i_category_mapping_repository.dart';
import 'package:tkit/features/category_mapping/domain/usecases/get_all_mappings_usecase.dart';
import 'package:tkit/features/category_mapping/domain/usecases/find_mapping_usecase.dart';
import 'package:tkit/features/category_mapping/domain/usecases/save_mapping_usecase.dart';
import 'package:tkit/features/category_mapping/domain/usecases/delete_mapping_usecase.dart';
import 'package:tkit/features/category_mapping/domain/entities/category_mapping.dart' as entity;

part 'category_mapping_providers.g.dart';

// =============================================================================
// CATEGORY MAPPING REPOSITORY
// =============================================================================

@Riverpod(keepAlive: true)
ICategoryMappingRepository categoryMappingRepository(Ref ref) {
  final localDataSource = ref.watch(categoryMappingLocalDataSourceProvider);
  final memoryCache = ref.watch(memoryCacheProvider);
  return CategoryMappingRepositoryImpl(localDataSource, memoryCache);
}

// =============================================================================
// CATEGORY MAPPING USE CASES
// =============================================================================

@Riverpod(keepAlive: true)
GetAllMappingsUseCase getAllMappingsUseCase(Ref ref) {
  final repository = ref.watch(categoryMappingRepositoryProvider);
  return GetAllMappingsUseCase(repository);
}

@Riverpod(keepAlive: true)
FindMappingUseCase findMappingUseCase(Ref ref) {
  final repository = ref.watch(categoryMappingRepositoryProvider);
  return FindMappingUseCase(repository);
}

@Riverpod(keepAlive: true)
SaveMappingUseCase saveMappingUseCase(Ref ref) {
  final repository = ref.watch(categoryMappingRepositoryProvider);
  return SaveMappingUseCase(repository);
}

@Riverpod(keepAlive: true)
DeleteMappingUseCase deleteMappingUseCase(Ref ref) {
  final repository = ref.watch(categoryMappingRepositoryProvider);
  return DeleteMappingUseCase(repository);
}

// =============================================================================
// CATEGORY MAPPING STATE NOTIFIER
// =============================================================================

@Riverpod(keepAlive: true)
class CategoryMappings extends _$CategoryMappings {
  @override
  CategoryMappingState build() {
    return const CategoryMappingState();
  }

  /// Clear messages
  void clearMessages() {
    state = state.copyWith(
      errorMessage: null,
      successMessage: null,
    );
  }

  /// Load all mappings
  Future<void> loadMappings() async {
    state = state.copyWith(isLoading: true);

    final useCase = ref.read(getAllMappingsUseCaseProvider);
    final result = await useCase();

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (mappings) {
        state = state.copyWith(
          isLoading: false,
          mappings: mappings,
          errorMessage: null,
        );
      },
    );
  }

  /// Find a mapping by process name
  Future<entity.CategoryMapping?> findMapping(String processName) async {
    final useCase = ref.read(findMappingUseCaseProvider);
    final result = await useCase(processName: processName);

    return result.fold(
      (failure) => null,
      (mapping) => mapping,
    );
  }

  /// Add a new mapping
  Future<void> addMapping(entity.CategoryMapping mapping) async {
    state = state.copyWith(isLoading: true);

    final useCase = ref.read(saveMappingUseCaseProvider);
    final result = await useCase(mapping);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (_) {
        state = state.copyWith(
          isLoading: false,
          successMessage: 'Mapping added successfully',
        );
        // Reload mappings after save
        loadMappings();
      },
    );
  }

  /// Update an existing mapping
  Future<void> updateMapping(entity.CategoryMapping mapping) async {
    state = state.copyWith(isLoading: true);

    final useCase = ref.read(saveMappingUseCaseProvider);
    final result = await useCase(mapping);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (_) {
        state = state.copyWith(
          isLoading: false,
          successMessage: 'Mapping updated successfully',
        );
        // Reload mappings after save
        loadMappings();
      },
    );
  }

  /// Delete a mapping by ID
  Future<void> deleteMapping(int id) async {
    state = state.copyWith(isLoading: true);

    final useCase = ref.read(deleteMappingUseCaseProvider);
    final result = await useCase(id);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (_) {
        state = state.copyWith(
          isLoading: false,
          successMessage: 'Mapping deleted successfully',
        );
        // Reload mappings after delete
        loadMappings();
      },
    );
  }

  /// Toggle enabled/disabled state of a mapping
  Future<void> toggleEnabled(entity.CategoryMapping mapping) async {
    final updatedMapping = mapping.copyWith(isEnabled: !mapping.isEnabled);

    final useCase = ref.read(saveMappingUseCaseProvider);
    final result = await useCase(updatedMapping);

    result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
      },
      (_) {
        // Update the mapping in the local list immediately for responsiveness
        final mappings = List<entity.CategoryMapping>.from(state.mappings);
        final index = mappings.indexWhere((m) => m.id == mapping.id);
        if (index != -1) {
          mappings[index] = updatedMapping;
          state = state.copyWith(mappings: mappings);
        }
      },
    );
  }

  /// Bulk delete mappings
  Future<void> bulkDelete(List<int> ids) async {
    if (ids.isEmpty) {
      return;
    }

    state = state.copyWith(isLoading: true);

    final useCase = ref.read(deleteMappingUseCaseProvider);

    // Delete each mapping sequentially
    for (final id in ids) {
      final result = await useCase(id);
      if (result.isLeft()) {
        // If any deletion fails, show error and reload
        await loadMappings();
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to delete some mappings',
        );
        return;
      }
    }

    // Reload all mappings to show the updated list
    state = state.copyWith(
      isLoading: false,
      successMessage: 'Deleted ${ids.length} mapping${ids.length > 1 ? 's' : ''}',
    );
    await loadMappings();
  }

  /// Bulk toggle enabled/disabled state
  Future<void> bulkToggleEnabled(List<int> ids, {required bool enabled}) async {
    if (ids.isEmpty) {
      return;
    }

    state = state.copyWith(isLoading: true);

    final useCase = ref.read(saveMappingUseCaseProvider);

    // Update each mapping sequentially
    for (final id in ids) {
      final mapping = state.mappings.firstWhere((m) => m.id == id);
      final updatedMapping = mapping.copyWith(isEnabled: enabled);
      final result = await useCase(updatedMapping);

      if (result.isLeft()) {
        // If any update fails, show error and reload
        await loadMappings();
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to update some mappings',
        );
        return;
      }
    }

    // Reload all mappings to show the updated list
    state = state.copyWith(
      isLoading: false,
      successMessage: '${enabled ? 'Enabled' : 'Disabled'} ${ids.length} mapping${ids.length > 1 ? 's' : ''}',
    );
    await loadMappings();
  }

  /// Bulk restore deleted mappings
  Future<void> bulkRestore(List<entity.CategoryMapping> mappingsToRestore) async {
    if (mappingsToRestore.isEmpty) {
      return;
    }

    state = state.copyWith(isLoading: true);

    final useCase = ref.read(saveMappingUseCaseProvider);

    // Re-add each mapping sequentially
    for (final mapping in mappingsToRestore) {
      final result = await useCase(mapping);
      if (result.isLeft()) {
        // If any restore fails, show error and reload
        await loadMappings();
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to restore some mappings',
        );
        return;
      }
    }

    // Reload all mappings to show the updated list
    state = state.copyWith(
      isLoading: false,
      successMessage: 'Restored ${mappingsToRestore.length} mapping${mappingsToRestore.length > 1 ? 's' : ''}',
    );
    await loadMappings();
  }
}

// State class for CategoryMapping
class CategoryMappingState {
  final bool isLoading;
  final List<entity.CategoryMapping> mappings;
  final String? errorMessage;
  final String? successMessage;

  const CategoryMappingState({
    this.isLoading = false,
    this.mappings = const [],
    this.errorMessage,
    this.successMessage,
  });

  CategoryMappingState copyWith({
    bool? isLoading,
    List<entity.CategoryMapping>? mappings,
    String? errorMessage,
    String? successMessage,
  }) {
    return CategoryMappingState(
      isLoading: isLoading ?? this.isLoading,
      mappings: mappings ?? this.mappings,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}
