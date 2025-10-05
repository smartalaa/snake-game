import 'package:flutter/material.dart';

/// Color schemes for the Snake Xenzia game, supporting retro themes
class AppColors {
  AppColors._();

  // Backlight Theme (Classic green-on-black)
  static const backlightTheme = _BacklightColors();
  
  // Inversion Theme (Dark vs light)
  static const inversionTheme = _InversionColors();
  
  // Colorful Theme (Multiple colors)
  static const colorfulTheme = _ColorfulColors();
}

/// Classic green-on-black theme reminiscent of old Nokia phones
class _BacklightColors {
  const _BacklightColors();
  
  final Color background = const Color(0xFF0F1A0F);
  final Color foreground = const Color(0xFF9FD849);
  final Color accent = const Color(0xFF7CB342);
  final Color highlight = const Color(0xFFCDDC39);
  final Color border = const Color(0xFF558B2F);
  final Color snakeBody = const Color(0xFF9FD849);
  final Color snakeHead = const Color(0xFFCDDC39);
  final Color food = const Color(0xFFCDDC39);
  final Color wall = const Color(0xFF558B2F);
  final Color grid = const Color(0xFF558B2F);
  final Color text = const Color(0xFF9FD849);
  final Color textSecondary = const Color(0xFF7CB342);
}

/// High contrast dark/light theme
class _InversionColors {
  const _InversionColors();
  
  final Color background = const Color(0xFF000000);
  final Color foreground = const Color(0xFFFFFFFF);
  final Color accent = const Color(0xFFE0E0E0);
  final Color highlight = const Color(0xFFF5F5F5);
  final Color border = const Color(0xFF9E9E9E);
  final Color snakeBody = const Color(0xFFFFFFFF);
  final Color snakeHead = const Color(0xFFF5F5F5);
  final Color food = const Color(0xFFF5F5F5);
  final Color wall = const Color(0xFF9E9E9E);
  final Color grid = const Color(0xFF424242);
  final Color text = const Color(0xFFFFFFFF);
  final Color textSecondary = const Color(0xFFE0E0E0);
}

/// Colorful retro theme with multiple colors
class _ColorfulColors {
  const _ColorfulColors();
  
  final Color background = const Color(0xFF1A1A2E);
  final Color foreground = const Color(0xFF16213E);
  final Color accent = const Color(0xFF0F3460);
  final Color highlight = const Color(0xFFE94560);
  final Color border = const Color(0xFF533483);
  final Color snakeBody = const Color(0xFF4CAF50);
  final Color snakeHead = const Color(0xFF8BC34A);
  final Color food = const Color(0xFFFF5722);
  final Color wall = const Color(0xFF9C27B0);
  final Color grid = const Color(0xFF533483);
  final Color text = const Color(0xFFFFFFFF);
  final Color textSecondary = const Color(0xFFBDBDBD);
}

/// Available theme types
enum GameTheme {
  backlight,
  inversion,
  colorful,
}

/// Extension to get color scheme from theme type
extension GameThemeExtension on GameTheme {
  /// Get the appropriate color scheme for the theme
  dynamic get colors {
    switch (this) {
      case GameTheme.backlight:
        return AppColors.backlightTheme;
      case GameTheme.inversion:
        return AppColors.inversionTheme;
      case GameTheme.colorful:
        return AppColors.colorfulTheme;
    }
  }
  
  /// Get display name for the theme
  String get displayName {
    switch (this) {
      case GameTheme.backlight:
        return 'Backlight';
      case GameTheme.inversion:
        return 'Inversion';
      case GameTheme.colorful:
        return 'Colorful';
    }
  }
}