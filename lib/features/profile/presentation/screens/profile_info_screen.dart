import 'package:firebase_auth/firebase_auth.dart';
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
              const _IncompleteProfileBanner(),
              SizedBox(height: AppDesignTokens.spacingLg),
            ],
            InfoRow(label: 'Nome completo', value: profile.fullName),
            InfoRow(label: 'Idade', value: _ageLabel(profile.birthDate)),
            InfoRow(label: 'Matrícula', value: profile.registrationId),
            InfoRow(
              label: 'Possui alguma deficiência?',
              value: profile.disabilityDescription ?? 'Não informado',
            ),
            InfoRow(label: 'E-mail', value: profile.email),
            InfoRow(label: 'Telefone', value: profile.phone),
            SizedBox(height: AppDesignTokens.spacingXl),
            AppButton(
              label: 'Editar informações',
              onPressed: () {},
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

    try {
      await sl<AuthController>().deleteAccount();
      if (context.mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(RouteNames.login, (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;
      final message = e.code == 'requires-recent-login'
          ? 'Por segurança, saia e entre novamente antes de excluir sua '
                'conta.'
          : 'Não foi possível excluir a conta. Tente novamente.';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  String _ageLabel(DateTime? birthDate) {
    if (birthDate == null) return 'Não informada';
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
    return profile.fullName.isEmpty ||
        profile.fullName == 'Complete seu perfil' ||
        profile.phone.isEmpty ||
        profile.birthDate == null;
  }
}

class _IncompleteProfileBanner extends StatelessWidget {
  const _IncompleteProfileBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: AppDesignTokens.colorFeedbackWarning.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(
          AppDesignTokens.borderRadiusDefault,
        ),
        border: Border.all(color: AppDesignTokens.colorFeedbackWarning),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: AppDesignTokens.colorFeedbackWarning,
          ),
          SizedBox(width: AppDesignTokens.spacingSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Complete seu perfil',
                  style: TextStyle(
                    fontSize: AppDesignTokens.fontSizeBody,
                    fontWeight: AppDesignTokens.fontWeightSemibold,
                    color: AppDesignTokens.colorContentDefault,
                  ),
                ),
                SizedBox(height: AppDesignTokens.spacingXs),
                Text(
                  'Algumas informações suas ainda estão faltando. Toque em '
                  '"Editar informações" abaixo para preenchê-las.',
                  style: TextStyle(
                    fontSize: AppDesignTokens.fontSizeBody,
                    color: AppDesignTokens.colorContentSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
