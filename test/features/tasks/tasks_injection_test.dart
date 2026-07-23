import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:senior_ease/features/dashboard/domain/usecases/complete_activity.dart';
import 'package:senior_ease/features/tasks/presentation/controllers/task_steps_controller.dart';
import 'package:senior_ease/features/tasks/tasks_injection.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockCompleteActivity extends Mock implements CompleteActivity {}

void main() {
  test('registerTasksDependencies resolves a TaskStepsController', () {
    final sl = GetIt.asNewInstance();
    sl.registerLazySingleton<FirebaseFirestore>(() => MockFirebaseFirestore());
    sl.registerLazySingleton<FirebaseAuth>(() => MockFirebaseAuth());
    sl.registerLazySingleton<CompleteActivity>(() => MockCompleteActivity());
    registerTasksDependencies(sl);

    final controller = sl<TaskStepsController>();

    expect(controller, isA<TaskStepsController>());
    // Factory (not singleton): each visit to the steps screen should get a
    // fresh controller instead of reusing another activity's stale state.
    expect(identical(controller, sl<TaskStepsController>()), isFalse);
  });
}
