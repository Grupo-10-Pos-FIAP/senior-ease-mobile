import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:senior_ease/features/tasks/domain/entities/task_step.dart';

abstract class TaskRemoteDataSource {
  Future<({String title, List<TaskStep> steps})> getSteps(String activityId);

  Future<void> completeStep(String activityId, String stepId);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  TaskRemoteDataSourceImpl(this._firestore, this._firebaseAuth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  @override
  Future<({String title, List<TaskStep> steps})> getSteps(
    String activityId,
  ) async {
    final uid = _firebaseAuth.currentUser!.uid;
    final userDoc = await _firestore.collection('users').doc(uid).get();
    final courseId = userDoc.data()?['enrolledCourseId'] as String?;
    if (courseId == null) return (title: '', steps: <TaskStep>[]);

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
    final completedStepIds = List<String>.from(
      (progressDoc.data()?['completedStepIds'] as List<dynamic>?) ?? [],
    );

    final steps =
        stepsData
            .map(
              (raw) =>
                  _mapStep(raw as Map<String, dynamic>, completedStepIds),
            )
            .toList()
          ..sort((a, b) => a.order.compareTo(b.order));

    return (title: data['title'] as String? ?? '', steps: steps);
  }

  TaskStep _mapStep(Map<String, dynamic> data, List<String> completedStepIds) {
    final id = data['id'] as String;
    final isQuiz = data['type'] == 'multiple_choice';
    final content = data['content'] as Map<String, dynamic>?;
    final optionsData = content?['options'] as List<dynamic>?;

    return TaskStep(
      id: id,
      label: data['label'] as String? ?? '',
      order: (data['order'] as num?)?.toInt() ?? 0,
      kind: isQuiz ? TaskStepKind.multipleChoice : TaskStepKind.contentReading,
      completed: completedStepIds.contains(id),
      body: content?['body'] as String?,
      question: content?['question'] as String?,
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
}
