class UserProfile {
  const UserProfile({
    required this.fullName,
    required this.birthDate,
    required this.registrationId,
    required this.registrationCode,
    required this.disabilityDescription,
    required this.email,
    required this.phone,
  });

  final String fullName;
  final DateTime? birthDate;
  /// Firebase UID — the real, immutable identifier. Never shown to the user.
  final String registrationId;
  /// Friendly "SE" + 5-digit code shown to the user as their "matrícula",
  /// generated once at account creation and linked to [registrationId].
  final String registrationCode;
  final String? disabilityDescription;
  final String email;
  final String phone;

  UserProfile copyWith({
    String? fullName,
    DateTime? birthDate,
    String? registrationId,
    String? registrationCode,
    String? disabilityDescription,
    String? email,
    String? phone,
    bool clearDisability = false,
  }) {
    return UserProfile(
      fullName: fullName ?? this.fullName,
      birthDate: birthDate ?? this.birthDate,
      registrationId: registrationId ?? this.registrationId,
      registrationCode: registrationCode ?? this.registrationCode,
      disabilityDescription: clearDisability
          ? null
          : (disabilityDescription ?? this.disabilityDescription),
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }
}
