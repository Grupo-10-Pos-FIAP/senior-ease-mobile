import 'package:flutter/material.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';
import 'package:senior_ease/shared/widgets/app_bar.dart';
import 'package:senior_ease/shared/widgets/app_button.dart';

class ActivityStageScreen extends StatelessWidget {
  const ActivityStageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesignTokens.colorGray100,
      appBar: SeniorEaseAppBar(onProfileTap: () {}, onLogoutTap: () {}),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDesignTokens.spacingMd,
            vertical: AppDesignTokens.spacingLg,
          ),
          children: [
            Text(
              'Boas-vindas e apresentação',
              style: TextStyle(
                fontSize: AppDesignTokens.fontSizeH4,
                fontWeight: AppDesignTokens.fontWeightBold,
                color: AppDesignTokens.colorContentDefault,
              ),
            ),
            const SizedBox(height: AppDesignTokens.spacingMd),
            Text(
              'Sejam muito bem-vindos à oficina “Primeiros Passos no Digital”. Este é um espaço criado especialmente para quem está começando a usar o celular, encontrar informações e conhecer como a internet pode ajudar no dia a dia.',
              style: TextStyle(
                fontSize: AppDesignTokens.fontSizeBody,
                fontWeight: AppDesignTokens.fontWeightRegular,
                height: AppDesignTokens.lineHeightBody,
                color: AppDesignTokens.colorContentSecondary,
              ),
            ),
            const SizedBox(height: AppDesignTokens.spacingLg),
            _buildSection(
              title: 'O que você verá nesta etapa',
              content:
                  'Ao longo desta oficina, vamos descobrir juntos como usar o celular, enviar mensagens, buscar informações, criar senhas e navegar com mais confiança.',
            ),
            _buildSection(
              title: 'Por que isso importa?',
              content:
                  'Estas habilidades ajudam você a se manter conectado com familiares, acessar serviços e aproveitar novas oportunidades com segurança.',
            ),
            const SizedBox(height: AppDesignTokens.spacingXl),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: '',
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    variant: ButtonVariant.outlined,
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppDesignTokens.colorPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: AppDesignTokens.spacingMd),
                Expanded(
                  child: AppButton(
                    label: '',
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/profile');
                    },
                    variant: ButtonVariant.primary,
                    icon: const Icon(
                      Icons.arrow_forward,
                      color: AppDesignTokens.colorWhite,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDesignTokens.spacingMd),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Voltar para o passo-a-passo',
                style: TextStyle(
                  color: AppDesignTokens.colorPrimary,
                  fontSize: AppDesignTokens.fontSizeBody,
                  fontWeight: AppDesignTokens.fontWeightSemibold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDesignTokens.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: AppDesignTokens.fontSizeTitle,
              fontWeight: AppDesignTokens.fontWeightSemibold,
              color: AppDesignTokens.colorContentDefault,
            ),
          ),
          const SizedBox(height: AppDesignTokens.spacingSm),
          Text(
            content,
            style: TextStyle(
              fontSize: AppDesignTokens.fontSizeBody,
              color: AppDesignTokens.colorContentSecondary,
              height: AppDesignTokens.lineHeightBody,
            ),
          ),
        ],
      ),
    );
  }
}
