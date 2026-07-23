import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:senior_ease/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:senior_ease/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:senior_ease/features/profile/domain/repositories/profile_repository.dart';
import 'package:senior_ease/features/profile/domain/usecases/get_user_profile.dart';
import 'package:senior_ease/features/profile/domain/usecases/update_user_profile.dart';
import 'package:senior_ease/features/profile/presentation/controllers/profile_info_controller.dart';

void registerProfileDependencies(GetIt sl) {
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(
      sl<FirebaseFirestore>(),
      sl<FirebaseAuth>(),
    ),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetUserProfile(sl()));
  sl.registerLazySingleton(() => UpdateUserProfile(sl()));
  // Singleton (not factory): ProfileShellScreen creates this once and keeps
  // both tabs mounted via IndexedStack, so a single shared instance is correct.
  sl.registerLazySingleton(() => ProfileInfoController(sl(), sl()));
}
