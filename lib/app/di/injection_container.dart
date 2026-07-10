import 'package:get_it/get_it.dart';
import 'package:senior_ease/features/dashboard/dashboard_injection.dart';
import 'package:senior_ease/features/profile/profile_injection.dart';
import 'package:senior_ease/features/settings/settings_injection.dart';
import 'package:senior_ease/features/tasks/tasks_injection.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  // Each feature module registers its own dependencies to keep this
  // composition root free of per-feature implementation details.
  registerDashboardDependencies(sl);
  registerTasksDependencies(sl);
  registerProfileDependencies(sl);
  registerSettingsDependencies(sl);
}
