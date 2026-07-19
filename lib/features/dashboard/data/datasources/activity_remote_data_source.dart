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

    return activitiesSnapshot.docs.map((doc) {
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
      return Activity(
        id: doc.id,
        title: data['title'] as String? ?? '',
        dateRange: _formatDateRange(
          data['startDate'] as String?,
          data['endDate'] as String?,
        ),
        status: _statusFrom(status),
      );
    }).toList();
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

  ActivityStatus _statusFrom(String? value) {
    switch (value) {
      case 'completed':
        return ActivityStatus.completed;
      case 'expired':
        return ActivityStatus.expired;
      default:
        return ActivityStatus.active;
    }
  }
}
