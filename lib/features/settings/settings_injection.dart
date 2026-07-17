import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:senior_ease/core/app_mode/app_mode_controller.dart';
import 'package:senior_ease/features/settings/data/datasources/settings_remote_data_source.dart';
import 'package:senior_ease/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:senior_ease/features/settings/domain/repositories/settings_repository.dart';
import 'package:senior_ease/features/settings/domain/usecases/get_settings.dart';
import 'package:senior_ease/features/settings/domain/usecases/save_settings.dart';
import 'package:senior_ease/features/settings/presentation/controllers/settings_controller.dart';

void registerSettingsDependencies(GetIt sl) {
  sl.registerLazySingleton<SettingsRemoteDataSource>(
    () => SettingsRemoteDataSourceImpl(
      sl<FirebaseFirestore>(),
      sl<FirebaseAuth>(),
    ),
  );
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetSettings(sl()));
  sl.registerLazySingleton(() => SaveSettings(sl()));
  // Singleton (not factory): ProfileShellScreen creates this once and keeps
  // both tabs mounted via IndexedStack, so a single shared instance is correct.
  sl.registerLazySingleton(
    () => SettingsController(sl(), sl(), sl<AppModeController>()),
  );
}
