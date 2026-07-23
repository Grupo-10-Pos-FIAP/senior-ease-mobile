import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:senior_ease/features/profile/presentation/controllers/profile_info_controller.dart';
import 'package:senior_ease/features/profile/profile_injection.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  test('registerProfileDependencies resolves a ProfileInfoController', () {
    final sl = GetIt.asNewInstance();
    sl.registerLazySingleton<FirebaseFirestore>(() => MockFirebaseFirestore());
    sl.registerLazySingleton<FirebaseAuth>(() => MockFirebaseAuth());
    registerProfileDependencies(sl);

    final controller = sl<ProfileInfoController>();

    expect(controller, isA<ProfileInfoController>());
    // Singleton on purpose (see the registration's own comment) — both
    // profile tabs must share the same instance under IndexedStack.
    expect(identical(controller, sl<ProfileInfoController>()), isTrue);
  });
}
