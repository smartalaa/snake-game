import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snake_xenzia/core/constants/game_constants.dart';
import 'package:snake_xenzia/data/models/achievement.dart';
import 'package:snake_xenzia/data/models/game_settings.dart';
import 'package:snake_xenzia/data/models/score_record.dart';

/// Service for managing local data storage
class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  /// Initialize the storage service
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get _preferences {
    if (_prefs == null) {
      throw StateError('StorageService not initialized. Call initialize() first.');
    }
    return _prefs!;
  }

  // ============ Settings ============

  /// Save game settings
  Future<bool> saveSettings(GameSettings settings) async {
    final json = jsonEncode(settings.toJson());
    return await _preferences.setString(GameConstants.settingsKey, json);
  }

  /// Load game settings
  GameSettings? loadSettings() {
    final json = _preferences.getString(GameConstants.settingsKey);
    if (json == null) return null;

    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return GameSettings.fromJson(map);
    } catch (e) {
      return null;
    }
  }

  // ============ High Scores ============

  /// Save high scores
  Future<bool> saveHighScores(List<ScoreRecord> scores) async {
    final jsonList = scores.map((score) => score.toJson()).toList();
    final json = jsonEncode(jsonList);
    return await _preferences.setString(GameConstants.highScoresKey, json);
  }

  /// Load high scores
  List<ScoreRecord> loadHighScores() {
    final json = _preferences.getString(GameConstants.highScoresKey);
    if (json == null) return [];

    try {
      final List<dynamic> jsonList = jsonDecode(json);
      return jsonList
          .map((item) => ScoreRecord.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Add a new high score
  Future<bool> addHighScore(ScoreRecord score) async {
    final scores = loadHighScores();
    scores.add(score);
    
    // Sort by score (descending)
    scores.sort((a, b) => b.score.compareTo(a.score));
    
    // Keep only top 100 scores
    final topScores = scores.take(100).toList();
    
    return await saveHighScores(topScores);
  }

  /// Get high scores for a specific level
  List<ScoreRecord> getHighScoresForLevel(int level) {
    final allScores = loadHighScores();
    return allScores.where((score) => score.level == level).toList();
  }

  /// Get top score for a specific level
  ScoreRecord? getTopScoreForLevel(int level) {
    final scores = getHighScoresForLevel(level);
    if (scores.isEmpty) return null;
    return scores.first;
  }

  // ============ Achievements ============

  /// Save achievements
  Future<bool> saveAchievements(List<Achievement> achievements) async {
    final jsonList = achievements.map((achievement) => achievement.toJson()).toList();
    final json = jsonEncode(jsonList);
    return await _preferences.setString(GameConstants.achievementsKey, json);
  }

  /// Load achievements
  List<Achievement> loadAchievements() {
    final json = _preferences.getString(GameConstants.achievementsKey);
    if (json == null) {
      // Return default achievements if none saved
      return Achievements.all;
    }

    try {
      final List<dynamic> jsonList = jsonDecode(json);
      return jsonList
          .map((item) => Achievement.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return Achievements.all;
    }
  }

  /// Update a specific achievement
  Future<bool> updateAchievement(Achievement achievement) async {
    final achievements = loadAchievements();
    final index = achievements.indexWhere((a) => a.id == achievement.id);
    
    if (index != -1) {
      achievements[index] = achievement;
    } else {
      achievements.add(achievement);
    }
    
    return await saveAchievements(achievements);
  }

  /// Unlock an achievement
  Future<bool> unlockAchievement(String achievementId) async {
    final achievements = loadAchievements();
    final index = achievements.indexWhere((a) => a.id == achievementId);
    
    if (index != -1 && !achievements[index].isUnlocked) {
      achievements[index] = achievements[index].copyWith(
        isUnlocked: true,
        unlockedAt: DateTime.now(),
        progress: 1.0,
      );
      return await saveAchievements(achievements);
    }
    
    return false;
  }

  /// Update achievement progress
  Future<bool> updateAchievementProgress(
    String achievementId,
    int currentValue,
  ) async {
    final achievements = loadAchievements();
    final index = achievements.indexWhere((a) => a.id == achievementId);
    
    if (index != -1) {
      final achievement = achievements[index];
      if (achievement.isUnlocked) return false;
      
      final requiredValue = achievement.requiredValue ?? 1;
      final progress = (currentValue / requiredValue).clamp(0.0, 1.0);
      final isUnlocked = currentValue >= requiredValue;
      
      achievements[index] = achievement.copyWith(
        currentValue: currentValue,
        progress: progress,
        isUnlocked: isUnlocked,
        unlockedAt: isUnlocked ? DateTime.now() : null,
      );
      
      return await saveAchievements(achievements);
    }
    
    return false;
  }

  /// Get unlocked achievements count
  int getUnlockedAchievementsCount() {
    final achievements = loadAchievements();
    return achievements.where((a) => a.isUnlocked).length;
  }

  // ============ Statistics ============

  /// Get total games played
  int getTotalGamesPlayed() {
    return _preferences.getInt('total_games') ?? 0;
  }

  /// Increment games played counter
  Future<bool> incrementGamesPlayed() async {
    final current = getTotalGamesPlayed();
    return await _preferences.setInt('total_games', current + 1);
  }

  /// Get highest score ever
  int getHighestScore() {
    final scores = loadHighScores();
    if (scores.isEmpty) return 0;
    return scores.first.score;
  }

  // ============ Utility ============

  /// Clear all data
  Future<bool> clearAll() async {
    return await _preferences.clear();
  }

  /// Clear only high scores
  Future<bool> clearHighScores() async {
    return await _preferences.remove(GameConstants.highScoresKey);
  }

  /// Clear only achievements
  Future<bool> clearAchievements() async {
    return await _preferences.remove(GameConstants.achievementsKey);
  }
}
