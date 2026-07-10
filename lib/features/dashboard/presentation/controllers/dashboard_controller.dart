import 'package:flutter/foundation.dart';
import 'package:senior_ease/core/usecase/usecase.dart';
import 'package:senior_ease/features/dashboard/domain/entities/activity.dart';
import 'package:senior_ease/features/dashboard/domain/usecases/get_activities.dart';

class DashboardController extends ChangeNotifier {
  DashboardController(this._getActivities);

  final GetActivities _getActivities;

  static const List<({String label, ActivityStatus status})> tabs = [
    (label: 'Atividades', status: ActivityStatus.active),
    (label: 'Concluídas', status: ActivityStatus.completed),
    (label: 'Expiradas', status: ActivityStatus.expired),
  ];

  bool isLoading = true;
  int selectedTab = 0;
  List<Activity> _activities = [];

  List<String> get tabLabels => tabs.map((tab) => tab.label).toList();

  List<Activity> get filteredActivities {
    final status = tabs[selectedTab].status;
    return _activities
        .where((activity) => activity.status == status)
        .toList();
  }

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    _activities = await _getActivities(const NoParams());
    isLoading = false;
    notifyListeners();
  }

  void selectTab(int index) {
    selectedTab = index;
    notifyListeners();
  }
}
