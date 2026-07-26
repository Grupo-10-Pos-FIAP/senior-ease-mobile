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
    draft = _normalizeForMode(_persisted);
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
    draft = _normalizeForMode(draft.copyWith(navigationMode: navigationMode));
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
    _applyDraftLive();
    notifyListeners();
  }

  Future<void> save() async {
    await _saveSettings(draft);
    _persisted = draft;
    notifyListeners();
  }

  void resetToDefaults() {
    draft = AppSettings.defaults();
    _applyDraftLive();
    notifyListeners();
  }

  void _applyDraftLive() {
    _appMode.update(
      isSimpleMode: draft.navigationMode == 'Básico',
      fontScale: draft.fontScale,
      spacingScale: draft.spacingScale,
      contrastLevel: draft.contrastLevelEnum,
      reinforcedVisualFeedback: draft.enhancedVisualFeedback,
      criticalActionConfirmation: draft.criticalActionConfirmation,
    );
  }

  AppSettings _normalizeForMode(AppSettings settings) {
    if (settings.navigationMode == 'Básico') return settings;
    return settings.copyWith(
      enhancedVisualFeedback: false,
      criticalActionConfirmation: false,
    );
  }
}
