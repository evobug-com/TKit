# Developer Guide

This guide covers the technical details for developers who want to build, modify, or understand TKit's architecture.

## Tech Stack

- **Flutter** (Windows) - Cross-platform UI framework
- **Provider** - State management
- **Drift** - SQLite database for persistent storage
- **Dio** - HTTP client for Twitch API integration
- **flutter_secure_storage** - Secure token storage
- **window_manager** - Native window management
- **hotkey_manager** - Global hotkey support
- **Clean Architecture** - Domain, Data, Presentation layers

## Prerequisites

- **Flutter SDK** >=3.9.2
- **Dart SDK** (included with Flutter)
- **Windows 10/11** development machine
- **Visual Studio 2022** with "Desktop development with C++" workload
- **Git** for version control

## Building from Source

### Clone Repository

```bash
git clone https://github.com/evobug-com/TKit.git
cd TKit
```

### Install Dependencies

```bash
flutter pub get
```

### Generate Code

TKit uses code generation for database, routing, and serialization:

```bash
# Generate all code
dart run build_runner build --delete-conflicting-outputs

# Generate localizations
flutter gen-l10n
```

### Run in Development

```bash
# Run on Windows
flutter run -d windows

# Run with verbose logging
flutter run -d windows --dart-define=VERBOSE_LOGGING=true
```

### Build Release

```bash
# Build Windows release
flutter build windows --release

# Output: build/windows/x64/runner/Release/
```

### Create Installers

#### MSIX Package

```bash
# Configure in pubspec.yaml first
flutter pub run msix:create

# Output: build/windows/x64/runner/Release/TKit.msix
```

#### EXE Installer (Inno Setup)

1. Build the release first
2. Open `installer/windows/installer.iss` in Inno Setup Compiler
3. Click "Compile"
4. Output: `installer/windows/Output/TKit-Setup-{version}.exe`

## Project Structure

```
TKit/
├── lib/
│   ├── core/                     # Core functionality
│   │   ├── config/               # App configuration
│   │   ├── database/             # Drift database setup
│   │   ├── errors/               # Error handling
│   │   ├── platform/             # Windows platform channels
│   │   ├── routing/              # Auto-route navigation
│   │   ├── services/             # Core services
│   │   │   ├── hotkey_service.dart
│   │   │   ├── system_tray_service.dart
│   │   │   └── updater/          # Auto-update system
│   │   └── utils/                # Shared utilities
│   │
│   ├── features/                 # Feature modules (Clean Architecture)
│   │   ├── auth/                 # Twitch OAuth authentication
│   │   │   ├── domain/           # Entities, repositories, use cases
│   │   │   ├── data/             # Repository implementations, data sources
│   │   │   └── presentation/     # UI, state management (providers)
│   │   │
│   │   ├── auto_switcher/        # Main orchestration logic
│   │   ├── category_mapping/     # Process-to-category mappings
│   │   ├── process_detection/    # Active window detection
│   │   ├── settings/             # App settings management
│   │   ├── twitch_api/           # Twitch API integration
│   │   └── welcome/              # First-run experience
│   │
│   ├── l10n/                     # Localization files
│   ├── presentation/             # Shared UI components
│   │   ├── pages/                # Shared pages
│   │   └── widgets/              # Reusable widgets
│   │
│   ├── shared/                   # Shared code
│   │   ├── theme/                # Colors, text styles
│   │   └── widgets/              # Design system components
│   │
│   └── main.dart                 # Application entry point
│
├── windows/                      # Windows platform code
│   └── runner/                   # Windows runner with platform channels
│
├── test/                         # Unit and widget tests
├── integration_test/             # Integration tests
├── Assets/                       # Logo and icons
└── installer/                    # Installer scripts
```

## Architecture

TKit follows **Clean Architecture** principles with clear separation of concerns:

### Clean Architecture Layers

Each feature is organized into three layers:

#### 1. Domain Layer (Business Logic)
- **Entities**: Core business objects (e.g., `CategoryMapping`, `TwitchCategory`)
- **Repositories**: Abstract interfaces defining data operations
- **Use Cases**: Business logic encapsulated in single-responsibility classes

