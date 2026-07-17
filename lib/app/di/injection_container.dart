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
  // Cross-cutting core services first, so feature modules can depend on them.
  sl.registerLazySingleton(() => AppModeController());
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => GoogleSignIn.instance);
  sl.registerLazySingleton(() => AuthController(sl(), sl(), sl()));

  // Each feature module registers its own dependencies to keep this
  // composition root free of per-feature implementation details.
  registerAuthDependencies(sl);
  registerDashboardDependencies(sl);
  registerTasksDependencies(sl);
  registerProfileDependencies(sl);
  registerSettingsDependencies(sl);

  // AppModeController otherwise only learns the persisted navigation mode
  // once the Settings screen is opened, so screens visited before that
  // (e.g. Dashboard on app start) would render in advanced mode even when
  // "Simples" is the saved/default setting. Settings now live in Firestore
  // under the signed-in user's document, so this sync only makes sense once
  // a session already exists (e.g. app restart while logged in) — a fresh,
  // logged-out cold start keeps AppModeController's hardcoded default until
  // LoginController re-runs this same sync right after sign-in.
  if (sl<AuthController>().currentUser != null) {
    final settings = await sl<GetSettings>()(const NoParams());
    sl<AppModeController>().update(
      isSimpleMode: settings.navigationMode == 'Simples',
    );
  }
}
