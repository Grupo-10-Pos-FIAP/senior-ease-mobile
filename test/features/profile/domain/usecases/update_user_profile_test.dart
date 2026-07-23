import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:senior_ease/features/profile/domain/entities/user_profile.dart';
import 'package:senior_ease/features/profile/domain/repositories/profile_repository.dart';
import 'package:senior_ease/features/profile/domain/usecases/update_user_profile.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late MockProfileRepository repository;
  late UpdateUserProfile usecase;

  setUp(() {
    repository = MockProfileRepository();
    usecase = UpdateUserProfile(repository);
  });

  test('delegates to ProfileRepository.updateProfile', () async {
    const profile = UserProfile(
      fullName: 'Maria Silva',
      birthDate: null,
      registrationId: 'uid-1',
      disabilityDescription: null,
      email: 'maria@gmail.com',
      phone: '11999999999',
    );
    when(() => repository.updateProfile(profile)).thenAnswer((_) async {});

    await usecase(profile);

    verify(() => repository.updateProfile(profile)).called(1);
  });
}
