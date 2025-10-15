/// Utility for normalizing and extracting privacy-safe game installation paths
///
/// This class ensures that only game-identifying paths are stored, never
/// user-sensitive information like usernames or personal directories.
///
/// Works cross-platform (Windows, Linux, macOS) with support for:
/// - Native game installations
/// - Steam (including Flatpak on Linux)
/// - Wine/Proton (Windows games on Linux)
/// - Various game launchers (Epic, GOG, Lutris, etc.)
///
/// Examples:
/// ```
/// Windows:
/// C:\Program Files\Steam\steamapps\common\Dota 2\game\dota2.exe
/// → steamapps/common/dota 2
///
/// D:\Epic Games\Fortnite\FortniteGame\Binaries\Win64\FortniteClient.exe
/// → epic games/fortnite
///
/// Linux:
/// /home/user/.steam/steam/steamapps/common/Dota 2/game/dota2
/// → .steam/steam/steamapps/common/dota 2
///
/// /home/user/.local/share/lutris/runners/wine/game
/// → .local/share/lutris/runners/wine/game
///
/// Privacy Protection:
/// C:\Users\JohnSmith\MyGames\CustomGame\game.exe
/// → null (no recognizable anchor - username would leak)
/// ```
class PathNormalizer {
  /// Common game installation path anchors, ordered by specificity
  /// (most specific first to avoid false matches)
  ///
  /// Supports both Windows and Linux game installation locations
  static const _gamePathAnchors = <String>[
    // ========================================================================
    // WINDOWS PATHS
    // ========================================================================

    // Steam (most common)
    'steamapps/common',
    'steam/steamapps/common',
    'steamlibrary/steamapps/common',

    // Epic Games
    'epic games',

    // EA/Origin
    'ea games',
    'origin games',

    // GOG
    'gog games',
    'gog galaxy/games',

    // Riot Games
    'riot games',

    // Ubisoft
    'ubisoft/ubisoft game launcher/games',
    'ubisoft game launcher/games',

    // Battle.net/Blizzard
    'battle.net',
    'blizzard entertainment',

    // Xbox/Microsoft Store
    'windowsapps',
    'xbox games',
    'microsoft/windowsapps',

    // Rockstar
    'rockstar games',

    // Other launchers
    'amazon games',
    'bethesda.net launcher',
    'itch.io',
    'playnite',

    // Generic Windows (broader matches)
    'program files (x86)',
    'program files',

    // ========================================================================
    // LINUX PATHS
    // ========================================================================

    // Steam on Linux (most common - check specific paths first)
    '.steam/steam/steamapps/common',
    '.local/share/steam/steamapps/common',

    // Flatpak Steam (containerized)
    '.var/app/com.valvesoftware.steam/.local/share/steam/steamapps/common',
    '.var/app/com.valvesoftware.steam/data/steam/steamapps/common',

    // Lutris game manager
    'games/lutris',
    '.local/share/lutris/runners',

    // Wine/Proton prefixes (Windows games on Linux)
    '.wine/drive_c/program files',
    '.wine/drive_c/program files (x86)',

    // System-wide game directories
    '/usr/share/games',
    '/usr/local/games',
    '/opt/games',

    // Snap packages
    'snap/',

    // AppImage games (typically in user directories)
    'applications',

    // ========================================================================
    // GENERIC (Cross-platform - broader matches - check last)
    // ========================================================================
    'games', // Only if near root (max 2 segments before)
  ];

  /// Normalize a file path to a consistent format
  ///
  /// Converts to lowercase, uses forward slashes, and removes duplicate slashes
  ///
  /// Example:
  /// ```
  /// normalize('C:\\SteamApps\\\\Common\\Dota 2')
  /// → 'c:/steamapps/common/dota 2'
  /// ```
  static String normalize(String path) {
    return path
        .toLowerCase()
        .replaceAll('\\', '/') // Unified separator
        .replaceAll(RegExp('/+'), '/') // Collapse multiple slashes
        .replaceAll(RegExp('^[a-z]:/'), '') // Remove drive letter
        .trim();
  }

  /// Extract privacy-safe game path from full executable path
  ///
  /// Returns a normalized game installation path starting from a recognized
  /// game launcher/platform anchor, or null if no anchor is found.
  ///
  /// For privacy protection, this method will ONLY return paths that start
  /// with a recognized game platform anchor. Paths in custom user directories
  /// will return null to prevent leaking usernames or personal folder names.
  ///
  /// [fullPath] - The full path to the game executable
  ///
  /// Returns the normalized game path or null if no anchor found
  ///
  /// Examples:
  /// ```
  /// extractGamePath('C:\\Steam\\steamapps\\common\\Dota 2\\dota2.exe')
  /// → 'steamapps/common/dota 2'
  ///
  /// extractGamePath('C:\\Users\\John\\MyGames\\Game.exe')
  /// → null (privacy protection - no recognized anchor)
  /// ```
  static String? extractGamePath(String fullPath) {
    final normalized = normalize(fullPath);

    // Try to find a recognized anchor
    for (final anchor in _gamePathAnchors) {
      final idx = normalized.indexOf(anchor);
      if (idx == -1) continue;

      // Special case: 'games' should only match near root
      if (anchor == 'games') {
        final beforeAnchor = normalized.substring(0, idx);
        final segments =
            beforeAnchor.split('/').where((s) => s.isNotEmpty).length;
        if (segments > 2) continue; // Too deep, skip this anchor
      }

      // Extract from anchor to end, removing filename
      final fromAnchor = normalized.substring(idx);
      final pathSegments = fromAnchor.split('/');

      // Remove the executable filename (last segment)
      if (pathSegments.isNotEmpty) {
        pathSegments.removeLast();
      }

      // Must have at least one directory after anchor
      if (pathSegments.isEmpty) return null;

      return pathSegments.join('/');
    }

    // No recognizable anchor found - return null for privacy
    return null;
  }

  /// Extract all possible normalized paths from a list of full paths
  ///
  /// Useful when a game has been detected from multiple installations
  /// (e.g., Steam and Epic versions)
  ///
  /// [fullPaths] - List of full executable paths
  ///
  /// Returns a list of unique normalized paths (empty if no anchors found)
  static List<String> extractAllGamePaths(List<String> fullPaths) {
    final uniquePaths = <String>{};

    for (final fullPath in fullPaths) {
      final extracted = extractGamePath(fullPath);
      if (extracted != null) {
        uniquePaths.add(extracted);
      }
    }

    return uniquePaths.toList();
  }

  /// Check if a path was successfully normalized (has a recognized anchor)
  ///
  /// Returns true if the path contains a recognized game platform anchor
  static bool hasRecognizedAnchor(String fullPath) {
    return extractGamePath(fullPath) != null;
  }

  /// Get a user-friendly explanation of what will be stored
  ///
  /// Returns a message explaining what path data will be stored, or
  /// a warning if the path won't be stored for privacy reasons
  static String getStorageExplanation(String? fullPath) {
    if (fullPath == null || fullPath.isEmpty) {
      return 'No path detected. Only process name will be stored.';
    }

    final extracted = extractGamePath(fullPath);

    if (extracted != null) {
      return 'Privacy-safe path will be stored: $extracted\n'
          'Your username and personal folders are not included.';
    } else {
      return 'Custom installation location detected.\n'
          'For privacy, only the process name will be stored.\n'
          'Path matching will not be available for this game.';
    }
  }
}
