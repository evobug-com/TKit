import 'package:flutter/foundation.dart';
import 'package:tkit/features/category_mapping/domain/entities/category_mapping.dart';
import 'package:tkit/features/category_mapping/domain/usecases/delete_mapping_usecase.dart';
import 'package:tkit/features/category_mapping/domain/usecases/find_mapping_usecase.dart';
import 'package:tkit/features/category_mapping/domain/usecases/get_all_mappings_usecase.dart';
import 'package:tkit/features/category_mapping/domain/usecases/save_mapping_usecase.dart';

/// Provider for managing category mapping state
///
/// Handles all category mapping operations including CRUD and search
class CategoryMappingProvider extends ChangeNotifier {
  final GetAllMappingsUseCase getAllMappingsUseCase;
  final FindMappingUseCase findMappingUseCase;
  final SaveMappingUseCase saveMappingUseCase;
  final DeleteMappingUseCase deleteMappingUseCase;

  // State properties
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  List<CategoryMapping> _mappings = [];
  CategoryMapping? _foundMapping;
  String? _searchQuery;

  CategoryMappingProvider({
    required this.getAllMappingsUseCase,
    required this.findMappingUseCase,
    required this.saveMappingUseCase,
    required this.deleteMappingUseCase,
  });

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  List<CategoryMapping> get mappings => _mappings;
  CategoryMapping? get foundMapping => _foundMapping;
  String? get searchQuery => _searchQuery;

  // Helper method to set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Helper method to set error
  void _setError(String message) {
    _errorMessage = message;
    _successMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  // Helper method to set success
  void _setSuccess(String message) {
    _successMessage = message;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  // Clear messages
  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  /// Load all mappings
  Future<void> loadMappings() async {
    _setLoading(true);

    final result = await getAllMappingsUseCase();

    result.fold(
      (failure) => _setError(failure.message),
      (mappings) {
        _mappings = mappings;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
    );
  }

  /// Add a new mapping
  Future<void> addMapping(CategoryMapping mapping, {String? successMessage}) async {
    _setLoading(true);

    final result = await saveMappingUseCase(mapping);

    await result.fold(
      (failure) async => _setError(failure.message),
      (_) async {
        // Reload all mappings to show the updated list
        final mappingsResult = await getAllMappingsUseCase();
        mappingsResult.fold(
          (failure) => _setError(failure.message),
          (mappings) {
            _mappings = mappings;
            _setSuccess(successMessage ?? 'Mapping added successfully');
          },
        );
      },
    );
  }

  /// Update an existing mapping
  Future<void> updateMapping(CategoryMapping mapping, {String? successMessage}) async {
    _setLoading(true);

    final result = await saveMappingUseCase(mapping);

    await result.fold(
      (failure) async => _setError(failure.message),
      (_) async {
        // Reload all mappings to show the updated list
        final mappingsResult = await getAllMappingsUseCase();
        mappingsResult.fold(
          (failure) => _setError(failure.message),
          (mappings) {
            _mappings = mappings;
            _setSuccess(successMessage ?? 'Mapping updated successfully');
          },
        );
      },
    );
  }

  /// Delete a mapping
  Future<void> deleteMapping(int id, {String? successMessage}) async {
    _setLoading(true);

    final result = await deleteMappingUseCase(id);

    await result.fold(
      (failure) async => _setError(failure.message),
      (_) async {
        // Reload all mappings to show the updated list
        final mappingsResult = await getAllMappingsUseCase();
        mappingsResult.fold(
          (failure) => _setError(failure.message),
          (mappings) {
            _mappings = mappings;
            _setSuccess(successMessage ?? 'Mapping deleted successfully');
          },
        );
      },
    );
  }

  /// Search for a mapping by process name
  Future<void> searchMapping({
    required String processName,
    String? executablePath,
  }) async {
    _setLoading(true);

    final result = await findMappingUseCase(
      processName: processName,
      executablePath: executablePath,
    );

    result.fold(
      (failure) => _setError(failure.message),
      (mapping) {
        _foundMapping = mapping;
        _searchQuery = processName;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
    );
  }

  /// Toggle enabled/disabled state of a mapping
  Future<void> toggleEnabled(CategoryMapping mapping) async {
    final updatedMapping = mapping.copyWith(isEnabled: !mapping.isEnabled);

    final result = await saveMappingUseCase(updatedMapping);

    await result.fold(
      (failure) async => _setError(failure.message),
      (_) async {
        // Update the mapping in the local list immediately for responsiveness
        final index = _mappings.indexWhere((m) => m.id == mapping.id);
        if (index != -1) {
          _mappings[index] = updatedMapping;
          notifyListeners();
        }
      },
    );
  }
}
