import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:senior_ease/core/registration/registration_counter.dart';
import 'package:senior_ease/core/registration/registration_id.dart';
import 'package:senior_ease/features/profile/domain/entities/user_profile.dart';

const defaultCourseId = 'default-course';

const _defaultPreferences = {
  'fontSize': 3,
  'contrast': 1,
  'spacing': 3,
  'interfaceMode': 'simple',
  'reinforcedVisualFeedback': false,
  'confirmCriticalActions': true,
};

/// Garante que `users/{uid}` exista com matrícula sequencial `SE#####`.
///
/// Usuários novos recebem o próximo ID via contador atômico
/// `counters/matriculas`. Documentos legados com `registrationId` inválido
/// (ex.: uid do Firebase) são migrados na mesma lógica.
class EnsureUserDocument {
  EnsureUserDocument(this._firestore);

  final FirebaseFirestore _firestore;

  Future<void> call(String uid, String? email, {String? displayName}) async {
    final userRef = _firestore.collection('users').doc(uid);
    final snapshot = await userRef.get();

    if (snapshot.exists) {
      await _migrateLegacyUserDocument(userRef, snapshot.data() ?? {});
      return;
    }

    await _createUserDocumentWithRegistrationId(uid, email, displayName);
  }

  Map<String, dynamic> _newUserDocument({
    required String uid,
    required String? email,
    required String? displayName,
    required String registrationId,
  }) {
    final name = displayName?.trim();
    return {
      'id': uid,
      'fullName': (name != null && name.isNotEmpty)
          ? name
          : incompleteProfileName,
      'birthDate': '',
      'registrationId': registrationId,
      'disability': null,
      'email': email ?? '',
      'phone': '',
      'enrolledCourseId': defaultCourseId,
      'preferences': _defaultPreferences,
    };
  }

  bool _needsRegistrationId(Object? value) {
    return value is! String || !isFriendlyRegistrationId(value);
  }

  Future<void> _migrateLegacyUserDocument(
    DocumentReference<Map<String, dynamic>> userRef,
    Map<String, dynamic> data,
  ) async {
    final patch = <String, dynamic>{};

    if (data['phone'] == '-') {
      patch['phone'] = '';
    }

    if (data['enrolledCourseId'] == null ||
        (data['enrolledCourseId'] is String &&
            (data['enrolledCourseId'] as String).isEmpty)) {
      patch['enrolledCourseId'] = defaultCourseId;
    }

    final shouldAllocate = _needsRegistrationId(data['registrationId']);

    if (!shouldAllocate && patch.isEmpty) {
      return;
    }

    if (shouldAllocate) {
      await _firestore.runTransaction((transaction) async {
        final latest = await transaction.get(userRef);
        if (!latest.exists) return;

        final latestData = latest.data() ?? {};
        if (!_needsRegistrationId(latestData['registrationId'])) {
          if (patch.isNotEmpty) {
            transaction.update(userRef, patch);
          }
          return;
        }

        final registrationId = await allocateNextRegistrationId(
          _firestore,
          transaction,
        );
        transaction.update(userRef, {...patch, 'registrationId': registrationId});
      });
      return;
    }

    await userRef.update(patch);
  }

  Future<void> _createUserDocumentWithRegistrationId(
    String uid,
    String? email,
    String? displayName,
  ) async {
    final userRef = _firestore.collection('users').doc(uid);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(userRef);
      if (snapshot.exists) return;

      final registrationId = await allocateNextRegistrationId(
        _firestore,
        transaction,
      );
      transaction.set(
        userRef,
        _newUserDocument(
          uid: uid,
          email: email,
          displayName: displayName,
          registrationId: registrationId,
        ),
      );
    });
  }
}
