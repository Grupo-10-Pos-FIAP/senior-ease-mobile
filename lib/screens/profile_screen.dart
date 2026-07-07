import 'package:flutter/material.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';
import 'package:senior_ease/shared/widgets/app_subtitle.dart';
import 'package:senior_ease/shared/widgets/app_info.dart';
import 'package:senior_ease/shared/widgets/app_title.dart';
import 'package:senior_ease/shared/widgets/info_row.dart';
import 'package:senior_ease/shared/widgets/app_card.dart';
import 'package:senior_ease/shared/widgets/app_bar.dart';
import 'package:senior_ease/shared/widgets/app_button.dart';
import 'package:senior_ease/shared/widgets/app_tabs.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedTab = 0;
  String _fontSize = 'Normal';
  bool _contrast = false;

  final List<String> _tabs = const ['Personalização', 'Informações'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesignTokens.colorGray100,
      appBar: SeniorEaseAppBar(onProfileTap: () {}, onLogoutTap: () {}),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDesignTokens.spacingMd,
                AppDesignTokens.spacingLg,
                AppDesignTokens.spacingMd,
                AppDesignTokens.spacingLg,
              ),
              child: AppTabs(
                tabs: _tabs,
                selectedIndex: _selectedTab,
                onTabSelected: (index) => setState(() => _selectedTab = index),
              ),
            ),
            Expanded(
              child: _selectedTab == 0
                  ? _buildPersonalizationTab()
                  : _buildInformationTab(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalizationTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesignTokens.spacingMd,
        vertical: AppDesignTokens.spacingLg,
      ),
      children: [
        AppTitle(text: 'Personalização da experiência'),
        const SizedBox(height: AppDesignTokens.spacingSm),
        AppInfo(
          'Ajuste como a plataforma aparece para você. As mudanças sao mostradas na hora.',
        ),
        const SizedBox(height: AppDesignTokens.spacingMd),
        AppSubtitle(text: 'Tamanho da letra'),
        const SizedBox(height: AppDesignTokens.spacingMd),
        AppCard(
          options: [
            AppCardItem(
              label: 'Pequena',
              selected: _fontSize == 'Pequena',
              onTap: () => setState(() => _fontSize = 'Pequena'),
            ),
            AppCardItem(
              label: 'Reduzida',
              selected: _fontSize == 'Reduzida',
              onTap: () => setState(() => _fontSize = 'Reduzida'),
            ),
            AppCardItem(
              label: 'Normal',
              selected: _fontSize == 'Normal',
              onTap: () => setState(() => _fontSize = 'Normal'),
            ),
            AppCardItem(
              label: 'Grande',
              selected: _fontSize == 'Grande',
              onTap: () => setState(() => _fontSize = 'Grande'),
            ),
            AppCardItem(
              label: 'Muito grande',
              selected: _fontSize == 'Muito grande',
              onTap: () => setState(() => _fontSize = 'Muito grande'),
            ),
          ],
        ),
        const SizedBox(height: AppDesignTokens.spacingXl),
        AppSubtitle(text: 'Contraste'),
        const SizedBox(height: AppDesignTokens.spacingMd),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: AppInfo(_contrast ? 'Alto contraste' : 'Contraste padrão'),
          subtitle: const AppInfo(
            'Letras mais confortáveis para vista cansada ou idade avançada.',
          ),
          value: _contrast,
          onChanged: (value) => setState(() => _contrast = value),
        ),
        const SizedBox(height: AppDesignTokens.spacingXl),
        AppButton(
          label: 'Salvar mudanças',
          onPressed: () {},
          variant: ButtonVariant.primary,
        ),
        const SizedBox(height: AppDesignTokens.spacingMd),
        AppButton(
          label: 'Retornar configurações padrão',
          onPressed: () {
            setState(() {
              _fontSize = 'Normal';
              _contrast = false;
            });
          },
          variant: ButtonVariant.outlined,
        ),
      ],
    );
  }

  Widget _buildInformationTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesignTokens.spacingMd,
        vertical: AppDesignTokens.spacingLg,
      ),
      children: [
        AppTitle(text: 'Informações da conta'),
        const SizedBox(height: AppDesignTokens.spacingSm),
        AppInfo(
          'Consulte e atualize seus dados pessoais. A idade é calculada a partir da data de nascimento informada no cadastro.',
        ),
        const InfoRow(
          label: 'Nome completo',
          value: 'Antônio José Maria da Silva',
        ),
        const InfoRow(label: 'Idade', value: '67 anos'),
        const InfoRow(label: 'Matrícula', value: '2026067'),
        const InfoRow(
          label: 'Possui alguma deficiência?',
          value: 'Baixa visão',
        ),
        const InfoRow(label: 'E-mail', value: 'antoniojose@seniorease.com.br'),
        const InfoRow(label: 'Telefone', value: '(85) 9767-6767'),
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
  }
}
