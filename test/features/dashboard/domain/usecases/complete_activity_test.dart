import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:senior_ease/features/dashboard/domain/repositories/activity_repository.dart';
import 'package:senior_ease/features/dashboard/domain/usecases/complete_activity.dart';

class MockActivityRepository extends Mock implements ActivityRepository {}

void main() {
  late MockActivityRepository repository;
  late CompleteActivity usecase;

  setUp(() {
    repository = MockActivityRepository();
    usecase = CompleteActivity(repository);
  });

  test('delegates to ActivityRepository.completeActivity', () async {
    when(
      () => repository.completeActivity('activity-1'),
    ).thenAnswer((_) async {});

    await usecase('activity-1');

    verify(() => repository.completeActivity('activity-1')).called(1);
  });
}
