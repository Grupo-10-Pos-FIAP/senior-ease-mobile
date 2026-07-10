import 'package:flutter/foundation.dart';
import 'package:senior_ease/core/usecase/usecase.dart';
import 'package:senior_ease/features/settings/domain/entities/app_settings.dart';
import 'package:senior_ease/features/settings/domain/usecases/get_settings.dart';
import 'package:senior_ease/features/settings/domain/usecases/save_settings.dart';

class SettingsController extends ChangeNotifier {
  SettingsController(this._getSettings, this._saveSettings);

  final GetSettings _getSettings;
  final SaveSettings _saveSettings;

  bool isLoading = true;
  AppSettings draft = AppSettings.defaults();

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    draft = await _getSettings(const NoParams());
    isLoading = false;
    notifyListeners();
  }

  void selectFontSize(String fontSize) {
    draft = draft.copyWith(fontSize: fontSize);
    notifyListeners();
  }

  void setHighContrast(bool value) {
    draft = draft.copyWith(highContrast: value);
    notifyListeners();
  }

  /// Persists [draft] as the current settings for the rest of the session
  /// (in-memory only today; see the local data source for why).
  Future<void> save() async {
    await _saveSettings(draft);
  }

  /// Resets only the on-screen draft, mirroring the old screen's behavior —
  /// it does not touch whatever was last persisted via [save].
  void resetToDefaults() {
    draft = AppSettings.defaults();
    notifyListeners();
  }
}
