import 'package:get_it/get_it.dart';
import 'package:senior_ease/features/tasks/data/datasources/task_local_data_source.dart';
import 'package:senior_ease/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:senior_ease/features/tasks/domain/repositories/task_repository.dart';
import 'package:senior_ease/features/tasks/domain/usecases/get_steps.dart';
import 'package:senior_ease/features/tasks/presentation/controllers/task_steps_controller.dart';

void registerTasksDependencies(GetIt sl) {
  sl.registerLazySingleton<TaskLocalDataSource>(
    () => TaskLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<TaskRepository>(() => TaskRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetSteps(sl()));
  sl.registerFactory(() => TaskStepsController(sl()));
}
