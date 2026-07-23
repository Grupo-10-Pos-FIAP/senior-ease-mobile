import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:senior_ease/core/app_mode/app_mode_controller.dart';
import 'package:senior_ease/core/auth/auth_controller.dart';
import 'package:senior_ease/features/auth/auth_injection.dart';
import 'package:senior_ease/features/auth/presentation/controllers/login_controller.dart';
import 'package:senior_ease/features/settings/domain/usecases/get_settings.dart';

class MockAuthController extends Mock implements AuthController {}

class MockGetSettings extends Mock implements GetSettings {}

void main() {
  test('registerAuthDependencies resolves a LoginController', () {
    final sl = GetIt.asNewInstance();
    sl.registerLazySingleton<AuthController>(() => MockAuthController());
    sl.registerLazySingleton<GetSettings>(() => MockGetSettings());
    sl.registerLazySingleton(() => AppModeController());
    registerAuthDependencies(sl);

    final controller = sl<LoginController>();

    expect(controller, isA<LoginController>());
  });
}
