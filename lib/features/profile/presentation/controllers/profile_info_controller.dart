import 'package:flutter/foundation.dart';
import 'package:senior_ease/core/usecase/usecase.dart';
import 'package:senior_ease/features/profile/domain/entities/user_profile.dart';
import 'package:senior_ease/features/profile/domain/usecases/get_user_profile.dart';
import 'package:senior_ease/features/profile/domain/usecases/update_user_profile.dart';

class ProfileInfoController extends ChangeNotifier {
  ProfileInfoController(this._getUserProfile, this._updateUserProfile);

  final GetUserProfile _getUserProfile;
  final UpdateUserProfile _updateUserProfile;

  bool isLoading = true;
  UserProfile? profile;

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    try {
      profile = await _getUserProfile(const NoParams());
    } catch (e) {
      debugPrint('Erro ao carregar perfil: $e');
      profile = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> save(UserProfile updated) async {
    await _updateUserProfile(updated);
    await load();
  }
}
