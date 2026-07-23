import 'package:senior_ease/core/usecase/usecase.dart';
import 'package:senior_ease/features/profile/domain/entities/user_profile.dart';
import 'package:senior_ease/features/profile/domain/repositories/profile_repository.dart';

class UpdateUserProfile implements UseCase<void, UserProfile> {
  const UpdateUserProfile(this.repository);

  final ProfileRepository repository;

  @override
  Future<void> call(UserProfile profile) {
    return repository.updateProfile(profile);
  }
}
