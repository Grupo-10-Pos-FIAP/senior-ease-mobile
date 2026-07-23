import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:senior_ease/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:senior_ease/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:senior_ease/features/profile/domain/entities/user_profile.dart';

class MockProfileRemoteDataSource extends Mock
    implements ProfileRemoteDataSource {}

void main() {
  late MockProfileRemoteDataSource dataSource;
  late ProfileRepositoryImpl repository;

  const profile = UserProfile(
    fullName: 'Maria',
    birthDate: null,
    registrationId: 'uid-1',
    disabilityDescription: null,
    email: 'maria@gmail.com',
    phone: '',
  );

  setUp(() {
    dataSource = MockProfileRemoteDataSource();
    repository = ProfileRepositoryImpl(dataSource);
  });

  test('getProfile delegates to ProfileRemoteDataSource.getProfile', () async {
    when(() => dataSource.getProfile()).thenAnswer((_) async => profile);

    final result = await repository.getProfile();

    expect(result, profile);
    verify(() => dataSource.getProfile()).called(1);
  });

  test(
    'updateProfile delegates to ProfileRemoteDataSource.updateProfile',
    () async {
      when(() => dataSource.updateProfile(profile)).thenAnswer((_) async {});

      await repository.updateProfile(profile);

      verify(() => dataSource.updateProfile(profile)).called(1);
    },
  );
}
