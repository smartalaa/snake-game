import 'package:flutter/material.dart';

/// High scores screen displaying top scores
/// TODO: Implement complete high scores display
class HighScoresScreen extends StatelessWidget {
  const HighScoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('High Scores'),
      ),
      body: const Center(
        child: Text(
          'High Scores Screen - Implementation in Progress',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
