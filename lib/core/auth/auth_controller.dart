import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:senior_ease/core/auth/ensure_user_document.dart';

class DeactivatedAccountException implements Exception {}

class DeactivatedAccountFoundException implements Exception {}

const _reactivationWindow = Duration(days: 90);

class AuthController extends ChangeNotifier {
  AuthController(
    this._firebaseAuth,
    this._googleSignIn,
    this._firestore, [
    EnsureUserDocument? ensureUserDocument,
  ]) : _ensureUserDocument =
           ensureUserDocument ?? EnsureUserDocument(_firestore) {
    _firebaseAuth.authStateChanges().listen((_) => notifyListeners());
  }

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;
  final EnsureUserDocument _ensureUserDocument;

  bool _googleSignInInitialized = false;

  firebase_auth.User? get currentUser => _firebaseAuth.currentUser;

  Stream<firebase_auth.User?> get authStateChanges =>
      _firebaseAuth.authStateChanges();

  Future<void> signInWithEmail(String email, String password) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _prepareUserDocument(credential.user);
    await _checkDeactivated(credential.user);
  }

  Future<void> signUpWithEmail(String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _prepareUserDocument(credential.user);
    } on firebase_auth.FirebaseAuthException catch (emailInUse) {
      if (emailInUse.code != 'email-already-in-use') rethrow;
      final firebase_auth.UserCredential credential;
      try {
        credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } catch (_) {
        throw emailInUse;
      }
      await _prepareUserDocument(credential.user);
      await _checkDeactivated(credential.user);
    }
  }

  Future<void> signInWithGoogle() async {
    if (!_googleSignInInitialized) {
      await _googleSignIn.initialize(
        serverClientId: dotenv.env['GOOGLE_SERVER_CLIENT_ID'],
      );
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
      await _prepareUserDocument(userCredential.user);
      await _checkDeactivated(userCredential.user);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return;
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

  /// Garante doc + matrícula sequencial para a sessão já autenticada (ex.: splash).
  Future<void> ensureCurrentUserDocument() async {
    await _prepareUserDocument(_firebaseAuth.currentUser);
  }

  Future<bool> isCurrentAccountDeactivated() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return false;
    final doc = await _firestore.collection('users').doc(user.uid).get();
    return doc.data()?['deactivated'] == true;
  }

  Future<void> confirmReactivation() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return;
    await _firestore.collection('users').doc(user.uid).set({
      'deactivated': false,
      'deactivatedAt': FieldValue.delete(),
    }, SetOptions(merge: true));
  }

  Future<void> _checkDeactivated(firebase_auth.User? user) async {
    if (user == null) return;
    final data = (await _firestore.collection('users').doc(user.uid).get())
        .data();
    if (data?['deactivated'] != true) return;

    final deactivatedAt = data?['deactivatedAt'];
    final withinWindow =
        deactivatedAt is Timestamp &&
        DateTime.now().difference(deactivatedAt.toDate()) <=
            _reactivationWindow;
    if (withinWindow) {
      throw DeactivatedAccountFoundException();
    }

    await signOut();
    throw DeactivatedAccountException();
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

  Future<void> _prepareUserDocument(firebase_auth.User? user) async {
    if (user == null) return;
    try {
      await _ensureUserDocument(
        user.uid,
        user.email,
        displayName: user.displayName,
      );
    } catch (error, stackTrace) {
      debugPrint(
        '[SeniorEase] Falha ao preparar dados do usuário no Firestore: $error',
      );
      debugPrint('$stackTrace');
    }
  }
}
