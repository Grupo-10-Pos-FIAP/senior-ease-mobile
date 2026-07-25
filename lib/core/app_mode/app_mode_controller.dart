import 'package:flutter/foundation.dart';
import 'package:senior_ease/core/app_mode/contrast_level.dart';

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
