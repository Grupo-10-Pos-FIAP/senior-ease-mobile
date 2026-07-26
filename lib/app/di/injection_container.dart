import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:senior_ease/core/app_mode/app_mode_controller.dart';
import 'package:senior_ease/core/auth/auth_controller.dart';
import 'package:senior_ease/core/usecase/usecase.dart';
import 'package:senior_ease/features/auth/auth_injection.dart';
import 'package:senior_ease/features/dashboard/dashboard_injection.dart';
import 'package:senior_ease/features/profile/profile_injection.dart';
import 'package:senior_ease/features/settings/domain/usecases/get_settings.dart';
import 'package:senior_ease/features/settings/settings_injection.dart';
import 'package:senior_ease/features/tasks/tasks_injection.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  sl.registerLazySingleton(() => AppModeController());
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => GoogleSignIn.instance);
  sl.registerLazySingleton(() => AuthController(sl(), sl(), sl()));

  registerAuthDependencies(sl);
  registerDashboardDependencies(sl);
  registerTasksDependencies(sl);
  registerProfileDependencies(sl);
  registerSettingsDependencies(sl);

  if (sl<AuthController>().currentUser != null) {
    final settings = await sl<GetSettings>()(const NoParams());
    sl<AppModeController>().update(
      isSimpleMode: settings.navigationMode == 'Padrão',
      fontScale: settings.fontScale,
      spacingScale: settings.spacingScale,
      contrastLevel: settings.contrastLevelEnum,
      reinforcedVisualFeedback: settings.enhancedVisualFeedback,
      criticalActionConfirmation: settings.criticalActionConfirmation,
    );
  }
}
