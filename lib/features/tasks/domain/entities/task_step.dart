enum TaskStepKind {
  contentReading,
  watchContent,
  multipleChoice,
  openQuestion,
}

class TaskStepOption {
  const TaskStepOption({required this.id, required this.label});

  final String id;
  final String label;
}

class TaskStep {
  const TaskStep({
    required this.id,
    required this.label,
    required this.order,
    required this.kind,
    required this.completed,
    this.guideCompleted = false,
    this.body,
    this.question,
    this.options,
    this.videoUrl,
  });

  final String id;
  final String label;
  final int order;
  final TaskStepKind kind;
  final bool completed;
  final bool guideCompleted;
  final String? body;
  final String? question;
  final List<TaskStepOption>? options;
  final String? videoUrl;

  String get typeLabel => switch (kind) {
    TaskStepKind.contentReading => 'Leitura de conteúdo',
    TaskStepKind.watchContent => 'Assistir conteúdo',
    TaskStepKind.multipleChoice => 'Múltipla escolha',
    TaskStepKind.openQuestion => 'Questão aberta',
  };

  TaskStep copyWith({bool? completed, bool? guideCompleted}) {
    return TaskStep(
      id: id,
      label: label,
      order: order,
      kind: kind,
      completed: completed ?? this.completed,
      guideCompleted: guideCompleted ?? this.guideCompleted,
      body: body,
      question: question,
      options: options,
      videoUrl: videoUrl,
    );
  }
}
