import 'package:senior_ease/features/tasks/domain/entities/task_step.dart';

abstract class TaskRepository {
  Future<List<TaskStep>> getSteps();
}
