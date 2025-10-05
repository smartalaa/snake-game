import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake_xenzia/core/constants/app_colors.dart';
import 'package:snake_xenzia/core/constants/app_text_styles.dart';
import 'package:snake_xenzia/core/services/audio_service.dart';
import 'package:snake_xenzia/data/models/game_settings.dart';
import 'package:snake_xenzia/domain/blocs/settings_bloc.dart';
import 'package:snake_xenzia/domain/blocs/snake_game_bloc.dart';
import 'package:snake_xenzia/routes/app_routes.dart';

/// Main menu screen - entry point of the application
class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, settingsState) {
            final settings = settingsState is SettingsLoaded
                ? settingsState.settings
                : const GameSettings();
            final theme = settings.theme;
            final colors = theme.colors;

            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colors.background,
                    Color.lerp(colors.background, colors.foreground, 0.1)!,
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Game Title
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Text(
                          'SNAKE',
                          style: AppTextStyles.title.colored(colors.foreground)
                              .withGlow(colors.highlight),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'XENZIA',
                          style: AppTextStyles.subtitle.colored(colors.accent),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Menu Items
                  _buildMenuItem(
                    context,
                    icon: '🎮',
                    label: 'New Game',
                    onTap: () => _startGame(context, settings, false),
                    colors: colors,
                  ),
                  _buildMenuItem(
                    context,
                    icon: '🏆',
                    label: 'Campaign',
                    onTap: () => _startGame(context, settings, true),
                    colors: colors,
                  ),
                  _buildMenuItem(
                    context,
                    icon: '📊',
                    label: 'High Scores',
                    onTap: () => Navigator.pushNamed(context, AppRoutes.highScores),
                    colors: colors,
                  ),
                  _buildMenuItem(
                    context,
                    icon: '🎯',
                    label: 'Achievements',
                    onTap: () => Navigator.pushNamed(context, AppRoutes.achievements),
                    colors: colors,
                  ),
                  _buildMenuItem(
                    context,
                    icon: '⚙️',
                    label: 'Settings',
                    onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
                    colors: colors,
                  ),

                  const SizedBox(height: 40),

                  // Version Info
                  Text(
                    'v1.0.0',
                    style: AppTextStyles.caption.colored(colors.textSecondary),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Build a menu item button
  Widget _buildMenuItem(
    BuildContext context, {
    required String icon,
    required String label,
    required VoidCallback onTap,
    required dynamic colors,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      child: InkWell(
        onTap: () {
          context.read<AudioService>().playMenuClick();
          onTap();
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: colors.foreground.withOpacity(0.1),
            border: Border.all(color: colors.border, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Text(
                icon,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 16),
              Text(
                label,
                style: AppTextStyles.menuItem.colored(colors.text),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Start a new game
  void _startGame(BuildContext context, GameSettings settings, bool isCampaign) {
    context.read<SnakeGameBloc>().add(
          StartGameEvent(
            settings: settings,
            isCampaign: isCampaign,
          ),
        );
    Navigator.pushNamed(context, AppRoutes.game);
  }
}
