import 'package:flutter_test/flutter_test.dart';
import 'package:senior_ease/features/tasks/domain/entities/task_step.dart';

void main() {
  const step = TaskStep(
    id: 'step-1',
    label: 'Abrir o app',
    order: 1,
    kind: TaskStepKind.contentReading,
    completed: false,
    body: 'Toque no ícone do app.',
  );

  test(
    'copyWith(completed: true) flips completed and keeps everything else',
    () {
      final updated = step.copyWith(completed: true);

      expect(updated.completed, isTrue);
      expect(updated.id, step.id);
      expect(updated.label, step.label);
      expect(updated.order, step.order);
      expect(updated.kind, step.kind);
      expect(updated.body, step.body);
    },
  );

  test('copyWith() with no arguments preserves completed as-is', () {
    final updated = step.copyWith();

    expect(updated.completed, step.completed);
  });

  test('multipleChoice steps keep their question and options', () {
    const quiz = TaskStep(
      id: 'step-2',
      label: 'Pergunta',
      order: 2,
      kind: TaskStepKind.multipleChoice,
      completed: false,
      question: 'Qual botão fecha o app?',
      options: [
        TaskStepOption(id: 'a', label: 'O X vermelho'),
        TaskStepOption(id: 'b', label: 'O botão home'),
      ],
    );

    final updated = quiz.copyWith(completed: true);

    expect(updated.question, quiz.question);
    expect(updated.options, quiz.options);
    expect(updated.completed, isTrue);
  });
}
