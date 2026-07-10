import 'package:flutter/foundation.dart';
import 'package:senior_ease/core/usecase/usecase.dart';
import 'package:senior_ease/features/tasks/domain/entities/task_step.dart';
import 'package:senior_ease/features/tasks/domain/usecases/get_steps.dart';

class TaskStepsController extends ChangeNotifier {
  TaskStepsController(this._getSteps);

  final GetSteps _getSteps;

  bool isLoading = true;
  List<TaskStep> steps = [];

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    steps = await _getSteps(const NoParams());
    isLoading = false;
    notifyListeners();
  }

  void toggleStep(int index) {
    final updated = [...steps];
    updated[index] = updated[index].copyWith(
      completed: !updated[index].completed,
    );
    steps = updated;
    notifyListeners();
  }
}
