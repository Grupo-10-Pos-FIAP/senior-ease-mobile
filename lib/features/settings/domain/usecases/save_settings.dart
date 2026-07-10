import 'package:senior_ease/core/usecase/usecase.dart';
import 'package:senior_ease/features/settings/domain/entities/app_settings.dart';
import 'package:senior_ease/features/settings/domain/repositories/settings_repository.dart';

class SaveSettings implements UseCase<void, AppSettings> {
  const SaveSettings(this.repository);

  final SettingsRepository repository;

  @override
  Future<void> call(AppSettings params) {
    return repository.saveSettings(params);
  }
}
