import 'package:senior_ease/features/profile/domain/entities/user_profile.dart';

abstract class ProfileLocalDataSource {
  Future<UserProfile> getProfile();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  static const UserProfile _mockProfile = UserProfile(
    fullName: 'Antônio José Maria da Silva',
    age: '67 anos',
    registration: '2026067',
    disabilityDescription: 'Baixa visão',
    email: 'antoniojose@seniorease.com.br',
    phone: '(85) 9767-6767',
  );

  @override
  Future<UserProfile> getProfile() async {
    return _mockProfile;
  }
}
