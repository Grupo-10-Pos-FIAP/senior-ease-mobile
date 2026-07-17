import 'package:flutter/foundation.dart';
import 'package:senior_ease/features/tasks/domain/entities/task_step.dart';
import 'package:senior_ease/features/tasks/domain/usecases/get_steps.dart';

class TaskStepsController extends ChangeNotifier {
  TaskStepsController(this._getSteps);

  final GetSteps _getSteps;

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

  /// Marks [stepId] as completed locally. The Firestore write itself happens
  /// in the stage screen (which has the ids in scope via route arguments) —
  /// this just reflects that back into the steps list once we return to it.
  void markCompleted(String stepId) {
    steps = steps
        .map(
          (step) =>
              step.id == stepId ? step.copyWith(completed: true) : step,
        )
        .toList();
    notifyListeners();
  }
}
