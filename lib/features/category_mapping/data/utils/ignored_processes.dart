/// List of processes that should be automatically ignored
///
/// These processes are common system processes, launchers, or other
/// applications that are not games and should never trigger the
/// unknown game dialog.
///
/// When a process from this list is detected, it will be automatically
/// ignored without prompting the user.
class IgnoredProcesses {
  /// List of process names (case-insensitive) that should be automatically ignored
  ///
  /// This includes:
  /// - System processes (explorer.exe, etc.)
  /// - Game launchers (Steam, Epic, etc.)
  /// - Social platforms and overlay apps
  /// - Common utilities
  static const List<String> ignoredProcessNames = [
    // ========================================================================
    // SYSTEM PROCESSES
    // ========================================================================
    'explorer.exe',
    'dwm.exe', // Desktop Window Manager
    'taskmgr.exe', // Task Manager
    'cmd.exe',
    'powershell.exe',
    'conhost.exe',
    'svchost.exe',
    'mmc.exe', // Microsoft Management Console
    'rundll32.exe',

    // ========================================================================
    // GAME LAUNCHERS & PLATFORMS
    // ========================================================================

    // Steam
    'steam.exe',
    'steamwebhelper.exe',
    'steamerrorreporter.exe',
    'steamservice.exe',

    // Epic Games
    'epicgameslauncher.exe',
    'epicwebhelper.exe',
    'easyanticheat.exe',

    // EA/Origin
    'origin.exe',
    'originwebhelper.exe',
    'eadesktop.exe',
    'eabackgroundservice.exe',

    // Ubisoft
    'uplay.exe',
    'uplaywebcore.exe',
    'ubisoftconnect.exe',

    // GOG Galaxy
    'galaxyclient.exe',
    'galaxyclientservice.exe',

    // Battle.net
    'battle.net.exe',
    'blizzard.exe',
    'agent.exe', // Blizzard Agent

    // Rockstar Games
    'rockstargameslauncher.exe',
    'launchergamesservices.exe',
    'socialclublauncher.exe',
    'socialclub.exe',

    // Xbox/Microsoft Store
    'gamingservices.exe',
    'gamebar.exe',
    'xboxapp.exe',
    'microsoftstore.exe',

    // Amazon Games
    'amazongames.exe',

    // Riot Games
    'riotclientservices.exe',
    'riotclientux.exe',
    'riotclientcrashhandler.exe',

    // Other launchers
    'bethesdalauncher.exe',
    'playnite.exe',
    'playniteui.exe',
    'itch.exe',

    // ========================================================================
    // OVERLAYS & SOCIAL
    // ========================================================================

    // Discord
    'discord.exe',
    'discordptb.exe',
    'discordcanary.exe',

    // TeamSpeak
    'ts3client_win64.exe',
    'ts3client_win32.exe',

    // Nvidia
    'nvcontainer.exe',
    'nvsphelper64.exe',
    'geforce experience.exe',
    'geforceexperience.exe',
    'shadowplay.exe',

    // AMD
    'radeonrelive.exe',
    'radrmi.exe',
    'amdrsserv.exe',

    // ========================================================================
    // BROWSERS (Sometimes detected as focused window)
    // ========================================================================
    'chrome.exe',
    'firefox.exe',
    'msedge.exe',
    'opera.exe',
    'brave.exe',
    'vivaldi.exe',
    'iexplore.exe',

    // ========================================================================
    // COMMON UTILITIES
    // ========================================================================
    'notepad.exe',
    'notepad++.exe',
    'code.exe', // VS Code
    'devenv.exe', // Visual Studio
    'obs64.exe', // OBS Studio
    'obs32.exe',
    'streamlabs obs.exe',
    'spotify.exe',
    'vlc.exe',
    'winamp.exe',

    // ========================================================================
    // SECURITY & ANTI-CHEAT
    // ========================================================================
    'battleye.exe',
    'bedaisy.exe',
    'easyanticheat.exe',
    'vanguard.exe', // Riot Vanguard
    'faceitclient.exe',

    // ========================================================================
    // TKIT (Don't detect ourselves!)
    // ========================================================================
    'tkit.exe',
  ];

  /// Check if a process should be automatically ignored
  ///
  /// [processName] - The name of the process to check (e.g., "steam.exe")
  ///
  /// Returns true if the process should be ignored, false otherwise
  static bool shouldIgnore(String processName) {
    final normalizedName = processName.toLowerCase().trim();
    return ignoredProcessNames.any(
      (ignored) => ignored.toLowerCase() == normalizedName,
    );
  }

  /// Get a user-friendly explanation for why a process is ignored
  ///
  /// [processName] - The name of the process
  ///
  /// Returns a string explaining why the process is ignored, or null if not ignored
  static String? getIgnoreReason(String processName) {
    if (!shouldIgnore(processName)) return null;

    final normalizedName = processName.toLowerCase().trim();

    // System processes
    if (['explorer.exe', 'dwm.exe', 'taskmgr.exe', 'cmd.exe', 'powershell.exe']
        .contains(normalizedName)) {
      return 'System process';
    }

    // Browsers
    if (['chrome.exe', 'firefox.exe', 'msedge.exe', 'opera.exe', 'brave.exe']
        .contains(normalizedName)) {
      return 'Web browser';
    }

    // Launchers
    if (normalizedName.contains('steam') ||
        normalizedName.contains('epic') ||
        normalizedName.contains('origin') ||
        normalizedName.contains('uplay') ||
        normalizedName.contains('battle.net') ||
        normalizedName.contains('rockstar') ||
        normalizedName.contains('socialclub') ||
        normalizedName.contains('galaxy')) {
      return 'Game launcher/platform';
    }

    // Overlays & social
    if (normalizedName.contains('discord') ||
        normalizedName.contains('teamspeak') ||
        normalizedName.contains('nvidia') ||
        normalizedName.contains('geforce')) {
      return 'Overlay/social app';
    }

    // Anti-cheat
    if (normalizedName.contains('anticheat') ||
        normalizedName.contains('battleye') ||
        normalizedName.contains('vanguard')) {
      return 'Anti-cheat service';
    }

    // Generic
    return 'Non-game process';
  }
}
