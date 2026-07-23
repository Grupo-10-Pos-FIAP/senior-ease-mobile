import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:senior_ease/core/app_mode/app_mode_controller.dart';
import 'package:senior_ease/features/settings/presentation/controllers/settings_controller.dart';
import 'package:senior_ease/features/settings/settings_injection.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  test('registerSettingsDependencies resolves a SettingsController', () {
    final sl = GetIt.asNewInstance();
    sl.registerLazySingleton(() => AppModeController());
    sl.registerLazySingleton<FirebaseFirestore>(() => MockFirebaseFirestore());
    sl.registerLazySingleton<FirebaseAuth>(() => MockFirebaseAuth());
    registerSettingsDependencies(sl);

    final controller = sl<SettingsController>();

    expect(controller, isA<SettingsController>());
    // Singleton on purpose (see the registration's own comment) — both
    // profile tabs must share the same instance under IndexedStack.
    expect(identical(controller, sl<SettingsController>()), isTrue);
  });
}
