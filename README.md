# 🐍 Snake Xenzia - Flutter Game

A complete Flutter implementation of the classic Snake Xenzia game with modern features, retro pixel art aesthetics, and clean architecture.

**🎮 GAME STATUS: FULLY PLAYABLE!** - Try it now on Web, Android, or iOS!

[![Flutter](https://img.shields.io/badge/Flutter-3.9.2+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Progress](https://img.shields.io/badge/Progress-85%25-brightgreen)]()

## ✨ Features

### 🎮 Gameplay
- **10 Difficulty Levels** - Progressive speed from beginner (500ms) to expert (140ms)
- **6 Unique Mazes** - No Maze, Box, Tunnel, Mill, Rails, Apartment
- **Campaign Mode** - Progress through all mazes sequentially
- **Classic Mode** - Choose any maze and difficulty
- **Smart Scoring** - Points multiplied by difficulty level

### 🎨 Visual Themes
- **Backlight** - Classic Nokia green phosphor on black
- **Inversion** - High contrast black and white
- **Colorful** - Vibrant retro neon colors

### 🎯 Controls
- **Swipe Gestures** - Swipe in any direction
- **Screen Taps** - Tap left/right to turn
- **Keyboard** - Arrow keys, WASD, numeric pad
- **Volume Buttons** - Android hardware buttons (planned)

### 🏆 Achievements
12 unlockable achievements with progress tracking:
- Score milestones (100, 500, 1000, 2500)
- Snake length challenges (20, 50, 100)
- Persistence rewards (50, 100 games)
- Special achievements (Campaign Master, Speed Demon)

### 💾 Data Persistence
- Top 100 high scores with metadata
- Achievement progress tracking
- Settings and preferences
- Game statistics

## 📸 Screenshots

### Main Menu
Beautiful retro-themed menu with theme selection (Backlight, Inversion, Colorful)

### Game Screen - PLAYABLE! 🎮
- ✅ Full canvas rendering with CustomPainter
- ✅ Swipe and keyboard controls (arrows + WASD)
- ✅ All 6 mazes working
- ✅ Pause/resume functionality
- ✅ Score tracking with difficulty multipliers
- ✅ Game over dialog with retry option

_Screenshots coming soon - Or build and play it yourself!_

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.9.2 or higher
- Dart 3.0 or higher
- Android Studio / VS Code / IntelliJ

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd Snake-Xenzia
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # On Web (Recommended - fastest to test!)
   flutter run -d chrome

   # On Android
   flutter run

   # On iOS
   flutter run -d ios

   # On Windows (may have NuGet issues, try web/mobile first)
   flutter run -d windows
   ```

4. **Play the game!** 🎮
   - Use arrow keys or WASD to move
   - Swipe on touch devices
   - Press Space to pause
   - Eat food, avoid walls and yourself!

### Building for Release

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release

# Windows (may need network access for dependencies)
flutter build windows --release
```

## 🏗️ Architecture

The project follows **Clean Architecture** principles with **BLoC** state management:

```
┌─────────────────┐
│  Presentation   │  ← Widgets, Screens, UI
└────────┬────────┘
         │
┌────────▼────────┐
│     Domain      │  ← BLoCs, Events, States
└────────┬────────┘
         │
┌────────▼────────┐
│      Data       │  ← Models, Repositories, Services
└─────────────────┘
```

### Key Components

**Data Layer:**
- Models: `Position`, `SnakeSegment`, `Direction`, `Achievement`, `ScoreRecord`, `GameSettings`, `Maze`
- Repositories: `ScoreRepository`, `AchievementRepository`

**Domain Layer:**
- BLoCs: `SnakeGameBloc`, `SettingsBloc`
- Complete event/state system for reactive updates

**Presentation Layer:**
- Screens: Main Menu, Game, Settings, High Scores, Achievements
- Widgets: Snake Board (CustomPainter), Controls, Scoreboard

**Core:**
- Services: `AudioService`, `StorageService`
- Utilities: `CollisionDetection`, `RandomGenerator`
- Constants: Colors, Text Styles, Game Configuration

## 📂 Project Structure

```
lib/
├── main.dart                    # App entry point
├── core/
│   ├── constants/              # Colors, text styles, sounds, game config
│   ├── services/               # Audio, storage services
│   └── utilities/              # Collision detection, helpers
├── data/
│   ├── models/                 # Data models & enums
│   └── repositories/           # Data access layer
├── domain/
│   └── blocs/                  # State management (BLoC)
├── presentation/
│   ├── screens/                # UI screens
│   └── widgets/                # Reusable components
└── routes/                     # Navigation configuration
```

## 🎮 How to Play

1. **Start Game** - Choose Classic or Campaign mode
2. **Control the Snake** - Use swipes, taps, or keyboard
3. **Eat Food** - Grow longer and score points
4. **Avoid Collisions** - Don't hit walls or yourself
5. **Progress** - Complete mazes in Campaign mode
6. **Unlock Achievements** - Reach milestones for rewards

### Scoring System
- Base points: **10 per food**
- Multiplier: **Current difficulty level**
- Example: Level 5 = 10 × 5 = **50 points/food**
- Maze completion bonus: **+100 points**

## 🛠️ Configuration

Game settings can be modified in `lib/core/constants/game_constants.dart`:

```dart
// Grid Size
static const int gridColumns = 20;
static const int gridRows = 30;

// Speed Settings
static const int baseSpeed = 500;        // Level 1 (ms)
static const int speedDecrement = 40;    // Per level

// Initial Settings
static const int initialSnakeLength = 3;
static const int foodPerMaze = 20;       // Campaign mode
```

## 📦 Dependencies

```yaml
flutter_bloc: ^8.1.5      # State management
equatable: ^2.0.5         # Value equality
audioplayers: ^6.0.0      # Audio playback
shared_preferences: ^2.2.3 # Simple storage
hive: ^2.2.3              # Local database
hive_flutter: ^1.1.0      # Hive integration
google_fonts: ^6.2.1      # Custom fonts
```

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/models/snake_segment_test.dart
```

## 📝 Development Status

### ✅ Completed (85%) - GAME PLAYABLE! 🎮
- [x] Complete architecture setup
- [x] Data models and repositories
- [x] BLoC state management
- [x] Game logic (movement, collision, scoring)
- [x] Maze generation (6 types)
- [x] Achievement system
- [x] Settings persistence
- [x] Audio service
- [x] Main menu UI
- [x] Theme system (3 themes)
- [x] **Game screen with full rendering** ✅ NEW!
- [x] **CustomPainter canvas drawing** ✅ NEW!
- [x] **Input handling (swipe + keyboard)** ✅ NEW!
- [x] **Pause/resume/game over** ✅ NEW!

### 🔨 In Progress (15%)
- [ ] Settings screen UI (functional stub exists)
- [ ] High scores screen UI (functional stub exists)
- [ ] Achievements screen UI (functional stub exists)
- [ ] Sound effect files (service ready)
- [ ] Victory animations
- [ ] Achievement unlock animations

**You can play the full game right now!** The remaining work is just secondary UI screens and polish.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Inspired by the classic **Nokia Snake Xenzia** game
- Built with **Flutter** framework
- Uses **BLoC** pattern by Felix Angelov
- Retro fonts by **Google Fonts**

## 📞 Support

For issues, questions, or suggestions:
- Open an issue on GitHub
- Check [DEVELOPMENT.md](DEVELOPMENT.md) for implementation details

## 🎯 Roadmap

### Version 1.0 (Current - 85% Complete) 🎮
- ✅ Core game mechanics (PLAYABLE!)
- ✅ Game screen with rendering
- ✅ Input handling
- ✅ Pause/resume
- ✅ Local high scores (backend ready)
- ✅ Achievements (backend ready)
- 🔨 Settings/Scores/Achievements UI screens

### Version 1.1 (Planned)
- [ ] Sound effects
- [ ] Animations and transitions
- [ ] Tutorial mode
- [ ] More themes

### Version 2.0 (Future)
- [ ] Online leaderboards (Firebase)
- [ ] Multiplayer mode
- [ ] Custom maze editor
- [ ] Daily challenges
- [ ] Social sharing

---

**Made with ❤️ using Flutter**

**Current Build Status**: ✅ Compiles | ✅ Runs on Web/Android/iOS | 🎮 **FULLY PLAYABLE!**

**Try it now:** `flutter run -d chrome` and start playing! 🐍📱

Enjoy the nostalgia! 🎮🐍✨
