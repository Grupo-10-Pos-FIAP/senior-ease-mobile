class UserProfile {
  const UserProfile({
    required this.fullName,
    required this.birthDate,
    required this.registrationId,
    required this.disabilityDescription,
    required this.email,
    required this.phone,
  });

  final String fullName;
  final DateTime? birthDate;
  final String registrationId;
  final String? disabilityDescription;
  final String email;
  final String phone;

  UserProfile copyWith({
    String? fullName,
    DateTime? birthDate,
    String? registrationId,
    String? disabilityDescription,
    String? email,
    String? phone,
    bool clearDisability = false,
  }) {
    return UserProfile(
      fullName: fullName ?? this.fullName,
      birthDate: birthDate ?? this.birthDate,
      registrationId: registrationId ?? this.registrationId,
      disabilityDescription: clearDisability
          ? null
          : (disabilityDescription ?? this.disabilityDescription),
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }
}
