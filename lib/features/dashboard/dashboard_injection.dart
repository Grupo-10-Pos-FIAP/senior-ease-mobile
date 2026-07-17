import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:senior_ease/core/app_mode/app_mode_controller.dart';
import 'package:senior_ease/features/dashboard/data/datasources/activity_remote_data_source.dart';
import 'package:senior_ease/features/dashboard/data/repositories/activity_repository_impl.dart';
import 'package:senior_ease/features/dashboard/domain/repositories/activity_repository.dart';
import 'package:senior_ease/features/dashboard/domain/usecases/get_activities.dart';
import 'package:senior_ease/features/dashboard/presentation/controllers/dashboard_controller.dart';

void registerDashboardDependencies(GetIt sl) {
  sl.registerLazySingleton<ActivityRemoteDataSource>(
    () => ActivityRemoteDataSourceImpl(
      sl<FirebaseFirestore>(),
      sl<FirebaseAuth>(),
    ),
  );
  sl.registerLazySingleton<ActivityRepository>(
    () => ActivityRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetActivities(sl()));
  sl.registerFactory(() => DashboardController(sl(), sl<AppModeController>()));
}
