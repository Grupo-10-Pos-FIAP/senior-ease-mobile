import 'package:flutter/foundation.dart';

/// App-wide UI mode, driven by the "Modo de navegação" setting. Any feature
/// can listen to this (via GetIt, since it's a long-lived singleton) to hide
/// advanced UI in "Simples" mode — this is the one cross-cutting concern
/// allowed to be shared across `features/*` without a direct feature-to-
/// feature import, since it lives in `core/`.
class AppModeController extends ChangeNotifier {
  bool isSimpleMode = false;

  void update({required bool isSimpleMode}) {
    if (this.isSimpleMode == isSimpleMode) return;
    this.isSimpleMode = isSimpleMode;
    notifyListeners();
  }
}
