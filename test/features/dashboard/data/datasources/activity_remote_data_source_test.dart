import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:senior_ease/features/dashboard/data/datasources/activity_remote_data_source.dart';
import 'package:senior_ease/features/dashboard/domain/entities/activity.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}

class MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {}

class MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}

void main() {
  late MockFirebaseFirestore firestore;
  late MockFirebaseAuth firebaseAuth;
  late MockCollectionReference usersCollection;
  late MockDocumentReference userDocRef;
  late MockDocumentSnapshot userDocSnapshot;
  late MockCollectionReference coursesCollection;
  late MockDocumentReference courseDocRef;
  late MockCollectionReference activitiesCollection;
  late MockQuerySnapshot activitiesSnapshot;
  late MockCollectionReference progressCollection;
  late MockQuerySnapshot progressSnapshot;
  late ActivityRemoteDataSourceImpl dataSource;

  const uid = 'uid-1';
  const courseId = 'course-1';

  // Kept as separate statements (never inlined into a when(...).thenReturn
  // argument list) — mocktail's `when` recording gets corrupted if another
  // `when` call (here, inside buildDoc) runs while one is still "open".
  MockQueryDocumentSnapshot buildDoc(String id, Map<String, dynamic> data) {
    final doc = MockQueryDocumentSnapshot();
    when(() => doc.id).thenReturn(id);
    when(() => doc.data()).thenReturn(data);
    return doc;
  }

  void stubActivityDocs(List<MockQueryDocumentSnapshot> docs) {
    when(() => activitiesSnapshot.docs).thenReturn(docs);
  }

  void stubProgressDocs(List<MockQueryDocumentSnapshot> docs) {
    when(() => progressSnapshot.docs).thenReturn(docs);
  }

  setUpAll(() {
    registerFallbackValue(SetOptions(merge: true));
  });

  setUp(() {
    firestore = MockFirebaseFirestore();
    firebaseAuth = MockFirebaseAuth();
    usersCollection = MockCollectionReference();
    userDocRef = MockDocumentReference();
    userDocSnapshot = MockDocumentSnapshot();
    coursesCollection = MockCollectionReference();
    courseDocRef = MockDocumentReference();
    activitiesCollection = MockCollectionReference();
    activitiesSnapshot = MockQuerySnapshot();
    progressCollection = MockCollectionReference();
    progressSnapshot = MockQuerySnapshot();

    final user = MockUser();
    when(() => user.uid).thenReturn(uid);
    when(() => firebaseAuth.currentUser).thenReturn(user);

    when(() => firestore.collection('users')).thenReturn(usersCollection);
    when(() => usersCollection.doc(uid)).thenReturn(userDocRef);
    when(() => userDocRef.get()).thenAnswer((_) async => userDocSnapshot);
    when(
      () => userDocRef.collection('activityProgress'),
    ).thenReturn(progressCollection);
    when(
      () => progressCollection.get(),
    ).thenAnswer((_) async => progressSnapshot);
    stubProgressDocs([]);

    when(() => firestore.collection('courses')).thenReturn(coursesCollection);
    when(() => coursesCollection.doc(any())).thenReturn(courseDocRef);
    when(
      () => courseDocRef.collection('activities'),
    ).thenReturn(activitiesCollection);
    when(
      () => activitiesCollection.get(),
    ).thenAnswer((_) async => activitiesSnapshot);

    dataSource = ActivityRemoteDataSourceImpl(firestore, firebaseAuth);
  });

  group('getActivities', () {
    test(
      'returns an empty list when the user has no enrolled course',
      () async {
        when(() => userDocSnapshot.data()).thenReturn({});

        final result = await dataSource.getActivities();

        expect(result, isEmpty);
      },
    );

    test('a completed progress always wins over the course status', () async {
      when(
        () => userDocSnapshot.data(),
      ).thenReturn({'enrolledCourseId': courseId});
      final activityDoc = buildDoc('activity-1', {
        'title': 'Curso X',
        'status': 'expired',
        'startDate': '2026-01-01',
        'endDate': '2026-02-01',
      });
      stubActivityDocs([activityDoc]);
      final progressDoc = buildDoc('activity-1', {'status': 'completed'});
      stubProgressDocs([progressDoc]);

      final result = await dataSource.getActivities();

      expect(result.single.status, ActivityStatus.completed);
    });

    test(
      'a stale "active" progress never masks an expired course status',
      () async {
        when(
          () => userDocSnapshot.data(),
        ).thenReturn({'enrolledCourseId': courseId});
        final activityDoc = buildDoc('activity-1', {
          'title': 'Curso X',
          'status': 'expired',
          'startDate': '2026-01-01',
          'endDate': '2026-02-01',
        });
        stubActivityDocs([activityDoc]);
        final progressDoc = buildDoc('activity-1', {'status': 'active'});
        stubProgressDocs([progressDoc]);

        final result = await dataSource.getActivities();

        expect(result.single.status, ActivityStatus.expired);
      },
    );

    test(
      'auto-expires an activity past its due date with no explicit status',
      () async {
        when(
          () => userDocSnapshot.data(),
        ).thenReturn({'enrolledCourseId': courseId});
        final activityDoc = buildDoc('activity-1', {
          'title': 'Curso X',
          'startDate': '2020-01-01',
          'endDate': '2020-02-01',
        });
        stubActivityDocs([activityDoc]);

        final result = await dataSource.getActivities();

        expect(result.single.status, ActivityStatus.expired);
      },
    );

    test('stays active when the due date has not passed yet', () async {
      final future = DateTime.now().add(const Duration(days: 30));
      when(
        () => userDocSnapshot.data(),
      ).thenReturn({'enrolledCourseId': courseId});
      final activityDoc = buildDoc('activity-1', {
        'title': 'Curso X',
        'startDate': '2026-01-01',
        'endDate': future.toIso8601String(),
      });
      stubActivityDocs([activityDoc]);

      final result = await dataSource.getActivities();

      expect(result.single.status, ActivityStatus.active);
    });

    test(
      'sorts by nearest due date first, with unparsable dates last',
      () async {
        when(
          () => userDocSnapshot.data(),
        ).thenReturn({'enrolledCourseId': courseId});
        final laterDoc = buildDoc('later', {
          'title': 'Depois',
          'startDate': '2026-01-01',
          'endDate': '2026-03-01',
        });
        final noDateDoc = buildDoc('no-date', {'title': 'Sem data'});
        final soonerDoc = buildDoc('sooner', {
          'title': 'Antes',
          'startDate': '2026-01-01',
          'endDate': '2026-02-01',
        });
        stubActivityDocs([laterDoc, noDateDoc, soonerDoc]);

        final result = await dataSource.getActivities();

        expect(result.map((a) => a.id), ['sooner', 'later', 'no-date']);
      },
    );

    test('formats the date range as dd/MM/yyyy - dd/MM/yyyy', () async {
      when(
        () => userDocSnapshot.data(),
      ).thenReturn({'enrolledCourseId': courseId});
      final activityDoc = buildDoc('activity-1', {
        'title': 'Curso X',
        'startDate': '2026-01-05',
        'endDate': '2026-02-10',
      });
      stubActivityDocs([activityDoc]);

      final result = await dataSource.getActivities();

      expect(result.single.dateRange, '05/01/2026 - 10/02/2026');
    });
  });

  group('completeActivity', () {
    test(
      "writes a completed status merge to the user's activityProgress doc",
      () async {
        final docRef = MockDocumentReference();
        when(() => progressCollection.doc('activity-1')).thenReturn(docRef);
        when(() => docRef.set(any(), any())).thenAnswer((_) async {});

        await dataSource.completeActivity('activity-1');

        final captured =
            verify(() => docRef.set(captureAny(), any())).captured.single
                as Map<String, dynamic>;
        expect(captured['activityId'], 'activity-1');
        expect(captured['status'], 'completed');
      },
    );
  });
}
