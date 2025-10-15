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

  /// Save a mapping
  Future<void> saveMapping(entity.CategoryMapping mapping) async {
    final useCase = ref.read(saveMappingUseCaseProvider);
    final result = await useCase(mapping);

    result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
      },
      (_) {
        // Reload mappings after save
        loadMappings();
      },
    );
  }

  /// Delete a mapping by ID
  Future<void> deleteMapping(int id) async {
    final useCase = ref.read(deleteMappingUseCaseProvider);
    final result = await useCase(id);

    result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
      },
      (_) {
        // Reload mappings after delete
        loadMappings();
      },
    );
  }
}

// State class for CategoryMapping
class CategoryMappingState {
  final bool isLoading;
  final List<entity.CategoryMapping> mappings;
  final String? errorMessage;

  const CategoryMappingState({
    this.isLoading = false,
    this.mappings = const [],
    this.errorMessage,
  });

  CategoryMappingState copyWith({
    bool? isLoading,
    List<entity.CategoryMapping>? mappings,
    String? errorMessage,
  }) {
    return CategoryMappingState(
      isLoading: isLoading ?? this.isLoading,
      mappings: mappings ?? this.mappings,
      errorMessage: errorMessage,
    );
  }
}
