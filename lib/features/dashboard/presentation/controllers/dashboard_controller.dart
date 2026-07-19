import 'package:flutter/foundation.dart';
import 'package:senior_ease/core/app_mode/app_mode_controller.dart';
import 'package:senior_ease/core/usecase/usecase.dart';
import 'package:senior_ease/features/dashboard/domain/entities/activity.dart';
import 'package:senior_ease/features/dashboard/domain/usecases/complete_activity.dart';
import 'package:senior_ease/features/dashboard/domain/usecases/get_activities.dart';

class DashboardController extends ChangeNotifier {
  DashboardController(
    this._getActivities,
    this._completeActivity,
    this._appMode,
  ) {
    _appMode.addListener(_handleAppModeChanged);
  }

  final GetActivities _getActivities;
  final CompleteActivity _completeActivity;
  final AppModeController _appMode;
  String? _completingActivityId;

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

  bool isCompleting(String activityId) => _completingActivityId == activityId;

  /// Refetches quietly (no [isLoading] toggle) — this only ever affects one
  /// card's status, so the full list blanking out while it reloads would
  /// read as a glitch rather than a completion.
  Future<void> completeActivity(String activityId) async {
    _completingActivityId = activityId;
    notifyListeners();
    try {
      await _completeActivity(activityId);
      _activities = await _getActivities(const NoParams());
    } finally {
      _completingActivityId = null;
      notifyListeners();
    }
  }

  /// Pull-to-refresh: [RefreshIndicator] already shows its own spinner, so
  /// this refetches quietly instead of also blanking the list via
  /// [isLoading].
  Future<void> refresh() async {
    _activities = await _getActivities(const NoParams());
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
