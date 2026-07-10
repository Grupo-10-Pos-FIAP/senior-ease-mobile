import 'package:get_it/get_it.dart';
import 'package:senior_ease/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:senior_ease/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:senior_ease/features/profile/domain/repositories/profile_repository.dart';
import 'package:senior_ease/features/profile/domain/usecases/get_user_profile.dart';
import 'package:senior_ease/features/profile/presentation/controllers/profile_info_controller.dart';

void registerProfileDependencies(GetIt sl) {
  sl.registerLazySingleton<ProfileLocalDataSource>(
    () => ProfileLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetUserProfile(sl()));
  // Singleton (not factory): ProfileShellScreen creates this once and keeps
  // both tabs mounted via IndexedStack, so a single shared instance is correct.
  sl.registerLazySingleton(() => ProfileInfoController(sl()));
}
