import 'package:flutter/material.dart';
import 'package:senior_ease/app/di/injection_container.dart';
import 'package:senior_ease/core/auth/auth_controller.dart';
import 'package:senior_ease/core/routes/route_names.dart';
import 'package:senior_ease/shared/widgets/app_dialog.dart';

Future<void> confirmAndSignOut(BuildContext context) async {
  final confirmed = await AppDialog.warn(
    context,
    title: 'Sair da sua conta?',
    description:
        'Você precisará entrar novamente para acessar suas atividades e preferências salvas.',
    confirmLabel: 'Sim, sair da conta',
    cancelLabel: 'Não, continuar aqui',
  );
  if (!confirmed) return;

  await sl<AuthController>().signOut();
  if (context.mounted) {
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(RouteNames.login, (route) => false);
  }
}
