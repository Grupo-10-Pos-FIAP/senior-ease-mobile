import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:senior_ease/app/di/injection_container.dart';
import 'package:senior_ease/core/routes/route_names.dart';
import 'package:senior_ease/features/auth/presentation/controllers/login_controller.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';
import 'package:senior_ease/shared/widgets/app_button.dart';
import 'package:senior_ease/shared/widgets/app_subtitle.dart';
import 'package:senior_ease/shared/widgets/app_text_field.dart';
import 'package:senior_ease/shared/widgets/app_title.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginController>(
      create: (_) => sl<LoginController>(),
      child: const Scaffold(
        backgroundColor: AppDesignTokens.colorGray100,
        body: SafeArea(child: _LoginForm()),
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
          padding: const EdgeInsets.all(AppDesignTokens.spacingLg),
          children: [
            const SizedBox(height: AppDesignTokens.spacing2xl),
            Center(
              child: SvgPicture.asset('lib/assets/logo.svg', height: 64),
            ),
            const SizedBox(height: AppDesignTokens.spacingXl),
            AppTitle(text: isSignIn ? 'Entrar' : 'Criar conta'),
            const SizedBox(height: AppDesignTokens.spacingSm),
            AppSubtitle(
              text: isSignIn
                  ? 'Acesse sua conta para continuar.'
                  : 'Preencha seus dados para começar.',
            ),
            const SizedBox(height: AppDesignTokens.spacingLg),
            AppTextField(
              label: 'E-mail',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              enabled: !controller.isLoading,
            ),
            const SizedBox(height: AppDesignTokens.spacingMd),
            AppTextField(
              label: 'Senha',
              controller: _passwordController,
              obscureText: true,
              enabled: !controller.isLoading,
            ),
            if (controller.errorMessage != null) ...[
              const SizedBox(height: AppDesignTokens.spacingMd),
              Text(
                controller.errorMessage!,
                style: TextStyle(
                  color: AppDesignTokens.colorFeedbackError,
                  fontSize: AppDesignTokens.fontSizeBody,
                ),
              ),
            ],
            const SizedBox(height: AppDesignTokens.spacingLg),
            AppButton(
              label: isSignIn ? 'Entrar' : 'Criar conta',
              loading: controller.isLoading,
              onPressed: () async {
                final success = await controller.submitEmailPassword(
                  _emailController.text.trim(),
                  _passwordController.text,
                );
                if (success) await _onSuccess();
              },
            ),
            const SizedBox(height: AppDesignTokens.spacingMd),
            AppButton(
              label: 'Continuar com o Google',
              variant: ButtonVariant.outlined,
              loading: controller.isLoading,
              onPressed: () async {
                final success = await controller.submitGoogle();
                if (success) await _onSuccess();
              },
            ),
            const SizedBox(height: AppDesignTokens.spacingLg),
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
