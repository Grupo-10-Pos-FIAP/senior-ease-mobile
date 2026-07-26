import 'package:flutter/material.dart';
import 'package:senior_ease/features/tasks/domain/entities/task_step.dart';
import 'package:senior_ease/features/tasks/presentation/widgets/tutorials/content_reading_tutorial.dart';
import 'package:senior_ease/features/tasks/presentation/widgets/tutorials/multiple_choice_tutorial.dart';
import 'package:senior_ease/features/tasks/presentation/widgets/tutorials/open_question_tutorial.dart';
import 'package:senior_ease/features/tasks/presentation/widgets/tutorials/watch_content_tutorial.dart';

class StepTutorialRenderer extends StatelessWidget {
  const StepTutorialRenderer({
    super.key,
    required this.kind,
    required this.stepLabel,
    this.onCanCompleteChange,
  });

  final TaskStepKind kind;
  final String stepLabel;
  final ValueChanged<bool>? onCanCompleteChange;

  @override
  Widget build(BuildContext context) {
    switch (kind) {
      case TaskStepKind.multipleChoice:
        return MultipleChoiceTutorial(
          stepLabel: stepLabel,
          onCanCompleteChange: onCanCompleteChange,
        );
      case TaskStepKind.openQuestion:
        return OpenQuestionTutorial(
          stepLabel: stepLabel,
          onCanCompleteChange: onCanCompleteChange,
        );
      case TaskStepKind.contentReading:
        return ContentReadingTutorial(stepLabel: stepLabel);
      case TaskStepKind.watchContent:
        return WatchContentTutorial(stepLabel: stepLabel);
    }
  }
}
