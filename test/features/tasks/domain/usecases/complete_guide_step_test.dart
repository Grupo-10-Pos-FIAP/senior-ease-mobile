import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:senior_ease/features/tasks/domain/repositories/task_repository.dart';
import 'package:senior_ease/features/tasks/domain/usecases/complete_guide_step.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late MockTaskRepository repository;
  late CompleteGuideStep usecase;

  setUp(() {
    repository = MockTaskRepository();
    usecase = CompleteGuideStep(repository);
  });

  test('delegates to TaskRepository.completeGuideStep', () async {
    when(
      () => repository.completeGuideStep('activity-1', 'step-1'),
    ).thenAnswer((_) async {});

    await usecase(
      const CompleteGuideStepParams(
        activityId: 'activity-1',
        stepId: 'step-1',
      ),
    );

    verify(
      () => repository.completeGuideStep('activity-1', 'step-1'),
    ).called(1);
  });
}
