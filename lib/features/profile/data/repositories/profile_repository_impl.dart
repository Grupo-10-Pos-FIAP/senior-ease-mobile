import 'package:senior_ease/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:senior_ease/features/profile/domain/entities/user_profile.dart';
import 'package:senior_ease/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this.localDataSource);

  final ProfileLocalDataSource localDataSource;

  @override
  Future<UserProfile> getProfile() {
    return localDataSource.getProfile();
  }
}