Example:
```dart
// Entity
class CategoryMapping {
  final String processName;
  final String categoryId;
  final bool isEnabled;
}

// Repository Interface (in domain)
abstract class CategoryMappingRepository {
  Future<List<CategoryMapping>> getMappings();
  Future<void> addMapping(CategoryMapping mapping);
}

// Use Case
class GetMappingsUseCase {
  final CategoryMappingRepository repository;

  Future<List<CategoryMapping>> call() {
    return repository.getMappings();
  }
}
```

#### 2. Data Layer (Data Access)
- **Repository Implementations**: Concrete implementations of domain interfaces
- **Data Sources**: Local (Drift database) and remote (Twitch API) data access
- **Models**: Data transfer objects with serialization

Example:
```dart
// Repository Implementation
class CategoryMappingRepositoryImpl implements CategoryMappingRepository {
  final CategoryMappingLocalDataSource localDataSource;

  @override
  Future<List<CategoryMapping>> getMappings() {
    return localDataSource.getMappings();
  }
}

// Data Source
class CategoryMappingLocalDataSource {
  final AppDatabase database;

  Future<List<CategoryMapping>> getMappings() {
    return database.categoryMappings.select().get();
  }
}
```

#### 3. Presentation Layer (UI)
- **Pages**: Full-screen views
- **Widgets**: Reusable UI components
- **Providers**: State management using Provider package

Example:
```dart
class CategoryMappingProvider extends ChangeNotifier {
  final GetMappingsUseCase getMappingsUseCase;

  List<CategoryMapping> _mappings = [];
  List<CategoryMapping> get mappings => _mappings;

  Future<void> loadMappings() async {
    _mappings = await getMappingsUseCase();
    notifyListeners();
  }
}
```

### Dependency Injection

TKit uses **manual dependency injection** with **Provider** for state management. All dependencies are manually created and wired together in `main.dart`:

```dart
void main() async {
  // 1. Create core dependencies (singletons)
  final database = AppDatabase();
  final dio = Dio();
  final secureStorage = const FlutterSecureStorage();
  final sharedPreferences = await SharedPreferences.getInstance();

  // 2. Create data sources
  final tokenLocalDataSource = TokenLocalDataSource(secureStorage);
  final categoryMappingLocalDataSource = CategoryMappingLocalDataSource(database);

  // 3. Create repositories
  final authRepository = AuthRepositoryImpl(
    twitchAuthRemoteDataSource,
    tokenLocalDataSource,
  );

  final categoryMappingRepository = CategoryMappingRepositoryImpl(
    categoryMappingLocalDataSource,
    memoryCache,
  );

  // 4. Create use cases
  final getAllMappingsUseCase = GetAllMappingsUseCase(categoryMappingRepository);

  // 5. Create providers
  final categoryMappingProvider = CategoryMappingProvider(
    getAllMappingsUseCase: getAllMappingsUseCase,
    findMappingUseCase: findMappingUseCase,
    saveMappingUseCase: saveMappingUseCase,
    deleteMappingUseCase: deleteMappingUseCase,
  );

  // 6. Provide all dependencies via MultiProvider
  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: database),
        Provider<ICategoryMappingRepository>.value(value: categoryMappingRepository),
        Provider<GetAllMappingsUseCase>.value(value: getAllMappingsUseCase),
        ChangeNotifierProvider<CategoryMappingProvider>.value(value: categoryMappingProvider),
      ],
      child: const TKitApp(),
    ),
  );
}
```

**Benefits of manual DI:**
- Compile-time safety (no service locator lookups)
- Explicit dependency graph (easy to understand)
- Better IDE support and navigation
- No hidden dependencies

### State Management

TKit uses **Provider** for state management:

- **ChangeNotifier**: For complex state (providers)
- **StreamProvider**: For reactive streams (database queries)
- **FutureProvider**: For async data loading

### Database

**Drift** (formerly Moor) is used for local SQLite database:

- Type-safe queries
- Reactive streams
- Schema versioning
- Migration support

Example table definition:
```dart
@DataClassName('CategoryMappingData')
class CategoryMappings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get processName => text()();
  TextColumn get categoryId => text()();
  TextColumn get categoryName => text()();
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();
}
```

## Key Services

### Auto Switcher Service
Orchestrates the automatic category switching:
1. Monitors process detection stream
2. Looks up category mapping
3. Updates Twitch category via API
4. Manages scan intervals and debouncing

### Process Detection Service
Windows-specific service using platform channels:
- Detects active window process
- Returns process name and path
- Handles UWP apps and system processes

