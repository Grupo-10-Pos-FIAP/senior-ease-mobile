import 'package:flutter/foundation.dart';
import 'package:senior_ease/core/app_mode/app_mode_controller.dart';
import 'package:senior_ease/core/usecase/usecase.dart';
import 'package:senior_ease/features/settings/domain/entities/app_settings.dart';
import 'package:senior_ease/features/settings/domain/usecases/get_settings.dart';
import 'package:senior_ease/features/settings/domain/usecases/save_settings.dart';

class SettingsController extends ChangeNotifier {
  SettingsController(this._getSettings, this._saveSettings, this._appMode);

  final GetSettings _getSettings;
  final SaveSettings _saveSettings;
  final AppModeController _appMode;

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
    _applyDraftLive();
    notifyListeners();
  }

  void selectFontSize(String fontSize) {
    draft = draft.copyWith(fontSize: fontSize);
    _applyDraftLive();
    notifyListeners();
  }

  void selectContrastLevel(String contrastLevel) {
    draft = draft.copyWith(contrastLevel: contrastLevel);
    _applyDraftLive();
    notifyListeners();
  }

  void selectNavigationMode(String navigationMode) {
    draft = draft.copyWith(navigationMode: navigationMode);
    _applyDraftLive();
    notifyListeners();
  }

  void selectSpacing(String spacing) {
    draft = draft.copyWith(spacing: spacing);
    _applyDraftLive();
    notifyListeners();
  }

  void setEnhancedVisualFeedback(bool value) {
    draft = draft.copyWith(enhancedVisualFeedback: value);
    _applyDraftLive();
    notifyListeners();
  }

  void setCriticalActionConfirmation(bool value) {
    draft = draft.copyWith(criticalActionConfirmation: value);
    notifyListeners();
  }

  /// Persists [draft] as the current settings (in the signed-in user's
  /// Firestore document). The app's appearance already matches [draft] (see
  /// [_applyDraftLive]) — this only needs to update what counts as "saved".
  Future<void> save() async {
    await _saveSettings(draft);
    _persisted = draft;
    notifyListeners();
  }

  /// Resets only the on-screen draft, mirroring the old screen's behavior —
  /// it does not touch whatever was last persisted via [save].
  void resetToDefaults() {
    draft = AppSettings.defaults();
    _applyDraftLive();
    notifyListeners();
  }

  /// Pushes [draft] (not [_persisted]) to [AppModeController], so the whole
  /// app reflects each option as soon as it's picked — matching the
  /// screen's own "As mudanças são mostradas na hora" copy. Firestore only
  /// gets [draft] on [save]; until then, an unsaved preview is exactly as
  /// reversible as it looks (a fresh [load] — e.g. next app launch — falls
  /// back to whatever was last actually saved).
  void _applyDraftLive() {
    _appMode.update(
      isSimpleMode: draft.navigationMode == 'Simples',
      fontScale: draft.fontScale,
      spacingScale: draft.spacingScale,
      contrastLevel: draft.contrastLevelEnum,
      reinforcedVisualFeedback: draft.enhancedVisualFeedback,
    );
  }
}
