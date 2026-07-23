import 'package:flutter_test/flutter_test.dart';
import 'package:senior_ease/features/profile/domain/entities/user_profile.dart';

void main() {
  const profile = UserProfile(
    fullName: 'Maria',
    birthDate: null,
    registrationId: 'uid-1',
    disabilityDescription: null,
    email: 'maria@gmail.com',
    phone: '',
  );

  test('copyWith overrides only the given fields', () {
    final birthDate = DateTime(1960, 5, 20);

    final updated = profile.copyWith(
      fullName: 'Maria Silva',
      birthDate: birthDate,
      disabilityDescription: 'Baixa visão',
      phone: '11999999999',
    );

    expect(updated.fullName, 'Maria Silva');
    expect(updated.birthDate, birthDate);
    expect(updated.disabilityDescription, 'Baixa visão');
    expect(updated.phone, '11999999999');
    // registrationId and email are never overridable via copyWith.
    expect(updated.registrationId, 'uid-1');
    expect(updated.email, 'maria@gmail.com');
  });

  test('copyWith with no arguments returns equivalent values', () {
    final updated = profile.copyWith();

    expect(updated.fullName, profile.fullName);
    expect(updated.birthDate, profile.birthDate);
    expect(updated.disabilityDescription, profile.disabilityDescription);
    expect(updated.phone, profile.phone);
    expect(updated.registrationId, profile.registrationId);
    expect(updated.email, profile.email);
  });
}
