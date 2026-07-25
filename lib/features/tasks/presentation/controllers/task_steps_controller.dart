import 'package:flutter/foundation.dart';
import 'package:senior_ease/features/dashboard/domain/usecases/complete_activity.dart';
import 'package:senior_ease/features/tasks/domain/entities/task_step.dart';
import 'package:senior_ease/features/tasks/domain/usecases/get_steps.dart';

class TaskStepsController extends ChangeNotifier {
  TaskStepsController(this._getSteps, this._completeActivity);

  final GetSteps _getSteps;
  final CompleteActivity _completeActivity;

  bool isLoading = true;
  String? activityId;
  String activityTitle = '';
  List<TaskStep> steps = [];

  Future<void> load(String activityId) async {
    this.activityId = activityId;
    isLoading = true;
    notifyListeners();
    final result = await _getSteps(GetStepsParams(activityId: activityId));
    activityTitle = result.title;
    steps = result.steps;
    isLoading = false;
    notifyListeners();
  }

  void markCompleted(String stepId) {
    steps = steps
        .map(
          (step) => step.id == stepId ? step.copyWith(completed: true) : step,
        )
        .toList();
    notifyListeners();
  }

  Future<void> completeActivity() async {
    final id = activityId;
    if (id == null) return;
    await _completeActivity(id);
  }
}
