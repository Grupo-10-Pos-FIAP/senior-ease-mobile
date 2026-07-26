import 'package:senior_ease/core/usecase/usecase.dart';
import 'package:senior_ease/features/tasks/domain/repositories/task_repository.dart';

class CompleteGuideStepParams {
  const CompleteGuideStepParams({
    required this.activityId,
    required this.stepId,
  });

  final String activityId;
  final String stepId;
}

class CompleteGuideStep implements UseCase<void, CompleteGuideStepParams> {
  const CompleteGuideStep(this.repository);

  final TaskRepository repository;

  @override
  Future<void> call(CompleteGuideStepParams params) {
    return repository.completeGuideStep(params.activityId, params.stepId);
  }
}
