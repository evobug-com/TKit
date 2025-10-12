# Contributing to TKit

Thank you for considering contributing to TKit! This document provides guidelines for contributing to the project.

## How to Contribute

### Reporting Bugs

1. Check if the bug has already been reported in [Issues](https://github.com/evobug-com/TKit/issues)
2. If not, create a new issue with:
   - Clear, descriptive title
   - Steps to reproduce
   - Expected vs actual behavior
   - Screenshots if applicable
   - System information (Windows version, TKit version)
   - Log files (found in `%APPDATA%/tkit/logs/`)

### Suggesting Features

1. Check [existing issues](https://github.com/evobug-com/TKit/issues) for similar suggestions
2. Create a new issue with:
   - Clear description of the feature
   - Use cases / why it's useful
   - Potential implementation approach (optional)

### Pull Requests

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/my-new-feature
   ```
3. **Make your changes**
   - Follow the code style guidelines below
   - Add tests if applicable
   - Update documentation if needed
4. **Commit your changes**
   ```bash
   git commit -m "feat: add new feature description"
   ```
5. **Push to your fork**
   ```bash
   git push origin feature/my-new-feature
   ```
6. **Create a Pull Request**
   - Describe what you changed and why
   - Reference any related issues
   - Include screenshots for UI changes

## Development Setup

See [DEVELOPERS.md](DEVELOPERS.md) for detailed setup instructions.

Quick start:
```bash
git clone https://github.com/evobug-com/TKit.git
cd TKit
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter run -d windows
```

## Code Style Guidelines

### General

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart)
- Use `dart format` before committing
- Run `dart analyze` to catch issues
- Maximum line length: 80 characters (flexible for readability)

### Naming Conventions

- **Classes**: `PascalCase` (e.g., `CategoryMapping`)
- **Variables/Functions**: `camelCase` (e.g., `processName`)
- **Constants**: `lowerCamelCase` (e.g., `defaultScanInterval`)
- **Private members**: prefix with `_` (e.g., `_updateCategory`)
- **Files**: `snake_case.dart` (e.g., `category_mapping_page.dart`)

### Architecture

TKit follows **Clean Architecture** principles:

#### Feature Structure
```
features/my_feature/
├── domain/              # Business logic
│   ├── entities/        # Core business objects
│   ├── repositories/    # Abstract interfaces
│   └── usecases/        # Business use cases
├── data/                # Data access
│   ├── datasources/     # API, database access
│   ├── models/          # Data models
│   └── repositories/    # Repository implementations
└── presentation/        # UI
    ├── pages/           # Full screens
    ├── widgets/         # Reusable components
    └── providers/       # State management
```

#### Dependency Rule

**Dependencies must point inward:**
- Presentation → Domain
- Data → Domain
- Domain has no external dependencies

#### Examples

**Good:**
```dart
// Data layer depends on domain
class CategoryMappingRepositoryImpl implements CategoryMappingRepository {
  final CategoryMappingLocalDataSource dataSource;

  Future<List<CategoryMapping>> getMappings() {
    return dataSource.getMappings();
  }
}
```

**Bad:**
```dart
// Domain depending on data (violates dependency rule)
class GetMappingsUseCase {
  final CategoryMappingLocalDataSource dataSource; // ❌ Should use repository interface
}
```

### State Management

Use **Provider** for state management:

```dart
class MyProvider extends ChangeNotifier {
  MyProvider(this._useCase);

  final MyUseCase _useCase;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> doSomething() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _useCase();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

### Error Handling

Use `Either` from `dartz` for operations that can fail:

```dart
// Repository
Future<Either<Failure, List<CategoryMapping>>> getMappings();

// Use case
Future<Either<Failure, List<CategoryMapping>>> call() {
  return repository.getMappings();
}

// Presentation
final result = await useCase();
result.fold(
  (failure) => showError(failure.message),
  (mappings) => displayMappings(mappings),
);
```

### Documentation

- Document all public APIs
- Use `///` for documentation comments
- Include examples for complex APIs

```dart
/// Retrieves all category mappings from the database.
///
/// Returns a list of [CategoryMapping] objects. The list may be empty
/// if no mappings have been created yet.
///
/// Example:
/// ```dart
/// final mappings = await repository.getMappings();
/// for (final mapping in mappings) {
///   print('${mapping.processName} -> ${mapping.categoryName}');
/// }
/// ```
Future<List<CategoryMapping>> getMappings();
```

## Testing

### Writing Tests

- Write tests for business logic (use cases, repositories)
- Write widget tests for complex UI components
- Use mocking for external dependencies

```dart
@GenerateMocks([CategoryMappingRepository])
void main() {
  late MockCategoryMappingRepository mockRepository;
  late GetMappingsUseCase useCase;

  setUp(() {
    mockRepository = MockCategoryMappingRepository();
    useCase = GetMappingsUseCase(mockRepository);
  });

  test('should return mappings from repository', () async {
    // Arrange
    final testMappings = [
      CategoryMapping(/* ... */),
    ];
    when(mockRepository.getMappings())
      .thenAnswer((_) async => Right(testMappings));

    // Act
    final result = await useCase();

    // Assert
    expect(result.isRight(), true);
    result.fold(
      (_) => fail('Should not fail'),
      (mappings) => expect(mappings, equals(testMappings)),
    );
  });
}
```

### Running Tests

```bash
# All tests
flutter test

# Specific test file
flutter test test/features/category_mapping/domain/usecases/get_mappings_usecase_test.dart

# With coverage
flutter test --coverage
```

## Commit Message Convention

Use [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

### Examples

```
feat(mappings): add import/export functionality

Allows users to backup and restore their category mappings.

Closes #123
```

```
fix(auto-switcher): prevent rapid category switches

Added debouncing to avoid switching categories too quickly
when alt-tabbing between applications.

Fixes #456
```

## Pull Request Guidelines

### Before Submitting

- [ ] Code follows the style guidelines
- [ ] Self-review completed
- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] No breaking changes (or clearly documented)
- [ ] `dart analyze` passes with no errors
- [ ] All tests pass

### PR Description Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
How was this tested?

## Screenshots (if applicable)
Add screenshots for UI changes

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-reviewed
- [ ] Tests added/updated
- [ ] Documentation updated
```

## Code Review Process

1. Maintainers will review your PR
2. Address any feedback or requested changes
3. Once approved, your PR will be merged
4. Your contribution will be included in the next release

## Recognition

Contributors are recognized in:
- CHANGELOG.md for each release
- GitHub contributors page
- Release notes

## Questions?

- Check [DEVELOPERS.md](DEVELOPERS.md) for technical details
- Ask in PR comments
- Open a discussion issue

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Code of Conduct

Be respectful and constructive. We're all here to make TKit better!
