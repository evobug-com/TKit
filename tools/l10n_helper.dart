import 'dart:convert';
import 'dart:io';

void main(List<String> args) {
  if (args.isEmpty) {
    printUsage();
    exit(1);
  }

  final command = args[0];

  switch (command) {
    case 'extract':
      if (args.length < 3) {
        print('Usage: dart run tools/l10n_helper.dart extract <language> <output-file>');
        exit(1);
      }
      handleExtract(args[1], args[2]);
      break;

    case 'insert':
      if (args.length < 3) {
        print('Usage: dart run tools/l10n_helper.dart insert <language> <translations-file>');
        exit(1);
      }
      handleInsert(args[1], args[2]);
      break;

    case 'list':
      handleList();
      break;

    default:
      print('Unknown command: $command');
      printUsage();
      exit(1);
  }
}

void printUsage() {
  print('''
L10n Helper Tool - Manage translations without reading entire language files

Commands:
  extract <language> <output-file>
    Extract untranslated keys for a language with English values and insertion positions.
    Example: dart run tools/l10n_helper.dart extract cs translations_cs.json

  insert <language> <translations-file>
    Insert translated content into the language file at correct positions.
    Example: dart run tools/l10n_helper.dart insert cs translations_cs.json

  list
    List all languages and their missing translation counts.
    Example: dart run tools/l10n_helper.dart list
''');
}

void handleList() {
  final untranslatedFile = File('untranslated_messages.txt');
  if (!untranslatedFile.existsSync()) {
    print('Error: untranslated_messages.txt not found');
    exit(1);
  }

  final data = jsonDecode(untranslatedFile.readAsStringSync()) as Map<String, dynamic>;

  print('Missing translations by language:\n');
  for (final entry in data.entries) {
    final lang = entry.key;
    final keys = entry.value as List;
    print('  $lang: ${keys.length} missing keys');
  }
}

void handleExtract(String language, String outputFile) {
  print('Extracting untranslated keys for language: $language');

  // Read untranslated messages
  final untranslatedFile = File('untranslated_messages.txt');
  if (!untranslatedFile.existsSync()) {
    print('Error: untranslated_messages.txt not found');
    exit(1);
  }

  final untranslatedData = jsonDecode(untranslatedFile.readAsStringSync()) as Map<String, dynamic>;

  if (!untranslatedData.containsKey(language)) {
    print('Error: Language "$language" not found in untranslated_messages.txt');
    exit(1);
  }

  final missingKeys = (untranslatedData[language] as List).cast<String>();

  if (missingKeys.isEmpty) {
    print('No missing translations for language: $language');
    exit(0);
  }

  print('Found ${missingKeys.length} missing keys');

  // Read English ARB file
  final enArbFile = File('lib/l10n/app_en.arb');
  if (!enArbFile.existsSync()) {
    print('Error: lib/l10n/app_en.arb not found');
    exit(1);
  }

  final enArb = jsonDecode(enArbFile.readAsStringSync()) as Map<String, dynamic>;

  // Read target language ARB file to find insertion positions
  final langArbFile = File('lib/l10n/app_$language.arb');
  if (!langArbFile.existsSync()) {
    print('Error: lib/l10n/app_$language.arb not found');
    exit(1);
  }

  final langArb = jsonDecode(langArbFile.readAsStringSync()) as Map<String, dynamic>;
  final existingKeys = langArb.keys.toList();

  // Extract data for each missing key
  final extractedData = <Map<String, dynamic>>[];

  // Get all EN keys to preserve order
  final enKeys = enArb.keys.where((k) => !k.startsWith('@')).toList();

  for (final key in missingKeys) {
    if (!enArb.containsKey(key)) {
      print('Warning: Key "$key" not found in English ARB file, skipping');
      continue;
    }

    final value = enArb[key];
    final metaKey = '@$key';
    final metadata = enArb[metaKey] as Map<String, dynamic>?;

    // Find insertion position - insert after the last key that comes before this one in EN file
    final keyIndex = enKeys.indexOf(key);

    String? insertAfterKey;
    if (keyIndex > 0) {
      // Find the nearest previous key that exists in the target language
      for (int i = keyIndex - 1; i >= 0; i--) {
        if (existingKeys.contains(enKeys[i])) {
          insertAfterKey = enKeys[i];
          break;
        }
      }
    }

    extractedData.add({
      'key': key,
      'value': value,
      'description': metadata?['description'],
      'placeholders': metadata?['placeholders'],
      'insertAfter': insertAfterKey,
      'order': keyIndex, // Include order for correct insertion
    });
  }

  // Save to output file
  final output = {
    'language': language,
    'extractedAt': DateTime.now().toIso8601String(),
    'totalKeys': extractedData.length,
    'translations': extractedData,
  };

  final outputFileObj = File(outputFile);
  outputFileObj.writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert(output),
  );

  print('✓ Extracted ${extractedData.length} keys to $outputFile');
  print('\nNext steps:');
  print('1. Translate the "value" fields in $outputFile');
  print('2. Run: dart run tools/l10n_helper.dart insert $language $outputFile');
}

