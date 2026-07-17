import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:senior_ease/core/app_mode/app_mode_controller.dart';
import 'package:senior_ease/core/app_mode/contrast_level.dart';
import 'package:senior_ease/core/usecase/usecase.dart';
import 'package:senior_ease/features/dashboard/domain/entities/activity.dart';
import 'package:senior_ease/features/dashboard/domain/usecases/get_activities.dart';
import 'package:senior_ease/features/dashboard/presentation/controllers/dashboard_controller.dart';

class MockGetActivities extends Mock implements GetActivities {}

void main() {
  late MockGetActivities getActivities;
  late AppModeController appMode;
  late DashboardController controller;

  const activities = [
    Activity(
      id: '1',
      title: 'Ativa',
      dateRange: '01/01/2026',
      status: ActivityStatus.active,
    ),
    Activity(
      id: '2',
      title: 'Concluída',
      dateRange: '01/02/2026',
      status: ActivityStatus.completed,
    ),
  ];

  setUp(() {
    getActivities = MockGetActivities();
    appMode = AppModeController();
    controller = DashboardController(getActivities, appMode);
  });

  test('load() fetches activities and stops loading', () async {
    when(
      () => getActivities(const NoParams()),
    ).thenAnswer((_) async => activities);

    expect(controller.isLoading, isTrue);
    await controller.load();

    expect(controller.isLoading, isFalse);
    expect(controller.filteredActivities, [activities[0]]);
  });

  test('selectTab filters activities by the matching status', () async {
    when(
      () => getActivities(const NoParams()),
    ).thenAnswer((_) async => activities);
    await controller.load();

    controller.selectTab(1);

    expect(controller.selectedTab, 1);
    expect(controller.filteredActivities, [activities[1]]);
  });

  test('hides the "Expiradas" tab and clamps selectedTab in simple mode', () {
    controller.selectTab(2);

    appMode.update(
      isSimpleMode: true,
      fontScale: 1.0,
      spacingScale: 1.0,
      contrastLevel: ContrastLevel.padrao,
      reinforcedVisualFeedback: false,
    );

    expect(controller.tabLabels, ['Atividades', 'Concluídas']);
    expect(controller.selectedTab, 0);
  });
}
