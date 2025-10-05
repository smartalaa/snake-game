import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake_xenzia/core/services/audio_service.dart';
import 'package:snake_xenzia/core/services/storage_service.dart';
import 'package:snake_xenzia/data/models/game_settings.dart';

part 'settings_event.dart';
part 'settings_state.dart';

/// BLoC for managing game settings
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final StorageService _storageService;
  final AudioService _audioService;

  SettingsBloc({
    required StorageService storageService,
    required AudioService audioService,
  })  : _storageService = storageService,
        _audioService = audioService,
        super(SettingsInitial()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<UpdateSettingsEvent>(_onUpdateSettings);
    on<ResetSettingsEvent>(_onResetSettings);
  }

  /// Load settings from storage
  Future<void> _onLoadSettings(
    LoadSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());

    try {
      final settings = _storageService.loadSettings() ?? const GameSettings();
      
      // Apply audio settings
      _audioService.setSoundEnabled(settings.soundEnabled);
      _audioService.setVolume(settings.soundVolume);

      emit(SettingsLoaded(settings));
    } catch (e) {
      emit(SettingsError('Failed to load settings: $e'));
    }
  }

  /// Update settings
  Future<void> _onUpdateSettings(
    UpdateSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is! SettingsLoaded) return;

    final currentSettings = (state as SettingsLoaded).settings;
    final newSettings = event.settings ?? currentSettings;

    try {
      await _storageService.saveSettings(newSettings);
      
      // Apply audio settings
      _audioService.setSoundEnabled(newSettings.soundEnabled);
      _audioService.setVolume(newSettings.soundVolume);

      emit(SettingsLoaded(newSettings));
    } catch (e) {
      emit(SettingsError('Failed to save settings: $e'));
      // Restore previous state
      emit(SettingsLoaded(currentSettings));
    }
  }

  /// Reset settings to default
  Future<void> _onResetSettings(
    ResetSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    const defaultSettings = GameSettings();

    try {
      await _storageService.saveSettings(defaultSettings);
      
      // Apply audio settings
      _audioService.setSoundEnabled(defaultSettings.soundEnabled);
      _audioService.setVolume(defaultSettings.soundVolume);

      emit(const SettingsLoaded(defaultSettings));
    } catch (e) {
      emit(SettingsError('Failed to reset settings: $e'));
    }
  }
}
