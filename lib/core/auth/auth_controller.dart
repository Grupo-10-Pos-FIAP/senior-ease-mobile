import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// App-wide session state, driven by Firebase Auth. Any feature can depend
/// on this (via GetIt) to read the current user id for scoping Firestore
/// reads/writes — this is the one cross-cutting concern allowed to be
/// shared across `features/*`, same rationale as [AppModeController].
class AuthController extends ChangeNotifier {
  AuthController(this._firebaseAuth, this._googleSignIn, this._firestore) {
    _firebaseAuth.authStateChanges().listen((_) => notifyListeners());
  }

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;

  bool _googleSignInInitialized = false;

  firebase_auth.User? get currentUser => _firebaseAuth.currentUser;

  Stream<firebase_auth.User?> get authStateChanges =>
      _firebaseAuth.authStateChanges();

  Future<void> signInWithEmail(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signUpWithEmail(String email, String password) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _seedUserDocument(credential.user!);
  }

  Future<void> signInWithGoogle() async {
    if (!_googleSignInInitialized) {
      await _googleSignIn.initialize();
      _googleSignInInitialized = true;
    }
    try {
      final account = await _googleSignIn.authenticate();
      final credential = firebase_auth.GoogleAuthProvider.credential(
        idToken: account.authentication.idToken,
      );
      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        await _seedUserDocument(userCredential.user!);
      }
    } on GoogleSignInException catch (e) {
      // The user backed out of the Google account picker — not an error.
      if (e.code == GoogleSignInExceptionCode.canceled) return;
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

  /// A brand-new account has no `users/{uid}` document yet, so Dashboard has
  /// no `enrolledCourseId` to look activities up by. Enroll every new user in
  /// the single course this app has today, with the same default shape as
  /// the rest of the seeded users (fullName placeholder, "-" registration,
  /// default preferences matching [AppSettings.defaults]).
  Future<void> _seedUserDocument(firebase_auth.User user) {
    return _firestore.collection('users').doc(user.uid).set({
      'id': user.uid,
      'fullName': user.displayName ?? 'Complete seu perfil',
      'email': user.email ?? '',
      'phone': user.phoneNumber ?? '',
      'disability': null,
      'enrolledCourseId': 'default-course',
      'registrationId': '-',
      'preferences': {
        'fontSize': 3,
        'contrast': 1,
        'spacing': 3,
        'interfaceMode': 'simple',
        'reinforcedVisualFeedback': false,
        'confirmCriticalActions': true,
      },
    }, SetOptions(merge: true));
  }
}
