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

  /// Marks [stepId] as completed locally. The Firestore write itself happens
  /// in the stage screen (which has the ids in scope via route arguments) —
  /// this just reflects that back into the steps list once we return to it.
  void markCompleted(String stepId) {
    steps = steps
        .map(
          (step) => step.id == stepId ? step.copyWith(completed: true) : step,
        )
        .toList();
    notifyListeners();
  }

  /// Marks the whole activity — not just one step — completed, persisted to
  /// `activityProgress` in Firestore (same usecase the Dashboard card's own
  /// "Concluir atividade" button uses).
  Future<void> completeActivity() async {
    final id = activityId;
    if (id == null) return;
    await _completeActivity(id);
  }
}
