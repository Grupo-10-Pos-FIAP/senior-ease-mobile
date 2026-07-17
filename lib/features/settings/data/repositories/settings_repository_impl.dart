import 'package:senior_ease/features/settings/data/datasources/settings_remote_data_source.dart';
import 'package:senior_ease/features/settings/domain/entities/app_settings.dart';
import 'package:senior_ease/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this.remoteDataSource);

  final SettingsRemoteDataSource remoteDataSource;

  @override
  Future<AppSettings> getSettings() {
    return remoteDataSource.getSettings();
  }

  @override
  Future<void> saveSettings(AppSettings settings) {
    return remoteDataSource.saveSettings(settings);
  }
}
