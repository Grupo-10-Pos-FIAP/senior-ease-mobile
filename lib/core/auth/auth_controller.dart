import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Thrown when sign-in succeeds against Firebase Auth but the account's
/// Firestore profile is flagged `deactivated` (via "Excluir conta") — the
/// credential is valid, but the app must refuse the session anyway.
class DeactivatedAccountException implements Exception {}

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

  Future<void> signInWithEmail(String email, String password) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _rejectIfDeactivated(credential.user);
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
      await _rejectIfDeactivated(userCredential.user);
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

  /// Firebase Auth alone can't tell a deactivated account from an active
  /// one — the credential is still perfectly valid — so this is also what
  /// the splash screen calls for an already-persisted session, to catch an
  /// account that got deactivated on another device without ever calling
  /// [signInWithEmail]/[signInWithGoogle] again on this one.
  Future<bool> isCurrentAccountDeactivated() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return false;
    final doc = await _firestore.collection('users').doc(user.uid).get();
    return doc.data()?['deactivated'] == true;
  }

  Future<void> _rejectIfDeactivated(firebase_auth.User? user) async {
    if (user == null) return;
    if (await isCurrentAccountDeactivated()) {
      await signOut();
      throw DeactivatedAccountException();
    }
  }

  /// "Excluir conta" is a soft delete on purpose: it only flags the
  /// Firestore profile as deactivated and signs the device out. It never
  /// calls Firebase Auth's `user.delete()` or removes any Firestore data —
  /// the real account/credential is left completely untouched, so this is
  /// safe to trigger (including by mistake, or during testing) without any
  /// risk of actually destroying an account.
  Future<void> deleteAccount() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return;
    await _firestore.collection('users').doc(user.uid).set({
      'deactivated': true,
      'deactivatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    await signOut();
  }

  /// A brand-new account has no `users/{uid}` document yet, so Dashboard has
  /// no `enrolledCourseId` to look activities up by. Enroll every new user in
  /// the single course this app has today, with the same default shape as
  /// the rest of the seeded users (fullName placeholder, registration is the
  /// Firebase uid, default preferences matching [AppSettings.defaults]).
  Future<void> _seedUserDocument(firebase_auth.User user) {
    return _firestore.collection('users').doc(user.uid).set({
      'id': user.uid,
      'fullName': user.displayName ?? 'Complete seu perfil',
      'email': user.email ?? '',
      'phone': user.phoneNumber ?? '',
      'disability': null,
      'enrolledCourseId': 'default-course',
      'registrationId': user.uid,
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
