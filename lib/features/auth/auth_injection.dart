import 'package:get_it/get_it.dart';
import 'package:senior_ease/core/app_mode/app_mode_controller.dart';
import 'package:senior_ease/core/auth/auth_controller.dart';
import 'package:senior_ease/features/auth/presentation/controllers/login_controller.dart';
import 'package:senior_ease/features/settings/domain/usecases/get_settings.dart';

void registerAuthDependencies(GetIt sl) {
  sl.registerFactory(
    () => LoginController(
      sl<AuthController>(),
      sl<GetSettings>(),
      sl<AppModeController>(),
    ),
  );
}
