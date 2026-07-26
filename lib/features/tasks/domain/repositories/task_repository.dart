import 'package:senior_ease/features/tasks/domain/entities/task_step.dart';

typedef ActivityStepsData = ({
  String title,
  List<TaskStep> steps,
  bool started,
});

abstract class TaskRepository {
  Future<ActivityStepsData> getSteps(String activityId);

  Future<void> completeStep(String activityId, String stepId);

  Future<void> completeGuideStep(String activityId, String stepId);

  Future<void> markStarted(String activityId);
}
