import 'package:senior_ease/features/dashboard/domain/entities/activity.dart';

abstract class ActivityRepository {
  Future<List<Activity>> getActivities();
}
