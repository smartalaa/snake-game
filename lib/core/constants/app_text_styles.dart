import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Text styles for the Snake Xenzia game with pixel-perfect retro fonts
class AppTextStyles {
  AppTextStyles._();

  /// Base font family - using a monospace font for retro feel
  static String get _fontFamily => GoogleFonts.orbitron().fontFamily!;
  
  /// Large title style for main headings
  static TextStyle get title => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: 2.0,
  );
  
  /// Subtitle style for section headers
  static TextStyle get subtitle => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
  );
  
  /// Body text style for general content
  static TextStyle get body => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.0,
  );
  
  /// Small text style for labels and captions
  static TextStyle get caption => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  );
  
  /// Score display style with larger, bold text
  static TextStyle get score => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    letterSpacing: 2.0,
  );
  
  /// Game over style for dramatic effect
  static TextStyle get gameOver => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.bold,
    letterSpacing: 3.0,
  );
  
  /// Menu item style for navigation
  static TextStyle get menuItem => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.2,
  );
  
  /// Button text style
  static TextStyle get button => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.0,
  );
  
  /// Achievement title style
  static TextStyle get achievementTitle => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.5,
  );
  
  /// Achievement description style
  static TextStyle get achievementDescription => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.8,
  );
  
  /// Level indicator style
  static TextStyle get levelIndicator => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.0,
  );
  
  /// High score entry style
  static TextStyle get highScoreEntry => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.0,
  );
  
  /// Pixel-style monospace font for game board numbers
  static TextStyle get pixelNumbers => TextStyle(
    fontFamily: GoogleFonts.courierPrime().fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.0,
  );
}

/// Extension to apply color to text styles
extension TextStyleColoring on TextStyle {
  /// Apply a specific color to the text style
  TextStyle colored(Color color) => copyWith(color: color);
  
  /// Apply retro glow effect (shadow)
  TextStyle withGlow(Color glowColor) => copyWith(
    shadows: [
      Shadow(
        color: glowColor.withOpacity(0.8),
        blurRadius: 4,
        offset: const Offset(0, 0),
      ),
      Shadow(
        color: glowColor.withOpacity(0.4),
        blurRadius: 8,
        offset: const Offset(0, 0),
      ),
    ],
  );
}