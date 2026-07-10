import 'package:flutter/material.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';
import 'package:senior_ease/shared/widgets/app_bar.dart';
import 'package:senior_ease/shared/widgets/app_button.dart';
import 'package:senior_ease/shared/widgets/app_card.dart';

class ActivityStepsScreen extends StatelessWidget {
  const ActivityStepsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesignTokens.colorGray100,
      appBar: SeniorEaseAppBar(
        onProfileTap: () {},
        onLogoutTap: () => Navigator.of(context).pop(),
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDesignTokens.spacingMd,
            vertical: AppDesignTokens.spacingLg,
          ),
          children: [
            Text(
              'Oficina “Primeiros Passos no Digital”',
              style: TextStyle(
                fontSize: AppDesignTokens.fontSizeH4,
                fontWeight: AppDesignTokens.fontWeightBold,
                color: AppDesignTokens.colorContentDefault,
              ),
            ),
            const SizedBox(height: AppDesignTokens.spacingMd),
            Text(
              'Etapas concluídas',
              style: TextStyle(
                fontSize: AppDesignTokens.fontSizeBody,
                fontWeight: AppDesignTokens.fontWeightSemibold,
                color: AppDesignTokens.colorContentSecondary,
              ),
            ),
            const SizedBox(height: AppDesignTokens.spacingLg),
            AppCard.simple(
              title: 'Boas-vindas e apresentação',
              subtitle: 'Etapa concluída',
              selected: true,
              onTap: () => Navigator.of(context).pushNamed('/stage'),
            ),
            AppCard.simple(
              title: 'Conhecendo o aparelho',
              subtitle: 'Etapa concluída',
              selected: true,
              onTap: () => Navigator.of(context).pushNamed('/stage'),
            ),
            AppCard.simple(
              title: 'Aprendendo toques e comandos',
              subtitle: 'Etapa concluída',
              selected: true,
              onTap: () => Navigator.of(context).pushNamed('/stage'),
            ),
            AppCard.simple(
              title: 'Conectando à internet',
              subtitle: 'Etapa concluída',
              selected: true,
              onTap: () => Navigator.of(context).pushNamed('/stage'),
            ),
            const SizedBox(height: AppDesignTokens.spacingLg),
            AppButton(
              label: 'Concluir atividade',
              onPressed: () => Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/home', (route) => false),
              variant: ButtonVariant.primary,
            ),
            const SizedBox(height: AppDesignTokens.spacingMd),
            AppButton(
              label: 'Voltar para minhas atividades',
              onPressed: () {
                Navigator.of(context).pop();
              },
              variant: ButtonVariant.outlined,
            ),
          ],
        ),
      ),
    );
  }
}
