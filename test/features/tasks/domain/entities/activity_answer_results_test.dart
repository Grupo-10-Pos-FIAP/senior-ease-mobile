import 'package:flutter_test/flutter_test.dart';
import 'package:senior_ease/features/tasks/domain/entities/activity_answer_results.dart';
import 'package:senior_ease/features/tasks/domain/entities/task_step.dart';

void main() {
  final steps = [
    const TaskStep(
      id: 'step-reading',
      label: 'Leitura',
      order: 1,
      kind: TaskStepKind.contentReading,
      completed: true,
      body: 'Texto',
    ),
    const TaskStep(
      id: 'step-mc-1',
      label: 'Quiz 1',
      order: 2,
      kind: TaskStepKind.multipleChoice,
      completed: true,
      question: 'Pergunta um?',
      answer: 'c',
      correctOptionId: 'c',
      options: [
        TaskStepOption(id: 'a', label: 'Opção A'),
        TaskStepOption(id: 'b', label: 'Opção B'),
        TaskStepOption(id: 'c', label: 'Opção C correta'),
      ],
    ),
    const TaskStep(
      id: 'step-mc-2',
      label: 'Quiz 2',
      order: 3,
      kind: TaskStepKind.multipleChoice,
      completed: true,
      question: 'Pergunta dois?',
      answer: 'a',
      correctOptionId: 'b',
      options: [
        TaskStepOption(id: 'a', label: 'Escolha errada'),
        TaskStepOption(id: 'b', label: 'Escolha certa'),
      ],
    ),
    const TaskStep(
      id: 'step-open',
      label: 'Aberta',
      order: 4,
      kind: TaskStepKind.openQuestion,
      completed: true,
      question: 'O que aprendeu?',
      answer: 'Minha reflexão',
    ),
  ];

  test('avalia só múltipla escolha e resolve labels', () {
    final results = getActivityAnswerResults(steps);

    expect(results, hasLength(2));
    expect(results[0].stepId, 'step-mc-1');
    expect(results[0].question, 'Pergunta um?');
    expect(results[0].userAnswerLabel, 'Opção C correta');
    expect(results[0].correctOptionLabel, 'Opção C correta');
    expect(results[0].isCorrect, isTrue);

    expect(results[1].stepId, 'step-mc-2');
    expect(results[1].isCorrect, isFalse);
    expect(results[1].userAnswerLabel, 'Escolha errada');
    expect(results[1].correctOptionLabel, 'Escolha certa');
  });

  test('resume acertos e erros', () {
    final summary = summarizeActivityAnswers(getActivityAnswerResults(steps));

    expect(summary.total, 2);
    expect(summary.correct, 1);
    expect(summary.incorrect, 1);
  });

  test('formatAnswerSummaryMessage incentiva aprendizado sem contar erros', () {
    expect(
      formatAnswerSummaryMessage(
        const ActivityAnswerSummary(total: 1, correct: 1, incorrect: 0),
      ),
      'Parabéns! Você foi muito bem. Continue assim!',
    );
    expect(
      formatAnswerSummaryMessage(
        const ActivityAnswerSummary(total: 3, correct: 3, incorrect: 0),
      ),
      'Parabéns! Você respondeu todas as 3 perguntas corretamente. Continue assim!',
    );
    expect(
      formatAnswerSummaryMessage(
        const ActivityAnswerSummary(total: 1, correct: 0, incorrect: 1),
      ),
      'Veja abaixo como foi a pergunta. O importante é aprender.',
    );
    expect(
      formatAnswerSummaryMessage(
        const ActivityAnswerSummary(total: 2, correct: 1, incorrect: 1),
      ),
      'Veja abaixo como foram as perguntas. O importante é aprender.',
    );
  });

  test('isMultipleChoiceAnswerCorrect compara answer com gabarito', () {
    expect(steps[1].isMultipleChoiceAnswerCorrect, isTrue);
    expect(steps[2].isMultipleChoiceAnswerCorrect, isFalse);
    expect(steps[0].isMultipleChoiceAnswerCorrect, isFalse);
  });
}
