import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:senior_ease/features/profile/domain/entities/user_profile.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfile> getProfile();

  Future<void> updateProfile(UserProfile profile);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImpl(this._firestore, this._firebaseAuth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  @override
  Future<UserProfile> getProfile() async {
    final uid = _firebaseAuth.currentUser!.uid;
    final doc = await _firestore.collection('users').doc(uid).get();
    final data = doc.data() ?? <String, dynamic>{};
    final birthDateRaw = data['birthDate'] as String?;

    return UserProfile(
      fullName: data['fullName'] as String? ?? '',
      birthDate: birthDateRaw != null ? DateTime.tryParse(birthDateRaw) : null,
      // "Matrícula" is the Firebase uid itself — read from auth, not the
      // Firestore field, so it's always correct even for accounts created
      // before registrationId was seeded (or seeded with a placeholder).
      registrationId: uid,
      disabilityDescription: data['disability'] as String?,
      email: data['email'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
    );
  }

  @override
  Future<void> updateProfile(UserProfile profile) {
    final uid = _firebaseAuth.currentUser!.uid;
    // registrationId (the uid) and email are read from Auth, never written
    // back here — this only touches the fields the edit form can change.
    return _firestore.collection('users').doc(uid).set({
      'fullName': profile.fullName,
      'birthDate': profile.birthDate?.toIso8601String(),
      'disability': profile.disabilityDescription,
      'phone': profile.phone,
    }, SetOptions(merge: true));
  }
}
