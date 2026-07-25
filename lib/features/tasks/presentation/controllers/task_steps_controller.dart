import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:senior_ease/features/dashboard/domain/usecases/complete_activity.dart';
import 'package:senior_ease/features/tasks/domain/entities/task_step.dart';
import 'package:senior_ease/features/tasks/domain/usecases/get_steps.dart';
import 'package:senior_ease/features/tasks/domain/usecases/mark_activity_started.dart';

class TaskStepsController extends ChangeNotifier {
  TaskStepsController(
    this._getSteps,
    this._completeActivity,
    this._markStarted,
  );

  final GetSteps _getSteps;
  final CompleteActivity _completeActivity;
  final MarkActivityStarted _markStarted;

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
    unawaited(_markStarted(activityId));
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
