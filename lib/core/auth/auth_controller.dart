import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class DeactivatedAccountException implements Exception {}

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
      if (e.code == GoogleSignInExceptionCode.canceled) return;
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

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

  Future<void> deleteAccount() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return;
    await _firestore.collection('users').doc(user.uid).set({
      'deactivated': true,
      'deactivatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    await signOut();
  }

  Future<void> _seedUserDocument(firebase_auth.User user) {
    return _firestore.collection('users').doc(user.uid).set({
      'id': user.uid,
      'fullName': user.displayName ?? '',
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
