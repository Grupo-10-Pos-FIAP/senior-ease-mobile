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

  static const List<String> _contrastLevels = [
    'Padrão',
    'Suave',
    'Conforto',
    'Alto',
    'Máximo',
    'Escuro',
  ];

  static const List<String> _navigationModes = ['Simples', 'Avançado'];

  static const List<String> _spacingOptions = [
    'Compacto',
    'Reduzido',
    'Normal',
    'Amplo',
    'Muito amplo',
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsController>(
      builder: (context, controller, _) {
        if (controller.isLoading) {
          return const SizedBox.shrink();
        }
        final draft = controller.draft;
        final isSimpleMode = draft.navigationMode == 'Simples';
        return ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDesignTokens.spacingMd,
            vertical: AppDesignTokens.spacingLg,
          ),
          children: [
            AppTitle(text: 'Personalização da experiência'),
            const SizedBox(height: AppDesignTokens.spacingSm),
            const AppInfo(
              'Ajuste como a plataforma aparece para você. As mudanças são '
              'mostradas na hora; toque em Salvar para guardar.',
            ),
            if (controller.hasUnsavedChanges) ...[
              const SizedBox(height: AppDesignTokens.spacingLg),
              _UnsavedChangesBanner(onSaveNow: controller.save),
            ],
            const SizedBox(height: AppDesignTokens.spacingXl),

            AppSubtitle(text: 'Tamanho da letra'),
            const SizedBox(height: AppDesignTokens.spacingXs),
            const AppInfo(
              'Deixe o texto no tamanho mais confortável para ler.',
            ),
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

            AppSubtitle(text: 'Nível de contraste'),
            const SizedBox(height: AppDesignTokens.spacingXs),
            const AppInfo(
              'Leitura mais confortável para vista cansada ou idade avançada.',
            ),
            const SizedBox(height: AppDesignTokens.spacingMd),
            AppCard(
              options: _contrastLevels
                  .map(
                    (level) => AppCardItem(
                      label: level,
                      selected: draft.contrastLevel == level,
                      onTap: () => controller.selectContrastLevel(level),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: AppDesignTokens.spacingXl),

            AppSubtitle(text: 'Modo de navegação'),
            const SizedBox(height: AppDesignTokens.spacingXs),
            const AppInfo(
              'No modo Simples, a plataforma mostra menos opções e textos '
              'mais diretos. Já no modo avançado, todas as opções são '
              'visíveis.',
            ),
            const SizedBox(height: AppDesignTokens.spacingMd),
            AppCard(
              options: _navigationModes
                  .map(
                    (mode) => AppCardItem(
                      label: mode,
                      selected: draft.navigationMode == mode,
                      onTap: () => controller.selectNavigationMode(mode),
                    ),
                  )
                  .toList(),
            ),
            if (!isSimpleMode) ...[
              const SizedBox(height: AppDesignTokens.spacingXl),
              AppSubtitle(text: 'Espaçamento entre elementos'),
              const SizedBox(height: AppDesignTokens.spacingXs),
              const AppInfo(
                'Aumente o espaço entre botões e blocos se tiver dificuldade '
                'para tocar.',
              ),
              const SizedBox(height: AppDesignTokens.spacingMd),
              AppCard(
                options: _spacingOptions
                    .map(
                      (spacing) => AppCardItem(
                        label: spacing,
                        selected: draft.spacing == spacing,
                        onTap: () => controller.selectSpacing(spacing),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: AppDesignTokens.spacingXl),
              AppSubtitle(text: 'Feedback visual reforçado'),
              const SizedBox(height: AppDesignTokens.spacingXs),
              const AppInfo(
                'Destaca botões e foco com contornos mais visíveis ao tocar '
                'ou navegar.',
              ),
              const SizedBox(height: AppDesignTokens.spacingMd),
              AppCard(
                options: [
                  AppCardItem(
                    label: 'Sim',
                    selected: draft.enhancedVisualFeedback,
                    onTap: () => controller.setEnhancedVisualFeedback(true),
                  ),
                  AppCardItem(
                    label: 'Não',
                    selected: !draft.enhancedVisualFeedback,
                    onTap: () => controller.setEnhancedVisualFeedback(false),
                  ),
                ],
              ),
              const SizedBox(height: AppDesignTokens.spacingXl),
              AppSubtitle(text: 'Confirmação em ações críticas'),
              const SizedBox(height: AppDesignTokens.spacingXs),
              const AppInfo(
                'Pede confirmação antes de ações importantes, como restaurar '
                'configurações.',
              ),
              const SizedBox(height: AppDesignTokens.spacingMd),
              AppCard(
                options: [
                  AppCardItem(
                    label: 'Sim',
                    selected: draft.criticalActionConfirmation,
                    onTap: () =>
                        controller.setCriticalActionConfirmation(true),
                  ),
                  AppCardItem(
                    label: 'Não',
                    selected: !draft.criticalActionConfirmation,
                    onTap: () =>
                        controller.setCriticalActionConfirmation(false),
                  ),
                ],
              ),
            ],
            const SizedBox(height: AppDesignTokens.spacingXl),

            AppButton(
              label: 'Salvar mudanças',
              onPressed: controller.hasUnsavedChanges ? controller.save : null,
              variant: ButtonVariant.primary,
            ),
            const SizedBox(height: AppDesignTokens.spacingMd),
            AppButton(
              label: 'Retornar configurações padrão',
              onPressed: () => _confirmReset(context, controller),
              variant: ButtonVariant.outlined,
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmReset(
    BuildContext context,
    SettingsController controller,
  ) async {
    if (!controller.draft.criticalActionConfirmation) {
      controller.resetToDefaults();
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restaurar configurações padrão?'),
        content: const Text(
          'As opções de personalização voltarão para os valores padrão.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Retornar configurações padrão'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      controller.resetToDefaults();
    }
  }
}

class _UnsavedChangesBanner extends StatelessWidget {
  const _UnsavedChangesBanner({required this.onSaveNow});

  final VoidCallback onSaveNow;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: AppDesignTokens.colorWhite,
        borderRadius: BorderRadius.circular(
          AppDesignTokens.borderRadiusDefault,
        ),
        border: Border.all(color: AppDesignTokens.colorPrimary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Você tem alterações não salvas.',
            style: TextStyle(
              fontSize: AppDesignTokens.fontSizeBody,
              fontWeight: AppDesignTokens.fontWeightSemibold,
              color: AppDesignTokens.colorContentDefault,
            ),
          ),
          const SizedBox(height: AppDesignTokens.spacingMd),
          AppButton(
            label: 'Salvar agora',
            onPressed: onSaveNow,
            variant: ButtonVariant.primary,
          ),
        ],
      ),
    );
  }
}
