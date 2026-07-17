import 'package:senior_ease/features/tasks/data/datasources/task_remote_data_source.dart';
import 'package:senior_ease/features/tasks/domain/entities/task_step.dart';
import 'package:senior_ease/features/tasks/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  const TaskRepositoryImpl(this.remoteDataSource);

  final TaskRemoteDataSource remoteDataSource;

  @override
  Future<({String title, List<TaskStep> steps})> getSteps(String activityId) {
    return remoteDataSource.getSteps(activityId);
  }

  @override
  Future<void> completeStep(String activityId, String stepId) {
    return remoteDataSource.completeStep(activityId, stepId);
  }
}
