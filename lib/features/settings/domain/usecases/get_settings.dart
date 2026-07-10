import 'package:senior_ease/core/usecase/usecase.dart';
import 'package:senior_ease/features/settings/domain/entities/app_settings.dart';
import 'package:senior_ease/features/settings/domain/repositories/settings_repository.dart';

class GetSettings implements UseCase<AppSettings, NoParams> {
  const GetSettings(this.repository);

  final SettingsRepository repository;

  @override
  Future<AppSettings> call(NoParams params) {
    return repository.getSettings();
  }
}
