part of 'settings_bloc.dart';

/// Base class for settings events
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load settings from storage
class LoadSettingsEvent extends SettingsEvent {
  const LoadSettingsEvent();
}

/// Event to update settings
class UpdateSettingsEvent extends SettingsEvent {
  final GameSettings? settings;

  const UpdateSettingsEvent({this.settings});

  @override
  List<Object?> get props => [settings];
}

/// Event to reset settings to default
class ResetSettingsEvent extends SettingsEvent {
  const ResetSettingsEvent();
}
