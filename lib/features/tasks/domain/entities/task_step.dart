class TaskStep {
  const TaskStep({required this.title, required this.completed});

  final String title;
  final bool completed;

  TaskStep copyWith({String? title, bool? completed}) {
    return TaskStep(
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }
}
