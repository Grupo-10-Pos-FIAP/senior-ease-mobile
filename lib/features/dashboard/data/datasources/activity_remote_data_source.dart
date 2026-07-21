import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:senior_ease/features/dashboard/domain/entities/activity.dart';

abstract class ActivityRemoteDataSource {
  Future<List<Activity>> getActivities();

  Future<void> completeActivity(String activityId);
}

class ActivityRemoteDataSourceImpl implements ActivityRemoteDataSource {
  ActivityRemoteDataSourceImpl(this._firestore, this._firebaseAuth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  Future<List<Activity>> getActivities() async {
    final uid = _firebaseAuth.currentUser!.uid;
    final userDoc = await _firestore.collection('users').doc(uid).get();
    final courseId = userDoc.data()?['enrolledCourseId'] as String?;
    if (courseId == null) return [];

    final activitiesSnapshot = await _firestore
        .collection('courses')
        .doc(courseId)
        .collection('activities')
        .get();
    final progressSnapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('activityProgress')
        .get();
    final progressStatusByActivityId = {
      for (final doc in progressSnapshot.docs)
        doc.id: doc.data()['status'] as String?,
    };

    final activities = activitiesSnapshot.docs.map((doc) {
      final data = doc.data();
      // Completion is the only per-user state — once the user completes an
      // activity that stays true regardless of the course's own status.
      // Everything else (expired, active) is a property of the course
      // activity itself, so a leftover/default progress status (e.g.
      // "active") must never mask the course marking something expired.
      final progressStatus = progressStatusByActivityId[doc.id];
      final status = progressStatus == 'completed'
          ? progressStatus
          : data['status'] as String?;
      final endDate = data['endDate'] as String?;
      final dueDate = endDate != null ? DateTime.tryParse(endDate) : null;
      return (
        activity: Activity(
          id: doc.id,
          title: data['title'] as String? ?? '',
          dateRange: _formatDateRange(data['startDate'] as String?, endDate),
          status: _statusFrom(status, dueDate),
        ),
        dueDate: dueDate,
      );
    }).toList();

    // Nearest due date (vencimento) first; activities with no parseable
    // end date sort last rather than breaking the ordering.
    activities.sort((a, b) {
      if (a.dueDate == null && b.dueDate == null) return 0;
      if (a.dueDate == null) return 1;
      if (b.dueDate == null) return -1;
      return a.dueDate!.compareTo(b.dueDate!);
    });

    return activities.map((entry) => entry.activity).toList();
  }

  @override
  Future<void> completeActivity(String activityId) {
    final uid = _firebaseAuth.currentUser!.uid;
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('activityProgress')
        .doc(activityId)
        .set({
          'activityId': activityId,
          'status': 'completed',
        }, SetOptions(merge: true));
  }

  String _formatDateRange(String? startDate, String? endDate) {
    final start = startDate != null ? DateTime.tryParse(startDate) : null;
    final end = endDate != null ? DateTime.tryParse(endDate) : null;
    if (start == null || end == null) return '';
    return '${_dateFormat.format(start)} - ${_dateFormat.format(end)}';
  }

  ActivityStatus _statusFrom(String? value, DateTime? dueDate) {
    switch (value) {
      case 'completed':
        return ActivityStatus.completed;
      case 'expired':
        return ActivityStatus.expired;
      default:
        // No explicit status past its due date still counts as expired,
        // even if progress/course data was never updated to say so.
        if (dueDate != null && _isBeforeToday(dueDate)) {
          return ActivityStatus.expired;
        }
        return ActivityStatus.active;
    }
  }

  bool _isBeforeToday(DateTime date) {
    final today = DateTime.now();
    final dateOnly = DateTime(date.year, date.month, date.day);
    final todayOnly = DateTime(today.year, today.month, today.day);
    return dateOnly.isBefore(todayOnly);
  }
}
