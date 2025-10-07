import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake_xenzia/data/models/score_record.dart';
import 'package:snake_xenzia/data/repositories/score_repository.dart';

/// High scores screen displaying the leaderboard
class HighScoresScreen extends StatefulWidget {
  const HighScoresScreen({super.key});

  @override
  State<HighScoresScreen> createState() => _HighScoresScreenState();
}

class _HighScoresScreenState extends State<HighScoresScreen> {
  MazeType? _selectedMazeFilter;
  List<ScoreRecord> _scores = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  Future<void> _loadScores() async {
    setState(() => _isLoading = true);
    
    final repository = context.read<ScoreRepository>();
    final scores = _selectedMazeFilter == null
        ? await Future.value(repository.getTopScores(limit: 100))
        : await Future.value(repository.getScoresForMaze(_selectedMazeFilter!));
    
    setState(() {
      _scores = scores;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('High Scores'),
        backgroundColor: const Color(0xFF1A1A2E),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            tooltip: 'Filter by maze',
          ),
          if (_selectedMazeFilter != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                setState(() => _selectedMazeFilter = null);
                _loadScores();
              },
              tooltip: 'Clear filter',
            ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F3460),
            ],
          ),
        ),
        child: Column(
          children: [
            // Header with filter info
            if (_selectedMazeFilter != null)
              Container(
                padding: const EdgeInsets.all(12),
                color: const Color(0xFF9FD849).withOpacity(0.2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _selectedMazeFilter!.icon,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Filtered by: ${_selectedMazeFilter!.displayName}',
                      style: const TextStyle(
                        color: Color(0xFF9FD849),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

            // Scores list
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF9FD849),
                      ),
                    )
                  : _scores.isEmpty
                      ? _buildEmptyState()
                      : _buildScoresList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: 80,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            _selectedMazeFilter == null
                ? 'No scores yet!'
                : 'No scores for this maze',
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Play some games to see scores here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoresList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _scores.length,
      itemBuilder: (context, index) {
        final score = _scores[index];
        final isTopThree = index < 3;
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildScoreCard(score, index + 1, isTopThree),
        );
      },
    );
  }

  Widget _buildScoreCard(ScoreRecord score, int rank, bool isTopThree) {
    return Card(
      elevation: isTopThree ? 8 : 2,
      color: isTopThree
          ? const Color(0xFF9FD849).withOpacity(0.15)
          : const Color(0xFF0F3460).withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isTopThree ? const Color(0xFF9FD849) : Colors.white24,
          width: isTopThree ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Rank badge
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: _getRankColor(rank),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Center(
                child: isTopThree
                    ? Text(
                        _getRankEmoji(rank),
                        style: const TextStyle(fontSize: 24),
                      )
                    : Text(
                        '$rank',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 16),

            // Score details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Score value
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Color(0xFF9FD849),
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${score.score} pts',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF9FD849),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Maze and difficulty
                  Row(
                    children: [
                      Text(
                        score.mazeType.icon,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        score.mazeType.displayName,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Lvl ${score.level}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Snake length and date
                  Row(
                    children: [
                      const Icon(
                        Icons.straighten,
                        size: 14,
                        color: Colors.white54,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Length: ${score.snakeLength}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white54,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.white54,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(score.timestamp),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return const Color(0xFF0F3460);
    }
  }

  String _getRankEmoji(int rank) {
    switch (rank) {
      case 1:
        return '🥇';
      case 2:
        return '🥈';
      case 3:
        return '🥉';
      default:
        return '';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      // Simple month/day format
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[date.month - 1]} ${date.day}';
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text(
          'Filter by Maze',
          style: TextStyle(color: Color(0xFF9FD849)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.all_inclusive, color: Colors.white70),
              title: const Text(
                'All Mazes',
                style: TextStyle(color: Colors.white),
              ),
              selected: _selectedMazeFilter == null,
              selectedTileColor: const Color(0xFF9FD849).withOpacity(0.2),
              onTap: () {
                setState(() => _selectedMazeFilter = null);
                _loadScores();
                Navigator.pop(context);
              },
            ),
            const Divider(color: Colors.white24),
            ...MazeType.values.map((maze) {
              return ListTile(
                leading: Text(
                  maze.icon,
                  style: const TextStyle(fontSize: 24),
                ),
                title: Text(
                  maze.displayName,
                  style: const TextStyle(color: Colors.white),
                ),
                selected: _selectedMazeFilter == maze,
                selectedTileColor: const Color(0xFF9FD849).withOpacity(0.2),
                onTap: () {
                  setState(() => _selectedMazeFilter = maze);
                  _loadScores();
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF9FD849)),
            ),
          ),
        ],
      ),
    );
  }
}

