part of 'settings_bloc.dart';

/// Base class for settings states
abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class SettingsInitial extends SettingsState {}

/// Loading state
class SettingsLoading extends SettingsState {}

/// Loaded state with settings
class SettingsLoaded extends SettingsState {
  final GameSettings settings;

  const SettingsLoaded(this.settings);

  @override
  List<Object?> get props => [settings];
}

/// Error state
class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object?> get props => [message];
}
