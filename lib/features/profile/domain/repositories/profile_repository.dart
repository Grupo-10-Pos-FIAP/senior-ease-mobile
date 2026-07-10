import 'package:senior_ease/features/profile/domain/entities/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile> getProfile();
}
