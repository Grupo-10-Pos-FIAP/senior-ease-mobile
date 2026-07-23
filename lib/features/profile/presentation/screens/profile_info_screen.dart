import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_ease/app/di/injection_container.dart';
import 'package:senior_ease/core/auth/auth_controller.dart';
import 'package:senior_ease/core/routes/route_names.dart';
import 'package:senior_ease/features/profile/domain/entities/user_profile.dart';
import 'package:senior_ease/features/profile/presentation/controllers/profile_info_controller.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';
import 'package:senior_ease/shared/widgets/app_button.dart';
import 'package:senior_ease/shared/widgets/app_dialog.dart';
import 'package:senior_ease/shared/widgets/app_warning_banner.dart';
import 'package:senior_ease/shared/widgets/info_row.dart';

class ProfileInfoScreen extends StatelessWidget {
  const ProfileInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileInfoController>(
      builder: (context, controller, _) {
        final profile = controller.profile;
        if (controller.isLoading || profile == null) {
          return const SizedBox.shrink();
        }
        return ListView(
          padding: EdgeInsets.symmetric(
            horizontal: AppDesignTokens.spacingMd,
            vertical: AppDesignTokens.spacingLg,
          ),
          children: [
            if (_isIncomplete(profile)) ...[
              const AppWarningBanner(
                title: 'Complete seu perfil',
                message:
                    'Algumas informações suas ainda estão faltando. Toque '
                    'em "Editar informações" abaixo para preenchê-las.',
              ),
              SizedBox(height: AppDesignTokens.spacingLg),
            ],
            InfoRow(
              label: 'Nome completo',
              value: _nameOrNotInformed(profile.fullName),
            ),
            InfoRow(label: 'Idade', value: _ageLabel(profile.birthDate)),
            InfoRow(
              label: 'Matrícula',
              value: _orNotInformed(profile.registrationId),
            ),
            InfoRow(
              label: 'Possui alguma deficiência?',
              value: _orNotInformed(profile.disabilityDescription ?? ''),
            ),
            InfoRow(label: 'E-mail', value: _orNotInformed(profile.email)),
            InfoRow(label: 'Telefone', value: _orNotInformed(profile.phone)),
            SizedBox(height: AppDesignTokens.spacingXl),
            AppButton(
              label: 'Editar informações',
              onPressed: () =>
                  Navigator.of(context).pushNamed(RouteNames.editProfile),
              icon: const Icon(Icons.edit),
              variant: ButtonVariant.primary,
            ),
            SizedBox(height: AppDesignTokens.spacingMd),
            AppButton(
              label: 'Excluir conta',
              onPressed: () => _deleteAccount(context),
              variant: ButtonVariant.negative,
              icon: const Icon(Icons.delete),
              backgroundColor: AppDesignTokens.colorErrorSurface,
            ),
          ],
        );
      },
    );
  }

  String _orNotInformed(String value) =>
      value.trim().isEmpty ? 'Não informado' : value;

  /// Older accounts still carry the literal "Complete seu perfil" seed
  /// placeholder as their fullName (current signups seed an empty string
  /// instead) — display both cases the same way, as not actually informed.
  String _nameOrNotInformed(String value) {
    if (value.trim().isEmpty || value.trim() == 'Complete seu perfil') {
      return 'Não informado';
    }
    return value;
  }

  Future<void> _deleteAccount(BuildContext context) async {
    final confirmed = await AppDialog.confirm(
      context,
      title: 'Tem certeza que deseja excluir sua conta?',
      description:
          'Ao fazer isso, você perderá todo o progresso de atividades e não '
          'poderá mais acessar o SeniorEase com esta conta, pois ela não '
          'existirá mais.',
      confirmLabel: 'Excluir conta',
      destructive: true,
      // Deleting the account is irreversible — unlike the other confirm
      // dialogs, this one always shows, even in Simple mode.
      skipInSimpleMode: false,
    );
    if (!confirmed) return;

    // Soft delete: flips a flag in Firestore and signs out, nothing more —
    // see AuthController.deleteAccount for why it's built this way.
    await sl<AuthController>().deleteAccount();
    if (context.mounted) {
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(RouteNames.login, (route) => false);
    }
  }

  String _ageLabel(DateTime? birthDate) {
    if (birthDate == null) return 'Não informado';
    final now = DateTime.now();
    var age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return '$age anos';
  }

  /// New accounts start with a placeholder name and no phone/birth date —
  /// nudge the person to fill those in rather than leaving them silently
  /// blank in "Minhas informações".
  bool _isIncomplete(UserProfile profile) {
    return profile.fullName.trim().isEmpty ||
        profile.fullName == 'Complete seu perfil' ||
        profile.phone.isEmpty ||
        profile.birthDate == null;
  }
}
