import 'package:senior_ease/features/dashboard/domain/entities/activity.dart';

abstract class ActivityLocalDataSource {
  Future<List<Activity>> getActivities();
}

class ActivityLocalDataSourceImpl implements ActivityLocalDataSource {
  static const List<Activity> _mockActivities = [
    Activity(
      id: '1',
      title: 'Oficina “Primeiros Passos no Digital”',
      dateRange: '05/06/2026 - 14/06/2026',
      status: ActivityStatus.active,
    ),
    Activity(
      id: '2',
      title: 'Curso “Como usar E-mail”',
      dateRange: '01/07/2026 - 16/07/2026',
      status: ActivityStatus.active,
    ),
    Activity(
      id: '3',
      title: 'Atividade “Videochamadas sem Medo”',
      dateRange: '14/08/2026 - 19/08/2026',
      status: ActivityStatus.active,
    ),
    Activity(
      id: '4',
      title: 'Oficina “Segurança online”',
      dateRange: '20/05/2026 - 25/05/2026',
      status: ActivityStatus.completed,
    ),
    Activity(
      id: '5',
      title: 'Curso “Configurar celular”',
      dateRange: '10/04/2026 - 15/04/2026',
      status: ActivityStatus.expired,
    ),
  ];

  @override
  Future<List<Activity>> getActivities() async {
    return _mockActivities;
  }
}
