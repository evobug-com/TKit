# L10n Helper Tool

CLI tool for managing translations efficiently without needing to read entire language files.

## Purpose

When translating with AI:
- **Problem**: Language ARB files are large (1000+ lines)
- **Solution**: Extract only missing keys with English values, translate them, then insert back at correct positions

## Commands

### 1. List Missing Translations

```bash
dart run tools/l10n_helper.dart list
```

Shows count of missing translations per language.

### 2. Extract Missing Translations

```bash
dart run tools/l10n_helper.dart extract <language> <output-file>
```

**Example:**
```bash
dart run tools/l10n_helper.dart extract cs translations_cs.json
```

**Output format:**
```json
{
  "language": "cs",
  "extractedAt": "2025-10-15T10:30:00.000Z",
  "totalKeys": 28,
  "translations": [
    {
      "key": "settingsTabGeneral",
      "value": "General",
      "description": "General settings tab",
      "insertAfter": "settingsPageDescription"
    },
    ...
  ]
}
```

### 3. Insert Translations

```bash
dart run tools/l10n_helper.dart insert <language> <translations-file>
```

**Example:**
```bash
dart run tools/l10n_helper.dart insert cs translations_cs.json
```

Inserts translated content at correct positions in `lib/l10n/app_cs.arb`.

## Workflow with AI

### 1. Extract for Translation

```bash
# Extract missing keys for Czech
dart run tools/l10n_helper.dart extract cs translations_cs.json
```

### 2. Translate with AI

Give AI the generated `translations_cs.json` file with this prompt:

```
Translate all "value" fields in this JSON from English to Czech.
Preserve all JSON structure, placeholders, and special characters.
Only translate the text content in "value" fields.
```

AI translates without seeing the full language files (saves tokens).

### 3. Insert Translations

```bash
# Insert translated content
dart run tools/l10n_helper.dart insert cs translations_cs.json

# Regenerate localization files
dart run build_runner build
```

## Features

- **Efficient**: Only extracts/processes missing keys
- **Preserves Order**: Maintains original key order from English file
- **Smart Insertion**: Finds correct position based on surrounding keys
- **Metadata**: Includes descriptions and placeholders for context
- **Safe**: Skips keys that already exist

## File Structure

```
tools/
  l10n_helper.dart    # Main CLI tool
  README.md           # This file

lib/l10n/
  app_en.arb          # Source (English)
  app_cs.arb          # Target (Czech)
  app_*.arb           # Other languages

untranslated_messages.txt  # Generated list of missing keys
```

## Example: Full Translation Workflow

```bash
# 1. Check what needs translation
dart run tools/l10n_helper.dart list

# Output:
# Missing translations by language:
#   cs: 28 missing keys
#   de: 28 missing keys
#   es: 28 missing keys
#   ...

# 2. Extract for a language
dart run tools/l10n_helper.dart extract cs translations_cs.json

# 3. Give translations_cs.json to AI for translation
# (AI translates the "value" fields)

# 4. Insert translated content
dart run tools/l10n_helper.dart insert cs translations_cs.json

# 5. Rebuild
dart run build_runner build
```

## Tips

- **Batch Processing**: Extract for multiple languages at once
- **Version Control**: Commit the generated JSON files for review
- **Validation**: Run the app to test translations before committing
- **Incremental**: Tool handles partial translations - run multiple times
