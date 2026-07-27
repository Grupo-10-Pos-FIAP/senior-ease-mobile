import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:senior_ease/features/tasks/domain/entities/task_step.dart';
import 'package:senior_ease/features/tasks/domain/repositories/task_repository.dart';

abstract class TaskRemoteDataSource {
  Future<ActivityStepsData> getSteps(String activityId);

  Future<void> completeStep(String activityId, String stepId);

  Future<void> completeGuideStep(String activityId, String stepId);

  Future<void> markStarted(String activityId);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  TaskRemoteDataSourceImpl(this._firestore, this._firebaseAuth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  @override
  Future<ActivityStepsData> getSteps(String activityId) async {
    final uid = _firebaseAuth.currentUser!.uid;
    final userDoc = await _firestore.collection('users').doc(uid).get();
    final courseId = userDoc.data()?['enrolledCourseId'] as String?;
    if (courseId == null) {
      return (title: '', steps: <TaskStep>[], started: false);
    }

    final activityDoc = await _firestore
        .collection('courses')
        .doc(courseId)
        .collection('activities')
        .doc(activityId)
        .get();
    final data = activityDoc.data() ?? <String, dynamic>{};
    final stepsData = (data['steps'] as List<dynamic>?) ?? [];

    final progressDoc = await _firestore
        .collection('users')
        .doc(uid)
        .collection('activityProgress')
        .doc(activityId)
        .get();
    final progress = progressDoc.data();
    final completedStepIds = List<String>.from(
      (progress?['completedStepIds'] as List<dynamic>?) ?? [],
    );
    final completedGuideStepIds = List<String>.from(
      (progress?['completedGuideStepIds'] as List<dynamic>?) ?? [],
    );
    final started =
        progress?['started'] == true || completedStepIds.isNotEmpty;

    final steps =
        stepsData
            .map(
              (raw) => _mapStep(
                raw as Map<String, dynamic>,
                completedStepIds,
                completedGuideStepIds,
              ),
            )
            .toList()
          ..sort((a, b) => a.order.compareTo(b.order));

    return (
      title: data['title'] as String? ?? '',
      steps: steps,
      started: started,
    );
  }

  TaskStep _mapStep(
    Map<String, dynamic> data,
    List<String> completedStepIds,
    List<String> completedGuideStepIds,
  ) {
    final id = data['id'] as String;
    final content = data['content'] as Map<String, dynamic>?;
    final optionsData = content?['options'] as List<dynamic>?;

    return TaskStep(
      id: id,
      label: data['label'] as String? ?? '',
      order: (data['order'] as num?)?.toInt() ?? 0,
      kind: _kindFrom(data['type'] as String?),
      completed: completedStepIds.contains(id),
      guideCompleted: completedGuideStepIds.contains(id),
      body: content?['body'] as String?,
      question: content?['question'] as String?,
      videoUrl: content?['videoUrl'] as String?,
      options: optionsData
          ?.map(
            (option) => TaskStepOption(
              id: (option as Map<String, dynamic>)['id'] as String,
              label: option['label'] as String,
            ),
          )
          .toList(),
    );
  }

  TaskStepKind _kindFrom(String? type) {
    switch (type) {
      case 'multiple_choice':
        return TaskStepKind.multipleChoice;
      case 'open_question':
        return TaskStepKind.openQuestion;
      case 'watch_content':
        return TaskStepKind.watchContent;
      case 'content_reading':
      default:
        return TaskStepKind.contentReading;
    }
  }

  @override
  Future<void> completeStep(String activityId, String stepId) {
    final uid = _firebaseAuth.currentUser!.uid;
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('activityProgress')
        .doc(activityId)
        .set({
          'activityId': activityId,
          'completedStepIds': FieldValue.arrayUnion([stepId]),
        }, SetOptions(merge: true));
  }

  @override
  Future<void> completeGuideStep(String activityId, String stepId) {
    final uid = _firebaseAuth.currentUser!.uid;
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('activityProgress')
        .doc(activityId)
        .set({
          'activityId': activityId,
          'completedGuideStepIds': FieldValue.arrayUnion([stepId]),
        }, SetOptions(merge: true));
  }

  @override
  Future<void> markStarted(String activityId) {
    final uid = _firebaseAuth.currentUser!.uid;
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('activityProgress')
        .doc(activityId)
        .set({
          'activityId': activityId,
          'started': true,
        }, SetOptions(merge: true));
  }
}
