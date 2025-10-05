import 'package:flutter/material.dart';
import 'package:snake_xenzia/presentation/screens/game_screen.dart';
import 'package:snake_xenzia/presentation/screens/high_scores_screen.dart';
import 'package:snake_xenzia/presentation/screens/main_menu_screen.dart';
import 'package:snake_xenzia/presentation/screens/settings_screen.dart';
import 'package:snake_xenzia/presentation/screens/achievements_screen.dart';

/// Application routes configuration
class AppRoutes {
  AppRoutes._();

  // Route names
  static const String mainMenu = '/';
  static const String game = '/game';
  static const String settings = '/settings';
  static const String highScores = '/high-scores';
  static const String achievements = '/achievements';

  // Route definitions
  static Map<String, WidgetBuilder> get routes => {
        mainMenu: (context) => const MainMenuScreen(),
        game: (context) => const GameScreen(),
        settings: (context) => const SettingsScreen(),
        highScores: (context) => const HighScoresScreen(),
        achievements: (context) => const AchievementsScreen(),
      };
}
