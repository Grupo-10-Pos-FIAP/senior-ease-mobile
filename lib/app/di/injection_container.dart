import 'package:get_it/get_it.dart';
import 'package:senior_ease/core/app_mode/app_mode_controller.dart';
import 'package:senior_ease/core/usecase/usecase.dart';
import 'package:senior_ease/features/dashboard/dashboard_injection.dart';
import 'package:senior_ease/features/profile/profile_injection.dart';
import 'package:senior_ease/features/settings/domain/usecases/get_settings.dart';
import 'package:senior_ease/features/settings/settings_injection.dart';
import 'package:senior_ease/features/tasks/tasks_injection.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  // Cross-cutting core services first, so feature modules can depend on them.
  sl.registerLazySingleton(() => AppModeController());

  // Each feature module registers its own dependencies to keep this
  // composition root free of per-feature implementation details.
  registerDashboardDependencies(sl);
  registerTasksDependencies(sl);
  registerProfileDependencies(sl);
  registerSettingsDependencies(sl);

  // AppModeController otherwise only learns the persisted navigation mode
  // once the Settings screen is opened, so screens visited before that
  // (e.g. Dashboard on app start) would render in advanced mode even when
  // "Simples" is the saved/default setting.
  final settings = await sl<GetSettings>()(const NoParams());
  sl<AppModeController>().update(
    isSimpleMode: settings.navigationMode == 'Simples',
  );
}
