import 'package:equatable/equatable.dart';
import 'package:tkit/features/category_mapping/domain/entities/category_mapping.dart';

/// States for CategoryMappingBloc
sealed class CategoryMappingState extends Equatable {
  const CategoryMappingState();

  @override
  List<Object?> get props => [];
}

/// Initial state
final class CategoryMappingInitial extends CategoryMappingState {
  const CategoryMappingInitial();
}

/// Loading state
final class CategoryMappingLoading extends CategoryMappingState {
  const CategoryMappingLoading();
}

/// Mappings loaded successfully
final class CategoryMappingLoaded extends CategoryMappingState {
  final List<CategoryMapping> mappings;

  const CategoryMappingLoaded(this.mappings);

  @override
  List<Object?> get props => [mappings];
}

/// Single mapping found (for search)
final class CategoryMappingFound extends CategoryMappingState {
  final CategoryMapping? mapping;
  final String searchQuery;

  const CategoryMappingFound({
    required this.mapping,
    required this.searchQuery,
  });

  @override
  List<Object?> get props => [mapping, searchQuery];
}

/// Operation succeeded
final class CategoryMappingOperationSuccess extends CategoryMappingState {
  final String message;
  final List<CategoryMapping> mappings;

  const CategoryMappingOperationSuccess({
    required this.message,
    required this.mappings,
  });

  @override
  List<Object?> get props => [message, mappings];
}

/// Error state
final class CategoryMappingError extends CategoryMappingState {
  final String message;

  const CategoryMappingError(this.message);

  @override
  List<Object?> get props => [message];
}
