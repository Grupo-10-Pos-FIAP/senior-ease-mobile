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
  AppSettings _persisted = AppSettings.defaults();

  bool get hasUnsavedChanges => draft != _persisted;

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    _persisted = await _getSettings(const NoParams());
    draft = _persisted;
    isLoading = false;
    notifyListeners();
  }

  void selectFontSize(String fontSize) {
    draft = draft.copyWith(fontSize: fontSize);
    notifyListeners();
  }

  void selectContrastLevel(String contrastLevel) {
    draft = draft.copyWith(contrastLevel: contrastLevel);
    notifyListeners();
  }

  void selectNavigationMode(String navigationMode) {
    draft = draft.copyWith(navigationMode: navigationMode);
    notifyListeners();
  }

  void selectSpacing(String spacing) {
    draft = draft.copyWith(spacing: spacing);
    notifyListeners();
  }

  void setEnhancedVisualFeedback(bool value) {
    draft = draft.copyWith(enhancedVisualFeedback: value);
    notifyListeners();
  }

  void setCriticalActionConfirmation(bool value) {
    draft = draft.copyWith(criticalActionConfirmation: value);
    notifyListeners();
  }

  /// Persists [draft] as the current settings for the rest of the session
  /// (in-memory only today; see the local data source for why).
  Future<void> save() async {
    await _saveSettings(draft);
    _persisted = draft;
    notifyListeners();
  }

  /// Resets only the on-screen draft, mirroring the old screen's behavior —
  /// it does not touch whatever was last persisted via [save].
  void resetToDefaults() {
    draft = AppSettings.defaults();
    notifyListeners();
  }
}
