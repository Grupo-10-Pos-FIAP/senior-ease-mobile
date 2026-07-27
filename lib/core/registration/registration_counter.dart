import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:senior_ease/core/registration/registration_id.dart';

int readCurrentSequence(Map<String, dynamic>? data) {
  final current = data?['current'];
  if (current is int && current >= 0) {
    return current;
  }
  return 0;
}

/// Reserva o próximo número de matrícula dentro de uma transação Firestore.
/// Garante unicidade mesmo com cadastros simultâneos.
Future<String> allocateNextRegistrationId(
  FirebaseFirestore firestore,
  Transaction transaction,
) async {
  final counterRef = firestore
      .collection(registrationCounterCollection)
      .doc(registrationCounterDoc);
  final snapshot = await transaction.get(counterRef);
  final next = readCurrentSequence(snapshot.data()) + 1;

  transaction.set(counterRef, {'current': next}, SetOptions(merge: true));

  return formatRegistrationId(next);
}
