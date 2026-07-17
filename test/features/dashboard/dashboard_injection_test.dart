import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:senior_ease/core/app_mode/app_mode_controller.dart';
import 'package:senior_ease/features/dashboard/dashboard_injection.dart';
import 'package:senior_ease/features/dashboard/presentation/controllers/dashboard_controller.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  test('registerDashboardDependencies resolves a DashboardController', () {
    final sl = GetIt.asNewInstance();
    sl.registerLazySingleton(() => AppModeController());
    sl.registerLazySingleton<FirebaseFirestore>(() => MockFirebaseFirestore());
    sl.registerLazySingleton<FirebaseAuth>(() => MockFirebaseAuth());
    registerDashboardDependencies(sl);

    final controller = sl<DashboardController>();

    expect(controller, isA<DashboardController>());
  });
}
