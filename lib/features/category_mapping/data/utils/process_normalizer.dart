/// Utility for normalizing and matching process names
///
/// Handles common variations in process names to improve matching:
/// - Version numbers (game_v1.2.3.exe → game.exe)
/// - Platform suffixes (game-x64.exe → game.exe)
/// - Special characters and spacing
/// - Common patterns
class ProcessNormalizer {
  /// Normalize a process name for comparison
  ///
  /// Removes:
  /// - .exe extension
  /// - Version numbers (v1.2.3, 1.2.3, etc.)
  /// - Platform suffixes (-x64, -x86, _64, _32, etc.)
  /// - Spaces, dashes, underscores
  /// - Converts to lowercase
  static String normalize(String processName) {
    String normalized = processName.toLowerCase();

    // Remove .exe extension
    normalized = normalized.replaceAll('.exe', '');

    // Remove version patterns
    // Patterns: v1.2.3, 1.2.3, v1_2_3, 1_2_3, etc.
    normalized = normalized.replaceAll(RegExp(r'[_\-\s]?v?\d+[\._]\d+[\._]\d+'), '');
    normalized = normalized.replaceAll(RegExp(r'[_\-\s]?v?\d+[\._]\d+'), '');
    normalized = normalized.replaceAll(RegExp(r'[_\-\s]?v\d+'), '');

    // Remove platform suffixes
    normalized = normalized.replaceAll(RegExp(r'[_\-](x64|x86|64|32|win64|win32)$'), '');

    // Remove special characters
    normalized = normalized.replaceAll(RegExp(r'[_\-\s:]'), '');

    // Remove common suffixes
    normalized = normalized.replaceAll(RegExp(r'(game|app|client|launcher)$'), '');

    return normalized.trim();
  }

  /// Generate variations of a process name for fuzzy matching
  ///
  /// Returns a list of possible variations to check
  static List<String> generateVariations(String processName) {
    final variations = <String>[];
    final normalized = normalize(processName);

    // Original normalized
    variations.add(normalized);

    // Without common prefixes
    final withoutPrefixes = normalized
        .replaceAll(RegExp('^(the|a|an)'), '')
        .trim();
    if (withoutPrefixes != normalized) {
      variations.add(withoutPrefixes);
    }

    // With spaces restored in common patterns
    // e.g., "leagueoflegends" → "league of legends"
    if (normalized.length > 10) {
      // Insert space before capitals in camelCase
      final withSpaces = normalized.replaceAllMapped(
        RegExp('([a-z])([A-Z])'),
        (match) => '${match.group(1)} ${match.group(2)?.toLowerCase()}',
      );
      if (withSpaces != normalized) {
        variations.add(withSpaces);
      }
    }

    // Remove duplicates while preserving order
    return variations.toSet().toList();
  }

  /// Check if two process names match after normalization
  static bool matches(String name1, String name2) {
    return normalize(name1) == normalize(name2);
  }

  /// Calculate similarity score between two process names (0.0 to 1.0)
  ///
  /// Uses normalized names and checks:
  /// - Exact match: 1.0
  /// - Contains: 0.7-0.9
  /// - Levenshtein distance: 0.0-0.6
  static double similarity(String name1, String name2) {
    final norm1 = normalize(name1);
    final norm2 = normalize(name2);

    // Exact match
    if (norm1 == norm2) {
      return 1.0;
    }

    // One contains the other
    if (norm1.contains(norm2) || norm2.contains(norm1)) {
      final shorter = norm1.length < norm2.length ? norm1 : norm2;
      final longer = norm1.length >= norm2.length ? norm1 : norm2;
      return 0.7 + (0.2 * (shorter.length / longer.length));
    }

    // Levenshtein distance similarity
    final distance = _levenshteinDistance(norm1, norm2);
    final maxLength = norm1.length > norm2.length ? norm1.length : norm2.length;

    if (maxLength == 0) return 0.0;

    final similarity = 1.0 - (distance / maxLength);
    return similarity.clamp(0.0, 0.6); // Cap at 0.6 for partial matches
  }

  /// Calculate Levenshtein distance between two strings
  static int _levenshteinDistance(String s1, String s2) {
    if (s1 == s2) return 0;
    if (s1.isEmpty) return s2.length;
    if (s2.isEmpty) return s1.length;

    final matrix = List.generate(
      s1.length + 1,
      (i) => List.generate(s2.length + 1, (j) => 0),
    );

    for (var i = 0; i <= s1.length; i++) {
      matrix[i][0] = i;
    }
    for (var j = 0; j <= s2.length; j++) {
      matrix[0][j] = j;
    }

    for (var i = 1; i <= s1.length; i++) {
      for (var j = 1; j <= s2.length; j++) {
        final cost = s1[i - 1] == s2[j - 1] ? 0 : 1;

        matrix[i][j] = [
          matrix[i - 1][j] + 1, // deletion
          matrix[i][j - 1] + 1, // insertion
          matrix[i - 1][j - 1] + cost, // substitution
        ].reduce((a, b) => a < b ? a : b);
      }
    }

    return matrix[s1.length][s2.length];
  }

  /// Find the best match from a list of candidates
  ///
  /// Returns the candidate with highest similarity score above threshold
  static String? findBestMatch(
    String processName,
    List<String> candidates, {
    double threshold = 0.7,
  }) {
    String? bestMatch;
    var bestScore = threshold;

    for (final candidate in candidates) {
      final score = similarity(processName, candidate);
      if (score > bestScore) {
        bestScore = score;
        bestMatch = candidate;
      }
    }

    return bestMatch;
  }
}
