import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:senior_ease/features/settings/domain/entities/app_settings.dart';
import 'package:senior_ease/features/settings/domain/repositories/settings_repository.dart';
import 'package:senior_ease/features/settings/domain/usecases/save_settings.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late MockSettingsRepository repository;
  late SaveSettings usecase;

  setUp(() {
    repository = MockSettingsRepository();
    usecase = SaveSettings(repository);
  });

  test('delegates to SettingsRepository.saveSettings', () async {
    final settings = AppSettings.defaults();
    when(() => repository.saveSettings(settings)).thenAnswer((_) async {});

    await usecase(settings);

    verify(() => repository.saveSettings(settings)).called(1);
  });
}
