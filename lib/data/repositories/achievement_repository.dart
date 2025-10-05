import 'package:snake_xenzia/core/constants/game_constants.dart';
import 'package:snake_xenzia/core/services/storage_service.dart';
import 'package:snake_xenzia/data/models/achievement.dart';

/// Repository for managing achievements
class AchievementRepository {
  final StorageService _storageService;

  AchievementRepository({StorageService? storageService})
      : _storageService = storageService ?? StorageService();

  /// Get all achievements
  List<Achievement> getAllAchievements() {
    return _storageService.loadAchievements();
  }

  /// Get a specific achievement by ID
  Achievement? getAchievement(String id) {
    final achievements = getAllAchievements();
    try {
      return achievements.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get all unlocked achievements
  List<Achievement> getUnlockedAchievements() {
    final achievements = getAllAchievements();
    return achievements.where((a) => a.isUnlocked).toList();
  }

  /// Get all locked achievements
  List<Achievement> getLockedAchievements() {
    final achievements = getAllAchievements();
    return achievements.where((a) => !a.isUnlocked).toList();
  }

  /// Unlock an achievement
  Future<bool> unlockAchievement(String id) async {
    return await _storageService.unlockAchievement(id);
  }

  /// Update achievement progress
  Future<bool> updateProgress(String id, int currentValue) async {
    return await _storageService.updateAchievementProgress(id, currentValue);
  }

  /// Check and update score-based achievements
  Future<List<Achievement>> checkScoreAchievements(int score) async {
    final newlyUnlocked = <Achievement>[];

    if (score >= GameConstants.achievementScoreNovice) {
      if (await unlockAchievement(Achievements.scoreNovice.id)) {
        final achievement = getAchievement(Achievements.scoreNovice.id);
        if (achievement != null) newlyUnlocked.add(achievement);
      }
    }

    if (score >= GameConstants.achievementScoreSkilled) {
      if (await unlockAchievement(Achievements.scoreSkilled.id)) {
        final achievement = getAchievement(Achievements.scoreSkilled.id);
        if (achievement != null) newlyUnlocked.add(achievement);
      }
    }

    if (score >= GameConstants.achievementScoreExpert) {
      if (await unlockAchievement(Achievements.scoreExpert.id)) {
        final achievement = getAchievement(Achievements.scoreExpert.id);
        if (achievement != null) newlyUnlocked.add(achievement);
      }
    }

    if (score >= GameConstants.achievementScoreMaster) {
      if (await unlockAchievement(Achievements.scoreMaster.id)) {
        final achievement = getAchievement(Achievements.scoreMaster.id);
        if (achievement != null) newlyUnlocked.add(achievement);
      }
    }

    return newlyUnlocked;
  }

  /// Check and update length-based achievements
  Future<List<Achievement>> checkLengthAchievements(int length) async {
    final newlyUnlocked = <Achievement>[];

    if (length >= GameConstants.achievementLengthLong) {
      if (await unlockAchievement(Achievements.lengthLong.id)) {
        final achievement = getAchievement(Achievements.lengthLong.id);
        if (achievement != null) newlyUnlocked.add(achievement);
      }
    }

    if (length >= GameConstants.achievementLengthVeryLong) {
      if (await unlockAchievement(Achievements.lengthVeryLong.id)) {
        final achievement = getAchievement(Achievements.lengthVeryLong.id);
        if (achievement != null) newlyUnlocked.add(achievement);
      }
    }

    if (length >= GameConstants.achievementLengthMax) {
      if (await unlockAchievement(Achievements.lengthMax.id)) {
        final achievement = getAchievement(Achievements.lengthMax.id);
        if (achievement != null) newlyUnlocked.add(achievement);
      }
    }

    return newlyUnlocked;
  }

  /// Check and update games played achievements
  Future<List<Achievement>> checkGamesPlayedAchievements() async {
    final newlyUnlocked = <Achievement>[];
    final gamesPlayed = _storageService.getTotalGamesPlayed();

    await updateProgress(Achievements.gamesPersistent.id, gamesPlayed);
    if (gamesPlayed >= GameConstants.achievementGamesPersistent) {
      if (await unlockAchievement(Achievements.gamesPersistent.id)) {
        final achievement = getAchievement(Achievements.gamesPersistent.id);
        if (achievement != null) newlyUnlocked.add(achievement);
      }
    }

    await updateProgress(Achievements.gamesDedicated.id, gamesPlayed);
    if (gamesPlayed >= GameConstants.achievementGamesDedicated) {
      if (await unlockAchievement(Achievements.gamesDedicated.id)) {
        final achievement = getAchievement(Achievements.gamesDedicated.id);
        if (achievement != null) newlyUnlocked.add(achievement);
      }
    }

    return newlyUnlocked;
  }

  /// Check difficulty achievement
  Future<bool> checkDifficultyAchievement(int level) async {
    if (level >= GameConstants.maxLevel) {
      return await unlockAchievement(Achievements.maxDifficulty.id);
    }
    return false;
  }

  /// Get completion percentage
  double getCompletionPercentage() {
    final achievements = getAllAchievements();
    if (achievements.isEmpty) return 0.0;
    
    final unlocked = achievements.where((a) => a.isUnlocked).length;
    return (unlocked / achievements.length) * 100;
  }

  /// Get total achievements count
  int getTotalAchievementsCount() {
    return getAllAchievements().length;
  }

  /// Get unlocked achievements count
  int getUnlockedCount() {
    return _storageService.getUnlockedAchievementsCount();
  }

  /// Clear all achievements
  Future<bool> clearAll() async {
    return await _storageService.clearAchievements();
  }
}
