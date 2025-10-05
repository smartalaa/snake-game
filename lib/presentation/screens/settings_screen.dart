import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake_xenzia/core/constants/app_colors.dart';
import 'package:snake_xenzia/data/models/game_settings.dart';
import 'package:snake_xenzia/data/models/score_record.dart';
import 'package:snake_xenzia/domain/blocs/settings_bloc.dart';

/// Settings screen for configuring game preferences
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF1A1A2E),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF9FD849),
              ),
            );
          }

          if (state is! SettingsLoaded) {
            return const Center(
              child: Text('Error loading settings'),
            );
          }

          final settings = state.settings;

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF1A1A2E),
                  const Color(0xFF16213E),
                  settings.theme.colors.background,
                ],
              ),
            ),
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Theme Section
                _buildSectionHeader('Visual Theme', Icons.palette),
                _buildThemeSelector(context, settings),
                const SizedBox(height: 24),

                // Gameplay Section
                _buildSectionHeader('Gameplay', Icons.gamepad),
                _buildDifficultySlider(context, settings),
                const SizedBox(height: 16),
                _buildMazeTypeSelector(context, settings),
                const SizedBox(height: 24),

                // Audio Section
                _buildSectionHeader('Audio', Icons.volume_up),
                _buildSoundToggle(context, settings),
                if (settings.soundEnabled) ...[
                  const SizedBox(height: 8),
                  _buildVolumeSlider(context, settings),
                ],
                const SizedBox(height: 24),

                // Control Scheme Section
                _buildSectionHeader('Controls', Icons.gamepad),
                _buildControlSchemeSelector(context, settings),
                const SizedBox(height: 24),

                // Info Section
                _buildInfoCard(settings),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF9FD849), size: 24),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF9FD849),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSelector(BuildContext context, GameSettings settings) {
    return Card(
      color: const Color(0xFF0F3460).withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF9FD849), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Theme',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            ...GameTheme.values.map((theme) {
              final isSelected = settings.theme == theme;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: InkWell(
                  onTap: () {
                    context.read<SettingsBloc>().add(
                          UpdateSettingsEvent(
                            settings: settings.copyWith(theme: theme),
                          ),
                        );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF9FD849).withOpacity(0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF9FD849)
                            : Colors.white24,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: Color(0xFF9FD849),
                            size: 20,
                          )
                        else
                          const Icon(
                            Icons.circle_outlined,
                            color: Colors.white54,
                            size: 20,
                          ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            theme.displayName,
                            style: TextStyle(
                              fontSize: 15,
                              color: isSelected ? Colors.white : Colors.white70,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        _buildThemePreview(theme),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildThemePreview(GameTheme theme) {
    final colors = theme.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: colors.snakeBody,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white24),
          ),
        ),
        const SizedBox(width: 4),
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: colors.food,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white24),
          ),
        ),
        const SizedBox(width: 4),
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: colors.wall,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.white24),
          ),
        ),
      ],
    );
  }

  Widget _buildDifficultySlider(BuildContext context, GameSettings settings) {
    return Card(
      color: const Color(0xFF0F3460).withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF9FD849), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Difficulty Level',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9FD849),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Level ${settings.difficultyLevel}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: const Color(0xFF9FD849),
                inactiveTrackColor: Colors.white24,
                thumbColor: const Color(0xFF9FD849),
                overlayColor: const Color(0xFF9FD849).withOpacity(0.2),
                valueIndicatorColor: const Color(0xFF9FD849),
                valueIndicatorTextStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Slider(
                value: settings.difficultyLevel.toDouble(),
                min: 1,
                max: 10,
                divisions: 9,
                label: settings.difficultyLevel.toString(),
                onChanged: (value) {
                  context.read<SettingsBloc>().add(
                        UpdateSettingsEvent(
                          settings: settings.copyWith(
                            difficultyLevel: value.toInt(),
                          ),
                        ),
                      );
                },
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Easy',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                Text(
                  'Expert',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMazeTypeSelector(BuildContext context, GameSettings settings) {
    return Card(
      color: const Color(0xFF0F3460).withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF9FD849), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Preferred Maze Type',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<MazeType>(
              value: settings.mazeType,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.black26,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF9FD849)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF9FD849), width: 2),
                ),
              ),
              dropdownColor: const Color(0xFF1A1A2E),
              style: const TextStyle(color: Colors.white, fontSize: 15),
              items: MazeType.values.map((maze) {
                return DropdownMenuItem(
                  value: maze,
                  child: Row(
                    children: [
                      Text(
                        maze.icon,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(width: 8),
                      Text(maze.displayName),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (newMaze) {
                if (newMaze != null) {
                  context.read<SettingsBloc>().add(
                        UpdateSettingsEvent(
                          settings: settings.copyWith(mazeType: newMaze),
                        ),
                      );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSoundToggle(BuildContext context, GameSettings settings) {
    return Card(
      color: const Color(0xFF0F3460).withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF9FD849), width: 1),
      ),
      child: SwitchListTile(
        title: const Text(
          'Sound Effects',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          settings.soundEnabled ? 'Enabled' : 'Disabled',
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
        value: settings.soundEnabled,
        activeColor: const Color(0xFF9FD849),
        activeTrackColor: const Color(0xFF9FD849).withOpacity(0.5),
        inactiveThumbColor: Colors.white54,
        inactiveTrackColor: Colors.white24,
        onChanged: (value) {
          context.read<SettingsBloc>().add(
                UpdateSettingsEvent(
                  settings: settings.copyWith(soundEnabled: value),
                ),
              );
        },
      ),
    );
  }

  Widget _buildVolumeSlider(BuildContext context, GameSettings settings) {
    return Card(
      color: const Color(0xFF0F3460).withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF9FD849), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Volume',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${(settings.soundVolume * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF9FD849),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: const Color(0xFF9FD849),
                inactiveTrackColor: Colors.white24,
                thumbColor: const Color(0xFF9FD849),
                overlayColor: const Color(0xFF9FD849).withOpacity(0.2),
              ),
              child: Slider(
                value: settings.soundVolume,
                min: 0.0,
                max: 1.0,
                onChanged: (value) {
                  context.read<SettingsBloc>().add(
                        UpdateSettingsEvent(
                          settings: settings.copyWith(soundVolume: value),
                        ),
                      );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlSchemeSelector(BuildContext context, GameSettings settings) {
    return Card(
      color: const Color(0xFF0F3460).withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF9FD849), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Control Scheme',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            ...ControlScheme.values.map((scheme) {
              final isSelected = settings.controlScheme == scheme;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: InkWell(
                  onTap: () {
                    context.read<SettingsBloc>().add(
                          UpdateSettingsEvent(
                            settings: settings.copyWith(controlScheme: scheme),
                          ),
                        );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF9FD849).withOpacity(0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF9FD849)
                            : Colors.white24,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: Color(0xFF9FD849),
                            size: 20,
                          )
                        else
                          const Icon(
                            Icons.circle_outlined,
                            color: Colors.white54,
                            size: 20,
                          ),
                        const SizedBox(width: 12),
                        Text(
                          scheme.displayName,
                          style: TextStyle(
                            fontSize: 15,
                            color: isSelected ? Colors.white : Colors.white70,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(GameSettings settings) {
    return Card(
      color: const Color(0xFF0F3460).withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.white70, size: 20),
                SizedBox(width: 8),
                Text(
                  'Current Configuration',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Theme', settings.theme.displayName),
            _buildInfoRow('Difficulty', 'Level ${settings.difficultyLevel}'),
            _buildInfoRow('Maze', settings.mazeType.displayName),
            _buildInfoRow('Sound', settings.soundEnabled ? 'On' : 'Off'),
            _buildInfoRow('Controls', settings.controlScheme.displayName),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white60,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF9FD849),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
