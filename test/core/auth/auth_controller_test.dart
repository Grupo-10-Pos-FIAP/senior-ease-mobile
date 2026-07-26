import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:senior_ease/core/auth/auth_controller.dart';

class MockFirebaseAuth extends Mock implements firebase_auth.FirebaseAuth {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}

class MockUser extends Mock implements firebase_auth.User {}

class MockUserCredential extends Mock implements firebase_auth.UserCredential {}

class MockAdditionalUserInfo extends Mock
    implements firebase_auth.AdditionalUserInfo {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class FakeAuthCredential extends Fake implements firebase_auth.AuthCredential {}

void main() {
  late MockFirebaseAuth firebaseAuth;
  late MockGoogleSignIn googleSignIn;
  late MockFirebaseFirestore firestore;
  late MockCollectionReference usersCollection;
  late MockDocumentReference docRef;
  late MockDocumentSnapshot docSnapshot;
  late AuthController controller;

  const uid = 'uid-123';

  setUpAll(() async {
    registerFallbackValue(FakeAuthCredential());
    registerFallbackValue(SetOptions(merge: true));
    await dotenv.load(
      fileName: 'no_such_file',
      isOptional: true,
      mergeWith: {'GOOGLE_SERVER_CLIENT_ID': 'test-client-id'},
    );
  });

  setUp(() {
    firebaseAuth = MockFirebaseAuth();
    googleSignIn = MockGoogleSignIn();
    firestore = MockFirebaseFirestore();
    usersCollection = MockCollectionReference();
    docRef = MockDocumentReference();
    docSnapshot = MockDocumentSnapshot();

    when(
      () => firebaseAuth.authStateChanges(),
    ).thenAnswer((_) => const Stream.empty());
    when(() => firestore.collection('users')).thenReturn(usersCollection);
    when(() => usersCollection.doc(any())).thenReturn(docRef);
    when(() => docRef.get()).thenAnswer((_) async => docSnapshot);
    when(() => docRef.set(any(), any())).thenAnswer((_) async {});

    controller = AuthController(firebaseAuth, googleSignIn, firestore);
  });

  group('isCurrentAccountDeactivated', () {
    test('returns false when nobody is signed in', () async {
      when(() => firebaseAuth.currentUser).thenReturn(null);

      expect(await controller.isCurrentAccountDeactivated(), isFalse);
    });

    test(
      'returns true when the Firestore profile is flagged deactivated',
      () async {
        final user = MockUser();
        when(() => user.uid).thenReturn(uid);
        when(() => firebaseAuth.currentUser).thenReturn(user);
        when(() => docSnapshot.data()).thenReturn({'deactivated': true});

        expect(await controller.isCurrentAccountDeactivated(), isTrue);
      },
    );

    test('returns false when the flag is absent', () async {
      final user = MockUser();
      when(() => user.uid).thenReturn(uid);
      when(() => firebaseAuth.currentUser).thenReturn(user);
      when(() => docSnapshot.data()).thenReturn({});

      expect(await controller.isCurrentAccountDeactivated(), isFalse);
    });
  });

  group('deleteAccount', () {
    test('does nothing when nobody is signed in', () async {
      when(() => firebaseAuth.currentUser).thenReturn(null);

      await controller.deleteAccount();

      verifyNever(() => docRef.set(any(), any()));
      verifyNever(() => firebaseAuth.signOut());
    });

    test(
      'only flags the Firestore profile and signs out — never deletes anything',
      () async {
        final user = MockUser();
        when(() => user.uid).thenReturn(uid);
        when(() => firebaseAuth.currentUser).thenReturn(user);
        when(() => googleSignIn.signOut()).thenAnswer((_) async {});
        when(() => firebaseAuth.signOut()).thenAnswer((_) async {});

        await controller.deleteAccount();

        final captured =
            verify(() => docRef.set(captureAny(), any())).captured.single
                as Map<String, dynamic>;
        expect(captured['deactivated'], isTrue);
        expect(captured.containsKey('deactivatedAt'), isTrue);
        verify(() => googleSignIn.signOut()).called(1);
        verify(() => firebaseAuth.signOut()).called(1);
        verifyNever(() => user.delete());
      },
    );
  });

  group('confirmReactivation', () {
    test('does nothing when nobody is signed in', () async {
      when(() => firebaseAuth.currentUser).thenReturn(null);

      await controller.confirmReactivation();

      verifyNever(() => docRef.set(any(), any()));
    });

    test('clears the deactivated flag for the signed-in user', () async {
      final user = MockUser();
      when(() => user.uid).thenReturn(uid);
      when(() => firebaseAuth.currentUser).thenReturn(user);

      await controller.confirmReactivation();

      final captured =
          verify(() => docRef.set(captureAny(), any())).captured.single
              as Map<String, dynamic>;
      expect(captured['deactivated'], isFalse);
      expect(captured.containsKey('deactivatedAt'), isTrue);
    });
  });

  group('signInWithEmail', () {
    test('signs in normally when the account is not deactivated', () async {
      final user = MockUser();
      when(() => user.uid).thenReturn(uid);
      final credential = MockUserCredential();
      when(() => credential.user).thenReturn(user);
      when(
        () => firebaseAuth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => credential);
      when(() => firebaseAuth.currentUser).thenReturn(user);
      when(() => docSnapshot.data()).thenReturn({});

      await controller.signInWithEmail('a@b.com', 'secret');

      verify(
        () => firebaseAuth.signInWithEmailAndPassword(
          email: 'a@b.com',
          password: 'secret',
        ),
      ).called(1);
    });

    test('rejects and signs out when the account is deactivated', () async {
      final user = MockUser();
      when(() => user.uid).thenReturn(uid);
      final credential = MockUserCredential();
      when(() => credential.user).thenReturn(user);
      when(
        () => firebaseAuth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => credential);
      when(() => firebaseAuth.currentUser).thenReturn(user);
      when(() => docSnapshot.data()).thenReturn({'deactivated': true});
      when(() => googleSignIn.signOut()).thenAnswer((_) async {});
      when(() => firebaseAuth.signOut()).thenAnswer((_) async {});

      await expectLater(
        controller.signInWithEmail('a@b.com', 'secret'),
        throwsA(isA<DeactivatedAccountException>()),
      );

      verify(() => firebaseAuth.signOut()).called(1);
    });

    test(
      'throws DeactivatedAccountFoundException without signing out, '
      'when deactivated within 90 days',
      () async {
        final user = MockUser();
        when(() => user.uid).thenReturn(uid);
        final credential = MockUserCredential();
        when(() => credential.user).thenReturn(user);
        when(
          () => firebaseAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => credential);
        when(() => firebaseAuth.currentUser).thenReturn(user);
        when(() => docSnapshot.data()).thenReturn({
          'deactivated': true,
          'deactivatedAt': Timestamp.fromDate(
            DateTime.now().subtract(const Duration(days: 10)),
          ),
        });

        await expectLater(
          controller.signInWithEmail('a@b.com', 'secret'),
          throwsA(isA<DeactivatedAccountFoundException>()),
        );

        verifyNever(() => firebaseAuth.signOut());
        verifyNever(() => docRef.set(any(), any()));
      },
    );

    test(
      'rejects and signs out when deactivated more than 90 days ago',
      () async {
        final user = MockUser();
        when(() => user.uid).thenReturn(uid);
        final credential = MockUserCredential();
        when(() => credential.user).thenReturn(user);
        when(
          () => firebaseAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => credential);
        when(() => firebaseAuth.currentUser).thenReturn(user);
        when(() => docSnapshot.data()).thenReturn({
          'deactivated': true,
          'deactivatedAt': Timestamp.fromDate(
            DateTime.now().subtract(const Duration(days: 91)),
          ),
        });
        when(() => googleSignIn.signOut()).thenAnswer((_) async {});
        when(() => firebaseAuth.signOut()).thenAnswer((_) async {});

        await expectLater(
          controller.signInWithEmail('a@b.com', 'secret'),
          throwsA(isA<DeactivatedAccountException>()),
        );

        verify(() => firebaseAuth.signOut()).called(1);
        verifyNever(() => docRef.set(any(), any()));
      },
    );
  });

  group('signUpWithEmail', () {
    test(
      'creates the account and seeds a default Firestore document',
      () async {
        final user = MockUser();
        when(() => user.uid).thenReturn(uid);
        when(() => user.displayName).thenReturn(null);
        when(() => user.email).thenReturn('new@user.com');
        when(() => user.phoneNumber).thenReturn(null);
        final credential = MockUserCredential();
        when(() => credential.user).thenReturn(user);
        when(
          () => firebaseAuth.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => credential);

        await controller.signUpWithEmail('new@user.com', 'secret');

        final captured =
            verify(() => docRef.set(captureAny(), any())).captured.single
                as Map<String, dynamic>;
        expect(captured['id'], uid);
        expect(captured['email'], 'new@user.com');
        expect(captured['enrolledCourseId'], 'default-course');
        expect(captured['registrationId'], uid);
        expect(captured['preferences'], isA<Map>());
      },
    );

    test(
      'falls back to signing in, and surfaces DeactivatedAccountFoundException '
      'when that account is deactivated within 90 days',
      () async {
        final user = MockUser();
        when(() => user.uid).thenReturn(uid);
        final credential = MockUserCredential();
        when(() => credential.user).thenReturn(user);
        when(
          () => firebaseAuth.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(
          firebase_auth.FirebaseAuthException(code: 'email-already-in-use'),
        );
        when(
          () => firebaseAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => credential);
        when(() => firebaseAuth.currentUser).thenReturn(user);
        when(() => docSnapshot.data()).thenReturn({
          'deactivated': true,
          'deactivatedAt': Timestamp.fromDate(
            DateTime.now().subtract(const Duration(days: 10)),
          ),
        });

        await expectLater(
          controller.signUpWithEmail('old@user.com', 'secret'),
          throwsA(isA<DeactivatedAccountFoundException>()),
        );

        verifyNever(() => firebaseAuth.signOut());
        verifyNever(() => docRef.set(any(), any()));
      },
    );

    test(
      'falls back to signing in when the existing account is active and the '
      'password matches — no error, just logs the caller in',
      () async {
        final user = MockUser();
        when(() => user.uid).thenReturn(uid);
        final credential = MockUserCredential();
        when(() => credential.user).thenReturn(user);
        when(
          () => firebaseAuth.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(
          firebase_auth.FirebaseAuthException(code: 'email-already-in-use'),
        );
        when(
          () => firebaseAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => credential);
        when(() => firebaseAuth.currentUser).thenReturn(user);
        when(() => docSnapshot.data()).thenReturn({});

        await controller.signUpWithEmail('active@user.com', 'secret');

        verifyNever(() => firebaseAuth.signOut());
      },
    );

    test(
      'rethrows email-already-in-use when the password does not match',
      () async {
        when(
          () => firebaseAuth.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(
          firebase_auth.FirebaseAuthException(code: 'email-already-in-use'),
        );
        when(
          () => firebaseAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(
          firebase_auth.FirebaseAuthException(code: 'wrong-password'),
        );

        await expectLater(
          controller.signUpWithEmail('taken@user.com', 'wrong'),
          throwsA(
            isA<firebase_auth.FirebaseAuthException>().having(
              (e) => e.code,
              'code',
              'email-already-in-use',
            ),
          ),
        );
      },
    );
  });

  group('signInWithGoogle', () {
    void stubAuthenticate(MockUser user, {required bool isNewUser}) {
      final account = MockGoogleSignInAccount();
      when(
        () => account.authentication,
      ).thenReturn(const GoogleSignInAuthentication(idToken: 'id-token'));
      when(
        () => googleSignIn.initialize(
          serverClientId: any(named: 'serverClientId'),
        ),
      ).thenAnswer((_) async {});
      when(() => googleSignIn.authenticate()).thenAnswer((_) async => account);
      final credential = MockUserCredential();
      when(() => credential.user).thenReturn(user);
      final additionalInfo = MockAdditionalUserInfo();
      when(() => credential.additionalUserInfo).thenReturn(additionalInfo);
      when(() => additionalInfo.isNewUser).thenReturn(isNewUser);
      when(
        () => firebaseAuth.signInWithCredential(any()),
      ).thenAnswer((_) async => credential);
    }

    test('seeds a Firestore document only for a brand-new user', () async {
      final user = MockUser();
      when(() => user.uid).thenReturn(uid);
      when(() => user.displayName).thenReturn('Maria');
      when(() => user.email).thenReturn('maria@gmail.com');
      when(() => user.phoneNumber).thenReturn(null);
      stubAuthenticate(user, isNewUser: true);
      when(() => firebaseAuth.currentUser).thenReturn(user);
      when(() => docSnapshot.data()).thenReturn({});

      await controller.signInWithGoogle();

      final captured =
          verify(() => docRef.set(captureAny(), any())).captured.single
              as Map<String, dynamic>;
      expect(captured['id'], uid);
      expect(captured['email'], 'maria@gmail.com');
    });

    test('does not seed a document for a returning user', () async {
      final user = MockUser();
      when(() => user.uid).thenReturn(uid);
      when(() => user.displayName).thenReturn('Maria');
      when(() => user.email).thenReturn('maria@gmail.com');
      when(() => user.phoneNumber).thenReturn(null);
      stubAuthenticate(user, isNewUser: false);
      when(() => firebaseAuth.currentUser).thenReturn(user);
      when(() => docSnapshot.data()).thenReturn({});

      await controller.signInWithGoogle();

      verifyNever(() => docRef.set(any(), any()));
    });

    test('rejects and signs out when the account is deactivated', () async {
      final user = MockUser();
      when(() => user.uid).thenReturn(uid);
      when(() => user.displayName).thenReturn('Maria');
      when(() => user.email).thenReturn('maria@gmail.com');
      when(() => user.phoneNumber).thenReturn(null);
      stubAuthenticate(user, isNewUser: false);
      when(() => firebaseAuth.currentUser).thenReturn(user);
      when(() => docSnapshot.data()).thenReturn({'deactivated': true});
      when(() => googleSignIn.signOut()).thenAnswer((_) async {});
      when(() => firebaseAuth.signOut()).thenAnswer((_) async {});

      await expectLater(
        controller.signInWithGoogle(),
        throwsA(isA<DeactivatedAccountException>()),
      );
    });

    test(
      'throws DeactivatedAccountFoundException without signing out, '
      'when deactivated within 90 days',
      () async {
        final user = MockUser();
        when(() => user.uid).thenReturn(uid);
        when(() => user.displayName).thenReturn('Maria');
        when(() => user.email).thenReturn('maria@gmail.com');
        when(() => user.phoneNumber).thenReturn(null);
        stubAuthenticate(user, isNewUser: false);
        when(() => firebaseAuth.currentUser).thenReturn(user);
        when(() => docSnapshot.data()).thenReturn({
          'deactivated': true,
          'deactivatedAt': Timestamp.fromDate(
            DateTime.now().subtract(const Duration(days: 10)),
          ),
        });

        await expectLater(
          controller.signInWithGoogle(),
          throwsA(isA<DeactivatedAccountFoundException>()),
        );

        verifyNever(() => firebaseAuth.signOut());
        verifyNever(() => docRef.set(any(), any()));
      },
    );

    test(
      'still rejects once past the 90-day window',
      () async {
        final user = MockUser();
        when(() => user.uid).thenReturn(uid);
        when(() => user.displayName).thenReturn('Maria');
        when(() => user.email).thenReturn('maria@gmail.com');
        when(() => user.phoneNumber).thenReturn(null);
        stubAuthenticate(user, isNewUser: false);
        when(() => firebaseAuth.currentUser).thenReturn(user);
        when(() => docSnapshot.data()).thenReturn({
          'deactivated': true,
          'deactivatedAt': Timestamp.fromDate(
            DateTime.now().subtract(const Duration(days: 91)),
          ),
        });
        when(() => googleSignIn.signOut()).thenAnswer((_) async {});
        when(() => firebaseAuth.signOut()).thenAnswer((_) async {});

        await expectLater(
          controller.signInWithGoogle(),
          throwsA(isA<DeactivatedAccountException>()),
        );
      },
    );

    test(
      'a canceled account picker is treated as a no-op, not an error',
      () async {
        when(
        () => googleSignIn.initialize(
          serverClientId: any(named: 'serverClientId'),
        ),
      ).thenAnswer((_) async {});
        when(() => googleSignIn.authenticate()).thenThrow(
          const GoogleSignInException(code: GoogleSignInExceptionCode.canceled),
        );

        await controller.signInWithGoogle();

        verifyNever(() => firebaseAuth.signInWithCredential(any()));
      },
    );

    test('rethrows any other GoogleSignInException', () async {
      when(
        () => googleSignIn.initialize(
          serverClientId: any(named: 'serverClientId'),
        ),
      ).thenAnswer((_) async {});
      when(() => googleSignIn.authenticate()).thenThrow(
        const GoogleSignInException(
          code: GoogleSignInExceptionCode.clientConfigurationError,
        ),
      );

      await expectLater(
        controller.signInWithGoogle(),
        throwsA(isA<GoogleSignInException>()),
      );
    });
  });

  group('signOut', () {
    test('signs out of both Google and Firebase', () async {
      when(() => googleSignIn.signOut()).thenAnswer((_) async {});
      when(() => firebaseAuth.signOut()).thenAnswer((_) async {});

      await controller.signOut();

      verify(() => googleSignIn.signOut()).called(1);
      verify(() => firebaseAuth.signOut()).called(1);
    });
  });
}
