import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_ease/features/settings/presentation/controllers/settings_controller.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';
import 'package:senior_ease/shared/widgets/app_button.dart';
import 'package:senior_ease/shared/widgets/app_card.dart';
import 'package:senior_ease/shared/widgets/app_info.dart';
import 'package:senior_ease/shared/widgets/app_subtitle.dart';
import 'package:senior_ease/shared/widgets/app_title.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const List<String> _fontSizes = [
    'Pequena',
    'Reduzida',
    'Normal',
    'Grande',
    'Muito grande',
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsController>(
      builder: (context, controller, _) {
        if (controller.isLoading) {
          return const SizedBox.shrink();
        }
        final draft = controller.draft;
        return ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDesignTokens.spacingMd,
            vertical: AppDesignTokens.spacingLg,
          ),
          children: [
            AppTitle(text: 'Personalização da experiência'),
            AppSubtitle(text: 'Tamanho da letra'),
            const SizedBox(height: AppDesignTokens.spacingMd),
            AppCard(
              options: _fontSizes
                  .map(
                    (size) => AppCardItem(
                      label: size,
                      selected: draft.fontSize == size,
                      onTap: () => controller.selectFontSize(size),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: AppDesignTokens.spacingXl),
            AppSubtitle(text: 'Contraste'),
            const SizedBox(height: AppDesignTokens.spacingMd),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: AppInfo(
                draft.highContrast ? 'Alto contraste' : 'Contraste padrão',
              ),
              subtitle: const AppInfo(
                'Letras mais confortáveis para vista cansada ou idade avançada.',
              ),
              value: draft.highContrast,
              onChanged: controller.setHighContrast,
            ),
            const SizedBox(height: AppDesignTokens.spacingXl),
            AppButton(
              label: 'Salvar mudanças',
              onPressed: controller.save,
              variant: ButtonVariant.primary,
            ),
            const SizedBox(height: AppDesignTokens.spacingMd),
            AppButton(
              label: 'Retornar configurações padrão',
              onPressed: controller.resetToDefaults,
              variant: ButtonVariant.outlined,
            ),
          ],
        );
      },
    );
  }
}
