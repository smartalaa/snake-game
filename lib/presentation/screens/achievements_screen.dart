import 'package:flutter/material.dart';

/// Achievements screen showing unlockable achievements
/// TODO: Implement complete achievements display
class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
      ),
      body: const Center(
        child: Text(
          'Achievements Screen - Implementation in Progress',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
