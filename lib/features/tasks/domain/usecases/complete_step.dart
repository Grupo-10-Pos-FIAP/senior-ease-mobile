import 'package:senior_ease/core/usecase/usecase.dart';
import 'package:senior_ease/features/tasks/domain/repositories/task_repository.dart';

class CompleteStepParams {
  const CompleteStepParams({required this.activityId, required this.stepId});

  final String activityId;
  final String stepId;
}

class CompleteStep implements UseCase<void, CompleteStepParams> {
  const CompleteStep(this.repository);

  final TaskRepository repository;

  @override
  Future<void> call(CompleteStepParams params) {
    return repository.completeStep(params.activityId, params.stepId);
  }
}
