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
}
