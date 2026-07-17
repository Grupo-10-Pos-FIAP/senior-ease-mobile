import 'package:senior_ease/features/dashboard/data/datasources/activity_remote_data_source.dart';
import 'package:senior_ease/features/dashboard/domain/entities/activity.dart';
import 'package:senior_ease/features/dashboard/domain/repositories/activity_repository.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  const ActivityRepositoryImpl(this.remoteDataSource);

  final ActivityRemoteDataSource remoteDataSource;

  @override
  Future<List<Activity>> getActivities() {
    return remoteDataSource.getActivities();
  }
}
