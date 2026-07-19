import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_ease/features/settings/domain/entities/app_settings.dart';
import 'package:senior_ease/features/settings/presentation/controllers/settings_controller.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';
import 'package:senior_ease/shared/widgets/app_button.dart';
import 'package:senior_ease/shared/widgets/app_card.dart';
import 'package:senior_ease/shared/widgets/app_dialog.dart';
import 'package:senior_ease/shared/widgets/app_info.dart';
import 'package:senior_ease/shared/widgets/app_subtitle.dart';
import 'package:senior_ease/shared/widgets/app_title.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
          padding: EdgeInsets.symmetric(
            horizontal: AppDesignTokens.spacingMd,
            vertical: AppDesignTokens.spacingLg,
          ),
          children: [
            AppTitle(text: 'Personalização da experiência'),
            SizedBox(height: AppDesignTokens.spacingSm),
            const AppInfo(
              'Ajuste como a plataforma aparece para você. As mudanças são '
              'mostradas na hora; toque em Salvar para guardar.',
            ),
            if (controller.hasUnsavedChanges) ...[
              SizedBox(height: AppDesignTokens.spacingLg),
              _UnsavedChangesBanner(
                onSaveNow: () => _confirmSave(context, controller),
              ),
            ],
            SizedBox(height: AppDesignTokens.spacingXl),

            AppSubtitle(text: 'Tamanho da letra'),
            SizedBox(height: AppDesignTokens.spacingXs),
            const AppInfo(
              'Deixe o texto no tamanho mais confortável para ler.',
            ),
            SizedBox(height: AppDesignTokens.spacingMd),
            AppCard(
              options: AppSettings.fontSizeOptions
                  .map(
                    (size) => AppCardItem(
                      label: size,
                      selected: draft.fontSize == size,
                      onTap: () => controller.selectFontSize(size),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: AppDesignTokens.spacingXl),

            AppSubtitle(text: 'Nível de contraste'),
            SizedBox(height: AppDesignTokens.spacingXs),
            const AppInfo(
              'Leitura mais confortável para vista cansada ou idade avançada.',
            ),
            SizedBox(height: AppDesignTokens.spacingMd),
            AppCard(
              options: AppSettings.contrastLevelOptions
                  .map(
                    (level) => AppCardItem(
                      label: level,
                      selected: draft.contrastLevel == level,
                      onTap: () => controller.selectContrastLevel(level),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: AppDesignTokens.spacingXl),

            AppSubtitle(text: 'Modo de navegação'),
            SizedBox(height: AppDesignTokens.spacingXs),
            const AppInfo(
              'No modo Simples, a plataforma mostra menos opções e textos '
              'mais diretos. Já no modo avançado, todas as opções são '
              'visíveis.',
            ),
            SizedBox(height: AppDesignTokens.spacingMd),
            AppCard(
              options: AppSettings.navigationModeOptions
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
              SizedBox(height: AppDesignTokens.spacingXl),
              AppSubtitle(text: 'Espaçamento entre elementos'),
              SizedBox(height: AppDesignTokens.spacingXs),
              const AppInfo(
                'Aumente o espaço entre botões e blocos se tiver dificuldade '
                'para tocar.',
              ),
              SizedBox(height: AppDesignTokens.spacingMd),
              AppCard(
                options: AppSettings.spacingOptions
                    .map(
                      (spacing) => AppCardItem(
                        label: spacing,
                        selected: draft.spacing == spacing,
                        onTap: () => controller.selectSpacing(spacing),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: AppDesignTokens.spacingXl),
              AppSubtitle(text: 'Feedback visual reforçado'),
              SizedBox(height: AppDesignTokens.spacingXs),
              const AppInfo(
                'Destaca botões e foco com contornos mais visíveis ao tocar '
                'ou navegar.',
              ),
              SizedBox(height: AppDesignTokens.spacingMd),
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
              SizedBox(height: AppDesignTokens.spacingXl),
              AppSubtitle(text: 'Confirmação em ações críticas'),
              SizedBox(height: AppDesignTokens.spacingXs),
              const AppInfo(
                'Pede confirmação antes de ações importantes, como restaurar '
                'configurações.',
              ),
              SizedBox(height: AppDesignTokens.spacingMd),
              AppCard(
                options: [
                  AppCardItem(
                    label: 'Sim',
                    selected: draft.criticalActionConfirmation,
                    onTap: () => controller.setCriticalActionConfirmation(true),
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
            SizedBox(height: AppDesignTokens.spacingXl),

            AppButton(
              label: 'Salvar mudanças',
              onPressed: controller.hasUnsavedChanges
                  ? () => _confirmSave(context, controller)
                  : null,
              variant: ButtonVariant.primary,
            ),
            SizedBox(height: AppDesignTokens.spacingMd),
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

  Future<void> _confirmSave(
    BuildContext context,
    SettingsController controller,
  ) async {
    final confirmed = await AppDialog.confirm(
      context,
      title: 'Deseja salvar as mudanças feitas?',
      description:
          'A aparência do SeniorEase será adaptada de acordo com as novas '
          'opções de personalização que você escolheu.',
      confirmLabel: 'Salvar',
    );
    if (confirmed) {
      await controller.save();
    }
  }

  Future<void> _confirmReset(
    BuildContext context,
    SettingsController controller,
  ) async {
    if (!controller.draft.criticalActionConfirmation) {
      controller.resetToDefaults();
      await controller.save();
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
      // Reset should take effect immediately, same as any other change —
      // no reason to make the user also hit "Salvar mudanças" right after.
      controller.resetToDefaults();
      await controller.save();
    }
  }
}

class _UnsavedChangesBanner extends StatelessWidget {
  const _UnsavedChangesBanner({required this.onSaveNow});

  final VoidCallback onSaveNow;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: AppDesignTokens.colorBgLight,
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
          SizedBox(height: AppDesignTokens.spacingMd),
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
