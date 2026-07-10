import 'package:senior_ease/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:senior_ease/features/settings/domain/entities/app_settings.dart';
import 'package:senior_ease/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this.localDataSource);

  final SettingsLocalDataSource localDataSource;

  @override
  Future<AppSettings> getSettings() {
    return localDataSource.getSettings();
  }

  @override
  Future<void> saveSettings(AppSettings settings) {
    return localDataSource.saveSettings(settings);
  }
}
