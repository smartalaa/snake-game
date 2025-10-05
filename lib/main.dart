import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:snake_xenzia/core/constants/app_colors.dart';
import 'package:snake_xenzia/core/services/audio_service.dart';
import 'package:snake_xenzia/core/services/storage_service.dart';
import 'package:snake_xenzia/data/repositories/achievement_repository.dart';
import 'package:snake_xenzia/data/repositories/score_repository.dart';
import 'package:snake_xenzia/domain/blocs/settings_bloc.dart';
import 'package:snake_xenzia/domain/blocs/snake_game_bloc.dart';
import 'package:snake_xenzia/routes/app_routes.dart';

/// Entry point of the Snake Xenzia application
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // Initialize services
  final storageService = StorageService();
  await storageService.initialize();

  final audioService = AudioService();
  await audioService.initialize();

  // Lock orientation to portrait mode for consistent gameplay
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(SnakeXenziaApp(
    storageService: storageService,
    audioService: audioService,
  ));
}

/// Root application widget
class SnakeXenziaApp extends StatelessWidget {
  final StorageService storageService;
  final AudioService audioService;

  const SnakeXenziaApp({
    super.key,
    required this.storageService,
    required this.audioService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<StorageService>(
          create: (_) => storageService,
        ),
        RepositoryProvider<AudioService>(
          create: (_) => audioService,
        ),
        RepositoryProvider<ScoreRepository>(
          create: (_) => ScoreRepository(storageService: storageService),
        ),
        RepositoryProvider<AchievementRepository>(
          create: (_) => AchievementRepository(storageService: storageService),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SettingsBloc>(
            create: (context) => SettingsBloc(
              storageService: storageService,
              audioService: audioService,
            )..add(const LoadSettingsEvent()),
          ),
          BlocProvider<SnakeGameBloc>(
            create: (context) => SnakeGameBloc(
              scoreRepository: context.read<ScoreRepository>(),
              achievementRepository: context.read<AchievementRepository>(),
              audioService: audioService,
            ),
          ),
        ],
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            final theme = state is SettingsLoaded
                ? state.settings.theme
                : GameTheme.backlight;

            return MaterialApp(
              title: 'Snake Xenzia',
              debugShowCheckedModeBanner: false,
              theme: _buildTheme(theme),
              initialRoute: AppRoutes.mainMenu,
              routes: AppRoutes.routes,
            );
          },
        ),
      ),
    );
  }

  /// Build theme based on selected game theme
  ThemeData _buildTheme(GameTheme gameTheme) {
    final colors = gameTheme.colors;
    
    return ThemeData(
      scaffoldBackgroundColor: colors.background,
      primaryColor: colors.foreground,
      colorScheme: ColorScheme.dark(
        primary: colors.foreground,
        secondary: colors.accent,
        surface: colors.background,
        background: colors.background,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: Colors.white),
        headlineMedium: TextStyle(color: Colors.white),
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.foreground,
          foregroundColor: colors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
      useMaterial3: false,
    );
  }
}
