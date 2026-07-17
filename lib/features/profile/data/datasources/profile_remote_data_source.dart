import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:senior_ease/features/profile/domain/entities/user_profile.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfile> getProfile();
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
      birthDate: birthDateRaw != null
          ? DateTime.tryParse(birthDateRaw)
          : null,
      registrationId: data['registrationId'] as String? ?? '',
      disabilityDescription: data['disability'] as String?,
      email: data['email'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
    );
  }
}
