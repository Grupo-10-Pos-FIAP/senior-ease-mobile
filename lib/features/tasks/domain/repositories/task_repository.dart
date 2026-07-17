import 'package:senior_ease/features/tasks/domain/entities/task_step.dart';

abstract class TaskRepository {
  Future<({String title, List<TaskStep> steps})> getSteps(String activityId);

  Future<void> completeStep(String activityId, String stepId);
}