void handleInsert(String language, String translationsFile) {
  print('Inserting translations for language: $language');

  // Read translations file
  final transFile = File(translationsFile);
  if (!transFile.existsSync()) {
    print('Error: $translationsFile not found');
    exit(1);
  }

  final transData = jsonDecode(transFile.readAsStringSync()) as Map<String, dynamic>;
  final translations = (transData['translations'] as List).cast<Map<String, dynamic>>();

  if (translations.isEmpty) {
    print('No translations to insert');
    exit(0);
  }

  // Read target language ARB file
  final langArbFile = File('lib/l10n/app_$language.arb');
  if (!langArbFile.existsSync()) {
    print('Error: lib/l10n/app_$language.arb not found');
    exit(1);
  }

  final langArbContent = langArbFile.readAsStringSync();
  final langArb = jsonDecode(langArbContent) as Map<String, dynamic>;

  // Read the file as lines to preserve formatting
  final lines = langArbContent.split('\n');

  int insertedCount = 0;

  // Sort by order to maintain correct sequence
  final sortedTranslations = List<Map<String, dynamic>>.from(translations);
  sortedTranslations.sort((a, b) {
    final orderA = a['order'] as int? ?? 0;
    final orderB = b['order'] as int? ?? 0;
    return orderA.compareTo(orderB);
  });

  // Track the last inserted key to chain insertions
  String? lastInsertedKey;

  for (final trans in sortedTranslations) {
    final key = trans['key'] as String;
    final value = trans['value'];
    final description = trans['description'];
    final placeholders = trans['placeholders'];
    var insertAfter = trans['insertAfter'] as String?;

    // Skip if already exists
    if (langArb.containsKey(key)) {
      print('Skipping $key (already exists)');
      continue;
    }

    // If we've inserted keys, use the last inserted key as anchor
    if (lastInsertedKey != null) {
      // Check if the original insertAfter matches the previous trans's insertAfter
      // This means they're in sequence and should chain
      insertAfter = lastInsertedKey;
    }

    // Build the JSON entries
    final entries = <String>[];

    // Add the main key
    final valueJson = value is String
        ? jsonEncode(value)
        : const JsonEncoder.withIndent('  ').convert(value);
    entries.add('  "$key": $valueJson,');

    // Add metadata
    final metadata = <String, dynamic>{};
    if (description != null) {
      metadata['description'] = description;
    }
    if (placeholders != null) {
      metadata['placeholders'] = placeholders;
    }

    if (metadata.isNotEmpty) {
      final metadataJson = const JsonEncoder.withIndent('  ').convert(metadata);
      // Indent each line of metadata properly
      final metadataLines = metadataJson.split('\n');
      entries.add('  "@$key": ${metadataLines[0]}');
      for (int i = 1; i < metadataLines.length; i++) {
        entries.add('  ${metadataLines[i]}${i == metadataLines.length - 1 ? ',' : ''}');
      }
    }

    // Find insertion position in the file
    int insertIndex = -1;

    if (insertAfter != null) {
      // Find the line with "@insertAfter": {
      for (int i = 0; i < lines.length; i++) {
        if (lines[i].contains('"@$insertAfter"')) {
          // Find the closing brace
          int braceCount = 0;
          for (int j = i; j < lines.length; j++) {
            final line = lines[j];
            braceCount += line.split('{').length - 1;
            braceCount -= line.split('}').length - 1;

            if (braceCount == 0 && line.contains('}')) {
              insertIndex = j + 1;
              break;
            }
          }
          break;
        }
      }
    }

    // If no insertion point found, insert before the closing brace
    if (insertIndex == -1) {
      for (int i = lines.length - 1; i >= 0; i--) {
        if (lines[i].trim() == '}') {
          insertIndex = i;
          break;
        }
      }
    }

    if (insertIndex != -1) {
      // Insert entries
      for (final entry in entries.reversed) {
        lines.insert(insertIndex, entry);
      }
      insertedCount++;
      lastInsertedKey = key; // Track for next insertion
      print('✓ Inserted $key');
    } else {
      print('✗ Failed to find insertion point for $key');
    }
  }

  // Write back to file
  langArbFile.writeAsStringSync(lines.join('\n'));

  print('\n✓ Inserted $insertedCount translations into lib/l10n/app_$language.arb');
  print('\nNext steps:');
  print('1. Run: dart run build_runner build');
  print('2. Test the translations in the app');
}
