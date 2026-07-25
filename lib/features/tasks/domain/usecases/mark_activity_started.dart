import 'package:senior_ease/core/usecase/usecase.dart';
import 'package:senior_ease/features/tasks/domain/repositories/task_repository.dart';

class MarkActivityStarted implements UseCase<void, String> {
  const MarkActivityStarted(this.repository);

  final TaskRepository repository;

  @override
  Future<void> call(String activityId) {
    return repository.markStarted(activityId);
  }
}
