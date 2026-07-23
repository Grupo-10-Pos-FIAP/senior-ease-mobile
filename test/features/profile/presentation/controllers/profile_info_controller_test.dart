import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:senior_ease/core/usecase/usecase.dart';
import 'package:senior_ease/features/profile/domain/entities/user_profile.dart';
import 'package:senior_ease/features/profile/domain/usecases/get_user_profile.dart';
import 'package:senior_ease/features/profile/domain/usecases/update_user_profile.dart';
import 'package:senior_ease/features/profile/presentation/controllers/profile_info_controller.dart';

class MockGetUserProfile extends Mock implements GetUserProfile {}

class MockUpdateUserProfile extends Mock implements UpdateUserProfile {}

void main() {
  late MockGetUserProfile getUserProfile;
  late MockUpdateUserProfile updateUserProfile;
  late ProfileInfoController controller;

  const profile = UserProfile(
    fullName: 'Maria',
    birthDate: null,
    registrationId: 'uid-1',
    disabilityDescription: null,
    email: 'maria@gmail.com',
    phone: '',
  );
  const updatedProfile = UserProfile(
    fullName: 'Maria Silva',
    birthDate: null,
    registrationId: 'uid-1',
    disabilityDescription: null,
    email: 'maria@gmail.com',
    phone: '11999999999',
  );

  setUp(() {
    getUserProfile = MockGetUserProfile();
    updateUserProfile = MockUpdateUserProfile();
    controller = ProfileInfoController(getUserProfile, updateUserProfile);
  });

  test('load() fetches the profile and stops loading', () async {
    when(
      () => getUserProfile(const NoParams()),
    ).thenAnswer((_) async => profile);

    expect(controller.isLoading, isTrue);
    await controller.load();

    expect(controller.isLoading, isFalse);
    expect(controller.profile, profile);
  });

  test('save() persists the update then reloads the profile', () async {
    when(() => updateUserProfile(updatedProfile)).thenAnswer((_) async {});
    when(
      () => getUserProfile(const NoParams()),
    ).thenAnswer((_) async => updatedProfile);

    await controller.save(updatedProfile);

    verify(() => updateUserProfile(updatedProfile)).called(1);
    verify(() => getUserProfile(const NoParams())).called(1);
    expect(controller.profile, updatedProfile);
    expect(controller.isLoading, isFalse);
  });

  test('save() propagates a failure from the update usecase', () async {
    when(
      () => updateUserProfile(updatedProfile),
    ).thenThrow(Exception('write denied'));

    await expectLater(
      controller.save(updatedProfile),
      throwsA(isA<Exception>()),
    );

    // A failed save must not silently reload (and thus mask) stale data.
    verifyNever(() => getUserProfile(const NoParams()));
  });
}
