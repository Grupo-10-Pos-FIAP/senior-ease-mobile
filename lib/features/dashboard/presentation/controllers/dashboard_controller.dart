import 'package:flutter/foundation.dart';
import 'package:senior_ease/core/app_mode/app_mode_controller.dart';
import 'package:senior_ease/core/usecase/usecase.dart';
import 'package:senior_ease/features/dashboard/domain/entities/activity.dart';
import 'package:senior_ease/features/dashboard/domain/usecases/get_activities.dart';

class DashboardController extends ChangeNotifier {
  DashboardController(this._getActivities, this._appMode) {
    _appMode.addListener(_handleAppModeChanged);
  }

  final GetActivities _getActivities;
  final AppModeController _appMode;

  static const List<({String label, ActivityStatus status})> _allTabs = [
    (label: 'Atividades', status: ActivityStatus.active),
    (label: 'Concluídas', status: ActivityStatus.completed),
    (label: 'Expiradas', status: ActivityStatus.expired),
  ];

  bool isLoading = true;
  int selectedTab = 0;
  List<Activity> _activities = [];

  bool get isSimpleMode => _appMode.isSimpleMode;

  /// "Expiradas" is hidden in Simple mode — it's not something the user
  /// needs to act on, so it's one less tab to scan.
  List<({String label, ActivityStatus status})> get tabs => isSimpleMode
      ? _allTabs.where((tab) => tab.status != ActivityStatus.expired).toList()
      : _allTabs;

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

  void _handleAppModeChanged() {
    if (selectedTab >= tabs.length) {
      selectedTab = 0;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _appMode.removeListener(_handleAppModeChanged);
    super.dispose();
  }
}
