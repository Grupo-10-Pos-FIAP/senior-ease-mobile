enum ActivityStatus { active, completed, expired }

class Activity {
  const Activity({
    required this.id,
    required this.title,
    required this.dateRange,
    required this.status,
  });

  final String id;
  final String title;
  final String dateRange;
  final ActivityStatus status;
}
