import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:senior_ease/core/usecase/usecase.dart';
import 'package:senior_ease/features/profile/domain/entities/user_profile.dart';
import 'package:senior_ease/features/profile/domain/repositories/profile_repository.dart';
import 'package:senior_ease/features/profile/domain/usecases/get_user_profile.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late MockProfileRepository repository;
  late GetUserProfile usecase;

  setUp(() {
    repository = MockProfileRepository();
    usecase = GetUserProfile(repository);
  });

  test('delegates to ProfileRepository.getProfile', () async {
    const profile = UserProfile(
      fullName: 'Maria',
      birthDate: null,
      registrationId: 'uid-1',
      disabilityDescription: null,
      email: 'maria@gmail.com',
      phone: '',
    );
    when(() => repository.getProfile()).thenAnswer((_) async => profile);

    final result = await usecase(const NoParams());

    expect(result, profile);
    verify(() => repository.getProfile()).called(1);
  });
}
