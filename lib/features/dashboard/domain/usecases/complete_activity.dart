import 'package:senior_ease/core/usecase/usecase.dart';
import 'package:senior_ease/features/dashboard/domain/repositories/activity_repository.dart';

class CompleteActivity implements UseCase<void, String> {
  const CompleteActivity(this.repository);

  final ActivityRepository repository;

  @override
  Future<void> call(String activityId) {
    return repository.completeActivity(activityId);
  }
}
