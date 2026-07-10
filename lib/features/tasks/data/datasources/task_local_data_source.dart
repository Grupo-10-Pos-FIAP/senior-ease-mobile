import 'package:senior_ease/features/tasks/domain/entities/task_step.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskStep>> getSteps();
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  static const List<TaskStep> _mockSteps = [
    TaskStep(title: 'Boas-vindas e apresentação', completed: true),
    TaskStep(title: 'Conhecendo o aparelho', completed: true),
    TaskStep(title: 'Aprendendo toques e comandos', completed: false),
    TaskStep(title: 'Conectando à internet', completed: false),
  ];

  @override
  Future<List<TaskStep>> getSteps() async {
    return _mockSteps;
  }
}
