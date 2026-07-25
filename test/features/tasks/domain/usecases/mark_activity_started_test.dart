import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:senior_ease/features/tasks/domain/repositories/task_repository.dart';
import 'package:senior_ease/features/tasks/domain/usecases/mark_activity_started.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late MockTaskRepository repository;
  late MarkActivityStarted usecase;

  setUp(() {
    repository = MockTaskRepository();
    usecase = MarkActivityStarted(repository);
  });

  test('delegates to TaskRepository.markStarted', () async {
    when(() => repository.markStarted('activity-1')).thenAnswer((_) async {});

    await usecase('activity-1');

    verify(() => repository.markStarted('activity-1')).called(1);
  });
}
