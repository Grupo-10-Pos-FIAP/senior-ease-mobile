enum TaskStepKind { contentReading, multipleChoice }

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
    this.body,
    this.question,
    this.options,
  });

  final String id;
  final String label;
  final int order;
  final TaskStepKind kind;
  final bool completed;
  final String? body;
  final String? question;
  final List<TaskStepOption>? options;

  TaskStep copyWith({bool? completed}) {
    return TaskStep(
      id: id,
      label: label,
      order: order,
      kind: kind,
      completed: completed ?? this.completed,
      body: body,
      question: question,
      options: options,
    );
  }
}
