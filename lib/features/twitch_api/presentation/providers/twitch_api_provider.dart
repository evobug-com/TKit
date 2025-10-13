import 'package:flutter/foundation.dart';
import 'package:tkit/core/utils/app_logger.dart';
import 'package:tkit/features/twitch_api/domain/entities/twitch_category.dart';
import 'package:tkit/features/twitch_api/domain/usecases/search_categories_usecase.dart';

/// Provider for managing Twitch category search
/// Used primarily in the category mapping feature for searching categories
class TwitchApiProvider extends ChangeNotifier {
  final SearchCategoriesUseCase _searchCategoriesUseCase;
  final AppLogger _logger;

  TwitchApiProvider(this._searchCategoriesUseCase, this._logger);

  // State properties
  bool _isLoading = false;
  List<TwitchCategory> _categories = [];
  String? _errorMessage;
  String _currentQuery = '';

  // Getters
  bool get isLoading => _isLoading;
  List<TwitchCategory> get categories => _categories;
  String? get errorMessage => _errorMessage;
  String get currentQuery => _currentQuery;
  bool get hasSearched => _currentQuery.isNotEmpty || _errorMessage != null;

  /// Search for categories
  Future<void> searchCategories(String query, {int maxResults = 20}) async {
    final trimmedQuery = query.trim();

    // Don't search for empty queries
    if (trimmedQuery.isEmpty) {
      clearSearch();
      return;
    }

    _logger.info('Searching for categories: "$trimmedQuery"');
    _isLoading = true;
    _currentQuery = trimmedQuery;
    _errorMessage = null;
    notifyListeners();

    final result = await _searchCategoriesUseCase(
      trimmedQuery,
      first: maxResults,
    );

    result.fold(
      (failure) {
        _logger.error('Category search failed: ${failure.message}');
        _isLoading = false;
        _errorMessage = failure.message;
        _categories = [];
        notifyListeners();
      },
      (categories) {
        _logger.info(
          'Found ${categories.length} categories for "$trimmedQuery"',
        );
        _isLoading = false;
        _categories = categories;
        _errorMessage = null;
        notifyListeners();
      },
    );
  }

  /// Clear search results
  void clearSearch() {
    _logger.debug('Clearing category search');
    _isLoading = false;
    _categories = [];
    _errorMessage = null;
    _currentQuery = '';
    notifyListeners();
  }

  /// Set error message manually (for pre-flight checks)
  void setError(String message) {
    _logger.warning('Manual error set: $message');
    _isLoading = false;
    _errorMessage = message;
    _categories = [];
    notifyListeners();
  }
}
