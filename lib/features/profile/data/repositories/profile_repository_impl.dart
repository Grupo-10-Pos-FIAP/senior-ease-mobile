import 'package:senior_ease/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:senior_ease/features/profile/domain/entities/user_profile.dart';
import 'package:senior_ease/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this.remoteDataSource);

  final ProfileRemoteDataSource remoteDataSource;

  @override
  Future<UserProfile> getProfile() {
    return remoteDataSource.getProfile();
  }

  @override
  Future<void> updateProfile(UserProfile profile) {
    return remoteDataSource.updateProfile(profile);
  }
}
