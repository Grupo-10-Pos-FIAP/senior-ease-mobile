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
    String? disabilityDescription,
    String? phone,
  }) {
    return UserProfile(
      fullName: fullName ?? this.fullName,
      birthDate: birthDate ?? this.birthDate,
      registrationId: registrationId,
      disabilityDescription:
          disabilityDescription ?? this.disabilityDescription,
      email: email,
      phone: phone ?? this.phone,
    );
  }
}
