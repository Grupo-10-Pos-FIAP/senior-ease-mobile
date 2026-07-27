import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_ease/app/di/injection_container.dart';
import 'package:senior_ease/core/auth/auth_controller.dart';
import 'package:senior_ease/core/routes/route_names.dart';
import 'package:senior_ease/features/profile/domain/entities/user_profile.dart';
import 'package:senior_ease/features/profile/presentation/controllers/profile_info_controller.dart';
import 'package:senior_ease/shared/lib/format_phone.dart';
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
        if (controller.isLoading) {
          return Center(
            child: Text(
              'Carregando informações…',
              style: TextStyle(
                fontSize: AppDesignTokens.fontSizeBody,
                color: AppDesignTokens.colorContentSecondary,
              ),
            ),
          );
        }

        final profile = controller.profile;
        if (profile == null) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(AppDesignTokens.spacingLg),
              child: Text(
                'Não foi possível carregar suas informações. Tente novamente '
                'mais tarde.',
                style: TextStyle(
                  fontSize: AppDesignTokens.fontSizeBody,
                  color: AppDesignTokens.colorContentSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return ListView(
          padding: EdgeInsets.symmetric(
            horizontal: AppDesignTokens.spacingMd,
            vertical: AppDesignTokens.spacingLg,
          ),
          children: [
            Text(
              'Informações da conta',
              style: TextStyle(
                fontSize: AppDesignTokens.fontSizeH4,
                fontWeight: AppDesignTokens.fontWeightBold,
                color: AppDesignTokens.colorContentPrimary,
              ),
            ),
            SizedBox(height: AppDesignTokens.spacingMd),
            Text(
              'Consulte e atualize seus dados pessoais. A idade é calculada a '
              'partir da data de nascimento.',
              style: TextStyle(
                fontSize: AppDesignTokens.fontSizeBody,
                height: AppDesignTokens.lineHeightBody,
                color: AppDesignTokens.colorContentSecondary,
              ),
            ),
            SizedBox(height: AppDesignTokens.spacingLg),
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
              value: _orNotInformed(profile.registrationCode),
            ),
            InfoRow(
              label: 'Possui alguma deficiência?',
              value: _disabilityLabel(profile.disabilityDescription),
            ),
            InfoRow(label: 'E-mail', value: _orNotInformed(profile.email)),
            InfoRow(
              label: 'Telefone',
              value: _phoneLabel(profile.phone),
            ),
            SizedBox(height: AppDesignTokens.spacingXl),
            AppButton(
              label: 'Desativar conta',
              onPressed: () => _deactivateAccount(context),
              variant: ButtonVariant.negative,
              leadingIcon: const Icon(Icons.delete_outline),
              backgroundColor: AppDesignTokens.colorErrorSurface,
            ),
            SizedBox(height: AppDesignTokens.spacingMd),
            AppButton(
              label: 'Editar informações',
              onPressed: () =>
                  Navigator.of(context).pushNamed(RouteNames.editProfile),
              leadingIcon: const Icon(Icons.edit),
              variant: ButtonVariant.primary,
            ),
          ],
        );
      },
    );
  }

  String _orNotInformed(String value) =>
      value.trim().isEmpty || value.trim() == '-' ? 'Não informado' : value;

  String _nameOrNotInformed(String value) {
    if (value.trim().isEmpty || value.trim() == 'Complete seu perfil') {
      return 'Não informado';
    }
    return value;
  }

  String _disabilityLabel(String? value) {
    if (value == null || value.trim().isEmpty) return 'Nenhuma';
    return value;
  }

  String _phoneLabel(String value) {
    final masked = formatPhoneMask(value);
    return masked.isEmpty ? 'Não informado' : masked;
  }

  Future<void> _deactivateAccount(BuildContext context) async {
    final confirmed = await AppDialog.confirm(
      context,
      title: 'Desativar sua conta?',
      description:
          'Sua conta ficará inativa por 90 dias. Nesse período seus dados e '
          'progresso serão preservados e você poderá reativar a conta. Após '
          '90 dias, a conta e todos os dados serão excluídos permanentemente.',
      confirmLabel: 'Sim, desativar minha conta',
      cancelLabel: 'Não, manter minha conta',
      destructive: true,
      stackedActions: true,
    );
    if (!confirmed) return;

    try {
      await sl<AuthController>().deleteAccount();
      if (!context.mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
        RouteNames.login,
        (route) => false,
        arguments: 'accountDeactivated',
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não foi possível desativar a conta. Tente novamente.',
          ),
        ),
      );
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
    return age == 1 ? '1 ano' : '$age anos';
  }

  bool _isIncomplete(UserProfile profile) {
    return profile.fullName.trim().isEmpty ||
        profile.fullName == 'Complete seu perfil' ||
        profile.phone.isEmpty ||
        profile.birthDate == null;
  }
}
