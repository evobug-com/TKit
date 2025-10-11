import 'package:equatable/equatable.dart';
import '../../domain/entities/app_settings.dart';

/// Base class for all settings states
sealed class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

/// Initial state before loading
final class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

/// Loading settings
final class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

/// Settings loaded successfully
final class SettingsLoaded extends SettingsState {
  final AppSettings settings;
  final bool hasUnsavedChanges;

  const SettingsLoaded(this.settings, {this.hasUnsavedChanges = false});

  @override
  List<Object?> get props => [settings, hasUnsavedChanges];

  /// Create a copy with updated values
  SettingsLoaded copyWith({AppSettings? settings, bool? hasUnsavedChanges}) {
    return SettingsLoaded(
      settings ?? this.settings,
      hasUnsavedChanges: hasUnsavedChanges ?? this.hasUnsavedChanges,
    );
  }
}

/// Saving settings
final class SettingsSaving extends SettingsState {
  final AppSettings settings;

  const SettingsSaving(this.settings);

  @override
  List<Object?> get props => [settings];
}

/// Settings saved successfully
final class SettingsSaved extends SettingsState {
  final AppSettings settings;

  const SettingsSaved(this.settings);

  @override
  List<Object?> get props => [settings];
}

/// Error occurred
final class SettingsError extends SettingsState {
  final String message;
  final AppSettings? currentSettings;

  const SettingsError(this.message, {this.currentSettings});

  @override
  List<Object?> get props => [message, currentSettings];
}
