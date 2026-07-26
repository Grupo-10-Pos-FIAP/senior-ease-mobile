import 'package:senior_ease/features/tasks/data/datasources/task_remote_data_source.dart';
import 'package:senior_ease/features/tasks/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  const TaskRepositoryImpl(this.remoteDataSource);

  final TaskRemoteDataSource remoteDataSource;

  @override
  Future<ActivityStepsData> getSteps(String activityId) {
    return remoteDataSource.getSteps(activityId);
  }

  @override
  Future<void> completeStep(String activityId, String stepId) {
    return remoteDataSource.completeStep(activityId, stepId);
  }

  @override
  Future<void> completeGuideStep(String activityId, String stepId) {
    return remoteDataSource.completeGuideStep(activityId, stepId);
  }

  @override
  Future<void> markStarted(String activityId) {
    return remoteDataSource.markStarted(activityId);
  }
}
