# Database Migrations Guide

This document explains how database migrations work in TKit and how to create new ones.

## Current State

- **Schema Version:** `6`
- **Migration System:** Hybrid (Manual v1-v5, Guided v6+)
- **Database File:** `lib/core/database/app_database.dart`
- **Schema Snapshots:** `drift_schemas/app_database/`

## Migration History

| Version | Description | Method |
|---------|-------------|--------|
| v1 | Initial schema | Manual |
| v2 | Add cache expiry fields, unknown_processes, top_games_cache | Manual |
| v3 | Add community_mappings table | Manual |
| v4 | Add isEnabled field | Manual |
| v5 | Add normalizedInstallPaths (privacy-preserving) | Manual |
| v6 | Add mapping lists system, category field, pending submissions | **Guided** ✅ |
| v7+ | Future migrations | **Guided** |

## Architecture

### Manual Migrations (v1-v5)

Legacy migrations use hand-written SQL and Drift's `Migrator` API:

```dart
onUpgrade: (Migrator m, int from, int to) async {
  if (from <= 5 && to >= 6) {
    await customStatement('ALTER TABLE ...');
    await m.createTable(mappingLists);
  }
}
```

**Limitations:**
- No automatic testing
- Schema drift possible
- Error-prone

### Guided Migrations (v6+)

Current and future migrations use Drift's `make-migrations` command for safety:

```dart
import 'app_database.steps.dart';

onUpgrade: stepByStep(
  from6To7: (m, schema) async {
    await m.addColumn(schema.categoryMappings, schema.categoryMappings.newColumn);
  },
)
```

**Benefits:**
- ✅ Automatic migration tests
- ✅ Schema validation
- ✅ Type-safe with schema snapshots
- ✅ Harder to make mistakes

## Creating a New Migration (v7+)

The v5→v6 migration is already using the guided system. Follow this guide for v7 and beyond.

### Step 1: Make Schema Changes

Edit your table definitions in `app_database.dart`:

```dart
class CategoryMappings extends Table {
  // ... existing columns ...

  // NEW: Add your column
  TextColumn get myNewColumn => text().nullable()();
}
```

### Step 2: Bump Schema Version

```dart
@override
int get schemaVersion => 7; // Increment from 6 to 7
```

### Step 3: Generate Migration Files

Run the make-migrations command:

```bash
dart run drift_dev make-migrations
```

This generates:
- `drift_schemas/app_database/drift_schema_v7.json` - Schema snapshot
- `lib/core/database/app_database.steps.dart` - Migration helpers
- `test/drift/app_database/schema_test.dart` - Migration tests

### Step 4: Write the Migration

The generated `app_database.steps.dart` will have a `from6To7` parameter:

```dart
import 'app_database.steps.dart';

@override
MigrationStrategy get migration {
  return MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      // ... onCreate indexes ...
    },
    onUpgrade: stepByStep(
      // NEW: Your v6→v7 migration
      from6To7: (m, schema) async {
        await m.addColumn(
          schema.categoryMappings,
          schema.categoryMappings.myNewColumn,
        );
      },

      // IMPORTANT: Keep existing manual migrations for backwards compatibility
      migrator: (m, from, to) async {
        // Manual migrations for v1-v6
        if (from <= 1 && to >= 2) { /* ... */ }
        if (from <= 2 && to >= 3) { /* ... */ }
        if (from <= 3 && to >= 4) { /* ... */ }
        if (from <= 4 && to >= 5) { /* ... */ }
        if (from <= 5 && to >= 6) { /* ... */ }
      },
    ),
  );
}
```

### Step 5: Test the Migration

Run the generated tests:

```bash
dart test test/drift/app_database/
```

The tests will:
- Verify the migration runs without errors
- Check the final schema matches your table definitions
- Test data integrity across migrations

### Step 6: Test with Real Data (Recommended)

1. **Backup production database** (if applicable)
2. **Delete local database:**
   ```bash
   # Windows
   del %APPDATA%\TKit\tkit.db

   # macOS
   rm ~/Library/Application\ Support/TKit/tkit.db

   # Linux
   rm ~/.local/share/TKit/tkit.db
   ```
3. **Run app** - Database will be created with new schema
4. **Test migration path:**
   - Copy a v6 database and run the app
   - Verify migration runs and data is preserved

## Common Migration Operations

### Add a Column

```dart
from6To7: (m, schema) async {
  await m.addColumn(schema.myTable, schema.myTable.newColumn);
}
```

### Create a Table

```dart
from6To7: (m, schema) async {
  await m.createTable(schema.myNewTable);
}
```

### Create an Index

```dart
from6To7: (m, schema) async {
  await m.createIndex(Index(
    'idx_my_table_column',
    'CREATE INDEX idx_my_table_column ON my_table(column_name)',
  ));
}
```

### Rename a Column

```dart
from6To7: (m, schema) async {
  await m.renameColumn(
    schema.myTable,
    'old_name',
    schema.myTable.newName,
  );
}
```

### Drop a Table (Use with Caution!)

```dart
from6To7: (m, schema) async {
  await m.deleteTable('old_table_name');
}
```

