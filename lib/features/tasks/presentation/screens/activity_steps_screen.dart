import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_ease/app/di/injection_container.dart';
import 'package:senior_ease/core/routes/route_names.dart';
import 'package:senior_ease/features/tasks/presentation/controllers/task_steps_controller.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';
import 'package:senior_ease/shared/widgets/app_bar.dart';
import 'package:senior_ease/shared/widgets/app_button.dart';
import 'package:senior_ease/shared/widgets/app_card.dart';

class ActivityStepsScreen extends StatelessWidget {
  const ActivityStepsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TaskStepsController>(
      create: (_) => sl<TaskStepsController>()..load(),
      child: Scaffold(
        backgroundColor: AppDesignTokens.colorGray100,
        appBar: SeniorEaseAppBar(
          onProfileTap: () {},
          onLogoutTap: () => Navigator.of(context).pop(),
        ),
        body: SafeArea(
          bottom: false,
          child: Consumer<TaskStepsController>(
            builder: (context, controller, _) {
              if (controller.isLoading) {
                return const SizedBox.shrink();
              }
              return ListView(
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
                  ...controller.steps.asMap().entries.map((entry) {
                    final index = entry.key;
                    final step = entry.value;
                    return AppCard.simple(
                      title: step.title,
                      subtitle: step.completed
                          ? 'Etapa concluída'
                          : 'Pendente',
                      selected: step.completed,
                      onTap: () {
                        controller.toggleStep(index);
                        Navigator.of(context).pushNamed(RouteNames.stage);
                      },
                    );
                  }),
                  const SizedBox(height: AppDesignTokens.spacingLg),
                  AppButton(
                    label: 'Concluir atividade',
                    onPressed: () => Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil(
                      RouteNames.home,
                      (route) => false,
                    ),
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
              );
            },
          ),
        ),
      ),
    );
  }
}
