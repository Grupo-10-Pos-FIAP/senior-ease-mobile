import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:senior_ease/features/tasks/domain/repositories/task_repository.dart';
import 'package:senior_ease/features/tasks/domain/usecases/complete_step.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late MockTaskRepository repository;
  late CompleteStep usecase;

  setUp(() {
    repository = MockTaskRepository();
    usecase = CompleteStep(repository);
  });

  test(
    'delegates to TaskRepository.completeStep with activityId and stepId',
    () async {
      when(
        () => repository.completeStep('activity-1', 'step-1'),
      ).thenAnswer((_) async {});

      await usecase(
        const CompleteStepParams(activityId: 'activity-1', stepId: 'step-1'),
      );

      verify(() => repository.completeStep('activity-1', 'step-1')).called(1);
    },
  );
}
