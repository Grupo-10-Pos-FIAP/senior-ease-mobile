import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:senior_ease/features/tasks/data/datasources/task_remote_data_source.dart';
import 'package:senior_ease/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:senior_ease/features/tasks/domain/entities/task_step.dart';

class MockTaskRemoteDataSource extends Mock implements TaskRemoteDataSource {}

void main() {
  late MockTaskRemoteDataSource dataSource;
  late TaskRepositoryImpl repository;

  setUp(() {
    dataSource = MockTaskRemoteDataSource();
    repository = TaskRepositoryImpl(dataSource);
  });

  test('getSteps delegates to TaskRemoteDataSource.getSteps', () async {
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
      () => dataSource.getSteps('activity-1'),
    ).thenAnswer((_) async => (title: 'Oficina', steps: steps));

    final result = await repository.getSteps('activity-1');

    expect(result.title, 'Oficina');
    expect(result.steps, steps);
    verify(() => dataSource.getSteps('activity-1')).called(1);
  });

  test('completeStep delegates to TaskRemoteDataSource.completeStep', () async {
    when(
      () => dataSource.completeStep('activity-1', 'step-1'),
    ).thenAnswer((_) async {});

    await repository.completeStep('activity-1', 'step-1');

    verify(() => dataSource.completeStep('activity-1', 'step-1')).called(1);
  });
}