### System Tray Service
Manages the system tray icon and menu:
- Show/hide main window
- Quick access to features
- Exit application

### Hotkey Service
Registers global keyboard shortcuts:
- Manual category update
- Show/hide window
- Configurable key combinations

### Update Service
GitHub-based auto-updater:
- Checks for new releases
- Downloads installers
- Supports multiple channels (Stable, RC, Beta, Dev)
- Installation type detection (MSIX vs EXE)

## Testing

### Run Tests

```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/
```

### Test Structure

```
test/
├── core/
│   └── services/
│       └── auto_switcher_service_test.dart
├── features/
│   └── category_mapping/
│       ├── domain/
│       │   └── usecases/
│       │       └── get_mappings_usecase_test.dart
│       └── presentation/
│           └── providers/
│               └── category_mapping_provider_test.dart
```

### Mocking

TKit uses **Mockito** for mocking dependencies:

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
    when(mockRepository.getMappings())
      .thenAnswer((_) async => [/* test data */]);

    final result = await useCase();

    expect(result, isNotEmpty);
  });
}
```

## Common Development Tasks

### Adding a New Feature

1. Create feature directory structure:
```
lib/features/my_feature/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
└── presentation/
    ├── pages/
    ├── widgets/
    └── providers/
```

2. Define domain layer (entities, repository interfaces, use cases)
3. Implement data layer (data sources, repository implementations)
4. Build presentation layer (UI, providers)
5. Wire up dependencies manually in `main.dart`:
   - Create data sources with required dependencies
   - Create repository with data sources
   - Create use cases with repositories
   - Create provider with use cases
   - Add all to MultiProvider
6. Add routes in `lib/core/routing/app_router.dart`

### Adding a Database Table

1. Define table in `lib/core/database/app_database.dart`:
```dart
class MyTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}
```

2. Add to database class:
```dart
@DriftDatabase(tables: [MyTable])
class AppDatabase extends _$AppDatabase {
  // ...
}
```

3. Increment schema version and add migration:
```dart
@override
int get schemaVersion => 5; // Increment

@override
MigrationStrategy get migration => MigrationStrategy(
  onUpgrade: (m, from, to) async {
    if (from == 4 && to == 5) {
      // Add migration logic
    }
  }
);
```

4. Generate code:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Adding Localization

1. Add keys to `lib/l10n/app_en.arb`:
```json
{
  "myNewKey": "My new text",
  "@myNewKey": {
    "description": "Description of what this is for"
  }
}
```

2. Generate localizations:
```bash
flutter gen-l10n
```

3. Use in code:
```dart
final l10n = AppLocalizations.of(context)!;
Text(l10n.myNewKey)
```

## Debugging

### Enable Verbose Logging

```bash
flutter run -d windows --dart-define=VERBOSE_LOGGING=true
```

### View Logs

Logs are written to:
- Console (during development)
- File: `%APPDATA%/tkit/logs/tkit.log`

### Common Issues

**Issue**: "Process detection not working"
- Check Windows platform channel implementation
- Verify UAC isn't blocking process access
- Check logs for platform channel errors

**Issue**: "Database migration failed"
- Check schema version incremented correctly
- Verify migration logic in `onUpgrade`
- Delete database file to start fresh (development only)

**Issue**: "Twitch API returns 401"
- Token may be expired, re-authenticate
- Check token storage in flutter_secure_storage
- Verify scopes in `lib/core/config/app_config.dart`

## Performance Tips

1. **Use const constructors** wherever possible
2. **Avoid rebuilds** with proper Provider usage
3. **Database indexes** for frequently queried columns
4. **Debounce rapid events** (process changes, API calls)
5. **Lazy load** heavy resources

## Code Style

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart)
- Run `dart format` before committing
- Run `dart analyze` to catch issues
- Use meaningful variable names
- Document public APIs

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Provider Documentation](https://pub.dev/packages/provider)
- [Drift Documentation](https://drift.simonbinder.eu/)
- [Twitch API Documentation](https://dev.twitch.tv/docs/api/)
- [Clean Architecture Guide](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

## Getting Help

- Check existing [GitHub Issues](https://github.com/evobug-com/TKit/issues)
- Review [CONTRIBUTING.md](CONTRIBUTING.md)
- Ask questions in pull request discussions
