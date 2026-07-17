import 'package:senior_ease/core/usecase/usecase.dart';
import 'package:senior_ease/features/tasks/domain/entities/task_step.dart';
import 'package:senior_ease/features/tasks/domain/repositories/task_repository.dart';

class GetStepsParams {
  const GetStepsParams({required this.activityId});

  final String activityId;
}

class GetSteps
    implements
        UseCase<({String title, List<TaskStep> steps}), GetStepsParams> {
  const GetSteps(this.repository);

  final TaskRepository repository;

  @override
  Future<({String title, List<TaskStep> steps})> call(GetStepsParams params) {
    return repository.getSteps(params.activityId);
  }
}
