import 'package:senior_ease/core/usecase/usecase.dart';
import 'package:senior_ease/features/tasks/domain/entities/task_step.dart';
import 'package:senior_ease/features/tasks/domain/repositories/task_repository.dart';

class GetSteps implements UseCase<List<TaskStep>, NoParams> {
  const GetSteps(this.repository);

  final TaskRepository repository;

  @override
  Future<List<TaskStep>> call(NoParams params) {
    return repository.getSteps();
  }
}
