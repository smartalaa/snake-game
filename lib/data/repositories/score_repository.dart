import 'package:snake_xenzia/core/services/storage_service.dart';
import 'package:snake_xenzia/data/models/score_record.dart';

/// Repository for managing high scores
class ScoreRepository {
  final StorageService _storageService;

  ScoreRepository({StorageService? storageService})
      : _storageService = storageService ?? StorageService();

  /// Get all high scores
  List<ScoreRecord> getAllHighScores() {
    return _storageService.loadHighScores();
  }

  /// Get high scores for a specific level
  List<ScoreRecord> getScoresForLevel(int level) {
    return _storageService.getHighScoresForLevel(level);
  }

  /// Get top score for a specific level
  ScoreRecord? getTopScoreForLevel(int level) {
    return _storageService.getTopScoreForLevel(level);
  }

  /// Add a new score
  Future<bool> addScore(ScoreRecord score) async {
    await _storageService.incrementGamesPlayed();
    return await _storageService.addHighScore(score);
  }

  /// Check if a score is a new high score for its level
  bool isNewHighScore(ScoreRecord score) {
    final topScore = getTopScoreForLevel(score.level);
    if (topScore == null) return true;
    return score.score > topScore.score;
  }

  /// Get highest score ever achieved
  int getHighestScore() {
    return _storageService.getHighestScore();
  }

  /// Get total number of games played
  int getTotalGamesPlayed() {
    return _storageService.getTotalGamesPlayed();
  }

  /// Clear all high scores
  Future<bool> clearAllScores() async {
    return await _storageService.clearHighScores();
  }

  /// Get top N scores across all levels
  List<ScoreRecord> getTopScores({int limit = 10}) {
    final scores = getAllHighScores();
    return scores.take(limit).toList();
  }

  /// Get scores for a specific maze type
  List<ScoreRecord> getScoresForMaze(MazeType mazeType) {
    final allScores = getAllHighScores();
    return allScores.where((score) => score.mazeType == mazeType).toList();
  }

  /// Get campaign mode scores
  List<ScoreRecord> getCampaignScores() {
    final allScores = getAllHighScores();
    return allScores.where((score) => score.isCampaign).toList();
  }
}
