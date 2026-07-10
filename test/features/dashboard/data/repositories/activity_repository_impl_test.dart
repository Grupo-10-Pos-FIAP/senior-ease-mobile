import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:senior_ease/features/dashboard/data/datasources/activity_local_data_source.dart';
import 'package:senior_ease/features/dashboard/data/repositories/activity_repository_impl.dart';
import 'package:senior_ease/features/dashboard/domain/entities/activity.dart';

class MockActivityLocalDataSource extends Mock
    implements ActivityLocalDataSource {}

void main() {
  late MockActivityLocalDataSource dataSource;
  late ActivityRepositoryImpl repository;

  setUp(() {
    dataSource = MockActivityLocalDataSource();
    repository = ActivityRepositoryImpl(dataSource);
  });

  test('delegates to ActivityLocalDataSource.getActivities', () async {
    const activities = [
      Activity(
        id: '1',
        title: 'Test',
        dateRange: '01/01/2026',
        status: ActivityStatus.active,
      ),
    ];
    when(
      () => dataSource.getActivities(),
    ).thenAnswer((_) async => activities);

    final result = await repository.getActivities();

    expect(result, activities);
    verify(() => dataSource.getActivities()).called(1);
  });
}
