# Integration Test Scenarios

This folder contains comprehensive scenario-based integration tests for TKit. Each test file represents a complete user flow with mocked backend responses.

## Test Structure

### Scenarios

1. **01_auto_switcher_unknown_game_test.dart** - AutoSwitcher unknown game detection
2. **02_mappings_list_fetch_test.dart** - Fetching and displaying mapping lists
3. **03_mappings_enabled_toggle_test.dart** - Enabling/disabling individual mappings
4. **04_mappings_disable_list_test.dart** - Disabling entire lists

## Running Tests

```bash
# Run all scenario tests
flutter test integration_test/scenarios/

# Run specific scenario
flutter test integration_test/scenarios/01_auto_switcher_unknown_game_test.dart

# Run with verbose output
flutter test integration_test/scenarios/ --verbose
```

## Test Scenarios

### Scenario 1: AutoSwitcher - UnknownGameDialog Flow

**File:** `01_auto_switcher_unknown_game_test.dart`

**Tests:**
- 1.1: Enable Auto Switch and detect HelloWorld.exe triggers UnknownGameDialog
- 1.2: User can select category in UnknownGameDialog
- 1.3: User can ignore process in UnknownGameDialog

**Requirements:**
- Mock process detection system
- Override `processDetectionRepositoryProvider`
- Simulate HelloWorld.exe being detected 3 times
- Verify dialog appearance and content

**Current Status:**
- ✅ Test structure complete
- ⚠️ Process detection override needed
- ⚠️ Dialog interaction needs implementation

### Scenario 2.1: Fetch and Display Mapping Lists

**File:** `02_mappings_list_fetch_test.dart`

**Tests:**
- 2.1.1: Fetches and displays official games and programs lists
- 2.1.2: Displays individual mappings from lists
- 2.1.3: Handles fetch errors gracefully

**Mock Data:**
```dart
{
  'id': 'official-games',
  'name': 'Official Games List',
  'mappings': [
    {
      'processName': 'HelloWorld.exe',
      'twitchCategoryId': '999',
      'twitchCategoryName': 'Hello World Game',
    },
  ],
}
```

**Current Status:**
- ✅ Mock backend configured
- ✅ List display verification
- ⚠️ Individual mapping display needs UI implementation

### Scenario 2.2: Enabled Toggle Behavior

**File:** `03_mappings_enabled_toggle_test.dart`

**Tests:**
- 2.2.1: Disabling mapping triggers UnknownGameDialog for active process
- 2.2.2: Re-enabling mapping suppresses UnknownGameDialog
- 2.2.3: Multiple mappings - only disabled ones trigger dialog

**Flow:**
1. HelloWorld.exe is active
2. Mapping is enabled → No dialog
3. Disable mapping via toggle
4. UnknownGameDialog appears for HelloWorld.exe
5. Re-enable mapping → Dialog suppressed

**Current Status:**
- ✅ Test structure complete
- ⚠️ Process detection needed
- ⚠️ Toggle interaction implementation needed

### Scenario 2.3: Disable Entire List

**File:** `04_mappings_disable_list_test.dart`

**Tests:**
- 2.3.1: Disabling entire list triggers UnknownGameDialog for all processes
- 2.3.2: Re-enabling list suppresses UnknownGameDialog
- 2.3.3: Disabled list does not affect other enabled lists
- 2.3.4: Disabling all lists containing a process triggers dialog

**Flow:**
1. List "Test Games Collection" contains HelloWorld.exe
2. List is enabled → Process resolves normally
3. Disable entire list
4. HelloWorld.exe now triggers UnknownGameDialog
5. Re-enable list → Dialog suppressed

**Current Status:**
- ✅ Test structure complete
- ⚠️ Process detection needed
- ⚠️ List-level toggle implementation needed

## Implementation Checklist

### Phase 1: Process Detection (Required for all tests)

- [ ] Create `MockProcessDetectionRepository`
- [ ] Override `processDetectionRepositoryProvider` in tests
- [ ] Implement `simulateProcess()` method
- [ ] Integrate with `MockProcessDetector` helper

**Example:**
```dart
final mockProcessRepo = MockProcessDetectionRepository();
final container = ProviderContainer(
  overrides: [
    processDetectionRepositoryProvider.overrideWithValue(mockProcessRepo),
  ],
);

// In test:
mockProcessRepo.simulateProcess('HelloWorld.exe');
```

### Phase 2: Dialog Interaction

