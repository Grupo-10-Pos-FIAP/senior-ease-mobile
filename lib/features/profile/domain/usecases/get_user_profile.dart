import 'package:senior_ease/core/usecase/usecase.dart';
import 'package:senior_ease/features/profile/domain/entities/user_profile.dart';
import 'package:senior_ease/features/profile/domain/repositories/profile_repository.dart';

class GetUserProfile implements UseCase<UserProfile, NoParams> {
  const GetUserProfile(this.repository);

  final ProfileRepository repository;

  @override
  Future<UserProfile> call(NoParams params) {
    return repository.getProfile();
  }
}
