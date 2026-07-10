import 'package:senior_ease/features/settings/domain/entities/app_settings.dart';

abstract class SettingsLocalDataSource {
  Future<AppSettings> getSettings();
  Future<void> saveSettings(AppSettings settings);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  AppSettings _current = AppSettings.defaults();

  @override
  Future<AppSettings> getSettings() async {
    return _current;
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    _current = settings;
  }
}
