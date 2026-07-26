import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_ease/app/di/injection_container.dart';
import 'package:senior_ease/core/routes/route_names.dart';
import 'package:senior_ease/features/auth/presentation/controllers/login_controller.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';
import 'package:senior_ease/shared/widgets/app_button.dart';
import 'package:senior_ease/shared/widgets/app_dialog.dart';
import 'package:senior_ease/shared/widgets/app_subtitle.dart';
import 'package:senior_ease/shared/widgets/app_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginController>(
      create: (_) => sl<LoginController>(),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/assets/background-login.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: const SafeArea(child: _LoginForm()),
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showedDeactivatedNotice = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_showedDeactivatedNotice) return;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args == 'accountDeactivated') {
      _showedDeactivatedNotice = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;
        await AppDialog.success(
          context,
          title: 'Pronto',
          description:
              'Sua conta foi desativada. Você pode reativá-la em até 90 dias '
              'ao criar conta com o mesmo e-mail.',
        );
      });
    }
  }

  Future<void> _onSuccess() async {
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(RouteNames.home);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginController>(
      builder: (context, controller, _) {
        final isSignIn = controller.mode == AuthFormMode.signIn;
        return ListView(
          padding: EdgeInsets.all(AppDesignTokens.spacingLg),
          children: [
            SizedBox(height: AppDesignTokens.spacing2xl),
            Center(
              child: Image.asset(
                'lib/assets/logo-seniorease.png',
                height: 180,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: AppDesignTokens.spacingXl),
            SizedBox(height: AppDesignTokens.spacingSm),
            AppSubtitle(
              text: isSignIn
                  ? 'Acesse sua conta para continuar.'
                  : 'Preencha seus dados para começar.',
            ),
            SizedBox(height: AppDesignTokens.spacingLg),
            AppTextField(
              label: 'E-mail',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              enabled: !controller.isLoading,
            ),
            SizedBox(height: AppDesignTokens.spacingMd),
            AppTextField(
              label: 'Senha',
              controller: _passwordController,
              obscureText: true,
              enabled: !controller.isLoading,
            ),
            if (controller.errorMessage != null) ...[
              SizedBox(height: AppDesignTokens.spacingMd),
              Text(
                controller.errorMessage!,
                style: TextStyle(
                  color: AppDesignTokens.colorFeedbackError,
                  fontSize: AppDesignTokens.fontSizeBody,
                ),
              ),
            ],
            SizedBox(height: AppDesignTokens.spacingLg),
            AppButton(
              label: isSignIn ? 'Acessar minha conta' : 'Criar minha conta',
              loading: controller.isEmailLoading,
              enabled: !controller.isLoading,
              onPressed: () async {
                final success = await controller.submitEmailPassword(
                  _emailController.text.trim(),
                  _passwordController.text,
                );
                if (success) await _onSuccess();
              },
            ),
            SizedBox(height: AppDesignTokens.spacingMd),
            AppButton(
              label: 'Entrar com Google',
              variant: ButtonVariant.outlined,
              loading: controller.isGoogleLoading,
              enabled: !controller.isLoading,
              onPressed: () async {
                final success = await controller.submitGoogle();
                if (success) await _onSuccess();
              },
            ),
            SizedBox(height: AppDesignTokens.spacingLg),
            Center(
              child: TextButton(
                onPressed: controller.isLoading ? null : controller.toggleMode,
                child: Text(
                  isSignIn
                      ? 'Não tem conta? Criar conta'
                      : 'Já tem conta? Entrar',
                  style: TextStyle(color: AppDesignTokens.colorLink),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
