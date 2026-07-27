import 'dart:math';

final _registrationCodeRandom = Random();

/// Generates the friendly "SE" + 5-digit code shown to the user as their
/// matrícula — the Firebase UID stays the real identifier; this is
/// display-only, linked to it. Not checked against other users' codes (that
/// would need Firestore read permissions this app doesn't grant), but with
/// 100,000 possible codes a collision is highly unlikely at this app's scale.
String generateRegistrationCode() {
  final digits = List.generate(
    5,
    (_) => _registrationCodeRandom.nextInt(10),
  ).join();
  return 'SE$digits';
}
