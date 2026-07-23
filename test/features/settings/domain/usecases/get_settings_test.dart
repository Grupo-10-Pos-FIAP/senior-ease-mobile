import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:senior_ease/core/usecase/usecase.dart';
import 'package:senior_ease/features/settings/domain/entities/app_settings.dart';
import 'package:senior_ease/features/settings/domain/repositories/settings_repository.dart';
import 'package:senior_ease/features/settings/domain/usecases/get_settings.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late MockSettingsRepository repository;
  late GetSettings usecase;

  setUp(() {
    repository = MockSettingsRepository();
    usecase = GetSettings(repository);
  });

  test('delegates to SettingsRepository.getSettings', () async {
    final settings = AppSettings.defaults();
    when(() => repository.getSettings()).thenAnswer((_) async => settings);

    final result = await usecase(const NoParams());

    expect(result, settings);
    verify(() => repository.getSettings()).called(1);
  });
}
