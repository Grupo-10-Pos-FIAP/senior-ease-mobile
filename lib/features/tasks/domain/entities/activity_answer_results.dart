import 'package:senior_ease/features/tasks/domain/entities/task_step.dart';

class ActivityAnswerResult {
  const ActivityAnswerResult({
    required this.stepId,
    required this.question,
    required this.userAnswerLabel,
    required this.correctOptionLabel,
    required this.isCorrect,
  });

  final String stepId;
  final String question;
  final String userAnswerLabel;
  final String correctOptionLabel;
  final bool isCorrect;
}

class ActivityAnswerSummary {
  const ActivityAnswerSummary({
    required this.total,
    required this.correct,
    required this.incorrect,
  });

  final int total;
  final int correct;
  final int incorrect;
}

String _resolveOptionLabel(TaskStep step, String? optionId) {
  if (optionId == null || optionId.trim().isEmpty) {
    return 'Sem resposta';
  }

  final options = step.options ?? const <TaskStepOption>[];
  for (final option in options) {
    if (option.id == optionId) {
      return option.label;
    }
  }
  return 'Resposta não encontrada';
}

List<ActivityAnswerResult> getActivityAnswerResults(List<TaskStep> steps) {
  final sorted = [...steps]..sort((a, b) => a.order.compareTo(b.order));

  return sorted
      .where((step) => step.kind == TaskStepKind.multipleChoice)
      .where((step) => step.correctOptionId != null && step.correctOptionId!.isNotEmpty)
      .map((step) {
        final question = (step.question?.trim().isNotEmpty ?? false)
            ? step.question!.trim()
            : step.label;
        return ActivityAnswerResult(
          stepId: step.id,
          question: question,
          userAnswerLabel: _resolveOptionLabel(step, step.answer),
          correctOptionLabel: _resolveOptionLabel(step, step.correctOptionId),
          isCorrect: step.isMultipleChoiceAnswerCorrect,
        );
      })
      .toList();
}

ActivityAnswerSummary summarizeActivityAnswers(List<ActivityAnswerResult> results) {
  final total = results.length;
  final correct = results.where((result) => result.isCorrect).length;
  return ActivityAnswerSummary(
    total: total,
    correct: correct,
    incorrect: total - correct,
  );
}
