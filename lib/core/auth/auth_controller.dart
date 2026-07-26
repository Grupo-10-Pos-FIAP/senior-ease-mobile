import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

class DeactivatedAccountException implements Exception {}

// Matches the "90 dias" window promised in the deactivation and login copy.
const _reactivationWindow = Duration(days: 90);

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

  /// Plain login: a deactivated account is always rejected here. Reactivation
  /// only happens by signing up again (see [signUpWithEmail]/[signInWithGoogle]).
  Future<void> signInWithEmail(String email, String password) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _rejectIfDeactivated(credential.user, allowReactivation: false);
  }

  /// If [email] belongs to a deactivated account, this reactivates it
  /// (within [_reactivationWindow]) instead of creating a duplicate — Firebase
  /// Auth won't let us recreate the account, so we sign back in with the
  /// given credentials instead.
  Future<void> signUpWithEmail(String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _seedUserDocument(credential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code != 'email-already-in-use') rethrow;
      await _reactivateOrRethrow(email, password, e);
    }
  }

  /// Only a deactivated account gets reactivated here; an active account
  /// with matching credentials still surfaces the original [emailInUse]
  /// error instead of silently logging the caller in via the sign-up form.
  Future<void> _reactivateOrRethrow(
    String email,
    String password,
    firebase_auth.FirebaseAuthException emailInUse,
  ) async {
    final firebase_auth.UserCredential credential;
    try {
      credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (_) {
      throw emailInUse;
    }
    if (!(await isCurrentAccountDeactivated())) {
      await signOut();
      throw emailInUse;
    }
    await _rejectIfDeactivated(credential.user, allowReactivation: true);
  }

  /// [isSignUp] controls whether a deactivated account gets reactivated
  /// (sign-up flow) or rejected outright (plain login) — see [signInWithEmail].
  Future<void> signInWithGoogle({bool isSignUp = false}) async {
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
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        await _seedUserDocument(userCredential.user!);
      }
      await _rejectIfDeactivated(
        userCredential.user,
        allowReactivation: isSignUp,
      );
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

  Future<void> _rejectIfDeactivated(
    firebase_auth.User? user, {
    required bool allowReactivation,
  }) async {
    if (user == null) return;
    final ref = _firestore.collection('users').doc(user.uid);
    final data = (await ref.get()).data();
    if (data?['deactivated'] != true) return;

    final deactivatedAt = data?['deactivatedAt'];
    final withinWindow =
        deactivatedAt is Timestamp &&
        DateTime.now().difference(deactivatedAt.toDate()) <=
            _reactivationWindow;
    if (allowReactivation && withinWindow) {
      await ref.set({
        'deactivated': false,
        'deactivatedAt': FieldValue.delete(),
      }, SetOptions(merge: true));
      return;
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
