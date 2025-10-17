import 'package:shared_preferences/shared_preferences.dart';

/// Service to manage tutorial/showcase state
class TutorialService {
  static const _tutorialCompletedKey = 'tutorial_completed';

  final SharedPreferences _prefs;

  TutorialService(this._prefs);

  /// Check if the tutorial has been completed
  Future<bool> isTutorialCompleted() async {
    return _prefs.getBool(_tutorialCompletedKey) ?? false;
  }

  /// Mark the tutorial as completed
  Future<void> completeTutorial() async {
    await _prefs.setBool(_tutorialCompletedKey, true);
  }

  /// Reset the tutorial (for "Show Tutorial Again" feature)
  Future<void> resetTutorial() async {
    await _prefs.setBool(_tutorialCompletedKey, false);
  }
}
