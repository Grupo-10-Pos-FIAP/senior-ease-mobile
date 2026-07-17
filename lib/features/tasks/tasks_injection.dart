import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:senior_ease/features/tasks/data/datasources/task_remote_data_source.dart';
import 'package:senior_ease/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:senior_ease/features/tasks/domain/repositories/task_repository.dart';
import 'package:senior_ease/features/tasks/domain/usecases/complete_step.dart';
import 'package:senior_ease/features/tasks/domain/usecases/get_steps.dart';
import 'package:senior_ease/features/tasks/presentation/controllers/task_steps_controller.dart';

void registerTasksDependencies(GetIt sl) {
  sl.registerLazySingleton<TaskRemoteDataSource>(
    () => TaskRemoteDataSourceImpl(sl<FirebaseFirestore>(), sl<FirebaseAuth>()),
  );
  sl.registerLazySingleton<TaskRepository>(() => TaskRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetSteps(sl()));
  sl.registerLazySingleton(() => CompleteStep(sl()));
  sl.registerFactory(() => TaskStepsController(sl()));
}
