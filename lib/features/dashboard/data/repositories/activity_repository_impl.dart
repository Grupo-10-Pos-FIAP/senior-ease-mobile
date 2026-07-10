import 'package:senior_ease/features/dashboard/data/datasources/activity_local_data_source.dart';
import 'package:senior_ease/features/dashboard/domain/entities/activity.dart';
import 'package:senior_ease/features/dashboard/domain/repositories/activity_repository.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  const ActivityRepositoryImpl(this.localDataSource);

  final ActivityLocalDataSource localDataSource;

  @override
  Future<List<Activity>> getActivities() {
    return localDataSource.getActivities();
  }
}
