import 'package:flutter/material.dart';
import 'package:senior_ease/app/di/injection_container.dart';
import 'package:senior_ease/core/auth/auth_controller.dart';
import 'package:senior_ease/core/routes/route_names.dart';
import 'package:senior_ease/shared/widgets/app_dialog.dart';

/// Confirms with the user (skipped in Simple mode), then signs out and
/// clears the navigation stack back to the login screen. Shared by every
/// screen's app bar "Sair" action.
Future<void> confirmAndSignOut(BuildContext context) async {
  final confirmed = await AppDialog.confirm(
    context,
    title: 'Tem certeza que deseja sair da conta?',
    description: 'Você precisará entrar novamente para acessar o SeniorEase.',
    confirmLabel: 'Sair',
  );
  if (!confirmed) return;

  await sl<AuthController>().signOut();
  if (context.mounted) {
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(RouteNames.login, (route) => false);
  }
}
