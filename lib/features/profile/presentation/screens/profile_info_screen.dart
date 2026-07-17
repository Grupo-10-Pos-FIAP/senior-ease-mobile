import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_ease/features/profile/presentation/controllers/profile_info_controller.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';
import 'package:senior_ease/shared/widgets/app_button.dart';
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
          padding: const EdgeInsets.symmetric(
            horizontal: AppDesignTokens.spacingMd,
            vertical: AppDesignTokens.spacingLg,
          ),
          children: [
            InfoRow(label: 'Nome completo', value: profile.fullName),
            InfoRow(label: 'Idade', value: _ageLabel(profile.birthDate)),
            InfoRow(label: 'Matrícula', value: profile.registrationId),
            InfoRow(
              label: 'Possui alguma deficiência?',
              value: profile.disabilityDescription ?? 'Não informado',
            ),
            InfoRow(label: 'E-mail', value: profile.email),
            InfoRow(label: 'Telefone', value: profile.phone),
            const SizedBox(height: AppDesignTokens.spacingXl),
            AppButton(
              label: 'Editar informações',
              onPressed: () {},
              icon: const Icon(Icons.edit),
              variant: ButtonVariant.primary,
            ),
            const SizedBox(height: AppDesignTokens.spacingMd),
            AppButton(
              label: 'Excluir conta',
              onPressed: () {},
              variant: ButtonVariant.negative,
              icon: const Icon(Icons.delete),
              backgroundColor: AppDesignTokens.colorErrorSurface,
            ),
          ],
        );
      },
    );
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
}
