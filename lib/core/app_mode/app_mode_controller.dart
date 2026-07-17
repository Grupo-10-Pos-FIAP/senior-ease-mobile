import 'package:flutter/foundation.dart';
import 'package:senior_ease/core/app_mode/contrast_level.dart';

/// App-wide personalization state, derived from the Settings feature. Any
/// feature can listen to this (via GetIt, since it's a long-lived singleton)
/// to react to the user's choices — this is the one cross-cutting concern
/// allowed to be shared across `features/*` without a direct feature-to-
/// feature import, since it lives in `core/`. Settings pushes its derived
/// primitives here (not the `AppSettings` entity itself, to avoid a
/// core -> feature import).
class AppModeController extends ChangeNotifier {
  bool isSimpleMode = false;
  double fontScale = 1.0;
  double spacingScale = 1.0;
  ContrastLevel contrastLevel = ContrastLevel.padrao;
  bool reinforcedVisualFeedback = false;

  void update({
    required bool isSimpleMode,
    required double fontScale,
    required double spacingScale,
    required ContrastLevel contrastLevel,
    required bool reinforcedVisualFeedback,
  }) {
    if (this.isSimpleMode == isSimpleMode &&
        this.fontScale == fontScale &&
        this.spacingScale == spacingScale &&
        this.contrastLevel == contrastLevel &&
        this.reinforcedVisualFeedback == reinforcedVisualFeedback) {
      return;
    }
    this.isSimpleMode = isSimpleMode;
    this.fontScale = fontScale;
    this.spacingScale = spacingScale;
    this.contrastLevel = contrastLevel;
    this.reinforcedVisualFeedback = reinforcedVisualFeedback;
    notifyListeners();
  }
}
