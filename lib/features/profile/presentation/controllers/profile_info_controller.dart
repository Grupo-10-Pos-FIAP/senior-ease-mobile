import 'package:flutter/foundation.dart';
import 'package:senior_ease/core/usecase/usecase.dart';
import 'package:senior_ease/features/profile/domain/entities/user_profile.dart';
import 'package:senior_ease/features/profile/domain/usecases/get_user_profile.dart';

class ProfileInfoController extends ChangeNotifier {
  ProfileInfoController(this._getUserProfile);

  final GetUserProfile _getUserProfile;

  bool isLoading = true;
  UserProfile? profile;

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    profile = await _getUserProfile(const NoParams());
    isLoading = false;
    notifyListeners();
  }
}
