const String incompleteProfileName = 'Complete seu perfil';

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

  /// Perfil incompleto se o nome ainda é placeholder ou se faltam campos
  /// obrigatórios (alinhado ao web `isProfileIncomplete`).
  bool get isIncomplete {
    final name = fullName.trim();
    if (name.isEmpty || name == incompleteProfileName) return true;
    if (birthDate == null) return true;
    if (registrationId.trim().isEmpty) return true;
    if (email.trim().isEmpty || !email.contains('@')) return true;
    final phoneDigits = phone.replaceAll(RegExp(r'\D'), '');
    if (phoneDigits.length < 10 || phoneDigits.length > 11) return true;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final birth = DateTime(birthDate!.year, birthDate!.month, birthDate!.day);
    if (birth.isAfter(today)) return true;

    var age = today.year - birth.year;
    if (today.month < birth.month ||
        (today.month == birth.month && today.day < birth.day)) {
      age--;
    }
    if (age < 1 || age > 120) return true;

    return false;
  }

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
