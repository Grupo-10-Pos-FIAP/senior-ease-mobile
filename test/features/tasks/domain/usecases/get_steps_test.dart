import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:senior_ease/features/tasks/domain/entities/task_step.dart';
import 'package:senior_ease/features/tasks/domain/repositories/task_repository.dart';
import 'package:senior_ease/features/tasks/domain/usecases/get_steps.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late MockTaskRepository repository;
  late GetSteps usecase;

  setUp(() {
    repository = MockTaskRepository();
    usecase = GetSteps(repository);
  });

  test(
    'delegates to TaskRepository.getSteps with the given activityId',
    () async {
      const steps = [
        TaskStep(
          id: 'step-1',
          label: 'Abrir o app',
          order: 1,
          kind: TaskStepKind.contentReading,
          completed: false,
        ),
      ];
      when(
        () => repository.getSteps('activity-1'),
      ).thenAnswer((_) async => (title: 'Oficina', steps: steps));

      final result = await usecase(
        const GetStepsParams(activityId: 'activity-1'),
      );

      expect(result.title, 'Oficina');
      expect(result.steps, steps);
      verify(() => repository.getSteps('activity-1')).called(1);
    },
  );
}
