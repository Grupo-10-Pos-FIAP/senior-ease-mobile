import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:senior_ease/features/settings/data/datasources/settings_remote_data_source.dart';
import 'package:senior_ease/features/settings/domain/entities/app_settings.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}

class MockUser extends Mock implements User {}

void main() {
  late MockFirebaseFirestore firestore;
  late MockFirebaseAuth firebaseAuth;
  late MockCollectionReference usersCollection;
  late MockDocumentReference docRef;
  late MockDocumentSnapshot docSnapshot;
  late SettingsRemoteDataSourceImpl dataSource;

  const uid = 'uid-123';

  setUpAll(() {
    registerFallbackValue(SetOptions(merge: true));
  });

  setUp(() {
    firestore = MockFirebaseFirestore();
    firebaseAuth = MockFirebaseAuth();
    usersCollection = MockCollectionReference();
    docRef = MockDocumentReference();
    docSnapshot = MockDocumentSnapshot();
    final user = MockUser();

    when(() => user.uid).thenReturn(uid);
    when(() => firebaseAuth.currentUser).thenReturn(user);
    when(() => firestore.collection('users')).thenReturn(usersCollection);
    when(() => usersCollection.doc(uid)).thenReturn(docRef);
    when(() => docRef.get()).thenAnswer((_) async => docSnapshot);
    when(() => docRef.set(any(), any())).thenAnswer((_) async {});

    dataSource = SettingsRemoteDataSourceImpl(firestore, firebaseAuth);
  });

  group('getSettings', () {
    test(
      'returns AppSettings.defaults() when no preferences are stored',
      () async {
        when(() => docSnapshot.data()).thenReturn({});

        final result = await dataSource.getSettings();

        expect(result, AppSettings.defaults());
      },
    );

    test('maps stored 1-based indices back to their labels', () async {
      when(() => docSnapshot.data()).thenReturn({
        'preferences': {
          'fontSize': 4, // 'Grande'
          'contrast': 6, // 'Escuro'
          'interfaceMode': 'simple',
          'spacing': 5, // 'Muito amplo'
          'reinforcedVisualFeedback': true,
          'confirmCriticalActions': false,
        },
      });

      final result = await dataSource.getSettings();

      expect(result.fontSize, 'Grande');
      expect(result.contrastLevel, 'Escuro');
      expect(result.navigationMode, 'Simples');
      expect(result.spacing, 'Muito amplo');
      expect(result.enhancedVisualFeedback, isTrue);
      expect(result.criticalActionConfirmation, isFalse);
    });

    test('any interfaceMode other than "simple" reads as Avançado', () async {
      when(() => docSnapshot.data()).thenReturn({
        'preferences': {
          'fontSize': 3,
          'contrast': 1,
          'interfaceMode': 'standard',
          'spacing': 3,
        },
      });

      final result = await dataSource.getSettings();

      expect(result.navigationMode, 'Avançado');
    });

    test('an out-of-range stored index clamps to the first option', () async {
      when(() => docSnapshot.data()).thenReturn({
        'preferences': {
          'fontSize': 99,
          'contrast': 0,
          'interfaceMode': 'standard',
          'spacing': -3,
        },
      });

      final result = await dataSource.getSettings();

      expect(result.fontSize, AppSettings.fontSizeOptions.first);
      expect(result.contrastLevel, AppSettings.contrastLevelOptions.first);
      expect(result.spacing, AppSettings.spacingOptions.first);
    });
  });

  group('saveSettings', () {
    test('writes 1-based indices and the mapped interfaceMode', () async {
      final settings = AppSettings.defaults().copyWith(
        fontSize: 'Grande',
        contrastLevel: 'Escuro',
        navigationMode: 'Simples',
        spacing: 'Muito amplo',
        enhancedVisualFeedback: true,
        criticalActionConfirmation: false,
      );

      await dataSource.saveSettings(settings);

      final captured =
          verify(() => docRef.set(captureAny(), any())).captured.single
              as Map<String, dynamic>;
      final preferences = captured['preferences'] as Map<String, dynamic>;
      expect(preferences['fontSize'], 4);
      expect(preferences['contrast'], 6);
      expect(preferences['interfaceMode'], 'simple');
      expect(preferences['spacing'], 5);
      expect(preferences['reinforcedVisualFeedback'], isTrue);
      expect(preferences['confirmCriticalActions'], isFalse);
    });

    test('a non-Simples navigationMode is saved as "standard"', () async {
      final settings = AppSettings.defaults().copyWith(
        navigationMode: 'Avançado',
      );

      await dataSource.saveSettings(settings);

      final captured =
          verify(() => docRef.set(captureAny(), any())).captured.single
              as Map<String, dynamic>;
      final preferences = captured['preferences'] as Map<String, dynamic>;
      expect(preferences['interfaceMode'], 'standard');
    });
  });
}
