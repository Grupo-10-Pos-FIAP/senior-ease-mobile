import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:senior_ease/core/app_mode/app_mode_controller.dart';
import 'package:senior_ease/core/auth/auth_controller.dart';
import 'package:senior_ease/core/usecase/usecase.dart';
import 'package:senior_ease/features/settings/domain/usecases/get_settings.dart';

enum AuthFormMode { signIn, signUp }

class LoginController extends ChangeNotifier {
  LoginController(this._authController, this._getSettings, this._appMode);

  final AuthController _authController;
  final GetSettings _getSettings;
  final AppModeController _appMode;

  AuthFormMode mode = AuthFormMode.signIn;
  bool isEmailLoading = false;
  bool isGoogleLoading = false;
  bool pendingReactivation = false;
  String? errorMessage;

  bool get isLoading => isEmailLoading || isGoogleLoading;

  void toggleMode() {
    mode = mode == AuthFormMode.signIn
        ? AuthFormMode.signUp
        : AuthFormMode.signIn;
    errorMessage = null;
    notifyListeners();
  }

  Future<bool> submitEmailPassword(String email, String password) {
    return _submit(
      () {
        return mode == AuthFormMode.signIn
            ? _authController.signInWithEmail(email, password)
            : _authController.signUpWithEmail(email, password);
      },
      onAuthError: _messageForCode,
      setLoading: (value) => isEmailLoading = value,
    );
  }

  Future<bool> submitGoogle() {
    return _submit(
      _authController.signInWithGoogle,
      onAuthError: (_) => 'Não foi possível entrar com o Google.',
      setLoading: (value) => isGoogleLoading = value,
    );
  }

  /// Called after the user confirms the "conta desativada encontrada"
  /// dialog shown when [_submit] sets [pendingReactivation].
  Future<bool> confirmReactivation() {
    return _submit(
      _authController.confirmReactivation,
      onAuthError: (_) => 'Não foi possível reativar sua conta.',
      setLoading: (value) => isEmailLoading = value,
    );
  }

  /// Called when the user declines that same dialog — the account stays
  /// deactivated and signed out.
  Future<void> declineReactivation() async {
    pendingReactivation = false;
    await _authController.signOut();
    notifyListeners();
  }

  Future<bool> _submit(
    Future<void> Function() action, {
    required String Function(String code) onAuthError,
    required void Function(bool value) setLoading,
  }) async {
    setLoading(true);
    errorMessage = null;
    pendingReactivation = false;
    notifyListeners();
    try {
      await action();
      final settings = await _getSettings(const NoParams());
      _appMode.update(
        isSimpleMode: settings.navigationMode == 'Padrão',
        fontScale: settings.fontScale,
        spacingScale: settings.spacingScale,
        contrastLevel: settings.contrastLevelEnum,
        reinforcedVisualFeedback: settings.enhancedVisualFeedback,
        criticalActionConfirmation: settings.criticalActionConfirmation,
      );
      return true;
    } on DeactivatedAccountFoundException {
      pendingReactivation = true;
      return false;
    } on DeactivatedAccountException {
      errorMessage =
          'Esta conta foi desativada e o prazo de 90 dias para reativação '
          'já passou. Ela não está mais disponível.';
      return false;
    } on FirebaseAuthException catch (e) {
      errorMessage = onAuthError(e.code);
      return false;
    } catch (e) {
      debugPrint('Auth error: $e');
      errorMessage = 'Não foi possível concluir. Tente novamente.';
      return false;
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }

  String _messageForCode(String code) {
    switch (code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'E-mail ou senha incorretos.';
      case 'email-already-in-use':
        return 'Este e-mail já possui uma conta. Faça login para continuar.';
      case 'weak-password':
        return 'A senha deve ter pelo menos 6 caracteres.';
      case 'invalid-email':
        return 'E-mail inválido.';
      default:
        return 'Não foi possível concluir. Tente novamente.';
    }
  }
}
