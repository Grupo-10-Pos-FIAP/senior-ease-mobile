enum ActivityStatus { active, completed, expired }

class Activity {
  const Activity({
    required this.id,
    required this.title,
    required this.dateRange,
    required this.status,
    required this.started,
    required this.completedStepsCount,
  });

  final String id;
  final String title;
  final String dateRange;
  final ActivityStatus status;
  final bool started;
  final int completedStepsCount;
}
