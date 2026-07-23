import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:senior_ease/features/settings/data/datasources/settings_remote_data_source.dart';
import 'package:senior_ease/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:senior_ease/features/settings/domain/entities/app_settings.dart';

class MockSettingsRemoteDataSource extends Mock
    implements SettingsRemoteDataSource {}

void main() {
  late MockSettingsRemoteDataSource dataSource;
  late SettingsRepositoryImpl repository;

  setUp(() {
    dataSource = MockSettingsRemoteDataSource();
    repository = SettingsRepositoryImpl(dataSource);
  });

  test(
    'getSettings delegates to SettingsRemoteDataSource.getSettings',
    () async {
      final settings = AppSettings.defaults();
      when(() => dataSource.getSettings()).thenAnswer((_) async => settings);

      final result = await repository.getSettings();

      expect(result, settings);
      verify(() => dataSource.getSettings()).called(1);
    },
  );

  test(
    'saveSettings delegates to SettingsRemoteDataSource.saveSettings',
    () async {
      final settings = AppSettings.defaults();
      when(() => dataSource.saveSettings(settings)).thenAnswer((_) async {});

      await repository.saveSettings(settings);

      verify(() => dataSource.saveSettings(settings)).called(1);
    },
  );
}
