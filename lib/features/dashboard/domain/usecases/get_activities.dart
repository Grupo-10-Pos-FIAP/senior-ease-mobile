import 'package:senior_ease/core/usecase/usecase.dart';
import 'package:senior_ease/features/dashboard/domain/entities/activity.dart';
import 'package:senior_ease/features/dashboard/domain/repositories/activity_repository.dart';

class GetActivities implements UseCase<List<Activity>, NoParams> {
  const GetActivities(this.repository);

  final ActivityRepository repository;

  @override
  Future<List<Activity>> call(NoParams params) {
    return repository.getActivities();
  }
}
