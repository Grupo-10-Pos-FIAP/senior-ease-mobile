import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:senior_ease/core/usecase/usecase.dart';
import 'package:senior_ease/features/dashboard/domain/entities/activity.dart';
import 'package:senior_ease/features/dashboard/domain/repositories/activity_repository.dart';
import 'package:senior_ease/features/dashboard/domain/usecases/get_activities.dart';

class MockActivityRepository extends Mock implements ActivityRepository {}

void main() {
  late MockActivityRepository repository;
  late GetActivities usecase;

  setUp(() {
    repository = MockActivityRepository();
    usecase = GetActivities(repository);
  });

  test('delegates to ActivityRepository.getActivities', () async {
    const activities = [
      Activity(
        id: '1',
        title: 'Test',
        dateRange: '01/01/2026',
        status: ActivityStatus.active,
      ),
    ];
    when(() => repository.getActivities()).thenAnswer((_) async => activities);

    final result = await usecase(const NoParams());

    expect(result, activities);
    verify(() => repository.getActivities()).called(1);
  });
}