### Complex Data Migration

```dart
from6To7: (m, schema) async {
  // 1. Add new column
  await m.addColumn(schema.myTable, schema.myTable.newColumn);

  // 2. Migrate data using raw SQL
  await m.database.customStatement('''
    UPDATE my_table
    SET new_column = CASE
      WHEN old_column = 'foo' THEN 'bar'
      ELSE 'default'
    END
  ''');

  // 3. Make column non-nullable (recreate table)
  // Note: SQLite doesn't support ALTER COLUMN, so you need to recreate
}
```

## Best Practices

### ✅ Do

- **Always test migrations** with the generated test suite
- **Test with real data** from previous versions
- **Keep migrations idempotent** - they should work even if run multiple times
- **Document complex migrations** with comments explaining why
- **Bump version for every schema change** - don't skip versions
- **Preserve data** - migrations should never lose user data

### ❌ Don't

- **Never skip versions** (e.g., going from v6 to v8)
- **Never modify old migrations** - they've already run on user devices
- **Don't delete schema snapshots** - needed for testing
- **Avoid `customStatement`** in guided migrations when possible
- **Never drop columns/tables** without user warning/export
- **Don't change manual migrations (v1-v6)** - already deployed

## Troubleshooting

### Migration Test Failures

```bash
# Error: Schema mismatch
```

**Solution:** Your migration didn't match your table definition. Check:
1. Did you add all new columns in the migration?
2. Did you create all new tables?
3. Did you update all modified column types?

### Database Locked Error

```bash
# Error: database is locked
```

**Solution:** Close all apps using the database, then retry.

### Schema Version Mismatch

```bash
# Error: Expected schema version X, found Y
```

**Solution:**
1. Delete `drift_schemas/app_database/drift_schema_vX.json`
2. Run `dart run drift_dev make-migrations` again

## File Structure

```
TKitFlutter/
├── lib/core/database/
│   ├── app_database.dart           # Main database class
│   ├── app_database.g.dart         # Generated code
│   └── app_database.steps.dart     # Generated migration helpers (v7+)
├── drift_schemas/app_database/
│   ├── drift_schema_v6.json        # v6 schema snapshot
│   └── drift_schema_v7.json        # v7 schema snapshot (future)
└── test/drift/app_database/
    └── schema_test.dart             # Generated migration tests (v7+)
```

## Additional Resources

- [Drift Migration Documentation](https://drift.simonbinder.eu/docs/migrations/)
- [Drift make-migrations Guide](https://drift.simonbinder.eu/docs/migrations/step_by_step/)
- [SQLite ALTER TABLE](https://www.sqlite.org/lang_altertable.html)

## Schema Versioning Policy

When to bump the schema version:

| Change | Bump Version? |
|--------|---------------|
| Add table | ✅ Yes |
| Add column | ✅ Yes |
| Remove column | ✅ Yes |
| Rename column | ✅ Yes |
| Change column type | ✅ Yes |
| Add index | ✅ Yes |
| Add/change default value | ❌ No (generated code only) |
| Rename Dart getter | ❌ No (code-level only) |
| Update comments/docs | ❌ No |

## Migration Checklist

Before committing a migration:

- [ ] Schema version bumped in `app_database.dart`
- [ ] `dart run drift_dev make-migrations` executed
- [ ] Migration code written in `stepByStep(fromXToY: ...)`
- [ ] Migration tests pass (`dart test test/drift/app_database/`)
- [ ] Tested with fresh database (onCreate)
- [ ] Tested with previous version database (onUpgrade)
- [ ] No data loss verified
- [ ] MIGRATIONS.md updated with version entry
- [ ] Schema snapshot committed to git (`drift_schemas/`)

## Current Implementation (v6)

The v5→v6 migration demonstrates guided migrations in action:

```dart
// lib/core/database/app_database.dart

import 'package:tkit/core/database/app_database.steps.dart';

@override
MigrationStrategy get migration => MigrationStrategy(
  onCreate: (Migrator m) async {
    await m.createAll();
    // ... indexes ...
  },
  onUpgrade: (Migrator m, int from, int to) async {
    // Manual migrations (v1-v5)
    if (from <= 1 && to >= 2) { /* ... */ }
    if (from <= 2 && to >= 3) { /* ... */ }
    if (from <= 3 && to >= 4) { /* ... */ }
    if (from <= 4 && to >= 5) { /* ... */ }

    // Guided migration (v5→v6)
    if (from <= 5 && to >= 6) {
      final schema = Schema6(database: attachedDatabase);
      await _migrateV5ToV6(m, schema);
    }
  },
);

/// Guided migration using type-safe schema
Future<void> _migrateV5ToV6(Migrator m, Schema6 schema) async {
  await m.addColumn(schema.communityMappings, schema.communityMappings.category);
  await m.createTable(schema.mappingLists);
  await m.addColumn(schema.categoryMappings, schema.categoryMappings.listId);
  await m.addColumn(schema.categoryMappings, schema.categoryMappings.pendingSubmission);
  // ... data migration ...
}
```

---

**Last Updated:** Schema v6 with Guided Migrations (2025-10-15)