- [ ] Verify UnknownGameDialog appears
- [ ] Implement category selection
- [ ] Implement list selection
- [ ] Verify mapping save
- [ ] Test "Ignore" functionality

### Phase 3: Mapping Toggle Interaction

- [ ] Find mapping row in table
- [ ] Locate enabled toggle
- [ ] Simulate toggle click
- [ ] Verify state change

### Phase 4: List Toggle Interaction

- [ ] Find list header/card
- [ ] Locate list-level enabled toggle
- [ ] Simulate toggle click
- [ ] Verify all mappings affected

## Test Helpers

Located in `test/helpers/process_simulation/`:

### MockProcessDetector

```dart
final detector = MockProcessDetector();
detector.simulateHelloWorld();
detector.simulateProcess('Custom.exe', windowTitle: 'My App');
detector.simulateNoProcess();
```

### Process Test Helpers

```dart
// Wait for widgets
await waitForWidget(tester, find.text('Hello'));
await waitForDialog(tester, UnknownGameDialog);

// Navigation
await navigateToPage(tester, 'Mappings');
await enableAutoSwitcher(tester);

// Verification
expectDialogShown(UnknownGameDialog);
expectDialogNotShown(UnknownGameDialog);
```

## Mock Backend

All tests use `MockBackend` from `test/helpers/mock_backend.dart`:

```dart
final backend = MockBackend(dio);

// Mock list fetch
backend
  .onGet('https://example.com/list.json')
  .reply(200, {
    'id': 'test-list',
    'mappings': [...],
  });

// Mock Twitch API
backend
  .onGet('/search/categories')
  .withQueryParameters({'query': 'Hello'})
  .reply(200, MockResponses.twitchSearchCategories([...]));
```

## Writing New Tests

### 1. Create Test File

```dart
import 'package:integration_test/integration_test.dart';
import '../../test/helpers/mock_backend.dart';
import '../../test/helpers/process_simulation/process_test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('My Scenario', () {
    late MockBackend backend;

    setUp(() {
      // Initialize mocks
    });

    testWidgets('Test description', (tester) async {
      // Test implementation
    });
  });
}
```

### 2. Setup Mock Backend

```dart
final mockDio = Dio();
final backend = MockBackend(mockDio);

// Define responses
backend.onGet('/endpoint').reply(200, {...});
```

### 3. Create App with Overrides

```dart
final container = ProviderContainer(
  overrides: [
    authDioProvider.overrideWithValue(mockDio),
    // Add other overrides
  ],
);

await tester.pumpWidget(
  UncontrolledProviderScope(
    container: container,
    child: MyApp(),
  ),
);
```

### 4. Test Flow

```dart
// Navigate
await navigateToPage(tester, 'Mappings');

// Interact
await tapAndSettle(tester, find.text('Enable'));

// Verify
expect(find.text('Enabled'), findsOneWidget);
```

## Debugging

### Enable Debug Prints

Tests include `debugPrint()` statements:

```dart
debugPrint('✓ Step completed successfully');
debugPrint('! Warning: feature not implemented');
debugPrint('✗ Test failed at this point');
```

### View Test Output

```bash
flutter test integration_test/scenarios/ --verbose 2>&1 | grep "═\|✓\|!\|✗"
```

### Common Issues

**Process not detected:**
- Ensure `processDetectionRepositoryProvider` is overridden
- Check `simulateProcess()` is called correctly

**Dialog not appearing:**
- Verify UnknownGameDialog trigger logic
- Check if mapping already exists
- Ensure process detection is working

**Toggle not found:**
- Use `find.byType(Switch)` or `find.byType(Checkbox)`
- Check widget tree with `tester.printToConsole()`

## Future Enhancements

- [ ] Add screenshot capture on test failure
- [ ] Implement test coverage reporting
- [ ] Add performance benchmarks
- [ ] Create test data factories
- [ ] Add visual regression testing
- [ ] Implement parallel test execution

## Contributing

When adding new scenarios:

1. Follow existing naming convention (`0X_feature_action_test.dart`)
2. Document expected behavior in file header
3. Use descriptive test names
4. Include `debugPrint()` for progress tracking
5. Add to this README
6. Mark incomplete features with `!` in debug output

## References

- [Integration Testing Guide](../../test/README_TESTING.md)
- [Mock Backend Documentation](../../test/helpers/mock_backend.dart)
- [Flutter Integration Testing](https://docs.flutter.dev/testing/integration-tests)
