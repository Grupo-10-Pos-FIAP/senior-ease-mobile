import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:senior_ease/features/dashboard/domain/usecases/complete_activity.dart';
import 'package:senior_ease/features/tasks/domain/entities/task_step.dart';
import 'package:senior_ease/features/tasks/domain/usecases/get_steps.dart';
import 'package:senior_ease/features/tasks/presentation/controllers/task_steps_controller.dart';

class MockGetSteps extends Mock implements GetSteps {}

class MockCompleteActivity extends Mock implements CompleteActivity {}

class FakeGetStepsParams extends Fake implements GetStepsParams {}

void main() {
  late MockGetSteps getSteps;
  late MockCompleteActivity completeActivity;
  late TaskStepsController controller;

  const steps = [
    TaskStep(
      id: 'step-1',
      label: 'Abrir o app',
      order: 1,
      kind: TaskStepKind.contentReading,
      completed: false,
    ),
    TaskStep(
      id: 'step-2',
      label: 'Fechar o app',
      order: 2,
      kind: TaskStepKind.contentReading,
      completed: false,
    ),
  ];

  Matcher forActivity(String activityId) => isA<GetStepsParams>().having(
    (p) => p.activityId,
    'activityId',
    activityId,
  );

  setUpAll(() {
    registerFallbackValue(FakeGetStepsParams());
  });

  setUp(() {
    getSteps = MockGetSteps();
    completeActivity = MockCompleteActivity();
    controller = TaskStepsController(getSteps, completeActivity);
  });

  test('load() fetches the steps and title for the given activity', () async {
    when(
      () => getSteps(any(that: forActivity('activity-1'))),
    ).thenAnswer((_) async => (title: 'Oficina', steps: steps));

    expect(controller.isLoading, isTrue);
    await controller.load('activity-1');

    expect(controller.isLoading, isFalse);
    expect(controller.activityId, 'activity-1');
    expect(controller.activityTitle, 'Oficina');
    expect(controller.steps, steps);
  });

  test('markCompleted flips only the matching step', () async {
    when(
      () => getSteps(any(that: forActivity('activity-1'))),
    ).thenAnswer((_) async => (title: 'Oficina', steps: steps));
    await controller.load('activity-1');

    controller.markCompleted('step-1');

    expect(
      controller.steps.firstWhere((s) => s.id == 'step-1').completed,
      isTrue,
    );
    expect(
      controller.steps.firstWhere((s) => s.id == 'step-2').completed,
      isFalse,
    );
  });

  group('completeActivity', () {
    test('does nothing if load() was never called', () async {
      await controller.completeActivity();

      verifyNever(() => completeActivity(any()));
    });

    test('calls CompleteActivity with the loaded activityId', () async {
      when(
        () => getSteps(any(that: forActivity('activity-1'))),
      ).thenAnswer((_) async => (title: 'Oficina', steps: steps));
      await controller.load('activity-1');
      when(() => completeActivity('activity-1')).thenAnswer((_) async {});

      await controller.completeActivity();

      verify(() => completeActivity('activity-1')).called(1);
    });
  });
}
