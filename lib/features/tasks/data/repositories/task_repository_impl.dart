import 'package:senior_ease/features/tasks/data/datasources/task_local_data_source.dart';
import 'package:senior_ease/features/tasks/domain/entities/task_step.dart';
import 'package:senior_ease/features/tasks/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  const TaskRepositoryImpl(this.localDataSource);

  final TaskLocalDataSource localDataSource;

  @override
  Future<List<TaskStep>> getSteps() {
    return localDataSource.getSteps();
  }
}
